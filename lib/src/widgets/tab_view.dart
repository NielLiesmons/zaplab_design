import 'package:zaplab_design/zaplab_design.dart';

class TabData {
  const TabData({
    required this.label,
    required this.content,
    this.count,
    this.settingsContent,
    this.settingsDescription,
  });

  final String label;
  final Widget content;
  final int? count;
  final Widget? settingsContent;
  final String? settingsDescription;
}

class AppTabView extends StatefulWidget {
  const AppTabView({
    super.key,
    required this.tabs,
  });

  final List<TabData> tabs;

  @override
  State<AppTabView> createState() => _AppTabViewState();
}

class _AppTabViewState extends State<AppTabView> {
  int _selectedIndex = 0;

  Future<void> _showSettingsModal(BuildContext context, TabData tab) async {
    if (tab.settingsContent == null) return;
    final theme = AppTheme.of(context);
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    final isInsideModal = ModalScope.of(context);

    if (isInsideModal) {
      await AppModal.showInOtherModal(
        rootContext,
        title: tab.label,
        description: tab.settingsDescription,
        children: [tab.settingsContent!],
        bottomBar: AppButton(
          content: [
            AppText.med16(
              'Done',
              color: AppColorsData.dark().white,
            ),
          ],
          onTap: () => Navigator.of(context).pop(),
          inactiveGradient: theme.colors.blurple,
          pressedGradient: theme.colors.blurple,
        ),
      );
    } else {
      await AppModal.show(
        rootContext,
        title: tab.label,
        description: tab.settingsDescription,
        children: [tab.settingsContent!],
        bottomBar: AppButton(
          content: [
            AppText.med16(
              'Done',
              color: AppColorsData.dark().white,
            ),
          ],
          onTap: () => Navigator.of(context).pop(),
          inactiveGradient: theme.colors.blurple,
          pressedGradient: theme.colors.blurple,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTabBar(
          tabs: widget.tabs,
          selectedIndex: _selectedIndex,
          onTabSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          onTabLongPress: (index) {
            _showSettingsModal(context, widget.tabs[index]);
          },
        ),
        widget.tabs[_selectedIndex].content,
      ],
    );
  }
}
