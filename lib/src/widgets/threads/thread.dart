import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppThread extends StatelessWidget {
  final Note thread;
  // TODO: Implement reactions, zaps, and communities once HasMany is available
  // final List<ReplaceReaction> reactions;
  // final List<ReplaceZap> zaps;
  final List<Community> communities;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final Function(Profile) onProfileTap;

  const AppThread({
    super.key,
    required this.thread,
    // TODO: Implement reactions, zaps, and communities once HasMany is available
    // this.reactions = const [],
    // this.zaps = const [],
    this.communities = const [],
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppProfilePic.s48(thread.author.value,
                  onTap: () => onProfileTap(thread.author.value as Profile)),
              const AppGap.s12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText.bold14(thread.author.value?.name ??
                            formatNpub(thread.author.value?.pubkey ?? '')),
                        AppText.reg12(
                          TimestampFormatter.format(thread.createdAt,
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
              content: thread.content,
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
