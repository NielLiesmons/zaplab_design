import 'package:zaplab_design/zaplab_design.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.progress,
    this.height = 4,
  });

  final double progress; // Progress value (0.0 to 1.0)
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // Background bar
          AppContainer(
            height: height,
            decoration: BoxDecoration(
              borderRadius: theme.radius.asBorderRadius().rad16,
              color: theme.colors.white8,
            ),
          ),
          // Progress bar
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: AnimatedContainer(
                duration: theme.durations.fast,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: theme.radius.asBorderRadius().rad16,
                  gradient: theme.colors.blurple66,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
