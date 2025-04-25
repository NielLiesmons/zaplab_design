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
