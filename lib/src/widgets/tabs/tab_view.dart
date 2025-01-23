import 'package:zaplab_design/zaplab_design.dart';

class TabData {
  const TabData({
    required this.label,
    required this.content,
    required this.icon,
    this.count,
    this.settingsContent,
    this.settingsDescription,
  });

  final String label;
  final Widget content;
  final Widget icon;
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

class _AppTabViewState extends State<AppTabView> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isExpanded = false;
  late final AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  final _tabBarKey = GlobalKey<AppTabBarState>();

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: AppDurationsData.normal().normal,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

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
    return Stack(
      children: [
        // Main content that slides right
        SlideTransition(
          position: _slideAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTabBar(
                key: _tabBarKey,
                tabs: widget.tabs,
                selectedIndex: _selectedIndex,
                onTabSelected: (index) {
                  setState(() => _selectedIndex = index);
                },
                onTabLongPress: (index) {
                  _showSettingsModal(context, widget.tabs[index]);
                },
                onExpansionChanged: (expanded) async {
                  setState(() => _isExpanded = expanded);
                  if (expanded) {
                    await Future.delayed(const Duration(milliseconds: 200));
                    _slideController.forward();
                  } else {
                    _slideController.reverse();
                  }
                },
              ),
              widget.tabs[_selectedIndex].content,
            ],
          ),
        ),

        // Grid that slides in from left
        if (_isExpanded)
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(_slideController),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppDivider(),
                AppContainer(
                  padding: const AppEdgeInsets.all(AppGapSize.s12),
                  child: AppTabGrid(
                    tabs: widget.tabs,
                    selectedIndex: _selectedIndex,
                    onTabSelected: (index) {
                      setState(() {
                        _selectedIndex = index;
                        _isExpanded = false;
                      });
                      _slideController.reverse();
                    },
                    tabBarKey: _tabBarKey,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }
}
