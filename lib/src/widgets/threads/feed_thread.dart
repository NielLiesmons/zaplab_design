import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppFeedThread extends StatelessWidget {
  final Note thread;
  final Function(Model) onTap;
  final List<Comment> topReplies;
  final int totalReplies;
  final Function(Model) onActions;
  final Function(Model) onReply;
  final Function(Reaction)? onReactionTap;
  final Function(Zap)? onZapTap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final bool isUnread;

  const AppFeedThread({
    super.key,
    required this.thread,
    required this.onTap,
    this.topReplies = const [],
    this.totalReplies = 0,
    required this.onReply,
    required this.onActions,
    required this.onReactionTap,
    required this.onZapTap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Column(
      children: [
        AppSwipeContainer(
          onTap: () => onTap(thread),
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
          onSwipeLeft: () => onReply(thread),
          onSwipeRight: () => onActions(thread),
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
                            thread.author.value?.pictureUrl ?? ''),
                        if (topReplies.isNotEmpty)
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
                              AppText.bold14(thread.author.value?.name ??
                                  formatNpub(
                                      thread.author.value?.pubkey ?? '')),
                              AppText.reg12(
                                TimestampFormatter.format(thread.createdAt,
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
                            content: thread.content,
                            onResolveEvent: onResolveEvent,
                            onResolveProfile: onResolveProfile,
                            onResolveEmoji: onResolveEmoji,
                            onResolveHashtag: onResolveHashtag,
                            onLinkTap: onLinkTap,
                          ),
                          // TODO: Implement Zaps and Reactions once HasMany is available
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (topReplies.isNotEmpty) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: Column(
                        children: [
                          AppProfilePic.s20(
                              topReplies[0].author.value?.pictureUrl ?? ''),
                          const AppGap.s2(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (topReplies.length > 1)
                                AppProfilePic.s16(
                                    topReplies[1].author.value?.pictureUrl ??
                                        ''),
                              const Spacer(),
                              if (topReplies.length > 2)
                                AppProfilePic.s12(
                                    topReplies[2].author.value?.pictureUrl ??
                                        ''),
                              const AppGap.s2()
                            ],
                          ),
                        ],
                      ),
                    ),
                    const AppGap.s12(),
                    Expanded(
                      child: AppText.med14(
                        '${topReplies[0].author.value?.name ?? formatNpub(topReplies[0].author.value?.npub ?? '')} & ${totalReplies - 1} others replied',
                        color: theme.colors.white33,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const AppDivider.horizontal(),
      ],
    );
  }
}
