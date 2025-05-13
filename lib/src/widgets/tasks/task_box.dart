import 'package:zaplab_design/zaplab_design.dart';

enum TaskBoxState {
  open,
  closed,
  inProgress,
  inReview,
}

class AppTaskBox extends StatelessWidget {
  final TaskBoxState state;
  final VoidCallback? onTap;
  final double size;

  const AppTaskBox({
    super.key,
    this.state = TaskBoxState.open,
    this.onTap,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
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
                  width: AppLineThicknessData.normal().medium,
                ),
        ),
        child: Center(
          child: _buildStateIndicator(theme),
        ),
      ),
    );
  }

  Widget _buildStateIndicator(AppThemeData theme) {
    return switch (state) {
      TaskBoxState.open => const SizedBox.shrink(),
      TaskBoxState.closed => AppIcon.s8(
          theme.icons.characters.check,
          outlineColor: theme.colors.whiteEnforced,
          outlineThickness: AppLineThicknessData.normal().thick,
        ),
      TaskBoxState.inProgress => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 7),
            AppIcon.s14(
              theme.icons.characters.circle50,
              gradient: theme.colors.gold,
            ),
          ],
        ),
      TaskBoxState.inReview => Stack(
          children: [
            AppIcon.s14(
              theme.icons.characters.circle75,
              gradient: theme.colors.blurple,
            ),
            AppIcon.s14(
              theme.icons.characters.circle75,
              color: theme.colors.white16,
            ),
          ],
        ),
    };
  }
}
