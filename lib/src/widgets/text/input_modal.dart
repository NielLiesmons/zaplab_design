import 'dart:ui';
import 'package:zaplab_design/zaplab_design.dart';

class LabInputModal extends StatelessWidget {
  final List<Widget> children;

  const LabInputModal({
    super.key,
    required this.children,
  });

  static Future<void> show(
    BuildContext context, {
    required List<Widget> children,
  }) {
    final theme = LabTheme.of(context);

    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: const Color(0x00000000),
        transitionDuration: theme.durations.fast,
        reverseTransitionDuration: theme.durations.fast,
        pageBuilder: (_, __, ___) => Focus(
          autofocus: true,
          child: LabInputModal(
            children: children,
          ),
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

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final modalOffset = ValueNotifier<double>(0.0);
    final keyboardHeight =
        (MediaQuery.of(context).viewInsets.bottom / theme.system.scale);
    final bottomPadding =
        LabPlatformUtils.isMobile ? LabGapSize.s4 : LabGapSize.s16;

    return ModalScope(
      isInsideModal: true,
      child: Stack(
        children: [
          // Backdrop with tap to dismiss
          GestureDetector(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            onVerticalDragUpdate: (details) {
              // Only handle drag on the backdrop, not the modal content
              final RenderBox box = context.findRenderObject() as RenderBox;
              final localPosition = box.globalToLocal(details.globalPosition);
              final modalHeight =
                  box.size.height * 0.7; // Approximate modal height

              // Only trigger if dragging on the backdrop area (above the modal)
              if (localPosition.dy < modalHeight &&
                  details.delta.dy > 0 &&
                  Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: LabContainer(
                decoration: BoxDecoration(color: theme.colors.black16),
              ),
            ),
          ),
          // Modal content
          Align(
            alignment: Alignment.bottomCenter,
            child: ValueListenableBuilder<double>(
              valueListenable: modalOffset,
              builder: (context, offset, child) {
                return Transform.translate(
                  offset: Offset(0, offset - keyboardHeight),
                  child: GestureDetector(
                    onVerticalDragUpdate: LabPlatformUtils.isMobile
                        ? (details) {
                            if (details.delta.dy > 0) {
                              modalOffset.value += details.delta.dy;
                              if (modalOffset.value > 40 &&
                                  Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              }
                            }
                          }
                        : null,
                    onVerticalDragEnd: LabPlatformUtils.isMobile
                        ? (details) {
                            if (modalOffset.value > 0 &&
                                modalOffset.value <= 160) {
                              modalOffset.value = 0;
                            }
                          }
                        : null,
                    child: LabContainer(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(theme.radius.rad32.x),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colors.black16,
                            blurRadius: 32,
                            offset: const Offset(0, -12),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(theme.radius.rad32.x),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                          child: LabContainer(
                            decoration: BoxDecoration(
                              color: theme.colors.gray66,
                              border: Border(
                                top: BorderSide(
                                  color: theme.colors.white16,
                                  width: LabLineThicknessData.normal().thin,
                                ),
                              ),
                            ),
                            padding: LabEdgeInsets.only(
                              top: LabGapSize.s16,
                              bottom: bottomPadding,
                              left: LabGapSize.s16,
                              right: LabGapSize.s16,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: children,
                            ),
                          ),
                        ),
                      ),
                    ),
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
