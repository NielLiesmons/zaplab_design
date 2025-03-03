import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppSlideInModal extends CustomTransitionPage {
  AppSlideInModal({
    required Widget child,
    LocalKey? key,
  }) : super(
          key: key,
          child: child,
          opaque: false,
          barrierDismissible: true,
          barrierColor: const Color(0x00000000),
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
