import 'dart:ui';
import 'package:zaplab_design/zaplab_design.dart';

class AppTextSelectionMenuItem {
  final String? label;
  final Widget? icon;
  final void Function(EditableTextState) onTap;
  final bool Function(EditableTextState)? isVisible;

  const AppTextSelectionMenuItem({
    this.label,
    this.icon,
    required this.onTap,
    this.isVisible,
  });
}

class AppTextSelectionMenu extends StatefulWidget {
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
  State<AppTextSelectionMenu> createState() => _AppTextSelectionMenuState();
}

class _AppTextSelectionMenuState extends State<AppTextSelectionMenu> {
  final ScrollController _scrollController = ScrollController();
  bool _showGradient = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isAtEnd =
        _scrollController.offset >= _scrollController.position.maxScrollExtent;
    if (isAtEnd != !_showGradient) {
      setState(() {
        _showGradient = !isAtEnd;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isEditable = widget.editableTextState.widget.readOnly != true;

    final defaultMenuItems = isEditable
        ? [
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
            AppTextSelectionMenuItem(
              label: 'Select All',
              onTap: (state) => _handleAction(state.selectAll),
            ),
            AppTextSelectionMenuItem(
              label: 'Bold',
              onTap: (state) => _handleAction((cause) {
                final selection = state.textEditingValue.selection;
                if (selection.isValid && !selection.isCollapsed) {
                  final text = state.textEditingValue.text;
                  final selectedText =
                      text.substring(selection.start, selection.end);
                  final newText = text.replaceRange(
                    selection.start,
                    selection.end,
                    '**$selectedText**',
                  );
                  state.updateEditingValue(
                    TextEditingValue(
                      text: newText,
                      selection: TextSelection(
                        baseOffset: selection.start,
                        extentOffset: selection.end + 4,
                      ),
                    ),
                  );
                }
              }),
            ),
            AppTextSelectionMenuItem(
              label: 'Strikethrough',
              onTap: (state) => _handleAction((cause) {
                final selection = state.textEditingValue.selection;
                if (selection.isValid && !selection.isCollapsed) {
                  final text = state.textEditingValue.text;
                  final selectedText =
                      text.substring(selection.start, selection.end);
                  final newText = text.replaceRange(
                    selection.start,
                    selection.end,
                    '~~$selectedText~~',
                  );
                  state.updateEditingValue(
                    TextEditingValue(
                      text: newText,
                      selection: TextSelection(
                        baseOffset: selection.start,
                        extentOffset: selection.end + 4,
                      ),
                    ),
                  );
                }
              }),
            ),
            AppTextSelectionMenuItem(
              label: 'List',
              onTap: (state) => _handleAction((cause) {
                final selection = state.textEditingValue.selection;
                if (selection.isValid && !selection.isCollapsed) {
                  final text = state.textEditingValue.text;
                  final selectedText =
                      text.substring(selection.start, selection.end);
                  final lines = selectedText.split('\n');
                  final bulletedLines =
                      lines.map((line) => '- $line').join('\n');
                  final newText = text.replaceRange(
                    selection.start,
                    selection.end,
                    bulletedLines,
                  );
                  state.updateEditingValue(
                    TextEditingValue(
                      text: newText,
                      selection: TextSelection(
                        baseOffset: selection.start,
                        extentOffset: selection.start + bulletedLines.length,
                      ),
                    ),
                  );
                }
              }),
            ),
          ]
        : [
            AppTextSelectionMenuItem(
              label: 'Copy',
              onTap: (state) => _handleAction(state.copySelection),
            ),
            AppTextSelectionMenuItem(
              label: 'Select All',
              onTap: (state) => _handleAction(state.selectAll),
            ),
            AppTextSelectionMenuItem(
              label: 'Look Up',
              onTap: (state) => {/* TODO: Implement look up */},
            ),
          ];

    final items = widget.menuItems
            ?.where(
              (item) => item.isVisible?.call(widget.editableTextState) ?? true,
            )
            .toList() ??
        defaultMenuItems;

    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 196,
        height: theme.sizes.s38,
        child: ClipRRect(
          borderRadius: theme.radius.asBorderRadius().rad8,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Stack(
              children: [
                AppContainer(
                  height: theme.sizes.s38,
                  decoration: BoxDecoration(
                    color: theme.colors.white16,
                    borderRadius: theme.radius.asBorderRadius().rad8,
                    border: Border.all(
                      color: theme.colors.white33,
                      width: LineThicknessData.normal().thin,
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: items.map((item) {
                        final isLast = item == items.last;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildButton(
                              context,
                              item.label!,
                              () => item.onTap(widget.editableTextState),
                            ),
                            if (!isLast) const AppDivider.vertical(),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (_showGradient)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: 32,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            theme.colors.black33.withOpacity(0),
                            theme.colors.black33,
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
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

  void _handleAction(Function(SelectionChangedCause) action) {
    action(SelectionChangedCause.tap);

    // Only hide toolbar for actions that should dismiss the menu
    if (action == widget.editableTextState.pasteText ||
        action == widget.editableTextState.cutSelection) {
      widget.editableTextState.hideToolbar();
    }
  }
}
