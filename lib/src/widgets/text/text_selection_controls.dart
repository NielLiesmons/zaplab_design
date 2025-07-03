import 'package:flutter/foundation.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabTextSelectionControls extends TextSelectionControls {
  static const double _handleSize = 16.0;
  static const double _lineThickness = 2.0;

  @override
  Widget buildHandle(
      BuildContext context, TextSelectionHandleType type, double textLineHeight,
      [VoidCallback? onTap]) {
    final theme = LabTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: LabContainer(
        width: 16.0,
        height: textLineHeight + 32,
        child: Column(
          children: [
            LabContainer(
              width: _handleSize,
              height: _handleSize,
              decoration: BoxDecoration(
                color: type == TextSelectionHandleType.left
                    ? theme.colors.blurpleLightColor
                    : null,
                shape: BoxShape.circle,
              ),
            ),
            LabContainer(
              width: _lineThickness,
              height: textLineHeight,
              decoration: BoxDecoration(
                color: type == TextSelectionHandleType.collapsed
                    ? null
                    : theme.colors.blurpleLightColor,
                borderRadius: BorderRadius.circular(10000),
              ),
            ),
            LabContainer(
              width: _handleSize,
              height: _handleSize,
              decoration: BoxDecoration(
                color: type == TextSelectionHandleType.right
                    ? theme.colors.blurpleLightColor
                    : null,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool canSelectAll(TextSelectionDelegate delegate) => true;

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    switch (type) {
      case TextSelectionHandleType.left:
        return Offset(_handleSize / 2, textLineHeight + _handleSize);
      case TextSelectionHandleType.right:
        return Offset(_handleSize / 2, textLineHeight + _handleSize);
      case TextSelectionHandleType.collapsed:
        return Offset(_handleSize / 2, textLineHeight + _handleSize);
    }
  }

  @override
  Size getHandleSize(double textLineHeight) {
    return Size(_handleSize, textLineHeight + _handleSize + _handleSize);
  }

  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ValueListenable<ClipboardStatus>? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) {
    final theme = LabTheme.of(context);
    final editableTextState = delegate as EditableTextState;

    // Use the leftmost point (start of selection) for positioning
    final startPoint = endpoints.first.point;

    // Check if we should show the style menu (when text is selected and editable)
    final isEditable = editableTextState.widget.readOnly != true;
    final hasSelection =
        !editableTextState.textEditingValue.selection.isCollapsed;
    final showStyleMenu = isEditable && hasSelection;

    // Adjust vertical offset when style menu is shown
    final styleMenuOffset = showStyleMenu ? 48.0 : 0.0;

    return CompositedTransformFollower(
      link: editableTextState.renderEditable.startHandleLayerLink,
      offset: Offset(
          startPoint.dx <=
                  (MediaQuery.of(context).size.width / theme.system.scale) / 3
              ? 0
              : // Left third
              startPoint.dx >=
                      ((MediaQuery.of(context).size.width /
                              theme.system.scale) *
                          2 /
                          3)
                  ? -(2 * theme.sizes.s104)
                  : // Right third
                  -theme.sizes.s104, // Middle third
          -textLineHeight - theme.sizes.s56 - styleMenuOffset),
      showWhenUnlinked: false,
      child: LabTextSelectionMenu(
        position: selectionMidpoint,
        editableTextState: editableTextState,
        showStyleMenu: showStyleMenu,
        clipboardStatus: clipboardStatus,
      ),
    );
  }
}
