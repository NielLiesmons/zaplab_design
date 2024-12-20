import 'dart:ui';
import 'dart:io' show Platform;
import 'package:zaplab_design/src/theme/data/durations.dart';
import 'package:zaplab_design/zaplab_design.dart';

final _needsCompactMode = ValueNotifier<bool>(false);

class AppModal extends StatelessWidget {
  final List<Widget> children;
  final Widget? topBar;
  final Widget? bottomBar;
  final bool includePadding;

  const AppModal({
    Key? key,
    required this.children,
    this.topBar,
    this.bottomBar,
    this.includePadding = true,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required List<Widget> children,
    Widget? topBar,
    Widget? bottomBar,
    bool includePadding = true,
  }) {
    final theme = AppTheme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    // Create a GlobalKey to measure content height
    final contentKey = GlobalKey();

    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: const Color(0x00000000),
        transitionDuration: theme.durations.normal,
        reverseTransitionDuration: theme.durations.normal,
        pageBuilder: (_, __, ___) {
          // Create a hidden container to measure content
          final measuringWidget = Opacity(
            opacity: 0,
            child: Container(
              key: contentKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (topBar != null) topBar,
                  ...children,
                  if (bottomBar != null) bottomBar,
                ],
              ),
            ),
          );

          return Stack(
            children: [
              // Measuring widget
              measuringWidget,
              // Backdrop
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: theme.colors.black16,
                ),
              ),
              // Actual modal
              Builder(
                builder: (context) {
                  // Measure content after build
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final RenderBox? box = contentKey.currentContext
                        ?.findRenderObject() as RenderBox?;
                    if (box != null) {
                      final contentHeight = box.size.height;
                      final maxAllowedHeight = screenHeight - 160;
                      _needsCompactMode.value =
                          contentHeight > maxAllowedHeight;
                    }
                  });

                  return AppModal(
                    topBar: topBar,
                    bottomBar: bottomBar,
                    includePadding: includePadding,
                    children: children,
                  );
                },
              ),
            ],
          );
        },
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

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final topBarVisible = ValueNotifier<bool>(false);
    final modalOffset = ValueNotifier<double>(0.0);

    return ValueListenableBuilder<bool>(
      valueListenable: _needsCompactMode,
      builder: (context, needsCompactMode, child) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            children: [
              // Background tap handler
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  color: const Color(0x00000000),
                ),
              ),
              // Main modal content
              if (needsCompactMode)
                _buildScrollableModal(
                  context,
                  theme,
                  screenHeight,
                  topBarVisible,
                  modalOffset,
                )
              else
                _buildCompactModal(context, theme),
              // Bottom bar overlay (only in scrollable mode)
              if (needsCompactMode && bottomBar != null)
                _buildBottomBarOverlay(context, theme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompactModal(BuildContext context, AppThemeData theme) {
    final bottomPadding =
        Platform.isIOS || Platform.isAndroid ? AppGapSize.s4 : AppGapSize.s16;
    final modalOffset = ValueNotifier<double>(0.0);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return ValueListenableBuilder<double>(
      valueListenable: modalOffset,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: Offset(0, offset - keyboardHeight),
          child: Align(
            alignment: Alignment.bottomCenter,
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
                if (modalOffset.value > 0 && modalOffset.value <= 160) {
                  modalOffset.value = 0;
                }
              },
              child: AppContainer(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: const AppRadiusData.normal().rad32,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colors.black33,
                      blurRadius: 32,
                      offset: const Offset(0, -12),
                    ),
                  ],
                  border: Border(
                    top: BorderSide(
                      color: theme.colors.white16,
                      width: LineThicknessData.normal().thin,
                    ),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: const AppRadiusData.normal().rad32,
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: AppContainer(
                      decoration: BoxDecoration(color: theme.colors.grey66),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (includePadding)
                            AppContainer(
                              padding: const AppEdgeInsets.s16(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: children,
                              ),
                            )
                          else
                            ...children,
                          if (bottomBar != null)
                            AppContainer(
                              padding: AppEdgeInsets.only(
                                left: AppGapSize.s16,
                                right: AppGapSize.s16,
                                top: AppGapSize.none,
                                bottom: bottomPadding,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  bottomBar!,
                                  const AppBottomSafeArea(),
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
    AppThemeData theme,
    double screenHeight,
    ValueNotifier<bool> topBarVisible,
    ValueNotifier<double> modalOffset,
  ) {
    final bottomBarHeight = bottomBar != null ? theme.sizes.s64 : 0.0;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final totalBottomPadding = bottomBar != null
        ? bottomBarHeight + bottomSafeArea + keyboardHeight
        : keyboardHeight;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          // Background tap handler
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: const Color(0x00000000),
            ),
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
                    initialChildSize: (screenHeight - 160) / screenHeight,
                    minChildSize: 0.6,
                    maxChildSize: 1.0,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: const AppRadiusData.normal().rad32,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colors.black33,
                              blurRadius: 32,
                              offset: const Offset(0, -12),
                            ),
                          ],
                          border: Border(
                            top: BorderSide(
                              color: theme.colors.white16,
                              width: LineThicknessData.normal().thin,
                            ),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: const AppRadiusData.normal().rad32,
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                            child: AppContainer(
                              decoration: BoxDecoration(
                                color: theme.colors.grey66,
                              ),
                              child: ListView(
                                controller: scrollController,
                                padding:
                                    EdgeInsets.only(bottom: totalBottomPadding),
                                children: [
                                  if (includePadding)
                                    AppContainer(
                                      padding: const AppEdgeInsets.s16(),
                                      child: Column(children: children),
                                    )
                                  else
                                    ...children,
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
                        duration: AppDurationsData.normal().normal,
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: offset > 0
                                  ? const AppRadiusData.normal().rad32
                                  : Radius.zero,
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.colors.grey66,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: theme.colors.white16,
                                      width: LineThicknessData.normal().thin,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const AppTopSafeArea(),
                                    const AppGap.s4(),
                                    const DragHandle(),
                                    if (topBar != null) topBar!,
                                  ],
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

  Widget _buildBottomBarOverlay(BuildContext context, AppThemeData theme) {
    final bottomPadding =
        Platform.isIOS || Platform.isAndroid ? AppGapSize.s4 : AppGapSize.s16;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: AppContainer(
            padding: AppEdgeInsets.only(
              left: AppGapSize.s16,
              right: AppGapSize.s16,
              top: AppGapSize.s16,
              bottom: bottomPadding,
            ),
            decoration: BoxDecoration(
              color: theme.colors.grey66,
              border: Border(
                top: BorderSide(
                  color: theme.colors.white16,
                  width: LineThicknessData.normal().thin,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                bottomBar!,
                const AppBottomSafeArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
