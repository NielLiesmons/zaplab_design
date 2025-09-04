import 'package:flutter/widgets.dart';

class LabLoadingDots extends StatefulWidget {
  const LabLoadingDots({
    super.key,
    this.color = const Color(0xFFFFFFFF),
    this.startingDelays = const [
      0.0,
      0.2,
      0.4
    ], // Default delays for each rectangle
  });

  final Color color;
  final List<double>
      startingDelays; // List of starting delays for each rectangle

  @override
  State<LabLoadingDots> createState() => _LabLoadingDotsState();
}

class _LabLoadingDotsState extends State<LabLoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Total animation cycle
    )..repeat(reverse: true); // Repeat indefinitely

    // Create animations for each rectangle using the starting delays
    _animations = List.generate(3, (index) {
      double start = widget.startingDelays[index];
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(begin: 7.0, end: 14.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50, // Scale up
        ),
        TweenSequenceItem(
          tween: Tween(begin: 14.0, end: 7.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50, // Scale down
        ),
      ]).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(start, (start + 0.6).clamp(0.0, 1.0),
            curve: Curves.linear), // Delayed start
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
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 7.0,
              height: _animations[index].value,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          },
        );
      }),
    );
  }
}
