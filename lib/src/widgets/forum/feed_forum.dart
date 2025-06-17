import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppFeedForumPost extends StatelessWidget {
  final ForumPost forumPost;
  final List<Profile> topThreeReplyProfiles;
  final int totalReplyProfiles;
  final Function(Model) onTap;
  final Function(Profile) onProfileTap;
  final bool isUnread;
  final Function(Model) onReply;
  final Function(Model) onActions;
  final Function(Zap) onZapTap;
  final Function(Reaction) onReactionTap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;

  const AppFeedForumPost({
    super.key,
    required this.forumPost,
    this.topThreeReplyProfiles = const [],
    this.totalReplyProfiles = 0,
    required this.onTap,
    required this.onProfileTap,
    this.isUnread = false,
    required this.onReply,
    required this.onActions,
    required this.onZapTap,
    required this.onReactionTap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Column(
      children: [
        AppSwipeContainer(
          onTap: () => onTap(forumPost),
          padding: const AppEdgeInsets.only(
            top: AppGapSize.s8,
            bottom: AppGapSize.s12,
            left: AppGapSize.s12,
            right: AppGapSize.s12,
          ),
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
          onSwipeLeft: () => onReply(forumPost),
          onSwipeRight: () => onActions(forumPost),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const AppGap.s4(),
                        AppProfilePic.s38(forumPost.author.value,
                            onTap: () => onProfileTap(
                                forumPost.author.value as Profile)),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AppText.bold16(
                                  forumPost.title ?? 'No Title',
                                  maxLines: 2,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const AppGap.s4(),
                              if (isUnread)
                                AppContainer(
                                  margin: const AppEdgeInsets.only(
                                      top: AppGapSize.s8),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppText.med12(
                                  forumPost.author.value?.name ??
                                      formatNpub(
                                          forumPost.author.value?.pubkey ?? ''),
                                  color: theme.colors.white66),
                              const Spacer(),
                              AppText.reg12(
                                TimestampFormatter.format(forumPost.createdAt,
                                    format: TimestampFormat.relative),
                                color: theme.colors.white33,
                              ),
                            ],
                          ),
                          const AppGap.s2(),
                          AppShortTextRenderer(
                            content: forumPost.content,
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
