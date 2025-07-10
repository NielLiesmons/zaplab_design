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

class LabScreen extends StatefulWidget {
  final Widget child;
  final Widget? topBarContent;
  final Widget? bottomBarContent;
  final List<HistoryItem> history;
  final VoidCallback onHomeTap;
  final bool alwaysShowTopBar;
  final bool customTopBar;
  final bool noTopGap;
  final ScrollController? scrollController;
  final bool startAtBottom;
  final bool showScrollToBottomButton;

  const LabScreen({
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
    this.startAtBottom = false,
    this.showScrollToBottomButton = true,
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
        pageBuilder: (context, animation, secondaryAnimation) => LabScreen(
          onHomeTap: () => Navigator.of(context).pop(),
          topBarContent: topBarContent,
          bottomBarContent: bottomBarContent,
          history: history,
          alwaysShowTopBar: alwaysShowTopBar,
          customTopBar: customTopBar,
          child: child,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final theme = LabTheme.of(context);
          return Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: LabContainer(
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
  State<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen> with TickerProviderStateMixin {
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
  bool _showScrollToBottomButton = false;

  @override
  void initState() {
    super.initState();
    final controller = widget.scrollController ?? _scrollController;
    controller.addListener(_handleScroll);
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

      // If startAtBottom is true, scroll to bottom after initial build
      if (widget.startAtBottom) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final controller = widget.scrollController ?? _scrollController;
              if (controller.hasClients) {
                final maxScroll = controller.position.maxScrollExtent;
                final currentOffset = controller.offset;
                print(
                    'DEBUG: startAtBottom - maxScroll=$maxScroll, currentOffset=$currentOffset');
                controller.jumpTo(maxScroll);
                print('DEBUG: After jumpTo - newOffset=${controller.offset}');
              }
            });
          });
        });
      }
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
    final baseHeight = 94.0 + (LabPlatformUtils.isMobile ? topPadding : 38.0);
    final historyHeight =
        widget.history.length * LabTheme.of(context).sizes.s38;
    return baseHeight + historyHeight;
  }

  bool get _shouldTreatAsEmpty =>
      widget.history.isEmpty || !LabPlatformUtils.isMobile;

  void _handleScroll() {
    final controller = widget.scrollController ?? _scrollController;

    setState(() {
      _isAtTop = controller.offset <= 0;
      _showTopBarContent = widget.alwaysShowTopBar || controller.offset > 2;

      // Show scroll button when scrolling past 100px
      if (widget.showScrollToBottomButton && controller.hasClients) {
        if (widget.startAtBottom) {
          // If started at bottom, show button when scrolling up past 100px
          _showScrollToBottomButton =
              controller.offset < controller.position.maxScrollExtent - 320;
        } else {
          // If started at top, show button when scrolling down past 100px
          _showScrollToBottomButton = controller.offset > 320;
        }
      }
    });

    final maxScroll = controller.position.maxScrollExtent;
    if (maxScroll > 0) {
      final progress = controller.offset / maxScroll;
      ScrollProgressNotification(progress, context).dispatch();

      // Debug logging for bottom detection
      if (widget.startAtBottom) {
        final distanceFromBottom = maxScroll - controller.offset;
        print(
            'DEBUG: Distance from bottom = $distanceFromBottom, offset=${controller.offset}, maxScroll=$maxScroll');
      }
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

    final theme = LabTheme.of(context);
    final progress = _currentDrag / _menuHeight;

    return Stack(
      children: [
        Column(
          children: [
            // Top zone (Safe Area))
            Opacity(
              opacity: _showTopZone ? 1.0 : 0.0,
              child: LabContainer(
                height: LabPlatformUtils.isMobile
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
                  if (widget.history.isNotEmpty && LabPlatformUtils.isMobile)
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
                                    LabPlatformUtils.isMobile) {
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
                            child: LabContainer(
                              height: _menuHeight,
                              padding: const LabEdgeInsets.symmetric(
                                horizontal: LabGapSize.s16,
                                vertical: LabGapSize.none,
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
                                          child: LabContainer(
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
                                            padding: const LabEdgeInsets.all(
                                                LabGapSize.s16),
                                            child: LabIcon.s20(
                                              theme.icons.characters.home,
                                              color: theme.colors.white66,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const LabGap.s24(),
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
                                          child: LabContainer(
                                            decoration: BoxDecoration(
                                              color: theme.colors.white8,
                                              borderRadius: BorderRadius.only(
                                                topLeft: theme.radius.rad16,
                                                topRight: theme.radius.rad16,
                                              ),
                                              border: Border(
                                                top: BorderSide(
                                                  color: LabColorsData.dark()
                                                      .white16,
                                                  width: LabLineThicknessData
                                                          .normal()
                                                      .thin,
                                                ),
                                              ),
                                            ),
                                            padding:
                                                const LabEdgeInsets.symmetric(
                                              horizontal: LabGapSize.s16,
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  LabText.reg12(
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
                                                return LabContainer(
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
                                                            LabColorsData.dark()
                                                                .white16,
                                                        width:
                                                            LabLineThicknessData
                                                                    .normal()
                                                                .thin,
                                                      ),
                                                    ),
                                                  ),
                                                  padding: const LabEdgeInsets
                                                      .symmetric(
                                                    horizontal: LabGapSize.s16,
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        LabText.reg12(
                                                          widget.history[index]
                                                              .modelType,
                                                          color: theme
                                                              .colors.white66,
                                                        ),
                                                        const LabGap.s8(),
                                                        Expanded(
                                                          child: LabText.reg12(
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
                    child: LabContainer(
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
                                ? LabLineThicknessData.normal().thin
                                : LabLineThicknessData.normal().medium,
                          ),
                        ),
                      ),
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height *
                                theme.system.scale -
                            (_topBarHeight +
                                (LabPlatformUtils.isMobile
                                    ? MediaQuery.of(context).padding.top
                                    : 20)),
                      ),
                      child: LabScaffold(
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
                                          !LabPlatformUtils.isMobile
                                              ? const LabGap.s8()
                                              : const LabGap.s10(),
                                        // Actual content
                                        widget.child,
                                        if (widget.bottomBarContent != null)
                                          SizedBox(
                                            height: LabPlatformUtils.isMobile
                                                ? 60
                                                : 70,
                                          ),
                                        const LabBottomSafeArea(),
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
                                child: LabContainer(
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
                                      LabPlatformUtils.isMobile) {
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
                                child: LabContainer(
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
                                          child: LabContainer(
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
                                                const LabGap.s8(),
                                                const LabDragHandle(),
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
                                                              cursor: LabPlatformUtils
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
                                                                            LabContainer(
                                                                              padding: LabEdgeInsets.only(
                                                                                left: LabGapSize.s12,
                                                                                right: LabGapSize.s12,
                                                                                bottom: LabPlatformUtils.isMobile ? LabGapSize.s12 : LabGapSize.s10,
                                                                              ),
                                                                              child: widget.topBarContent!,
                                                                            ),
                                                                            const LabDivider(),
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
                                                              LabDivider(),
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
                    child: LabContainer(
                      decoration: BoxDecoration(
                        color: theme.colors.black33,
                      ),
                      child: const LabBottomSafeArea(),
                    ),
                  ),
                ),
        ),

        // Floating scroll to bottom button
        if (widget.showScrollToBottomButton && _showScrollToBottomButton)
          Positioned(
            right: theme.sizes.s16,
            bottom: theme.sizes.s16 +
                (widget.bottomBarContent != null ? 70.0 : 0.0) +
                MediaQuery.of(context).padding.bottom,
            child: LabFloatingButton(
              icon: LabIcon.s12(
                widget.startAtBottom
                    ? theme.icons.characters.arrowDown
                    : theme.icons.characters.arrowUp,
                outlineThickness: LabLineThicknessData.normal().medium,
                outlineColor: theme.colors.white66,
              ),
              onTap: () {
                final controller = widget.scrollController ?? _scrollController;
                if (controller.hasClients) {
                  if (widget.startAtBottom) {
                    // If started at bottom, scroll to bottom
                    controller.animateTo(
                      controller.position.maxScrollExtent,
                      duration: LabDurationsData.normal().normal,
                      curve: Curves.easeOut,
                    );
                  } else {
                    // If started at top, scroll to top
                    controller.animateTo(
                      0,
                      duration: LabDurationsData.normal().normal,
                      curve: Curves.easeOut,
                    );
                  }
                }
              },
            ),
          ),
      ],
    );
  }
}
