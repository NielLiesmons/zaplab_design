import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppReply extends StatelessWidget {
  final Comment reply;
  // TODO: Implement reactions, zaps, and communities once HasMany is available
  // final List<ReplaceReaction> reactions;
  // final List<ReplaceZap> zaps;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final Function(Profile) onProfileTap;

  const AppReply({
    super.key,
    required this.reply,
    // TODO: Implement reactions, zaps, and communities once HasMany is available
    // this.reactions = const [],
    // this.zaps = const [],
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      padding: const AppEdgeInsets.only(
        top: AppGapSize.s4,
        left: AppGapSize.s12,
        right: AppGapSize.s12,
        bottom: AppGapSize.s12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppGap.s12(),
          IntrinsicHeight(
            child: Row(
              children: [
                AppContainer(
                  width: theme.sizes.s38,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppGap.s2(),
                      AppProfilePic.s20(reply.parentModel.value!.author.value),
                      Expanded(
                        child: AppDivider.vertical(
                          color: theme.colors.white33,
                        ),
                      ),
                    ],
                  ),
                ),
                const AppGap.s4(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppEmojiContentType(
                            contentType:
                                getModelContentType(reply.parentModel.value),
                            size: theme.sizes.s16,
                          ),
                          const AppGap.s8(),
                          Expanded(
                            child: AppText.reg14(
                              getModelDisplayText(reply.parentModel.value),
                              color: theme.colors.white66,
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const AppGap.s12(),
                        ],
                      ),
                      const AppGap.s10(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppProfilePic.s38(reply.author.value,
                  onTap: () => onProfileTap(reply.author.value as Profile)),
              const AppGap.s12(),
              Expanded(
                child: AppText.bold14(reply.author.value?.name ??
                    formatNpub(reply.author.value?.pubkey ?? '')),
              ),
              AppText.reg12(
                TimestampFormatter.format(reply.createdAt,
                    format: TimestampFormat.relative),
                color: theme.colors.white33,
              ),
            ],
          ),
          const AppGap.s8(),
          AppContainer(
            padding: const AppEdgeInsets.symmetric(
              vertical: AppGapSize.none,
              horizontal: AppGapSize.s4,
            ),
            child: AppShortTextRenderer(
              content: reply.content,
              onResolveEvent: onResolveEvent,
              onResolveProfile: onResolveProfile,
              onResolveEmoji: onResolveEmoji,
              onResolveHashtag: onResolveHashtag,
              onLinkTap: onLinkTap,
              onProfileTap: onProfileTap,
            ),
          ),
        ],
      ),
    );
  }
}
