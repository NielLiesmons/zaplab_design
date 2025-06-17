import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppFeedThread extends StatelessWidget {
  final Note? thread;
  final Comment? reply;
  final Function(Model) onTap;
  final List<Profile> topThreeReplyProfiles;
  final int totalReplyProfiles;
  final Function(Model) onActions;
  final Function(Model) onReply;
  final Function(Reaction)? onReactionTap;
  final Function(Zap)? onZapTap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final Function(Profile) onProfileTap;
  final bool isUnread;

  const AppFeedThread({
    super.key,
    this.thread,
    this.reply,
    required this.onTap,
    this.topThreeReplyProfiles = const [],
    this.totalReplyProfiles = 0,
    required this.onReply,
    required this.onActions,
    required this.onReactionTap,
    required this.onZapTap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    required this.onProfileTap,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Column(
      children: [
        AppSwipeContainer(
          onTap: () => onTap(thread ?? reply!),
          padding: const AppEdgeInsets.all(AppGapSize.s12),
          leftContent: AppIcon.s16(
            theme.icons.characters.reply,
            outlineColor: theme.colors.white66,
            outlineThickness: AppLineThicknessData.normal().medium,
          ),
          rightContent: AppIcon.s10(
            theme.icons.characters.chevronUp,
            outlineColor: theme.colors.white66,
            outlineThickness: AppLineThicknessData.normal().medium,
          ),
          onSwipeLeft: () => onReply(thread ?? reply!),
          onSwipeRight: () => onActions(thread ?? reply!),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        AppProfilePic.s38(
                            thread?.author.value ?? reply!.author.value),
                        if (topThreeReplyProfiles.isNotEmpty)
                          Expanded(
                            child: AppDivider.vertical(
                              color: theme.colors.white33,
                            ),
                          ),
                      ],
                    ),
                    const AppGap.s12(),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppText.bold14(thread != null
                                  ? thread!.author.value?.name ??
                                      formatNpub(
                                          thread!.author.value?.pubkey ?? '')
                                  : reply!.author.value?.name ??
                                      formatNpub(
                                          reply!.author.value?.pubkey ?? '')),
                              AppText.reg12(
                                TimestampFormatter.format(
                                    thread != null
                                        ? thread!.createdAt
                                        : reply!.createdAt,
                                    format: TimestampFormat.relative),
                                color: theme.colors.white33,
                              ),
                              if (isUnread)
                                AppContainer(
                                  height: theme.sizes.s8,
                                  width: theme.sizes.s8,
                                  decoration: BoxDecoration(
                                    gradient: theme.colors.blurple,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                            ],
                          ),
                          const AppGap.s2(),
                          AppShortTextRenderer(
                            content: thread != null
                                ? thread!.content
                                : reply!.content,
                            onResolveEvent: onResolveEvent,
                            onResolveProfile: onResolveProfile,
                            onResolveEmoji: onResolveEmoji,
                            onResolveHashtag: onResolveHashtag,
                            onLinkTap: onLinkTap,
                            onProfileTap: onProfileTap,
                          ),
                          // TODO: Implement Zaps and Reactions once HasMany is available
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (topThreeReplyProfiles.isNotEmpty) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: Column(
                        children: [
                          AppProfilePic.s20(topThreeReplyProfiles[0]),
                          const AppGap.s2(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (topThreeReplyProfiles.length > 1)
                                AppProfilePic.s16(topThreeReplyProfiles[1]),
                              const Spacer(),
                              if (topThreeReplyProfiles.length > 2)
                                AppProfilePic.s12(topThreeReplyProfiles[2]),
                              const AppGap.s2()
                            ],
                          ),
                        ],
                      ),
                    ),
                    const AppGap.s12(),
                    Expanded(
                      child: AppText.med14(
                        '${topThreeReplyProfiles[0].name ?? formatNpub(topThreeReplyProfiles[0].author.value?.npub ?? '')} & ${totalReplyProfiles - 1} others replied',
                        color: theme.colors.white33,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const AppDivider(),
      ],
    );
  }
}
