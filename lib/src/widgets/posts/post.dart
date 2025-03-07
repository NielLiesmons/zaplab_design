import 'package:zaplab_design/zaplab_design.dart';

class AppPost extends StatelessWidget {
  final String content;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;
  final List<Reaction> reactions;
  final List<Zap> zaps;
  final List<Community> communities;
  final void Function(String)? onReactionTap;
  final void Function(String)? onZapTap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;

  const AppPost({
    super.key,
    required this.content,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
    this.reactions = const [],
    this.zaps = const [],
    this.communities = const [],
    this.onReactionTap,
    this.onZapTap,
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
              AppProfilePic.s48(profilePicUrl),
              const AppGap.s12(),
              Expanded(
                child: Column(
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
                    const AppGap.s6(),
                    AppCommunityStack(
                      onTap:
                          () {}, // TODO: Add AppModal.show -> Community cards in the modal
                      communities: communities,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const AppGap.s8(),
          AppText.reg14(content),
          if (reactions.isNotEmpty || zaps.isNotEmpty) ...[
            const AppGap.s8(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AppInteractionPills(
                nevent: '',
                reactions: reactions,
                zaps: zaps,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
