import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabThread extends StatelessWidget {
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

  const LabThread({
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
    final theme = LabTheme.of(context);

    return LabContainer(
      padding: const LabEdgeInsets.only(
        top: LabGapSize.s4,
        left: LabGapSize.s12,
        right: LabGapSize.s12,
        bottom: LabGapSize.s12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabProfilePic.s48(thread.author.value,
                  onTap: () => onProfileTap(thread.author.value as Profile)),
              const LabGap.s12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LabText.bold14(thread.author.value?.name ??
                            formatNpub(thread.author.value?.pubkey ?? '')),
                        LabText.reg12(
                          TimestampFormatter.format(thread.createdAt,
                              format: TimestampFormat.relative),
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const LabGap.s6(),
                    LabCommunityStack(
                      communities: communities,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const LabGap.s12(),
          LabContainer(
            padding: const LabEdgeInsets.symmetric(
              vertical: LabGapSize.none,
              horizontal: LabGapSize.s4,
            ),
            child: LabShortTextRenderer(
              model: thread,
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
