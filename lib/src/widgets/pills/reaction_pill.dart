import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class AppReactionPill extends StatelessWidget {
  final String emojiUrl;
  final String profilePicUrl;
  final VoidCallback onTap;

  const AppReactionPill({
    super.key,
    required this.emojiUrl,
    required this.profilePicUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isInsideModal = ModalScope.of(context);
    final isInsideMessageBubble = MessageBubbleScope.of(context);

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
              color: isInsideModal
                  ? theme.colors.white8
                  : isInsideMessageBubble
                      ? theme.colors.white16
                      : theme.colors.grey66,
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
                AppEmojiImage(emojiUrl: emojiUrl),
                const AppGap.s6(),
                AppProfilePic.s18(profilePicUrl),
              ],
            ),
          ),
        );
      },
    );
  }
}
