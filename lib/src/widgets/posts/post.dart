import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppPost extends StatelessWidget {
  final Note post;
  // TODO: Implement reactions, zaps, and communities once HasMany is available
  // final List<ReplaceReaction> reactions;
  // final List<ReplaceZap> zaps;
  final List<Community> communities;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;

  const AppPost({
    super.key,
    required this.post,
    // TODO: Implement reactions, zaps, and communities once HasMany is available
    // this.reactions = const [],
    // this.zaps = const [],
    this.communities = const [],
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      padding: const AppEdgeInsets.all(AppGapSize.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppProfilePic.s48(post.author.value?.pictureUrl ?? ''),
              const AppGap.s12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText.bold14(post.author.value?.name ??
                            formatNpub(post.author.value?.pubkey ?? '')),
                        AppText.reg12(
                          TimestampFormatter.format(post.createdAt,
                              format: TimestampFormat.relative),
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const AppGap.s6(),
                    AppCommunityStack(
                      communities: communities,
                    ),

                    // TODO: Implement reactions, zaps, and communities once HasMany is available
                    /*
                    if (note.reactions.length > 0 ||
                        note.zaps.length > 0) ...[
                      const AppGap.s8(),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: AppInteractionPills(
                          nevent: note.id,
                          reactions: note.reactions
                              .map((r) => ReplaceReaction(
                                    npub: r.author.value?.pubkey ?? '',
                                    nevent: note.id,
                                    profileName: r.author.value?.name ??
                                        formatNpub(r.author.value?.pubkey ?? ''),
                                    profilePicUrl: r.author.value?.pictureUrl ?? '',
                                    emojiUrl: r.content,
                                    emojiName: r.content,
                                    timestamp: r.createdAt,
                                    isOutgoing: r.author.value?.pubkey ==
                                        note.author.value?.pubkey,
                                  ))
                              .toList(),
                          zaps: note.zaps
                              .map((z) => ReplaceZap(
                                    npub: z.author.value?.pubkey ?? '',
                                    nevent: note.id,
                                    amount: int.tryParse(z.content) ?? 0,
                                    profileName: z.author.value?.name ??
                                        formatNpub(z.author.value?.pubkey ?? ''),
                                    profilePicUrl: z.author.value?.pictureUrl ?? '',
                                    timestamp: z.createdAt,
                                    isOutgoing: z.author.value?.pubkey ==
                                        note.author.value?.pubkey,
                                  ))
                              .toList(),
                          onReactionTap: onReactionTap,
                          onZapTap: onZapTap,
                        ),
                      ),
                    ],
                    */
                  ],
                ),
              ),
            ],
          ),
          const AppGap.s12(),
          AppContainer(
            padding: const AppEdgeInsets.symmetric(
              vertical: AppGapSize.none,
              horizontal: AppGapSize.s4,
            ),
            child: AppShortTextRenderer(
              content: post.content,
              onResolveEvent: onResolveEvent,
              onResolveProfile: onResolveProfile,
              onResolveEmoji: onResolveEmoji,
              onResolveHashtag: onResolveHashtag,
              onLinkTap: onLinkTap,
            ),
          ),
        ],
      ),
    );
  }
}
