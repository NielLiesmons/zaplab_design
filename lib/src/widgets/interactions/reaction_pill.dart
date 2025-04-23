import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class AppReactionPill extends StatelessWidget {
  final Reaction reaction;
  final VoidCallback onTap;
  final bool isOutgoing;

  const AppReactionPill({
    super.key,
    required this.reaction,
    required this.onTap,
    this.isOutgoing = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isInsideModal = ModalScope.of(context);
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
          duration: AppDurationsData.normal().fast,
          curve: Curves.easeInOut,
          child: AppContainer(
            decoration: BoxDecoration(
              color: isOutgoing
                  ? null
                  : isInsideModal
                      ? theme.colors.white8
                      : isInsideMessageBubble
                          ? theme.colors.white16
                          : theme.colors.grey66,
              gradient: isOutgoing ? theme.colors.blurple : null,
              borderRadius: BorderRadius.all(theme.radius.rad16),
            ),
            padding: const AppEdgeInsets.only(
              left: AppGapSize.s8,
              right: AppGapSize.s4,
              top: AppGapSize.s4,
              bottom: AppGapSize.s4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (reaction.emojiTag != null)
                  AppEmojiImage(
                    emojiUrl: reaction.emojiTag?.$2 ?? '',
                    emojiName: reaction.emojiTag?.$1 ?? '',
                  )
                else
                  AppText.med16(
                    reaction.event.content,
                  ),
                const AppGap.s6(),
                AppProfilePic.s18(reaction.author.value?.pictureUrl ?? ''),
              ],
            ),
          ),
        );
      },
    );
  }
}
