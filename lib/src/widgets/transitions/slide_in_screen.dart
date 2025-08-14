import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabSlideInScreen extends CustomTransitionPage {
  LabSlideInScreen({
    required super.child,
    required BuildContext context,
    super.key,
  }) : super(
          opaque: false,
          barrierDismissible: true,
          maintainState: false,
          barrierColor:
              LabTheme.of(context).colors.gray33.withValues(alpha: 0.8),
          transitionDuration: const Duration(milliseconds: 222),
          reverseTransitionDuration: const Duration(milliseconds: 222),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final theme = LabTheme.of(context);

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          },
        );
}

/// Performance-optimized screen that completely disables underlying pages
class LabSlideInScreenOptimized extends CustomTransitionPage {
  LabSlideInScreenOptimized({
    required super.child,
    required BuildContext context,
    super.key,
  }) : super(
          opaque: false,
          barrierDismissible: true,
          maintainState: false,
          fullscreenDialog: true, // Treat as full dialog to disable underlying
          barrierColor:
              LabTheme.of(context).colors.gray33.withValues(alpha: 0.8),
          transitionDuration: const Duration(milliseconds: 222),
          reverseTransitionDuration: const Duration(milliseconds: 222),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final theme = LabTheme.of(context);

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          },
        );
}
