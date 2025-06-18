import 'dart:ui';

import 'package:zaplab_design/zaplab_design.dart';

class ModalScope extends InheritedWidget {
  const ModalScope({
    super.key,
    required super.child,
    required this.isInsideModal,
  });

  final bool isInsideModal;

  static bool of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ModalScope>();
    return scope?.isInsideModal ?? false;
  }

  @override
  bool updateShouldNotify(ModalScope oldWidget) {
    return oldWidget.isInsideModal != isInsideModal;
  }
}

class LabModal extends StatelessWidget {
  final Widget? topBar;
  final Widget? bottomBar;
  final bool includePadding;
  final String? profilePicUrl;
  final String? title;
  final String? description;
  final List<Widget> children;
  final Color? barrierColor;
  final bool handleNavigation;
  final double initialChildSize;
  final ValueNotifier<bool> _needsCompactMode = ValueNotifier<bool>(false);

  LabModal({
    super.key,
    this.topBar,
    this.bottomBar,
    this.includePadding = true,
    this.profilePicUrl,
    this.title,
    this.description,
    required this.children,
    this.barrierColor,
    this.handleNavigation = true,
    this.initialChildSize = 0.80,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required List<Widget> children,
    Widget? topBar,
    Widget? bottomBar,
    bool includePadding = true,
    String? profilePicUrl,
    String? title,
    String? description,
  }) {
    final theme = LabTheme.of(context);

    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: const Color(0x00000000),
        transitionDuration: theme.durations.normal,
        reverseTransitionDuration: theme.durations.normal,
        pageBuilder: (_, __, ___) => LabModal(
          topBar: topBar,
          bottomBar: bottomBar,
          includePadding: includePadding,
          profilePicUrl: profilePicUrl,
          title: title,
          description: description,
          handleNavigation: true,
          children: children,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }

  static Future<T?> showInOtherModal<T>(
    BuildContext context, {
    required List<Widget> children,
    Widget? bottomBar,
    String? profilePicUrl,
    String? title,
    String? description,
    double initialChildSize = 0.64,
  }) {
    final theme = LabTheme.of(context);

    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: theme.colors.black16,
        transitionDuration: theme.durations.normal,
        reverseTransitionDuration: theme.durations.normal,
        pageBuilder: (_, __, ___) => LabModal(
          bottomBar: bottomBar,
          profilePicUrl: profilePicUrl,
          title: title,
          description: description,
          barrierColor: theme.colors.black16,
          handleNavigation: true,
          initialChildSize: initialChildSize,
          children: children,
        ),
      ),
    );
  }

  List<Widget> _buildHeaderWidgets(LabThemeData theme) {
    List<Widget> headerWidgets = [];
    if (profilePicUrl != null || title != null || description != null) {
      if (profilePicUrl != null) {
        headerWidgets.addAll([
          const LabGap.s8(),
          LabProfilePic.fromUrl(profilePicUrl!, size: LabProfilePicSize.s80),
        ]);
      }

      if (title != null) {
        headerWidgets.addAll([
          const LabGap.s8(),
          LabText.h1(
            title!,
            color: theme.colors.white,
            textAlign: TextAlign.center,
          ),
        ]);
      }

      if (description != null) {
        headerWidgets.addAll([
          const LabGap.s4(),
          LabText.reg16(
            description!,
            color: theme.colors.white66,
            textAlign: TextAlign.center,
          ),
        ]);
      }

      if (headerWidgets.isNotEmpty) {
        headerWidgets.add(const LabGap.s8());
      }
    }
    return headerWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final screenHeight =
        MediaQuery.of(context).size.height / theme.system.scale;
    final topBarVisible = ValueNotifier<bool>(false);
    final modalOffset = ValueNotifier<double>(0.0);

    // Create header widgets and combine with children
    final headerWidgets = _buildHeaderWidgets(theme);
    final allChildren = [...headerWidgets, ...children];

    // Create default topBar if title is provided and no custom topBar
    Widget? resolvedTopBar = topBar;
    if (topBar == null && title != null) {
      resolvedTopBar = LabContainer(
        padding: const LabEdgeInsets.all(LabGapSize.s12),
        alignment: Alignment.center,
        child: LabText.med16(
          title!,
          color: theme.colors.white,
        ),
      );
    }

    // Measure content if needed
    final contentKey = GlobalKey();
    final measuringWidget = Opacity(
      opacity: 0,
      child: LabContainer(
        key: contentKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (resolvedTopBar != null) resolvedTopBar,
            ...allChildren,
            if (bottomBar != null) bottomBar!,
          ],
        ),
      ),
    );

    Widget modalContent = ValueListenableBuilder<bool>(
      valueListenable: _needsCompactMode,
      builder: (context, needsCompactMode, child) {
        return ModalScope(
          isInsideModal: true,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: LabContainer(
                  decoration: BoxDecoration(color: theme.colors.black16),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    if (handleNavigation)
                      GestureDetector(
                        onTap: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        },
                        onVerticalDragStart: (details) {
                          if (details.localPosition.dy > 0 &&
                              Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const LabContainer(
                          decoration: BoxDecoration(color: Color(0x00000000)),
                        ),
                      ),
                    if (needsCompactMode)
                      _buildScrollableModal(
                        context,
                        theme,
                        screenHeight,
                        topBarVisible,
                        modalOffset,
                        resolvedTopBar,
                        allChildren,
                        initialChildSize: initialChildSize,
                      )
                    else
                      _buildCompactModal(
                        context,
                        theme,
                        resolvedTopBar,
                        allChildren,
                      ),
                    if (needsCompactMode &&
                        (bottomBar != null || LabPlatformUtils.isMobile))
                      _buildBottomBarOverlay(context, theme),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    return Stack(
      children: [
        measuringWidget,
        Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final RenderBox? box =
                  contentKey.currentContext?.findRenderObject() as RenderBox?;
              if (box != null) {
                final contentHeight = box.size.height;
                final maxAllowedHeight = screenHeight * 0.8;

                _needsCompactMode.value = contentHeight > maxAllowedHeight;
              } else {}
            });
            return modalContent;
          },
        ),
      ],
    );
  }

  Widget _buildCompactModal(
    BuildContext context,
    LabThemeData theme,
    Widget? resolvedTopBar,
    List<Widget> allChildren,
  ) {
    final bottomPadding =
        LabPlatformUtils.isMobile ? LabGapSize.s4 : LabGapSize.s16;
    final modalOffset = ValueNotifier<double>(0.0);

    return ValueListenableBuilder<double>(
      valueListenable: modalOffset,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: Offset(0, offset),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  modalOffset.value += details.delta.dy;
                }
              },
              onVerticalDragEnd: (details) {
                if (modalOffset.value > 0 && modalOffset.value <= 80) {
                  modalOffset.value = 0;
                } else if (modalOffset.value > 80) {
                  Navigator.of(context).pop();
                }
              },
              child: LabContainer(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: const LabRadiusData.normal().rad32,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colors.black16,
                      blurRadius: 32,
                      offset: const Offset(0, -12),
                    ),
                  ],
                  border: Border(
                    top: BorderSide(
                      color: theme.colors.white16,
                      width: LabLineThicknessData.normal().thin,
                    ),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: const LabRadiusData.normal().rad32,
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: LabContainer(
                      width: double.infinity,
                      decoration: BoxDecoration(color: theme.colors.gray66),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (includePadding)
                            LabContainer(
                              padding: LabEdgeInsets.only(
                                left: LabGapSize.s16,
                                right: LabGapSize.s16,
                                top: LabGapSize.s16,
                                bottom: LabPlatformUtils.isMobile
                                    ? LabGapSize.s12
                                    : LabGapSize.s16,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...allChildren,
                                  if (bottomBar == null)
                                    const LabBottomSafeArea(),
                                ],
                              ),
                            )
                          else ...[
                            ...allChildren,
                            if (bottomBar == null) const LabBottomSafeArea(),
                          ],
                          if (bottomBar != null)
                            LabContainer(
                              padding: LabEdgeInsets.only(
                                left: LabGapSize.s16,
                                right: LabGapSize.s16,
                                top: LabGapSize.none,
                                bottom: bottomPadding,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  bottomBar!,
                                  const LabBottomSafeArea(),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScrollableModal(
    BuildContext context,
    LabThemeData theme,
    double screenHeight,
    ValueNotifier<bool> topBarVisible,
    ValueNotifier<double> modalOffset,
    Widget? resolvedTopBar,
    List<Widget> allChildren, {
    double initialChildSize = 0.80,
  }) {
    final bottomBarHeight = bottomBar != null ? theme.sizes.s64 : 0.0;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final totalBottomPadding =
        bottomBar != null ? bottomBarHeight + bottomSafeArea : 0.0;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          // Background tap handler
          GestureDetector(
            onTap: () {
              final navigator = Navigator.of(context);
              if (navigator.canPop()) {
                navigator.pop();
              }
            },
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 0 && Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            child: const LabContainer(
                decoration: BoxDecoration(
              color: Color(0x00000000),
            )),
          ),
          // Main modal content
          ValueListenableBuilder<double>(
            valueListenable: modalOffset,
            builder: (context, offset, child) {
              return Transform.translate(
                offset: Offset(0, offset),
                child: NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    if (notification.extent <= notification.minExtent) {
                      Navigator.of(context).pop();
                    }
                    topBarVisible.value = notification.extent >=
                        (screenHeight - 40) / screenHeight;
                    return true;
                  },
                  child: DraggableScrollableSheet(
                    initialChildSize: initialChildSize,
                    minChildSize: 0.6,
                    maxChildSize: 1.0,
                    builder: (context, scrollController) {
                      return LabContainer(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: const LabRadiusData.normal().rad32,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colors.black16,
                              blurRadius: 32,
                              offset: const Offset(0, -12),
                            ),
                          ],
                          border: Border(
                            top: BorderSide(
                              color: theme.colors.white16,
                              width: LabLineThicknessData.normal().thin,
                            ),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: const LabRadiusData.normal().rad32,
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                            child: LabContainer(
                              width: double.infinity,
                              decoration:
                                  BoxDecoration(color: theme.colors.gray66),
                              child: ListView(
                                controller: scrollController,
                                padding: bottomBar != null
                                    ? EdgeInsets.only(
                                        bottom: totalBottomPadding)
                                    : EdgeInsets.zero,
                                children: [
                                  if (includePadding)
                                    LabContainer(
                                      padding: const LabEdgeInsets.s16(),
                                      child: Column(
                                        children: [
                                          ...allChildren,
                                          const LabBottomSafeArea(),
                                        ],
                                      ),
                                    )
                                  else ...[
                                    ...allChildren,
                                    const LabBottomSafeArea(),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          // Top bar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<double>(
              valueListenable: modalOffset,
              builder: (context, offset, child) {
                return Transform.translate(
                  offset: Offset(0, offset),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: topBarVisible,
                    builder: (context, isVisible, child) {
                      if (!isVisible) return const SizedBox.shrink();

                      return AnimatedOpacity(
                        opacity: isVisible ? 1.0 : 0.0,
                        duration: LabDurationsData.normal().normal,
                        curve: Curves.easeInOut,
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            if (details.delta.dy > 0) {
                              modalOffset.value += details.delta.dy;
                              if (modalOffset.value > 160) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          onVerticalDragEnd: (details) {
                            if (modalOffset.value > 0 &&
                                modalOffset.value <= 160) {
                              modalOffset.value = 0;
                            }
                          },
                          child: LabContainer(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: offset > 0
                                    ? const LabRadiusData.normal().rad32
                                    : Radius.zero,
                              ),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                                child: LabContainer(
                                  decoration: BoxDecoration(
                                    color: theme.colors.gray66,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: theme.colors.white16,
                                        width:
                                            LabLineThicknessData.normal().thin,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const LabTopSafeArea(),
                                      const LabGap.s4(),
                                      const LabDragHandle(),
                                      if (resolvedTopBar != null)
                                        resolvedTopBar,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBarOverlay(BuildContext context, LabThemeData theme) {
    final bottomPadding =
        LabPlatformUtils.isMobile ? LabGapSize.s4 : LabGapSize.s16;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: LabContainer(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: LabContainer(
              padding: bottomBar != null
                  ? LabEdgeInsets.only(
                      left: LabGapSize.s16,
                      right: LabGapSize.s16,
                      top: LabGapSize.s16,
                      bottom: bottomPadding,
                    )
                  : const LabEdgeInsets.all(LabGapSize.none),
              decoration: BoxDecoration(
                color: theme.colors.gray66,
                border: Border(
                  top: BorderSide(
                    color: theme.colors.white16,
                    width: LabLineThicknessData.normal().thin,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (bottomBar != null) bottomBar!,
                  if (LabPlatformUtils.isMobile) const LabBottomSafeArea(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
