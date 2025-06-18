import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabTypingBubble extends StatelessWidget {
  final Profile? profile;

  const LabTypingBubble({
    super.key,
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LabContainer(
          child: LabProfilePic.s32(profile),
        ),
        const LabGap.s4(),
        LabContainer(
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
          padding: const LabEdgeInsets.only(
            left: LabGapSize.s8,
            right: LabGapSize.s8,
            top: LabGapSize.s4,
            bottom: LabGapSize.s2,
          ),
          child: Transform.scale(
            scale: 0.9,
            child: LabLoadingDots(
              color: theme.colors.white66,
            ),
          ),
        ),
      ],
    );
  }
}
