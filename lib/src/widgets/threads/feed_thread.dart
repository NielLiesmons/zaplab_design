import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabFeedThread extends StatelessWidget {
  final Note? thread;
  final Comment? reply;
  final Function(Model) onTap;
  final List<Comment>? replies;
  final List<Profile>? topThreeReplyProfiles;
  final int? totalReplyProfiles;
  final Function(Model) onActions;
  final Function(Model) onReply;
  final Function(Reaction)? onReactionTap;
  final Function(Zap)? onZapTap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final Function(Profile) onProfileTap;
  final bool isUnread;

  const LabFeedThread({
    super.key,
    this.thread,
    this.reply,
    required this.onTap,
    this.topThreeReplyProfiles,
    this.totalReplyProfiles,
    this.replies,
    required this.onReply,
    required this.onActions,
    required this.onReactionTap,
    required this.onZapTap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    required this.onProfileTap,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    // Calculate reply profiles if not provided
    final replyProfiles = topThreeReplyProfiles ?? _getReplyProfiles();
    final totalReplies = totalReplyProfiles ?? _getTotalReplies();

    return Column(
      children: [
        LabSwipeContainer(
          onTap: () => onTap(thread ?? reply!),
          padding: const LabEdgeInsets.all(LabGapSize.s12),
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
          onSwipeLeft: () => onReply(thread ?? reply!),
          onSwipeRight: () => onActions(thread ?? reply!),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        LabProfilePic.s38(
                          thread?.author.value ?? reply?.author.value,
                        ),
                        if (replyProfiles.isNotEmpty)
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              LabText.bold14(
                                  thread != null
                                      ? thread!.author.value != null
                                          ? thread!.author.value?.name ??
                                              formatNpub(thread!
                                                      .author.value?.pubkey ??
                                                  '')
                                          : 'Profile Name...'
                                      : reply!.author.value != null
                                          ? reply!.author.value?.name ??
                                              formatNpub(
                                                  reply!.author.value?.pubkey ??
                                                      '')
                                          : 'Profile Name...',
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis),
                              const Spacer(),
                              LabText.reg12(
                                TimestampFormatter.format(
                                    thread != null
                                        ? thread!.createdAt
                                        : reply!.createdAt,
                                    format: TimestampFormat.relative),
                                color: theme.colors.white33,
                              ),
                              if (isUnread) ...[
                                const LabGap.s12(),
                                LabContainer(
                                  height: theme.sizes.s8,
                                  width: theme.sizes.s8,
                                  decoration: BoxDecoration(
                                    gradient: theme.colors.blurple,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const LabGap.s4(),
                          LabShortTextRenderer(
                            model: thread ?? reply!,
                            content: thread != null
                                ? thread!.content
                                : reply!.content,
                            onResolveEvent: onResolveEvent,
                            onResolveProfile: onResolveProfile,
                            onResolveEmoji: onResolveEmoji,
                            onResolveHashtag: onResolveHashtag,
                            onLinkTap: onLinkTap,
                            onProfileTap: onProfileTap,
                          ),
                          if ((thread != null &&
                                  (thread!.reactions.isNotEmpty ||
                                      thread!.zaps.isNotEmpty)) ||
                              (reply != null &&
                                  (reply!.reactions.isNotEmpty ||
                                      reply!.zaps.isNotEmpty))) ...[
                            const LabGap.s4(),
                            LabContainer(
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
                                          child: LabInteractionPills(
                                            zaps: thread?.zaps.toList() ??
                                                reply!.zaps.toList(),
                                            reactions:
                                                thread?.reactions.toList() ??
                                                    reply!.reactions.toList(),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (replyProfiles.isNotEmpty) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: Column(
                        children: [
                          LabProfilePic.s20(replyProfiles[0]),
                          const LabGap.s2(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (replyProfiles.length > 1)
                                LabProfilePic.s16(replyProfiles[1]),
                              const Spacer(),
                              if (replyProfiles.length > 2)
                                LabProfilePic.s12(replyProfiles[2]),
                              const LabGap.s2()
                            ],
                          ),
                        ],
                      ),
                    ),
                    const LabGap.s12(),
                    Expanded(
                      child: LabText.med14(
                        '${replyProfiles[0].name ?? formatNpub(replyProfiles[0].author.value?.npub ?? '')} & ${totalReplies - 1} others replied',
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

  List<Profile> _getReplyProfiles() {
    // Use manual replies if provided, otherwise fall back to model relationships
    final replyList =
        replies ?? thread?.replies.toList() ?? reply?.replies.toList() ?? [];
    final uniqueProfiles = replyList
        .map((reply) => (reply as Comment).author.value)
        .where((profile) => profile != null)
        .toSet()
        .take(3)
        .cast<Profile>()
        .toList();
    return uniqueProfiles;
  }

  int _getTotalReplies() {
    // Use manual replies if provided, otherwise fall back to model relationships
    return replies?.length ??
        thread?.replies.length ??
        reply?.replies.length ??
        0;
  }
}
