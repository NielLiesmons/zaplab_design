import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppTypingBubble extends StatelessWidget {
  final Profile? profile;

  const AppTypingBubble({
    super.key,
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppContainer(
          child: AppProfilePic.s32(profile),
        ),
        const AppGap.s4(),
        AppContainer(
          width: 56,
          height: 32,
          decoration: BoxDecoration(
            color: theme.colors.gray66,
            borderRadius: BorderRadius.only(
              topLeft: theme.radius.rad16,
              topRight: theme.radius.rad16,
              bottomRight: theme.radius.rad16,
              bottomLeft: theme.radius.rad4,
            ),
          ),
          padding: const AppEdgeInsets.only(
            left: AppGapSize.s8,
            right: AppGapSize.s8,
            top: AppGapSize.s4,
            bottom: AppGapSize.s2,
          ),
          child: Transform.scale(
            scale: 0.9,
            child: AppLoadingDots(
              color: theme.colors.white66,
            ),
          ),
        ),
      ],
    );
  }
}
