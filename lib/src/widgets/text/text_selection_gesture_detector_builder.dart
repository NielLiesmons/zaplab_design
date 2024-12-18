import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

class TextSelectionGestureDetectorBuilder {
  TextSelectionGestureDetectorBuilder({
    required this.delegate,
  });

  final TextSelectionGestureDetectorBuilderDelegate delegate;
  bool _isDragging = false;
  Offset? _dragStartPosition;

  EditableTextState get editableText => delegate.editableTextKey.currentState!;
  RenderEditable get renderEditable => editableText.renderEditable;

  TextSelection _getWordAtOffset(TextPosition position) {
    final TextSpan span = renderEditable.text! as TextSpan;
    final String text = span.toPlainText();

    var start = position.offset;
    var end = position.offset;

    final RegExp wordBreak = RegExp(r'[\s\.,]');
    while (start > 0 && !wordBreak.hasMatch(text[start - 1])) {
      start--;
    }
    while (end < text.length && !wordBreak.hasMatch(text[end])) {
      end++;
    }

    return TextSelection(baseOffset: start, extentOffset: end);
  }

  TextPosition _getTextPositionForOffset(Offset globalPosition) {
    final RenderBox renderBox =
        editableText.context.findRenderObject()! as RenderBox;
    final Offset localPosition = renderBox.globalToLocal(globalPosition);
    return renderEditable.getPositionForPoint(localPosition);
  }

  void _handleMouseSelection(Offset offset, SelectionChangedCause cause) {
    renderEditable.selectPositionAt(
      from: offset,
      cause: cause,
    );
  }

  void _handleMouseDragSelection(
      Offset startOffset, Offset currentOffset, SelectionChangedCause cause) {
    renderEditable.selectPositionAt(
      from: startOffset,
      to: currentOffset,
      cause: cause,
    );

    // Show toolbar when text is selected
    final selection = editableText.textEditingValue.selection;
    if (!selection.isCollapsed) {
      editableText.showToolbar();
    }
  }

  void onDoubleTapDown(TapDownDetails details) {
    if (!delegate.selectionEnabled) {
      return;
    }

    final TextPosition position =
        _getTextPositionForOffset(details.globalPosition);
    final TextSelection selection = _getWordAtOffset(position);
    editableText.userUpdateTextEditingValue(
      editableText.textEditingValue.copyWith(selection: selection),
      SelectionChangedCause.tap,
    );
  }

  Widget buildGestureDetector({
    Key? key,
    HitTestBehavior? behavior,
    required Widget child,
  }) {
    // Desktop/Web behavior
    if (kIsWeb || !defaultTargetPlatform.isMobile) {
      return MouseRegion(
        cursor: SystemMouseCursors.text,
        child: Listener(
          onPointerDown: (PointerDownEvent event) {
            editableText.hideToolbar();
            _dragStartPosition = event.position;
            _handleMouseSelection(event.position, SelectionChangedCause.tap);
          },
          onPointerMove: (PointerMoveEvent event) {
            if (event.buttons == kPrimaryButton && _dragStartPosition != null) {
              if (!_isDragging) {
                _isDragging = true;
              }
              _handleMouseDragSelection(
                _dragStartPosition!,
                event.position,
                SelectionChangedCause.drag,
              );
              final selection = editableText.textEditingValue.selection;
              if (!selection.isCollapsed) {
                editableText.showToolbar();
              }
            }
          },
          onPointerUp: (PointerUpEvent event) {
            _isDragging = false;
            _dragStartPosition = null;
            final selection = editableText.textEditingValue.selection;
            if (!selection.isCollapsed) {
              editableText.showToolbar();
            }
          },
          child: GestureDetector(
            key: key,
            behavior: behavior ?? HitTestBehavior.translucent,
            onDoubleTapDown: onDoubleTapDown,
            onSecondaryTapUp: (details) {
              final selection = editableText.textEditingValue.selection;
              if (!selection.isCollapsed) {
                editableText.showToolbar();
              }
            },
            child: child,
          ),
        ),
      );
    }

    // Mobile behavior
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        TapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(),
          (TapGestureRecognizer instance) {
            instance.onTapDown = (details) {
              editableText.hideToolbar();
              _handleMouseSelection(
                  details.globalPosition, SelectionChangedCause.tap);
            };
          },
        ),
        DoubleTapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<DoubleTapGestureRecognizer>(
          () => DoubleTapGestureRecognizer(),
          (DoubleTapGestureRecognizer instance) {
            instance.onDoubleTapDown = onDoubleTapDown;
          },
        ),
        LongPressGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
          () => LongPressGestureRecognizer(
              duration: const Duration(milliseconds: 300)),
          (LongPressGestureRecognizer instance) {
            instance
              ..onLongPressStart = (details) {
                _handleMouseSelection(
                    details.globalPosition, SelectionChangedCause.longPress);
                editableText.showToolbar();
              }
              ..onLongPressMoveUpdate = (details) {
                _handleMouseDragSelection(
                  details.globalPosition - details.offsetFromOrigin,
                  details.globalPosition,
                  SelectionChangedCause.longPress,
                );
              };
          },
        ),
      },
      behavior: behavior ?? HitTestBehavior.translucent,
      child: child,
    );
  }
}

abstract class TextSelectionGestureDetectorBuilderDelegate {
  GlobalKey<EditableTextState> get editableTextKey;
  bool get forcePressEnabled;
  bool get selectionEnabled;
}

extension on TargetPlatform {
  bool get isMobile =>
      this == TargetPlatform.iOS || this == TargetPlatform.android;
}
