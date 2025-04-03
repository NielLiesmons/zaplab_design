import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppPostCard extends StatelessWidget {
  final Note post;
  final VoidCallback? onTap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;

  const AppPostCard({
    super.key,
    required this.post,
    this.onTap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppPanelButton(
      padding: const AppEdgeInsets.only(
          top: AppGapSize.s10,
          bottom: AppGapSize.s8,
          left: AppGapSize.s12,
          right: AppGapSize.s12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppContainer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppProfilePic.s18(post.author.value?.pictureUrl ?? ''),
                const AppGap.s8(),
                Expanded(
                  child: AppText.bold12(post.author.value?.name ?? ''),
                ),
                AppText.reg12(
                  TimestampFormatter.format(post.createdAt,
                      format: TimestampFormat.relative),
                  color: theme.colors.white33,
                ),
              ],
            ),
          ),
          const AppGap.s6(),
          AppContainer(
            child: AppCompactTextRenderer(
              content: post.content,
              onResolveEvent: onResolveEvent,
              onResolveProfile: onResolveProfile,
              onResolveEmoji: onResolveEmoji,
            ),
          ),
        ],
      ),
    );
  }
}
