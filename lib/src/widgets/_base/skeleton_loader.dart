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
        return LabContainer(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-6 + _controller.value * 8, -0.3),
              end: Alignment(-2 + _controller.value * 8, 0.3),
              colors: [
                theme.colors.white8,
                theme.colors.white16,
                theme.colors.white8,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
