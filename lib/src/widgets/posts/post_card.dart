import 'package:zaplab_design/zaplab_design.dart';
import 'package:zaplab_design/src/utils/timestamp_formatter.dart';

class AppPostCard extends StatelessWidget {
  final String content;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;
  final VoidCallback? onTap;

  const AppPostCard({
    super.key,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
    required this.content,
    this.onTap,
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
                AppProfilePic.s18(profilePicUrl),
                const AppGap.s8(),
                Expanded(
                  child: AppText.bold12(profileName),
                ),
                AppText.reg12(
                  TimestampFormatter.format(timestamp,
                      format: TimestampFormat.relative),
                  color: theme.colors.white33,
                ),
              ],
            ),
          ),
          const AppGap.s6(),
          AppContainer(
            child: AppText.reg12(
              content,
              color: theme.colors.white66,
              maxLines: 3,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
