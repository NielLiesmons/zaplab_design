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

  void _handleDoubleClick(TapDownDetails details) {
    if (!delegate.selectionEnabled) {
      return;
    }

    renderEditable.handleTapDown(details);
    renderEditable.selectWord(cause: SelectionChangedCause.tap);
    editableText.showToolbar();
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
        child: GestureDetector(
          key: key,
          behavior: behavior ?? HitTestBehavior.translucent,
          onDoubleTapDown: _handleDoubleClick,
          child: Listener(
            onPointerDown: (PointerDownEvent event) {
              editableText.hideToolbar();
              _dragStartPosition = event.position;
              _handleMouseSelection(event.position, SelectionChangedCause.tap);
            },
            onPointerMove: (PointerMoveEvent event) {
              if (event.buttons == kPrimaryButton &&
                  _dragStartPosition != null) {
                if (!_isDragging) {
                  _isDragging = true;
                }
                _handleMouseDragSelection(
                  _dragStartPosition!,
                  event.position,
                  SelectionChangedCause.drag,
                );
              }
            },
            onPointerUp: (PointerUpEvent event) {
              _isDragging = false;
              _dragStartPosition = null;
              // Show toolbar if text is selected
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
    return GestureDetector(
      key: key,
      behavior: behavior ?? HitTestBehavior.translucent,
      onTapDown: (details) {
        editableText.hideToolbar();
        _handleMouseSelection(
            details.globalPosition, SelectionChangedCause.tap);
      },
      onDoubleTapDown: _handleDoubleClick,
      onLongPressStart: (details) {
        _handleMouseSelection(
            details.globalPosition, SelectionChangedCause.longPress);
        editableText.showToolbar();
      },
      onLongPressMoveUpdate: (details) {
        _handleMouseDragSelection(
          details.globalPosition - details.offsetFromOrigin,
          details.globalPosition,
          SelectionChangedCause.longPress,
        );
      },
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
