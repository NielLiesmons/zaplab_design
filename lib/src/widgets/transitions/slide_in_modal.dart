import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabSlideInModal extends CustomTransitionPage {
  LabSlideInModal({
    required super.child,
    required BuildContext context,
    super.key,
  }) : super(
          opaque: false,
          barrierDismissible: true,
          maintainState: false,
          barrierColor: LabTheme.of(context).colors.black66,
          transitionDuration: const Duration(milliseconds: 222),
          reverseTransitionDuration: const Duration(milliseconds: 222),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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

/// Ultra-aggressive modal that completely removes underlying pages
class LabSlideInModalAggressive extends CustomTransitionPage {
  LabSlideInModalAggressive({
    required super.child,
    required BuildContext context,
    super.key,
  }) : super(
          opaque: true, // Make it opaque to completely cover underlying
          barrierDismissible: true,
          maintainState: false,
          fullscreenDialog: true,
          barrierColor: LabTheme.of(context).colors.black66,
          transitionDuration: const Duration(milliseconds: 222),
          reverseTransitionDuration: const Duration(milliseconds: 222),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
