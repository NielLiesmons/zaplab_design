import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class ReplyUserData {
  final String profileName;
  final String profilePicUrl;

  const ReplyUserData({
    required this.profileName,
    required this.profilePicUrl,
  });
}

class AppFeedPost extends StatelessWidget {
  final Note note;
  final List<ReplyUserData> topReplies;
  final int totalReplies;
  final Function(Event) onActions;
  final Function(Event) onReply;
  final Function(Reaction)? onReactionTap;
  final Function(CashuZap)? onZapTap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;

  const AppFeedPost({
    super.key,
    required this.note,
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
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Column(
      children: [
        AppSwipeContainer(
          padding: const AppEdgeInsets.all(AppGapSize.s12),
          leftContent: AppIcon.s16(
            theme.icons.characters.reply,
            outlineColor: theme.colors.white66,
            outlineThickness: LineThicknessData.normal().medium,
          ),
          rightContent: AppIcon.s10(
            theme.icons.characters.chevronUp,
            outlineColor: theme.colors.white66,
            outlineThickness: LineThicknessData.normal().medium,
          ),
          onSwipeLeft: () => onReply(note),
          onSwipeRight: () => onActions(note),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        AppProfilePic.s38(note.author.value?.pictureUrl ?? ''),
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
                              AppText.bold14(note.author.value?.name ??
                                  formatNpub(note.author.value?.pubkey ?? '')),
                              AppText.reg12(
                                TimestampFormatter.format(note.createdAt,
                                    format: TimestampFormat.relative),
                                color: theme.colors.white33,
                              ),
                            ],
                          ),
                          const AppGap.s2(),
                          AppShortTextRenderer(
                            content: note.content,
                            onResolveEvent: onResolveEvent,
                            onResolveProfile: onResolveProfile,
                            onResolveEmoji: onResolveEmoji,
                            onResolveHashtag: onResolveHashtag,
                            onLinkTap: onLinkTap,
                          ),
                          // TODO: Uncomment and implement once HasMany is available
                          /*
                          if (note.reactions.length > 0 ||
                              note.zaps.length > 0) ...[
                            const AppGap.s4(),
                            AppContainer(
                              height: 30,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: -62,
                                    right: 0,
                                    child: ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          stops: const [0.0, 0.5, 0.75, 1.0],
                                          colors: [
                                            const Color(0x00000000),
                                            const Color(0x00000000),
                                            theme.colors.white
                                                .withValues(alpha: 0.5),
                                            theme.colors.white,
                                          ],
                                        ).createShader(Rect.fromLTWH(
                                            0, 0, 62, bounds.height));
                                      },
                                      blendMode: BlendMode.dstIn,
                                      child: SingleChildScrollView(
                                        clipBehavior: Clip.none,
                                        scrollDirection: Axis.horizontal,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 62),
                                          child: AppInteractionPills(
                                            nevent: note.id,
                                            reactions: note.reactions
                                                .map((r) => ReplaceReaction(
                                                      npub: r.author.value
                                                              ?.pubkey ??
                                                          '',
                                                      nevent: note.id,
                                                      profileName: r.author
                                                              .value?.name ??
                                                          formatNpub(r
                                                                  .author
                                                                  .value
                                                                  ?.pubkey ??
                                                              ''),
                                                      profilePicUrl: r
                                                              .author
                                                              .value
                                                              ?.pictureUrl ??
                                                          '',
                                                      emojiUrl: r.content,
                                                      emojiName: r.content,
                                                      timestamp: r.createdAt,
                                                      isOutgoing: r.author.value
                                                              ?.pubkey ==
                                                          note.author.value
                                                              ?.pubkey,
                                                    ))
                                                .toList(),
                                            zaps: note.zaps
                                                .map((z) => ReplaceZap(
                                                      npub: z.author.value
                                                              ?.pubkey ??
                                                          '',
                                                      nevent: note.id,
                                                      amount: int.tryParse(
                                                              z.content) ??
                                                          0,
                                                      profileName: z.author
                                                              .value?.name ??
                                                          formatNpub(z
                                                                  .author
                                                                  .value
                                                                  ?.pubkey ??
                                                              ''),
                                                      profilePicUrl: z
                                                              .author
                                                              .value
                                                              ?.pictureUrl ??
                                                          '',
                                                      timestamp: z.createdAt,
                                                      isOutgoing: z.author.value
                                                              ?.pubkey ==
                                                          note.author.value
                                                              ?.pubkey,
                                                    ))
                                                .toList(),
                                            onReactionTap: onReactionTap,
                                            onZapTap: onZapTap,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          */
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
                          AppProfilePic.s20(topReplies[0].profilePicUrl),
                          const AppGap.s2(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (topReplies.length > 1)
                                AppProfilePic.s16(topReplies[1].profilePicUrl),
                              const Spacer(),
                              if (topReplies.length > 2)
                                AppProfilePic.s12(topReplies[2].profilePicUrl),
                              const AppGap.s2()
                            ],
                          ),
                        ],
                      ),
                    ),
                    const AppGap.s12(),
                    Expanded(
                      child: AppText.med14(
                        '${topReplies[0].profileName} & ${totalReplies - 1} others replied',
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
