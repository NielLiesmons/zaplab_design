import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppThreadCard extends StatelessWidget {
  final Note thread;
  final Function(Note)? onTap;
  final Function(Profile) onProfileTap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;

  const AppThreadCard({
    super.key,
    required this.thread,
    this.onTap,
    required this.onProfileTap,
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
      onTap: onTap == null ? null : () => onTap!(thread),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppContainer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppProfilePic.s18(thread.author.value,
                    onTap: () => onProfileTap(thread.author.value as Profile)),
                const AppGap.s8(),
                Expanded(
                  child: AppText.bold12(
                    thread.author.value?.name ??
                        formatNpub(thread.author.value?.pubkey ?? ''),
                  ),
                ),
                AppText.reg12(
                  TimestampFormatter.format(thread.createdAt,
                      format: TimestampFormat.relative),
                  color: theme.colors.white33,
                ),
              ],
            ),
          ),
          const AppGap.s6(),
          AppContainer(
            child: AppCompactTextRenderer(
              content: thread.content,
              onResolveEvent: onResolveEvent,
              onResolveProfile: onResolveProfile,
              onResolveEmoji: onResolveEmoji,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
