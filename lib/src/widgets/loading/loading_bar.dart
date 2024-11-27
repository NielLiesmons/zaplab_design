import 'package:zapchat_design/zapchat_design.dart';

class AppLoadBar extends StatelessWidget {
  const AppLoadBar({
    super.key,
    required this.progress,
    this.backgroundGradient,
    this.progressGradient,
  });

  final double progress; // Progress value (0.0 to 1.0)
  final Gradient? backgroundGradient; // Gradient for the background bar
  final Gradient? progressGradient; // Gradient for the progress bar

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Background bar
        _buildBar(
          theme: theme,
          gradient: backgroundGradient ?? theme.colors.blurple33,
          widthFactor: 1.0,
        ),
        // Progress bar
        Align(
          alignment: Alignment.centerLeft,
          child: _buildBar(
            theme: theme,
            gradient: progressGradient ?? theme.colors.blurple,
            widthFactor: progress,
          ),
        ),

        Text(
          '${(progress * 100).toInt()}%',
          style: theme.typography.med16.copyWith(color: theme.colors.white),
        ),
      ],
    );
  }

  Widget _buildBar({
    required AppThemeData theme,
    required Gradient gradient,
    required double widthFactor,
  }) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: AnimatedContainer(
        duration: theme.durations.fast,
        height: theme.sizes.s38,
        decoration: BoxDecoration(
          borderRadius: theme.radius.asBorderRadius().rad16,
          gradient: gradient,
        ),
      ),
    );
  }
}
