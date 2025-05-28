import 'package:zaplab_design/zaplab_design.dart';

class TabData {
  final String label;
  final Widget content;
  final Widget icon;
  final int? count;
  final Widget? settingsContent;
  final String? settingsDescription;
  final Widget? bottomBar;
  const TabData({
    required this.label,
    required this.content,
    required this.icon,
    this.count,
    this.settingsContent,
    this.settingsDescription,
    this.bottomBar,
  });
}

class AppTabView extends StatefulWidget {
  final List<TabData> tabs;
  final AppTabController controller;
  final bool scrollableContent;
  final void Function(double)? onScroll;
  const AppTabView({
    super.key,
    required this.tabs,
    required this.controller,
    this.scrollableContent = false,
    this.onScroll,
  });

  @override
  State<AppTabView> createState() => _AppTabViewState();
}

class _AppTabViewState extends State<AppTabView> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isExpanded = false;
  bool _showScrollButton = false;
  late final AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  final _tabBarKey = GlobalKey<AppTabBarState>();
  final _scrollController = ScrollController();

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
    _selectedIndex = widget.controller.index;
    widget.controller.addListener(_handleTabChange);
    _scrollController.addListener(_handleScroll);
  }

  void _handleTabChange() {
    setState(() {
      _selectedIndex = widget.controller.index;
    });
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position.pixels;
    widget.onScroll?.call(position);
    setState(() {
      _showScrollButton = position > 320;
    });
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: AppDurationsData.normal().normal,
      curve: Curves.easeOut,
    );
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
          onTap: () => Navigator.of(context).pop(),
          inactiveGradient: theme.colors.blurple,
          pressedGradient: theme.colors.blurple,
          children: [
            AppText.med16(
              'Done',
              color: theme.colors.whiteEnforced,
            ),
          ],
        ),
      );
    } else {
      await AppModal.show(
        rootContext,
        title: tab.label,
        description: tab.settingsDescription,
        children: [tab.settingsContent!],
        bottomBar: AppButton(
          onTap: () => Navigator.of(context).pop(),
          inactiveGradient: theme.colors.blurple,
          pressedGradient: theme.colors.blurple,
          children: [
            AppText.med16(
              'Done',
              color: theme.colors.whiteEnforced,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final currentTab = widget.tabs[_selectedIndex];
    final floatingButtonBottom = currentTab.bottomBar != null ? 84 : 16;

    return Stack(
      children: [
        // Main content that slides right
        SlideTransition(
          position: _slideAnimation,
          child: SizedBox(
            height: MediaQuery.of(context).size.height /
                AppTheme.of(context).system.scale,
            child: Column(
              children: [
                AppTabBar(
                  key: _tabBarKey,
                  tabs: widget.tabs,
                  selectedIndex: _selectedIndex,
                  onTabSelected: (index) {
                    widget.controller.animateTo(index);
                  },
                  onTabLongPress: (index) {
                    _showSettingsModal(context, widget.tabs[index]);
                  },
                  onExpansionChanged: (expanded) async {
                    setState(() => _isExpanded = expanded);
                    if (expanded) {
                      await Future.delayed(const Duration(milliseconds: 123));
                      _slideController.forward();
                    } else {
                      _slideController.reverse();
                    }
                  },
                ),
                if (widget.scrollableContent)
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: widget.tabs[_selectedIndex].content,
                    ),
                  )
                else
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 0,
                      ),
                      child: widget.tabs[_selectedIndex].content,
                    ),
                  ),
              ],
            ),
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
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.66 -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: SingleChildScrollView(
                    child: AppContainer(
                      padding: const AppEdgeInsets.all(AppGapSize.s12),
                      child: AppTabGrid(
                        tabs: widget.tabs,
                        selectedIndex: _selectedIndex,
                        onTabSelected: (index) {
                          widget.controller.animateTo(index);
                          setState(() {
                            _isExpanded = false;
                          });
                          _slideController.reverse();
                        },
                        tabBarKey: _tabBarKey,
                      ),
                    ),
                  ),
                ),
                const AppDivider()
              ],
            ),
          ),

        // Bottom bar for current tab
        if (currentTab.bottomBar != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: currentTab.bottomBar!,
          ),

        // Scroll to top button
        if (widget.scrollableContent && _showScrollButton)
          Positioned(
            right: theme.sizes.s16,
            bottom: floatingButtonBottom + bottomPadding,
            child: AppFloatingButton(
              icon: AppIcon.s12(
                theme.icons.characters.arrowUp,
                outlineThickness: AppLineThicknessData.normal().medium,
                outlineColor: theme.colors.white66,
              ),
              onTap: _scrollToTop,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _slideController.dispose();
    widget.controller.removeListener(_handleTabChange);
    super.dispose();
  }
}
