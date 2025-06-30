import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabPollButton extends StatelessWidget {
  final Model model;
  final String content;
  final List<PollResponse> votes;
  final int percentage;
  final int fillPercentage;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onVotesTap;
  final Function(Profile) onProfileTap;
  final LinkTapHandler onLinkTap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;

  const LabPollButton({
    super.key,
    required this.model,
    required this.content,
    required this.votes,
    required this.percentage,
    required this.fillPercentage,
    this.isSelected = false,
    required this.onTap,
    required this.onVotesTap,
    required this.onProfileTap,
    required this.onLinkTap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final isInsideModal = ModalScope.of(context);
    // ignore: unnecessary_null_comparison
    final isInsideMessage = MessageBubbleScope.of(context) == null;

    return TapBuilder(
      onTap: onTap,
      builder: (context, state, hasFocus) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.98;
        }

        return Transform.scale(
          scale: scaleFactor,
          child: LabContainer(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: isInsideModal || isInsideMessage
                  ? theme.colors.black33
                  : theme.colors.gray66,
              borderRadius: theme.radius.asBorderRadius().rad16,
              border: isSelected
                  ? Border.all(
                      color: theme.colors.blurpleLightColor,
                      width: LabLineThicknessData.normal().medium,
                    )
                  : null,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: LabContainer(
                        width: constraints.maxWidth * (fillPercentage / 100),
                        decoration: BoxDecoration(
                          gradient: theme.colors.blurple33,
                        ),
                      ),
                    ),
                    LabContainer(
                      padding: const LabEdgeInsets.only(
                        top: LabGapSize.s10,
                        bottom: LabGapSize.s12,
                        left: LabGapSize.s12,
                        right: LabGapSize.s16,
                      ),
                      child: ShortTextContent(
                        contentType:
                            LabShortTextRenderer.analyzeContent(content),
                        child: Builder(
                          builder: (context) {
                            final isSingleContent =
                                ShortTextContent.of(context).isSingleContent;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                isSingleContent
                                    ? const LabGap.s4()
                                    : const SizedBox.shrink(),
                                LabShortTextRenderer(
                                  model: model,
                                  content: content,
                                  onResolveEvent: onResolveEvent,
                                  onResolveProfile: onResolveProfile,
                                  onResolveEmoji: onResolveEmoji,
                                  onResolveHashtag: onResolveHashtag,
                                  onLinkTap: onLinkTap,
                                  onProfileTap: onProfileTap,
                                ),
                                isSingleContent
                                    ? const LabGap.s8()
                                    : const LabGap.s2(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: LabSmallProfileStack(
                                        onTap: onVotesTap,
                                        profiles: votes
                                            .map((vote) => vote.author.value!)
                                            .toList(),
                                        description: votes.length == 1
                                            ? '1 Vote'
                                            : '${votes.length} Votes',
                                      ),
                                    ),
                                    LabText.reg14(
                                      '${percentage.toString()}%',
                                      color: theme.colors.white66,
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
