import 'package:zaplab_design/zaplab_design.dart';

class AppSelector extends StatefulWidget {
  final List<AppSelectorButton> children;
  final bool emphasized;
  final bool small;
  final ValueChanged<int>? onChanged;
  final int? initialIndex;

  const AppSelector({
    super.key,
    required this.children,
    this.emphasized = false,
    this.small = false,
    this.onChanged,
    this.initialIndex,
  });

  @override
  State<AppSelector> createState() => _AppSelectorState();
}

class _AppSelectorState extends State<AppSelector> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex ?? 0;
  }

  void _handleSelection(int index) {
    setState(() => selectedIndex = index);
    widget.onChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isInsideModal = ModalScope.of(context);
    final isInsideScope = AppScope.of(context);

    return AppContainer(
      padding: const AppEdgeInsets.all(AppGapSize.s8),
      decoration: BoxDecoration(
        color: isInsideModal || isInsideScope
            ? theme.colors.black33
            : theme.colors.gray66,
        borderRadius: widget.emphasized
            ? theme.radius.asBorderRadius().rad24
            : theme.radius.asBorderRadius().rad16,
      ),
      child: Row(
        children: [
          for (int i = 0; i < widget.children.length; i++) ...[
            Expanded(
              child: AppSelectorButton(
                selectedContent: widget.children[i].selectedContent,
                unselectedContent: widget.children[i].unselectedContent,
                isSelected: i == selectedIndex,
                emphasized: widget.emphasized,
                small: widget.small,
                onTap: () => _handleSelection(i),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
