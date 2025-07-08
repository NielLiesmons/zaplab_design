import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'dart:ui' as ui;

class LabTabBar extends StatefulWidget {
  final List<TabData> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final ValueChanged<int> onTabLongPress;
  final ValueChanged<bool>? onExpansionChanged;
  const LabTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onTabLongPress,
    this.onExpansionChanged,
  });

  @override
  State<LabTabBar> createState() => LabTabBarState();
}

class LabTabBarState extends State<LabTabBar> with TickerProviderStateMixin {
  late final AnimationController _actionZoneController;
  late final AnimationController _popController;
  late final AnimationController _gridController;
  final _scrollController = ScrollController();
  final _initialScrollPosition = 0;
  late Animation<double> _actionWidthAnimation;
  late Animation<double> _actionScaleAnimation;
  // ignore: unused_field
  late Animation<double> _fullWidthAnimation;
  final Map<int, GlobalKey> _tabKeys = {};
  bool _isExpanded = false;
  Timer? _startPositionTimer;
  bool _canOpenActionZone = true;
  bool _isHovered = false;
  bool _isScrollable = false;

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

    // Add a post-frame callback to check initial scrollability
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScrollability();
    });
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
    final theme = LabTheme.of(context);

    // Check scrollability when scroll position changes
    _checkScrollability();

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
        _triggerTransitionSequence(isButtonClick: false);
      }

      _actionZoneController.value = 1.0;
    }
  }

  Future<void> _triggerTransitionSequence({bool isButtonClick = false}) async {
    final width = MediaQuery.of(context).size.width;
    final theme = LabTheme.of(context);

    if (isButtonClick) {
      // Fast parallel animation for button clicks
      setState(() => _isExpanded = true);
      widget.onExpansionChanged?.call(true);

      _actionZoneController.duration = const Duration(milliseconds: 200);
      _actionWidthAnimation = Tween<double>(
        begin: theme.sizes.s72,
        end: width,
      ).animate(CurvedAnimation(
        parent: _actionZoneController,
        curve: Curves.easeInOut,
      ));

      await Future.wait([
        _popController.forward(from: 0),
        _actionZoneController.forward(from: 0),
      ]);

      await _popController.reverse();
    } else {
      // Original sequential animation for drag/swipe
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
          duration: LabDurationsData.normal().normal,
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

  void _checkScrollability() {
    if (!mounted || !_scrollController.hasClients) return;
    final isScrollable = _scrollController.position.maxScrollExtent > 0;
    if (isScrollable != _isScrollable) {
      setState(() => _isScrollable = isScrollable);
    }
  }

  @override
  void didUpdateWidget(LabTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabs != widget.tabs) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkScrollability();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LabDivider(),
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
                      child: LabContainer(
                        padding: const LabEdgeInsets.symmetric(
                          horizontal: LabGapSize.s12,
                          vertical: LabGapSize.s12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var i = 0; i < widget.tabs.length; i++) ...[
                              LabTabButton(
                                key: _tabKeys[i],
                                label: widget.tabs[i].label,
                                count: widget.tabs[i].count,
                                icon: widget.tabs[i].icon,
                                isSelected: i == widget.selectedIndex,
                                hasOptions:
                                    widget.tabs[i].optionssContent != null,
                                onTap: () {
                                  if (i == widget.selectedIndex &&
                                      widget.tabs[i].optionssContent != null) {
                                    widget.onTabLongPress(i);
                                  } else {
                                    widget.onTabSelected(i);
                                  }
                                },
                                onLongPress:
                                    widget.tabs[i].optionssContent != null
                                        ? () => widget.onTabLongPress(i)
                                        : null,
                              ),
                              if (i < widget.tabs.length - 1)
                                const LabGap.s12(),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Left hover zone
                if (!LabPlatformUtils.isMobile && _isHovered && _isScrollable)
                  AnimatedBuilder(
                    animation: Listenable.merge(
                        [_actionWidthAnimation, _scrollController]),
                    builder: (context, child) => _actionWidthAnimation.value > 2
                        ? const SizedBox.shrink()
                        : Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Stack(
                              children: [
                                IgnorePointer(
                                  child: ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return ui.Gradient.linear(
                                        Offset(0, bounds.center.dy),
                                        Offset(
                                            theme.sizes.s64, bounds.center.dy),
                                        [
                                          const Color(0xFFFFFFFF),
                                          const Color(0x00000000),
                                        ],
                                        [0.0, 1.0],
                                      );
                                    },
                                    blendMode: BlendMode.dstIn,
                                    child: LabContainer(
                                      width: theme.sizes.s64,
                                      decoration: BoxDecoration(
                                        color: ModalScope.of(context)
                                            ? theme.colors.gray66
                                            : theme.colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 12,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: ClipOval(
                                      child: BackdropFilter(
                                        filter: ui.ImageFilter.blur(
                                            sigmaX: 24, sigmaY: 24),
                                        child: LabSmallButton(
                                          rounded: true,
                                          square: true,
                                          color: theme.colors.white16,
                                          onTap: _scrollController
                                                      .position.pixels <=
                                                  0
                                              ? () =>
                                                  _triggerTransitionSequence(
                                                      isButtonClick: true)
                                              : () {
                                                  _scrollController.animateTo(
                                                    _scrollController
                                                            .position.pixels -
                                                        theme.sizes.s104 * 2,
                                                    duration: LabDurationsData
                                                            .normal()
                                                        .normal,
                                                    curve: Curves.easeInOut,
                                                  );
                                                },
                                          children: [
                                            LabIcon.s12(
                                              _scrollController
                                                          .position.pixels <=
                                                      0
                                                  ? theme
                                                      .icons.characters.expand
                                                  : theme.icons.characters
                                                      .chevronLeft,
                                              outlineColor: theme.colors.white,
                                              outlineThickness:
                                                  LabLineThicknessData.normal()
                                                      .medium,
                                            ),
                                            if (_scrollController
                                                    .position.pixels >=
                                                0)
                                              const LabGap.s2(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                // Right hover zone
                if (!LabPlatformUtils.isMobile && _isHovered && _isScrollable)
                  AnimatedBuilder(
                    animation: Listenable.merge(
                        [_actionWidthAnimation, _scrollController]),
                    builder: (context, child) => _actionWidthAnimation.value >
                                2 ||
                            _scrollController.position.pixels >=
                                _scrollController.position.maxScrollExtent
                        ? const SizedBox.shrink()
                        : Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Stack(
                              children: [
                                IgnorePointer(
                                  child: ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return ui.Gradient.linear(
                                        Offset(bounds.width - theme.sizes.s64,
                                            bounds.center.dy),
                                        Offset(bounds.width, bounds.center.dy),
                                        [
                                          const Color(0x00000000),
                                          const Color(0xFFFFFFFF),
                                        ],
                                        [0.0, 1.0],
                                      );
                                    },
                                    blendMode: BlendMode.dstIn,
                                    child: LabContainer(
                                      width: theme.sizes.s64,
                                      decoration: BoxDecoration(
                                        color: ModalScope.of(context)
                                            ? theme.colors.gray66
                                            : theme.colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 12,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: ClipOval(
                                      child: BackdropFilter(
                                        filter: ui.ImageFilter.blur(
                                            sigmaX: 24, sigmaY: 24),
                                        child: LabSmallButton(
                                          rounded: true,
                                          square: true,
                                          color: theme.colors.white16,
                                          onTap: () {
                                            _scrollController.animateTo(
                                              _scrollController
                                                      .position.pixels +
                                                  theme.sizes.s104 * 2,
                                              duration:
                                                  LabDurationsData.normal()
                                                      .normal,
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                          children: [
                                            const LabGap.s2(),
                                            LabIcon.s12(
                                              theme.icons.characters
                                                  .chevronRight,
                                              outlineColor: theme.colors.white,
                                              outlineThickness:
                                                  LabLineThicknessData.normal()
                                                      .medium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                      child: LabContainer(
                        decoration: BoxDecoration(
                          color: theme.colors.white16,
                        ),
                        child: Center(
                          child: ScaleTransition(
                            scale: _actionScaleAnimation,
                            child: ScaleTransition(
                              scale:
                                  Tween<double>(begin: 1.0, end: 1.33).animate(
                                CurvedAnimation(
                                  parent: _popController,
                                  curve: Curves.easeOut,
                                ),
                              ),
                              child: LabIcon.s16(
                                theme.icons.characters.expand,
                                color: theme.colors.white66,
                                outlineColor: theme.colors.white66,
                                outlineThickness:
                                    LabLineThicknessData.normal().medium,
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
          const LabDivider(),
        ],
      ),
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
