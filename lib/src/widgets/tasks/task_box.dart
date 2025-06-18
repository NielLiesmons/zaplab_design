import 'package:zaplab_design/zaplab_design.dart';

enum TaskBoxState {
  open,
  closed,
  inProgress,
  inReview,
}

class LabTaskBox extends StatelessWidget {
  final TaskBoxState state;
  final VoidCallback? onTap;
  final double size;

  const LabTaskBox({
    super.key,
    this.state = TaskBoxState.open,
    this.onTap,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: LabContainer(
        width: theme.sizes.s24,
        height: theme.sizes.s24,
        decoration: BoxDecoration(
          borderRadius: theme.radius.asBorderRadius().rad8,
          gradient: state == TaskBoxState.closed ? theme.colors.blurple : null,
          color: state == TaskBoxState.closed ? null : theme.colors.black33,
          border: state == TaskBoxState.closed
              ? null
              : Border.all(
                  color: state == TaskBoxState.open
                      ? theme.colors.white33
                      : state == TaskBoxState.inProgress
                          ? theme.colors.goldColor66
                          : theme.colors.blurpleColor66,
                  width: LabLineThicknessData.normal().medium,
                ),
        ),
        child: Center(
          child: _buildStateIndicator(theme),
        ),
      ),
    );
  }

  Widget _buildStateIndicator(LabThemeData theme) {
    return switch (state) {
      TaskBoxState.open => const SizedBox.shrink(),
      TaskBoxState.closed => LabIcon.s8(
          theme.icons.characters.check,
          outlineColor: theme.colors.whiteEnforced,
          outlineThickness: LabLineThicknessData.normal().thick,
        ),
      TaskBoxState.inProgress => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 7),
            LabIcon.s14(
              theme.icons.characters.circle50,
              gradient: theme.colors.gold,
            ),
          ],
        ),
      TaskBoxState.inReview => Stack(
          children: [
            LabIcon.s14(
              theme.icons.characters.circle75,
              gradient: theme.colors.blurple,
            ),
            LabIcon.s14(
              theme.icons.characters.circle75,
              color: theme.colors.white16,
            ),
          ],
        ),
    };
  }
}
