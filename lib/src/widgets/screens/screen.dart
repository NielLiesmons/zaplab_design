import 'dart:ui';
import 'dart:io' show Platform;
import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:flutter/scheduler.dart';

class HistoryItem {
  const HistoryItem({
    required this.contentType,
    required this.title,
    // TODO: add callback
  });

  final String contentType;
  final String title;
  // TODO: add callback
}

class AppScreen extends StatefulWidget {
  const AppScreen({
    super.key,
    required this.child,
    this.topBarContent,
    required this.onHomeTap,
    this.history = const [],
  });

  final Widget child;
  final Widget? topBarContent;
  final VoidCallback onHomeTap;
  final List<HistoryItem> history;

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    List<HistoryItem> history = const [],
    Widget? topBarContent,
    VoidCallback? onHomeTap,
  }) {
    final theme = AppTheme.of(context);

    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: const Color(0x00000000),
        transitionDuration: theme.durations.fast,
        reverseTransitionDuration: theme.durations.normal,
        pageBuilder: (_, __, ___) => AppScreen(
          history: history,
          topBarContent: topBarContent,
          child: child,
          onHomeTap: onHomeTap!,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: AppContainer(
                  decoration: BoxDecoration(
                    color: theme.colors.grey33,
                  ),
                ),
              ),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
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
    final baseHeight =
        94.0 + (Platform.isIOS || Platform.isAndroid ? topPadding : 38.0);
    final historyHeight =
        widget.history.length * AppTheme.of(context).sizes.s38;
    return baseHeight + historyHeight;
  }

  void _handleScroll() {
    setState(() {
      _isAtTop = _scrollController.offset <= 0;
      _showTopBarContent = _scrollController.offset > 7.0;
    });
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
      _currentDrag = (_currentDrag + delta).clamp(0, _menuHeight).toDouble();
      _showTopZone = _currentDrag <= 7.0; // Only show when near top
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dy;

    if (_currentDrag > _menuHeight * 0.66) {
      // In top third when dragging up
      if (velocity < -500) {
        // Fast upward flick
        _closeMenu();
      } else {
        _openMenu(); // Snap back to open
      }
    } else if (_currentDrag > _menuHeight * 0.33) {
      // In middle third
      if (velocity > 500) {
        // Fast downward flick
        _openMenu();
      } else if (velocity < -500) {
        // Fast upward flick
        _closeMenu();
      } else {
        // Snap to nearest end based on direction
        velocity > 0 ? _openMenu() : _closeMenu();
      }
    } else {
      // In bottom third
      if (velocity > 500) {
        // Fast downward flick
        _openMenu();
      } else {
        _closeMenu(); // Snap back to closed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final progress = _currentDrag / _menuHeight;

    return Column(
      children: [
        // Top zone (Safe Area))
        Opacity(
          opacity: _showTopZone ? 1.0 : 0.0,
          child: AppContainer(
            height: Platform.isIOS || Platform.isAndroid
                ? MediaQuery.of(context).padding.top + 2
                : 26,
            decoration: BoxDecoration(
              color:
                  _currentDrag < 5 ? theme.colors.black : theme.colors.black33,
            ),
          ),
        ),

        // Main zone
        Expanded(
          child: Stack(
            children: [
              // History menu
              if (widget.history.isNotEmpty)
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
                                (Platform.isIOS || Platform.isAndroid)) {
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
                                    0, -_buttonHeight * (1 - progress) * (0.3)),
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
                                offset: Offset(
                                    0, -_buttonHeight * (1 - progress) * 0.8),
                                child: SizedBox(
                                  height: _buttonHeight,
                                  width:
                                      containerWidth - (_buttonWidthDelta * 4),
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
                                              color:
                                                  AppColorsData.dark().white16,
                                              width: LineThicknessData.normal()
                                                  .thin,
                                            ),
                                          ),
                                        ),
                                        padding: const AppEdgeInsets.symmetric(
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
                                                width:
                                                    LineThicknessData.normal()
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
                                                  widget.history[index]
                                                      .contentType,
                                                  color: theme.colors.white66,
                                                ),
                                                const AppGap.s8(),
                                                AppText.reg12(
                                                  widget.history[index].title,
                                                  color: theme.colors.white,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
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
                      );
                    },
                  ),
                ),
              // Main content
              Transform.translate(
                offset: Offset(0, _currentDrag),
                child: AppContainer(
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
                            ? LineThicknessData.normal().thin
                            : LineThicknessData.normal().medium,
                      ),
                    ),
                  ),
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        (_topBarHeight +
                            (Platform.isIOS || Platform.isAndroid
                                ? MediaQuery.of(context).padding.top
                                : 24)),
                  ),
                  child: AppScaffold(
                    body: Stack(
                      children: [
                        // Scrollable content that goes under the top bar
                        Positioned(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              if (notification.metrics.axis != Axis.vertical) {
                                return false; // Ignore horizontal scroll notifications
                              }

                              if (notification is ScrollUpdateNotification) {
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
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  // Top padding to account for the gap and drag handle in the top bar
                                  SizedBox(height: theme.sizes.s10),
                                  // Actual content
                                  widget.child,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Black bar that renders the top 8px of the screen always in black so that the blure of the top bar's white top border doesn't pick up on the screen content.
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

                        // Fixed top bar with blur effect
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: _showTopBarContent
                                  ? ImageFilter.blur(
                                      sigmaX: 24,
                                      sigmaY: 24,
                                    )
                                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                              child: AppContainer(
                                decoration: BoxDecoration(
                                  gradient: _showTopBarContent
                                      ? LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            theme.colors.black,
                                            theme.colors.black
                                                .withOpacity(0.33),
                                          ],
                                        )
                                      : null,
                                  color: _showTopBarContent
                                      ? null
                                      : const Color(0x00000000),
                                ),
                                child: Column(
                                  children: [
                                    const AppGap.s8(),
                                    const AppDragHandle(),
                                    if (widget.topBarContent != null &&
                                        _showTopBarContent) ...[
                                      AnimatedOpacity(
                                        duration: theme.durations.fast,
                                        opacity: _showTopBarContent ? 1.0 : 0.0,
                                        child: Column(
                                          children: [
                                            AppContainer(
                                              padding: const AppEdgeInsets.all(
                                                  AppGapSize.s12),
                                              child: widget.topBarContent!,
                                            ),
                                            const AppDivider(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Gesture detection zone
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
                                  (Platform.isIOS || Platform.isAndroid)) {
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
                              height: _currentDrag > 0 ? 2000 : _topBarHeight,
                              decoration: const BoxDecoration(
                                color: Color(0x00000000),
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
    );
  }
}
