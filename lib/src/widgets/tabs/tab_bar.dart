import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';

class AppTabBar extends StatefulWidget {
  const AppTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onTabLongPress,
    this.onExpansionChanged,
  });

  final List<TabData> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final ValueChanged<int> onTabLongPress;
  final ValueChanged<bool>? onExpansionChanged;

  @override
  State<AppTabBar> createState() => AppTabBarState();
}

class AppTabBarState extends State<AppTabBar> with TickerProviderStateMixin {
  late final AnimationController _actionZoneController;
  late final AnimationController _popController;
  late final AnimationController _gridController;
  final _scrollController = ScrollController();
  final _initialScrollPosition = 0;
  late Animation<double> _actionWidthAnimation;
  late Animation<double> _actionScaleAnimation;
  late Animation<double> _fullWidthAnimation;
  final Map<int, GlobalKey> _tabKeys = {};
  bool _isExpanded = false;
  Timer? _startPositionTimer;
  bool _canOpenActionZone = true;

  @override
  void initState() {
    super.initState();
    _actionZoneController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _setupAnimations();
    _scrollController.addListener(_handleScroll);

    for (var i = 0; i < 100; i++) {
      _tabKeys[i] = GlobalKey();
    }

    _fullWidthAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _actionZoneController,
      curve: Curves.easeInOut,
    ));
  }

  void _setupAnimations() {
    _actionWidthAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _actionZoneController,
      curve: Curves.easeInOut,
    ));

    _actionScaleAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _actionZoneController,
      curve: Curves.elasticOut,
    ));
  }

  void _handleScroll() {
    if (!_scrollController.hasClients || _isExpanded) return;
    final theme = AppTheme.of(context);

    if (_scrollController.position.pixels > 0.1) {
      _canOpenActionZone = false;
    } else if (!_canOpenActionZone) {
      _startPositionTimer?.cancel();
      _startPositionTimer = Timer(const Duration(milliseconds: 20), () {
        _canOpenActionZone = true;
      });
    }

    final delta = _scrollController.position.pixels - _initialScrollPosition;
    if (delta < 0 && _canOpenActionZone) {
      final progress = (-delta / theme.sizes.s56).clamp(0, 1);

      final previousScale = _actionScaleAnimation.value;
      _actionScaleAnimation = Tween<double>(
        begin: 0,
        end: progress.toDouble(),
      ).animate(CurvedAnimation(
        parent: _actionZoneController,
        curve: Curves.elasticOut,
      ));

      _actionWidthAnimation = Tween<double>(
        begin: 0,
        end: (-delta).clamp(0, theme.sizes.s72),
      ).animate(CurvedAnimation(
        parent: _actionZoneController,
        curve: Curves.easeInOut,
      ));

      if (progress >= 0.99 &&
          previousScale < 0.99 &&
          !_popController.isAnimating) {
        _triggerTransitionSequence();
      }

      _actionZoneController.value = 1.0;
    }
  }

  Future<void> _triggerTransitionSequence() async {
    final width = MediaQuery.of(context).size.width;
    final theme = AppTheme.of(context);

    await _popController.forward(from: 0);
    await _popController.reverse();

    setState(() => _isExpanded = true);
    widget.onExpansionChanged?.call(true);

    _actionZoneController.duration = const Duration(milliseconds: 250);
    _actionWidthAnimation = Tween<double>(
      begin: theme.sizes.s72,
      end: width,
    ).animate(CurvedAnimation(
      parent: _actionZoneController,
      curve: Curves.easeInOut,
    ));

    await _actionZoneController.forward(from: 0);
  }

  void scrollToTab(int index) {
    final tabContext = _tabKeys[index]?.currentContext;
    if (tabContext != null) {
      // Get the RenderBox of the tab
      final RenderBox tabBox = tabContext.findRenderObject() as RenderBox;
      final RenderBox scrollBox = _scrollController
          .position.context.notificationContext!
          .findRenderObject() as RenderBox;

      // Convert tab position to global coordinates
      final tabOffset = tabBox.localToGlobal(Offset.zero, ancestor: scrollBox);

      // Calculate if tab is out of view
      final double scrollStart = _scrollController.offset;
      final double scrollEnd = scrollStart + scrollBox.size.width;
      final double tabStart = tabOffset.dx;
      final double tabEnd = tabStart + tabBox.size.width;

      // Only scroll horizontally if tab is not fully visible
      if (tabStart < scrollStart || tabEnd > scrollEnd) {
        final targetOffset =
            tabStart - (scrollBox.size.width - tabBox.size.width) / 2;
        _scrollController.animateTo(
          targetOffset.clamp(
            _scrollController.position.minScrollExtent,
            _scrollController.position.maxScrollExtent,
          ),
          duration: AppDurationsData.normal().normal,
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void closeActionZone() {
    setState(() => _isExpanded = false);
    widget.onExpansionChanged?.call(false);
    _actionZoneController.reverse();
    _actionWidthAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _actionZoneController,
      curve: Curves.easeInOut,
    ));
    _actionScaleAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _actionZoneController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppDivider(),
        SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              // Tab buttons
              AnimatedBuilder(
                animation: _actionWidthAnimation,
                builder: (context, child) => Transform.translate(
                  offset: Offset(
                      _isExpanded
                          ? _actionWidthAnimation.value + theme.sizes.s16
                          : 0,
                      0),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    clipBehavior: Clip.none,
                    physics: _isExpanded
                        ? const NeverScrollableScrollPhysics()
                        : const ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    dragStartBehavior: DragStartBehavior.down,
                    child: AppContainer(
                      padding: const AppEdgeInsets.symmetric(
                        horizontal: AppGapSize.s12,
                        vertical: AppGapSize.s12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < widget.tabs.length; i++) ...[
                            AppTabButton(
                              key: _tabKeys[i],
                              label: widget.tabs[i].label,
                              count: widget.tabs[i].count,
                              icon: widget.tabs[i].icon,
                              isSelected: i == widget.selectedIndex,
                              onTap: () => widget.onTabSelected(i),
                              onLongPress:
                                  widget.tabs[i].settingsContent != null
                                      ? () => widget.onTabLongPress(i)
                                      : null,
                            ),
                            if (i < widget.tabs.length - 1) const AppGap.s12(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Action zone
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: AnimatedBuilder(
                  animation: _actionWidthAnimation,
                  builder: (context, child) => SizedBox(
                    width: _actionWidthAnimation.value,
                    child: AppContainer(
                      decoration: BoxDecoration(
                        color: theme.colors.white16,
                      ),
                      child: Center(
                        child: ScaleTransition(
                          scale: _actionScaleAnimation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 1.0, end: 1.33).animate(
                              CurvedAnimation(
                                parent: _popController,
                                curve: Curves.easeOut,
                              ),
                            ),
                            child: AppIcon.s16(
                              theme.icons.characters.expand,
                              color: theme.colors.white66,
                              outlineColor: theme.colors.white66,
                              outlineThickness:
                                  AppLineThicknessData.normal().medium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Grid View should go here
        const AppDivider(),
      ],
    );
  }

  @override
  void dispose() {
    _actionZoneController.dispose();
    _popController.dispose();
    _gridController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
