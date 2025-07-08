import 'package:zaplab_design/zaplab_design.dart';

class TabData {
  final String label;
  final Widget content;
  final Widget icon;
  final int? count;
  final Widget? optionssContent;
  final String? optionsDescription;
  final Widget? bottomBar;
  const TabData({
    required this.label,
    required this.content,
    required this.icon,
    this.count,
    this.optionssContent,
    this.optionsDescription,
    this.bottomBar,
  });
}

class LabTabView extends StatefulWidget {
  final List<TabData> tabs;
  final LabTabController controller;
  final bool scrollableContent;
  final void Function(double)? onScroll;
  final double? scrollOffsetHeight;
  const LabTabView({
    super.key,
    required this.tabs,
    required this.controller,
    this.scrollableContent = false,
    this.onScroll,
    this.scrollOffsetHeight,
  });

  @override
  State<LabTabView> createState() => _LabTabViewState();
}

class _LabTabViewState extends State<LabTabView> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isExpanded = false;
  bool _showScrollButton = false;
  late final AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  final _tabBarKey = GlobalKey<LabTabBarState>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: LabDurationsData.normal().normal,
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
      duration: LabDurationsData.normal().normal,
      curve: Curves.easeOut,
    );
  }

  Future<void> _showOptionssModal(BuildContext context, TabData tab) async {
    if (tab.optionssContent == null) return;
    final theme = LabTheme.of(context);
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    final isInsideModal = ModalScope.of(context);

    if (isInsideModal) {
      await LabModal.showInOtherModal(
        rootContext,
        title: tab.label,
        description: tab.optionsDescription,
        children: [tab.optionssContent!],
        bottomBar: LabButton(
          onTap: () => Navigator.of(context).pop(),
          gradient: theme.colors.blurple,
          pressedGradient: theme.colors.blurple,
          children: [
            LabText.med16(
              'Done',
              color: theme.colors.whiteEnforced,
            ),
          ],
        ),
      );
    } else {
      await LabModal.show(
        rootContext,
        title: tab.label,
        description: tab.optionsDescription,
        children: [tab.optionssContent!],
        bottomBar: LabButton(
          onTap: () => Navigator.of(context).pop(),
          gradient: theme.colors.blurple,
          pressedGradient: theme.colors.blurple,
          children: [
            LabText.med16(
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
    final theme = LabTheme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final currentTab = widget.tabs[_selectedIndex];
    final floatingButtonBottom = currentTab.bottomBar != null
        ? (currentTab.bottomBar is LabBottomBarSafeArea ? 16 : 84)
        : 16;

    return Stack(
      children: [
        // Main content that slides right
        SlideTransition(
          position: _slideAnimation,
          child: SizedBox(
            height: widget.scrollableContent
                ? MediaQuery.of(context).size.height /
                    LabTheme.of(context).system.scale
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LabTabBar(
                  key: _tabBarKey,
                  tabs: widget.tabs,
                  selectedIndex: _selectedIndex,
                  onTabSelected: (index) {
                    widget.controller.animateTo(index);
                  },
                  onTabLongPress: (index) {
                    _showOptionssModal(context, widget.tabs[index]);
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
                      child: Column(
                        children: [
                          if (widget.scrollOffsetHeight != null)
                            SizedBox(
                              height: widget.scrollOffsetHeight! *
                                  (_scrollController.hasClients
                                          ? _scrollController.position.pixels /
                                              widget.scrollOffsetHeight!
                                          : 0)
                                      .clamp(0, 1),
                            ),
                          widget.tabs[_selectedIndex].content,
                        ],
                      ),
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
                const LabDivider(),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.66 -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: SingleChildScrollView(
                    child: LabContainer(
                      padding: const LabEdgeInsets.all(LabGapSize.s12),
                      child: LabTabGrid(
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
                const LabDivider()
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
            child: LabFloatingButton(
              icon: LabIcon.s12(
                theme.icons.characters.arrowUp,
                outlineThickness: LabLineThicknessData.normal().medium,
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
