import 'package:zaplab_design/zaplab_design.dart';

class LabSkeletonLoader extends StatefulWidget {
  final Widget? child;

  const LabSkeletonLoader({
    super.key,
    this.child,
  });

  @override
  State<LabSkeletonLoader> createState() => _LabSkeletonLoaderState();
}

class _LabSkeletonLoaderState extends State<LabSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Cache gradient creation to avoid recreating on every frame
  LinearGradient? _cachedGradient;
  Color? _lastWhite8;
  Color? _lastWhite16;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Create animated gradient on every frame for smooth animation
        _cachedGradient = LinearGradient(
          begin: Alignment(-6 + _controller.value * 8, -0.3),
          end: Alignment(-2 + _controller.value * 8, 0.3),
          colors: [
            theme.colors.white8,
            theme.colors.white16,
            theme.colors.white8,
          ],
          stops: const [0.0, 0.5, 1.0],
        );

        return LabContainer(
          decoration: BoxDecoration(
            gradient: _cachedGradient,
          ),
          child: widget.child,
        );
      },
    );
  }
}
