import 'dart:ui';
import 'package:zaplab_design/zaplab_design.dart';

class AppTextSelectionMenuItem {
  final String label;
  final void Function(EditableTextState) onTap;
  final bool Function(EditableTextState)? isVisible;

  const AppTextSelectionMenuItem({
    required this.label,
    required this.onTap,
    this.isVisible,
  });
}

class AppTextSelectionMenu extends StatelessWidget {
  final Offset position;
  final EditableTextState editableTextState;
  final List<AppTextSelectionMenuItem>? menuItems;

  const AppTextSelectionMenu({
    super.key,
    required this.position,
    required this.editableTextState,
    this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final defaultMenuItems = [
      AppTextSelectionMenuItem(
        label: 'Copy',
        onTap: (state) => _handleAction(state.copySelection),
      ),
      AppTextSelectionMenuItem(
        label: 'Cut',
        onTap: (state) => _handleAction(state.cutSelection),
      ),
      AppTextSelectionMenuItem(
        label: 'Paste',
        onTap: (state) => _handleAction(state.pasteText),
      ),
    ];

    final items = menuItems
            ?.where(
              (item) => item.isVisible?.call(editableTextState) ?? true,
            )
            .toList() ??
        defaultMenuItems;

    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: theme.sizes.s38,
        child: ClipRRect(
          borderRadius: theme.radius.asBorderRadius().rad8,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: AppContainer(
              height: theme.sizes.s38,
              decoration: BoxDecoration(
                color: theme.colors.white16,
                borderRadius: theme.radius.asBorderRadius().rad8,
                border: Border.all(
                  color: theme.colors.white33,
                  width: LineThicknessData.normal().thin,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: items.map((item) {
                  final isLast = item == items.last;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildButton(
                        context,
                        item.label,
                        () => item.onTap(editableTextState),
                      ),
                      if (!isLast) const AppDivider.vertical(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleAction(Function(SelectionChangedCause) action) {
    action(SelectionChangedCause.tap);
    editableTextState.hideToolbar();
  }

  Widget _buildButton(BuildContext context, String label, VoidCallback onTap) {
    final theme = AppTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        padding: const AppEdgeInsets.symmetric(
          horizontal: AppGapSize.s12,
          vertical: AppGapSize.s8,
        ),
        child: AppText.med14(
          label,
          color: theme.colors.white,
        ),
      ),
    );
  }
}
