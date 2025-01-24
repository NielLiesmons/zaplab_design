import 'package:zaplab_design/zaplab_design.dart';

class AppPost extends StatelessWidget {
  final String content;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;
  final List<Reaction> reactions;
  final List<Zap> zaps;

  const AppPost({
    super.key,
    required this.content,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
    this.reactions = const [],
    this.zaps = const [],
  });

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

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
                          _formatTimestamp(timestamp),
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    AppContainer(
                      child: AppText.reg12(
                        'TODO: communities',
                        color: theme.colors.white33,
                      ),
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
                eventId: '',
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
