import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class LabReactionPill extends StatelessWidget {
  final Reaction reaction;
  final VoidCallback onTap;
  final bool isOutgoing;

  const LabReactionPill({
    super.key,
    required this.reaction,
    required this.onTap,
    this.isOutgoing = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final isInsideModal = ModalScope.of(context);
    final isInsideScope = LabScope.of(context);
    final (isInsideMessageBubble, _) = MessageBubbleScope.of(context);

    return TapBuilder(
      onTap: onTap,
      builder: (BuildContext context, TapState state, bool isFocused) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.98;
        } else if (state == TapState.hover) {
          scaleFactor = 1.04;
        }

        return AnimatedScale(
          scale: scaleFactor,
          duration: LabDurationsData.normal().fast,
          curve: Curves.easeInOut,
          child: LabContainer(
            decoration: BoxDecoration(
              color: isOutgoing
                  ? null
                  : (isInsideModal || isInsideScope)
                      ? theme.colors.white8
                      : isInsideMessageBubble
                          ? theme.colors.white16
                          : theme.colors.gray66,
              gradient: isOutgoing ? theme.colors.blurple : null,
              borderRadius: BorderRadius.all(theme.radius.rad16),
            ),
            padding: const LabEdgeInsets.only(
              left: LabGapSize.s8,
              right: LabGapSize.s4,
              top: LabGapSize.s4,
              bottom: LabGapSize.s4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (reaction.emojiTag != null)
                  LabEmojiImage(
                    emojiUrl: reaction.emojiTag?.$2 ?? '',
                    emojiName: reaction.emojiTag?.$1 ?? '',
                  )
                else
                  LabText.med16(
                    reaction.event.content,
                  ),
                const LabGap.s6(),
                LabProfilePic.s18(reaction.author.value),
              ],
            ),
          ),
        );
      },
    );
  }
}
