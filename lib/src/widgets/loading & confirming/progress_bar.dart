import 'package:zaplab_design/zaplab_design.dart';

class LabProgressBar extends StatelessWidget {
  final double progress; // Progress value (0.0 to 1.0)
  final double height;
  final bool isLight;
  const LabProgressBar({
    super.key,
    required this.progress,
    this.height = 4,
    this.isLight = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // Background bar
          LabContainer(
            height: height,
            decoration: BoxDecoration(
              borderRadius: theme.radius.asBorderRadius().rad16,
              color: isLight ? theme.colors.white8 : theme.colors.black33,
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
