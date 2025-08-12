import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabSlideInScreen extends CustomTransitionPage {
  LabSlideInScreen({
    required super.child,
    super.key,
  }) : super(
          opaque: false,
          barrierDismissible: true,
          barrierColor: const Color(0x00000000),
          transitionDuration: const Duration(milliseconds: 222),
          reverseTransitionDuration: const Duration(milliseconds: 222),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final theme = LabTheme.of(context);

            return Stack(
              children: [
                // ✅ SIMPLE: Translucent background instead of expensive blur
                Positioned.fill(
                  child: LabContainer(
                    decoration: BoxDecoration(
                      color: theme.colors.gray33
                          .withValues(alpha: 0.8), // Translucent but no blur
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
        );
}
