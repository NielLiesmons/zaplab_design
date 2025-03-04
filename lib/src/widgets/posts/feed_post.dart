import 'package:zaplab_design/zaplab_design.dart';
import 'package:zaplab_design/src/utils/timestamp_formatter.dart';

class ReplyUserData {
  final String profileName;
  final String profilePicUrl;

  const ReplyUserData({
    required this.profileName,
    required this.profilePicUrl,
  });
}

class AppFeedPost extends StatelessWidget {
  final String nevent;
  final String content;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;
  final List<Reaction> reactions;
  final List<Zap> zaps;
  final List<ReplyUserData> topReplies;
  final int totalReplies;
  final void Function(String) onReply;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final List<double> recentAmounts;
  final List<Reaction> recentReactions;

  const AppFeedPost({
    super.key,
    required this.nevent,
    required this.content,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
    this.reactions = const [],
    this.zaps = const [],
    this.topReplies = const [],
    this.totalReplies = 0,
    required this.onReply,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    this.recentAmounts = DefaultData.defaultAmounts,
    this.recentReactions = DefaultData.defaultReactions,
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
          onSwipeLeft: () => onReply(nevent),
          onSwipeRight: () => AppActionsModal.show(
            context,
            profileName: profileName,
            nevent: nevent,
            contentType: 'post',
            title: content,
            profilePicUrl: profilePicUrl,
            recentAmounts: recentAmounts,
            recentReactions: recentReactions,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        AppProfilePic.s38(profilePicUrl),
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
                              AppText.bold14(profileName),
                              AppText.reg12(
                                TimestampFormatter.format(timestamp,
                                    format: TimestampFormat.relative),
                                color: theme.colors.white33,
                              ),
                            ],
                          ),
                          const AppGap.s2(),
                          AppShortTextRenderer(
                            content: content,
                            onResolveEvent: onResolveEvent,
                            onResolveProfile: onResolveProfile,
                            onResolveEmoji: onResolveEmoji,
                            onResolveHashtag: onResolveHashtag,
                            onLinkTap: onLinkTap,
                          ),
                          if (reactions.isNotEmpty || zaps.isNotEmpty) ...[
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
                                            nevent: '',
                                            reactions: reactions,
                                            zaps: zaps,
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
