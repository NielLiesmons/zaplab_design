import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabReply extends StatelessWidget {
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

  const LabReply({
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
          const LabGap.s12(),
          IntrinsicHeight(
            child: Row(
              children: [
                LabContainer(
                  width: theme.sizes.s38,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LabGap.s2(),
                      LabProfilePic.s20(reply.parentModel.value!.author.value),
                      Expanded(
                        child: LabDivider.vertical(
                          color: theme.colors.white33,
                        ),
                      ),
                    ],
                  ),
                ),
                const LabGap.s4(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LabEmojiContentType(
                            contentType:
                                getModelContentType(reply.parentModel.value),
                            size: theme.sizes.s16,
                          ),
                          const LabGap.s8(),
                          Expanded(
                            child: LabText.reg14(
                              getModelDisplayText(reply.parentModel.value),
                              color: theme.colors.white66,
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const LabGap.s12(),
                        ],
                      ),
                      const LabGap.s10(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LabProfilePic.s38(reply.author.value,
                  onTap: () => onProfileTap(reply.author.value as Profile)),
              const LabGap.s12(),
              Expanded(
                child: LabText.bold14(reply.author.value?.name ??
                    formatNpub(reply.author.value?.pubkey ?? '')),
              ),
              LabText.reg12(
                TimestampFormatter.format(reply.createdAt,
                    format: TimestampFormat.relative),
                color: theme.colors.white33,
              ),
            ],
          ),
          const LabGap.s8(),
          LabContainer(
            padding: const LabEdgeInsets.symmetric(
              vertical: LabGapSize.none,
              horizontal: LabGapSize.s4,
            ),
            child: LabShortTextRenderer(
              model: reply,
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
