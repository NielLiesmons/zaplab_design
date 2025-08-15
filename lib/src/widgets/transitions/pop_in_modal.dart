import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabPopInModal extends CustomTransitionPage {
  LabPopInModal({
    required super.child,
    required BuildContext context,
    super.key,
  }) : super(
          opaque: false,
          barrierDismissible: true,
          barrierColor: LabTheme.of(context).colors.black66,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child; // No animation, just show immediately
          },
        );
}
