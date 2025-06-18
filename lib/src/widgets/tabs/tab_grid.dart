import 'package:zaplab_design/zaplab_design.dart';

class LabTabGrid extends StatelessWidget {
  const LabTabGrid({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.tabBarKey,
  });

  final List<TabData> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final GlobalKey<LabTabBarState> tabBarKey;

  void _handleTabSelection(int index) {
    onTabSelected(index);
    tabBarKey.currentState?.closeActionZone();
    tabBarKey.currentState?.scrollToTab(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final rowCount = (tabs.length / 3).ceil();
    // final isInsideModal = ModalScope.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var row = 0; row < rowCount; row++) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (var col = 0; col < 3; col++) ...[
                if (row * 3 + col < tabs.length)
                  Expanded(
                    child: LabPanelButton(
                      padding: const LabEdgeInsets.only(
                        top: LabGapSize.s20,
                        bottom: LabGapSize.s14,
                        left: LabGapSize.s12,
                        right: LabGapSize.s12,
                      ),
                      onTap: () => _handleTabSelection(row * 3 + col),
                      gradient: row * 3 + col == selectedIndex
                          ? theme.colors.blurple
                          : null,
                      isLight: true,
                      count: tabs[row * 3 + col].count,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          tabs[row * 3 + col].icon,
                          const LabGap.s10(),
                          LabText.med14(
                            tabs[row * 3 + col].label,
                            color: row * 3 + col == selectedIndex
                                ? theme.colors.whiteEnforced
                                : null,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
                if (col < 2) const LabGap.s12(),
              ],
            ],
          ),
          if (row < rowCount - 1) const LabGap.s12(),
        ],
      ],
    );
  }
}
