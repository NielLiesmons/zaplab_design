import 'package:zaplab_design/zaplab_design.dart';

class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onTabLongPress,
  });

  final List<TabData> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final ValueChanged<int> onTabLongPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppDivider(),
        AppContainer(
          width: double.infinity,
          padding: const AppEdgeInsets.symmetric(
            horizontal: AppGapSize.s12,
            vertical: AppGapSize.s12,
          ),
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < tabs.length; i++) ...[
                  AppTabButton(
                    label: tabs[i].label,
                    count: tabs[i].count,
                    isSelected: i == selectedIndex,
                    onTap: () => onTabSelected(i),
                    onLongPress: tabs[i].settingsContent != null
                        ? () => onTabLongPress(i)
                        : null,
                  ),
                  if (i < tabs.length - 1) const AppGap.s12(),
                ],
              ],
            ),
          ),
        ),
        const AppDivider(),
      ],
    );
  }
}
