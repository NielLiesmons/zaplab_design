import 'package:flutter/widgets.dart';
import 'dart:math';

class LoadingSmall extends StatefulWidget {
  const LoadingSmall({Key? key, this.color = const Color(0xFFFFFFFF)})
      : super(key: key);

  final Color color;

  @override
  State<LoadingSmall> createState() => _LoadingSmallState();
}

class _LoadingSmallState extends State<LoadingSmall>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Total animation cycle
    )..repeat(reverse: true); // Repeat indefinitely

    // Set up staggered animations for each rectangle
    _animations = List.generate(5, (index) {
      final start = index * 0.1; // Staggered start times
      final end = start + 0.6; // Each animation spans 80% of the cycle
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(begin: 4.0, end: 16.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50, // Scale up
        ),
        TweenSequenceItem(
          tween: Tween(begin: 16.0, end: 4.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50, // Scale down
        ),
      ]).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end.clamp(0.0, 1.0), curve: Curves.linear),
      ));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 4,
              height: _animations[index].value,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        );
      }),
    );
  }
}
