import 'dart:ui';
import 'package:zapchat_design/src/theme/data/durations.dart';
import 'package:zapchat_design/zapchat_design.dart';

class AppModal extends StatelessWidget {
  final List<Widget> children;
  final Widget? topBar;
  final Widget? bottomBar;

  const AppModal({
    Key? key,
    required this.children,
    this.topBar,
    this.bottomBar,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required List<Widget> children,
    Widget? topBar,
    Widget? bottomBar,
  }) {
    final theme = AppTheme.of(context);
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: const Color(0x00000000),
        transitionDuration: theme.durations.normal,
        reverseTransitionDuration: theme.durations.normal,
        pageBuilder: (_, __, ___) {
          return Stack(
            children: [
              // Blurred and semi-transparent background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: theme.colors.black16,
                ),
              ),
              // Modal content
              AppModal(
                topBar: topBar,
                bottomBar: bottomBar,
                children: children,
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
    final initialChildSize = 704 / screenHeight;
    final topBarVisible = ValueNotifier<bool>(false);
    final modalOffset = ValueNotifier<double>(0.0);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          // Background tap handler
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
                color:
                    const Color(0x00000000) // Ensure the background is tappable
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
                    initialChildSize: initialChildSize,
                    minChildSize: 0.25,
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
                            child: Container(
                              color: theme.colors.grey66,
                              child: ListView(
                                controller: scrollController,
                                padding: EdgeInsets.zero,
                                children: [
                                  Center(
                                    child: Column(
                                      children: children,
                                    ),
                                  ),
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
          // Bottom bar overlay (fixed)
          if (bottomBar != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
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
                      return AnimatedOpacity(
                        opacity: isVisible ? 1.0 : 0.0,
                        duration: AppDurationsData.normal().normal,
                        curve: Curves.easeInOut,
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            if (details.delta.dy > 0) {
                              // Only allow downward drag
                              modalOffset.value += details.delta.dy;
                              if (modalOffset.value > 200) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          onVerticalDragEnd: (details) {
                            if (modalOffset.value > 0 &&
                                modalOffset.value <= 200) {
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
}
