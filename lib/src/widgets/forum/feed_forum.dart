import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabFeedForumPost extends StatelessWidget {
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

  const LabFeedForumPost({
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
    final theme = LabTheme.of(context);

    return Column(
      children: [
        LabSwipeContainer(
          onTap: () => onTap(forumPost),
          padding: const LabEdgeInsets.only(
            top: LabGapSize.s8,
            bottom: LabGapSize.s12,
            left: LabGapSize.s12,
            right: LabGapSize.s12,
          ),
          leftContent: LabIcon.s16(
            theme.icons.characters.reply,
            outlineColor: theme.colors.white66,
            outlineThickness: LabLineThicknessData.normal().medium,
          ),
          rightContent: LabIcon.s10(
            theme.icons.characters.chevronUp,
            outlineColor: theme.colors.white66,
            outlineThickness: LabLineThicknessData.normal().medium,
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
                        const LabGap.s4(),
                        LabProfilePic.s38(forumPost.author.value,
                            onTap: () => onProfileTap(
                                forumPost.author.value as Profile)),
                        if (topThreeReplyProfiles.isNotEmpty)
                          Expanded(
                            child: LabDivider.vertical(
                              color: theme.colors.white33,
                            ),
                          ),
                      ],
                    ),
                    const LabGap.s12(),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: LabText.bold16(
                                  forumPost.title ?? 'No Title',
                                  maxLines: 2,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const LabGap.s4(),
                              if (isUnread)
                                LabContainer(
                                  margin: const LabEdgeInsets.only(
                                      top: LabGapSize.s8),
                                  height: theme.sizes.s8,
                                  width: theme.sizes.s8,
                                  decoration: BoxDecoration(
                                    gradient: theme.colors.blurple,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                            ],
                          ),
                          const LabGap.s2(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              LabText.med12(
                                  forumPost.author.value?.name ??
                                      formatNpub(
                                          forumPost.author.value?.pubkey ?? ''),
                                  color: theme.colors.white66),
                              const Spacer(),
                              LabText.reg12(
                                TimestampFormatter.format(forumPost.createdAt,
                                    format: TimestampFormat.relative),
                                color: theme.colors.white33,
                              ),
                            ],
                          ),
                          const LabGap.s2(),
                          LabShortTextRenderer(
                            model: forumPost,
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
                          LabProfilePic.s20(topThreeReplyProfiles[0]),
                          const LabGap.s2(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (topThreeReplyProfiles.length > 1)
                                LabProfilePic.s16(topThreeReplyProfiles[1]),
                              const Spacer(),
                              if (topThreeReplyProfiles.length > 2)
                                LabProfilePic.s12(topThreeReplyProfiles[2]),
                              const LabGap.s2()
                            ],
                          ),
                        ],
                      ),
                    ),
                    const LabGap.s12(),
                    Expanded(
                      child: LabText.med14(
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
        const LabDivider(),
      ],
    );
  }
}
