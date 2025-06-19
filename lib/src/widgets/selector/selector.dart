import 'package:zaplab_design/zaplab_design.dart';

class LabSelector extends StatefulWidget {
  final List<LabSelectorButton> children;
  final bool emphasized;
  final bool small;
  final bool isLight;
  final ValueChanged<int>? onChanged;
  final int? initialIndex;

  const LabSelector({
    super.key,
    required this.children,
    this.emphasized = false,
    this.small = false,
    this.isLight = false,
    this.onChanged,
    this.initialIndex,
  });

  @override
  State<LabSelector> createState() => _LabSelectorState();
}

class _LabSelectorState extends State<LabSelector> {
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
    final theme = LabTheme.of(context);
    final isInsideModal = ModalScope.of(context);
    final isInsideScope = LabScope.of(context);

    return LabContainer(
      padding: const LabEdgeInsets.all(LabGapSize.s8),
      decoration: BoxDecoration(
        color: widget.isLight
            ? theme.colors.white8
            : isInsideModal || isInsideScope
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
              child: LabSelectorButton(
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
