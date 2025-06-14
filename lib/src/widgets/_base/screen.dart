import 'dart:ui';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:flutter/scheduler.dart';
import 'package:zaplab_design/src/notifications/scroll_progress_notification.dart';

class HistoryItem {
  const HistoryItem({
    required this.modelType,
    required this.modelId,
    required this.displayText,
    required this.timestamp,
    this.onTap,
  });

  final String modelType;
  final String modelId;
  final String displayText;
  final DateTime timestamp;
  final VoidCallback? onTap;
}

class AppScreen extends StatefulWidget {
  final Widget child;
  final Widget? topBarContent;
  final Widget? bottomBarContent;
  final List<HistoryItem> history;
  final VoidCallback onHomeTap;
  final bool alwaysShowTopBar;
  final bool customTopBar;
  final bool noTopGap;
  final ScrollController? scrollController;

  const AppScreen({
    super.key,
    required this.child,
    this.topBarContent,
    this.bottomBarContent,
    this.history = const [],
    required this.onHomeTap,
    this.alwaysShowTopBar = false,
    this.customTopBar = false,
    this.noTopGap = false,
    this.scrollController,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    Widget? topBarContent,
    Widget? bottomBarContent,
    List<HistoryItem> history = const [],
    bool alwaysShowTopBar = false,
    bool customTopBar = false,
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AppScreen(
          onHomeTap: () => Navigator.of(context).pop(),
          topBarContent: topBarContent,
          bottomBarContent: bottomBarContent,
          history: history,
          alwaysShowTopBar: alwaysShowTopBar,
          customTopBar: customTopBar,
          child: child,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final theme = AppTheme.of(context);
          return Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: AppContainer(
                  decoration: BoxDecoration(
                    color: theme.colors.gray33,
                  ),
                ),
              ),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                )),
                child: child,
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> with TickerProviderStateMixin {
  static const double _buttonHeight = 38.0;
  static const double _buttonWidthDelta = 32.0;
  static const double _topBarHeight = 64.0;

  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationControllerClose;
  late AnimationController _animationControllerOpen;
  bool _showTopZone = false;
  double _currentDrag = 0;
  bool _isAtTop = true;
  DateTime? _menuOpenedAt;
  bool _showTopBarContent = false;
  bool _isInitialDrag = true;
  bool _isPopping = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _animationControllerOpen = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animationControllerClose = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize _showTopBarContent based on alwaysShowTopBar
    _showTopBarContent = widget.alwaysShowTopBar;

    // Wait for the initial slide-in animation from the PageRouteBuilder
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _showTopZone = true);
    });
  }

  @override
  void dispose() {
    _animationControllerOpen.dispose();
    _animationControllerClose.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  double get _menuHeight {
    final topPadding = MediaQuery.of(context).padding.top;
    final baseHeight = 94.0 + (AppPlatformUtils.isMobile ? topPadding : 38.0);
    final historyHeight =
        widget.history.length * AppTheme.of(context).sizes.s38;
    return baseHeight + historyHeight;
  }

  bool get _shouldTreatAsEmpty =>
      widget.history.isEmpty || !AppPlatformUtils.isMobile;

  void _handleScroll() {
    setState(() {
      _isAtTop = _scrollController.offset <= 0;
      _showTopBarContent =
          widget.alwaysShowTopBar || _scrollController.offset > 2;
    });

    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll > 0) {
      final progress = _scrollController.offset / maxScroll;
      ScrollProgressNotification(progress, context).dispatch();
    }
  }

  void _openMenu() {
    final tween = Tween(
      begin: _currentDrag,
      end: _menuHeight,
    ).animate(CurvedAnimation(
      parent: _animationControllerOpen,
      curve: Curves.easeOut,
    ));

    tween.addListener(() {
      // Use addPostFrameCallback to avoid build during frame
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentDrag = tween.value;
            if (_currentDrag >= _menuHeight) {
              _menuOpenedAt = DateTime.now();
            }
          });
        }
      });
    });

    _animationControllerOpen
      ..reset()
      ..forward();
  }

  void _closeMenu() {
    final tween = Tween(
      begin: _currentDrag,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationControllerClose,
      curve: Curves.easeOut,
    ));

    tween.addListener(() {
      // Use addPostFrameCallback to avoid build during frame
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentDrag = tween.value;
            _showTopZone = _currentDrag <= 7.0;
          });
        }
      });
    });

    _animationControllerClose
      ..reset()
      ..forward();
  }

  void _handleDrag(double delta) {
    setState(() {
      // Check for empty history pop condition first
      if (_shouldTreatAsEmpty && _currentDrag + delta > 0) {
        _currentDrag = (_currentDrag + delta).clamp(0, 40.0).toDouble();
        if (_currentDrag >= 40.0 && Navigator.canPop(context)) {
          // Only pop if we're not already in the process of popping
          if (!_isPopping) {
            _isPopping = true;
            Navigator.of(context).pop();
          }
        }
        return;
      }

      // Otherwise handle normal drag behavior
      _currentDrag = (_currentDrag + delta).clamp(0, _menuHeight).toDouble();
      _showTopZone = _currentDrag <= 7.0;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dy;

    if (_shouldTreatAsEmpty && _currentDrag > 0) {
      _closeMenu();
      return;
    }

    if (_currentDrag > _menuHeight * 0.66) {
      if (velocity < -500) {
        _closeMenu();
      } else {
        _openMenu();
      }
    } else if (_currentDrag > _menuHeight * 0.33) {
      if (velocity > 500) {
        _openMenu();
      } else if (velocity < -500) {
        _closeMenu();
      } else {
        velocity > 0 ? _openMenu() : _closeMenu();
      }
    } else {
      if (velocity > 500) {
        _openMenu();
      } else {
        _closeMenu();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure _showTopBarContent is false when there's no content
    if (widget.topBarContent == null) {
      _showTopBarContent = false;
    }

    final theme = AppTheme.of(context);
    final progress = _currentDrag / _menuHeight;

    return Stack(
      children: [
        Column(
          children: [
            // Top zone (Safe Area))
            Opacity(
              opacity: _showTopZone ? 1.0 : 0.0,
              child: AppContainer(
                height: AppPlatformUtils.isMobile
                    ? MediaQuery.of(context).padding.top + 2
                    : 22,
                decoration: BoxDecoration(
                  color: _currentDrag < 5
                      ? theme.colors.black
                      : theme.colors.black33,
                ),
              ),
            ),

            // Main zone
            Expanded(
              child: Stack(
                children: [
                  // History menu
                  if (widget.history.isNotEmpty && AppPlatformUtils.isMobile)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final containerWidth = constraints.maxWidth;
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => Navigator.of(context).pop(),
                            onVerticalDragUpdate: (details) {
                              if (_currentDrag > 0) {
                                if (details.primaryDelta! > 0 &&
                                    Navigator.canPop(context) &&
                                    AppPlatformUtils.isMobile) {
                                  final now = DateTime.now();
                                  if (_menuOpenedAt != null &&
                                      now
                                              .difference(_menuOpenedAt!)
                                              .inMilliseconds >
                                          800) {
                                    Navigator.of(context).pop();
                                  }
                                } else {
                                  _handleDrag(details.primaryDelta!);
                                }
                              }
                            },
                            onHorizontalDragStart: (_) {},
                            onHorizontalDragUpdate: (_) {},
                            onHorizontalDragEnd: (_) {},
                            child: AppContainer(
                              height: _menuHeight,
                              padding: const AppEdgeInsets.symmetric(
                                horizontal: AppGapSize.s16,
                                vertical: AppGapSize.none,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Transform.translate(
                                    offset: Offset(
                                        0,
                                        -_buttonHeight *
                                            (1 - progress) *
                                            (0.3)),
                                    child: TapBuilder(
                                      onTap: widget.onHomeTap,
                                      builder: (context, state, hasFocus) {
                                        double scaleFactor = 1.0;
                                        if (state == TapState.pressed) {
                                          scaleFactor = 0.99;
                                        } else if (state == TapState.hover) {
                                          scaleFactor = 1.01;
                                        }

                                        return Transform.scale(
                                          scale: scaleFactor,
                                          child: AppContainer(
                                            decoration: BoxDecoration(
                                              color: theme.colors.white16,
                                              borderRadius: theme.radius
                                                  .asBorderRadius()
                                                  .rad16,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: theme.colors.white16,
                                                  blurRadius: theme.sizes.s56,
                                                ),
                                              ],
                                            ),
                                            padding: const AppEdgeInsets.all(
                                                AppGapSize.s16),
                                            child: AppIcon.s20(
                                              theme.icons.characters.home,
                                              color: theme.colors.white66,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const AppGap.s24(),
                                  Transform.translate(
                                    offset: Offset(0,
                                        -_buttonHeight * (1 - progress) * 0.8),
                                    child: SizedBox(
                                      height: _buttonHeight,
                                      width: containerWidth -
                                          (_buttonWidthDelta * 4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: theme.radius.rad16,
                                          topRight: theme.radius.rad16,
                                        ),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 24, sigmaY: 24),
                                          child: AppContainer(
                                            decoration: BoxDecoration(
                                              color: theme.colors.white8,
                                              borderRadius: BorderRadius.only(
                                                topLeft: theme.radius.rad16,
                                                topRight: theme.radius.rad16,
                                              ),
                                              border: Border(
                                                top: BorderSide(
                                                  color: AppColorsData.dark()
                                                      .white16,
                                                  width: AppLineThicknessData
                                                          .normal()
                                                      .thin,
                                                ),
                                              ),
                                            ),
                                            padding:
                                                const AppEdgeInsets.symmetric(
                                              horizontal: AppGapSize.s16,
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  AppText.reg12(
                                                    'More History...',
                                                    color: theme.colors.white66,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ...List.generate(
                                    widget.history.length,
                                    (index) => Transform.translate(
                                      offset: Offset(
                                          0,
                                          -_buttonHeight *
                                              (1 - progress) *
                                              (index + 2)),
                                      child: SizedBox(
                                        height: _buttonHeight,
                                        width: containerWidth -
                                            (_buttonWidthDelta * (3 - index)),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: theme.radius.rad16,
                                            topRight: theme.radius.rad16,
                                          ),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 24, sigmaY: 24),
                                            child: TapBuilder(
                                              onTap: () {
                                                widget.history[index].onTap
                                                    ?.call();
                                              },
                                              builder:
                                                  (context, state, hasFocus) {
                                                return AppContainer(
                                                  decoration: BoxDecoration(
                                                    color: theme.colors.white8,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          theme.radius.rad16,
                                                      topRight:
                                                          theme.radius.rad16,
                                                    ),
                                                    border: Border(
                                                      top: BorderSide(
                                                        color:
                                                            AppColorsData.dark()
                                                                .white16,
                                                        width:
                                                            AppLineThicknessData
                                                                    .normal()
                                                                .thin,
                                                      ),
                                                    ),
                                                  ),
                                                  padding: const AppEdgeInsets
                                                      .symmetric(
                                                    horizontal: AppGapSize.s16,
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        AppText.reg12(
                                                          widget.history[index]
                                                              .modelType,
                                                          color: theme
                                                              .colors.white66,
                                                        ),
                                                        const AppGap.s8(),
                                                        Expanded(
                                                          child: AppText.reg12(
                                                            widget
                                                                .history[index]
                                                                .displayText,
                                                            color: theme
                                                                .colors.white,
                                                            maxLines: 1,
                                                            textOverflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  // Main content
                  Transform.translate(
                    offset: Offset(0, _currentDrag),
                    child: AppContainer(
                      width: double.infinity,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: theme.colors.black,
                        borderRadius: BorderRadius.vertical(
                          top: progress > 0 ? theme.radius.rad16 : Radius.zero,
                        ),
                        border: Border(
                          top: BorderSide(
                            color: theme.colors.white16,
                            width: _currentDrag > 0
                                ? AppLineThicknessData.normal().thin
                                : AppLineThicknessData.normal().medium,
                          ),
                        ),
                      ),
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height *
                                theme.system.scale -
                            (_topBarHeight +
                                (AppPlatformUtils.isMobile
                                    ? MediaQuery.of(context).padding.top
                                    : 20)),
                      ),
                      child: AppScaffold(
                        body: Stack(
                          children: [
                            // Scrollable content that goes under the top bar
                            Positioned(
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (notification.metrics.axis !=
                                      Axis.vertical) {
                                    return false; // Ignore horizontal scroll notifications
                                  }

                                  if (notification
                                      is ScrollUpdateNotification) {
                                    if (_isAtTop &&
                                        notification.metrics.pixels < 0) {
                                      if (notification.dragDetails != null) {
                                        _handleDrag(
                                            -notification.metrics.pixels * 0.2);
                                        return true;
                                      } else if (_currentDrag > 0) {
                                        // Menu is partially open but no active drag
                                        // Snap to nearest position based on current position
                                        if (_currentDrag > _menuHeight * 0.33) {
                                          _openMenu();
                                        } else {
                                          _closeMenu();
                                        }
                                        return true;
                                      }
                                    }
                                  }
                                  return false;
                                },
                                child: SingleChildScrollView(
                                  controller: widget.scrollController ??
                                      _scrollController,
                                  physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics(),
                                  ),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minHeight: 480,
                                    ),
                                    child: Column(
                                      children: [
                                        // Top padding to account for the gap and drag handle in the top bar
                                        if (!widget.noTopGap)
                                          !AppPlatformUtils.isMobile
                                              ? const AppGap.s8()
                                              : const AppGap.s10(),
                                        // Actual content
                                        widget.child,
                                        if (widget.bottomBarContent != null)
                                          SizedBox(
                                            height: AppPlatformUtils.isMobile
                                                ? 60
                                                : 70,
                                          ),
                                        const AppBottomSafeArea(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            //Black bar that renders the top 8px of the screen always in black so that the blure of the top bar's white top border doesn't pick up on the screen content.
                            if (!widget.noTopGap)
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: AppContainer(
                                  height: theme.sizes.s8,
                                  decoration: BoxDecoration(
                                    color: theme.colors.black,
                                  ),
                                ),
                              ),

                            // Top Bar + Gesture detection zone
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onVerticalDragStart: (details) {
                                  if (_currentDrag < _menuHeight) {
                                    _menuOpenedAt = null;
                                    _isInitialDrag = true;
                                  }
                                },
                                onVerticalDragUpdate: (details) {
                                  if (!_isInitialDrag &&
                                      _currentDrag >= _menuHeight &&
                                      _menuOpenedAt != null &&
                                      details.primaryDelta! > 0 &&
                                      Navigator.canPop(context) &&
                                      AppPlatformUtils.isMobile) {
                                    Navigator.of(context).pop();
                                  } else {
                                    _handleDrag(details.primaryDelta!);
                                  }
                                },
                                onVerticalDragEnd: (details) {
                                  _isInitialDrag = false;
                                  _handleDragEnd(details);
                                },
                                onHorizontalDragStart: (_) {},
                                onHorizontalDragUpdate: (_) {},
                                onHorizontalDragEnd: (_) {},
                                onTap: _currentDrag > 0 ? _closeMenu : null,
                                child: AppContainer(
                                  height: _currentDrag > 0 ? 2000 : null,
                                  decoration: const BoxDecoration(
                                    color: Color(0x00000000),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        child: BackdropFilter(
                                          filter: _showTopBarContent
                                              ? ImageFilter.blur(
                                                  sigmaX: 24,
                                                  sigmaY: 24,
                                                )
                                              : ImageFilter.blur(
                                                  sigmaX: 0, sigmaY: 0),
                                          child: AppContainer(
                                            decoration: BoxDecoration(
                                              gradient: _showTopBarContent
                                                  ? LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        theme.colors.black,
                                                        theme.colors.black
                                                            .withValues(
                                                                alpha: 0.33),
                                                      ],
                                                    )
                                                  : null,
                                              color: _showTopBarContent
                                                  ? null
                                                  : const Color(0x00000000),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const AppGap.s8(),
                                                const AppDragHandle(),
                                                if (widget.topBarContent !=
                                                        null &&
                                                    _showTopBarContent) ...[
                                                  AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 100),
                                                    height: widget
                                                            .alwaysShowTopBar
                                                        ? null
                                                        : !_scrollController
                                                                    .hasClients ||
                                                                _scrollController
                                                                        .offset <
                                                                    2
                                                            ? 0.0
                                                            : _scrollController
                                                                        .offset >
                                                                    68
                                                                ? null
                                                                : (_scrollController
                                                                            .offset -
                                                                        2) /
                                                                    66 *
                                                                    68,
                                                    child: widget
                                                                .alwaysShowTopBar ||
                                                            (!_scrollController
                                                                    .hasClients ||
                                                                _scrollController
                                                                        .offset >=
                                                                    68)
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              if (_scrollController
                                                                  .hasClients) {
                                                                _scrollController
                                                                    .animateTo(
                                                                  0,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  curve: Curves
                                                                      .easeOut,
                                                                );
                                                              }
                                                            },
                                                            child: MouseRegion(
                                                              cursor: AppPlatformUtils
                                                                      .isDesktop
                                                                  ? SystemMouseCursors
                                                                      .click
                                                                  : MouseCursor
                                                                      .defer,
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  widget
                                                                          .customTopBar
                                                                      ? widget
                                                                          .topBarContent!
                                                                      : Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            AppContainer(
                                                                              padding: AppEdgeInsets.only(
                                                                                left: AppGapSize.s12,
                                                                                right: AppGapSize.s12,
                                                                                bottom: AppPlatformUtils.isMobile ? AppGapSize.s12 : AppGapSize.s10,
                                                                              ),
                                                                              child: widget.topBarContent!,
                                                                            ),
                                                                            const AppDivider(),
                                                                          ],
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : const Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SizedBox(
                                                                  width: double
                                                                      .infinity),
                                                              Spacer(),
                                                              AppDivider(),
                                                            ],
                                                          ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: widget.bottomBarContent != null
              ? widget.bottomBarContent!
              : ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: AppContainer(
                      decoration: BoxDecoration(
                        color: theme.colors.black33,
                      ),
                      child: const AppBottomSafeArea(),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
