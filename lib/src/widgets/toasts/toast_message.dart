import 'package:zaplab_design/zaplab_design.dart';

class AppToastMessage extends StatelessWidget {
  final String message;
  final String profilePicUrl;
  final String? profileName;
  final DateTime? timestamp;
  final VoidCallback? onTap;

  const AppToastMessage({
    super.key,
    required this.message,
    required this.profilePicUrl,
    this.profileName,
    this.timestamp,
    this.onTap,
  });

  static void show(
    BuildContext context, {
    required String message,
    required String profilePicUrl,
    String? profileName,
    DateTime? timestamp,
    Duration? duration,
    VoidCallback? onTap,
  }) {
    AppToast.show(
      context,
      duration: duration,
      onTap: onTap,
      children: [
        AppToastMessage(
          message: message,
          profilePicUrl: profilePicUrl,
          profileName: profileName,
          timestamp: timestamp,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppProfilePic.s32(profilePicUrl),
        const AppGap.s8(),
        Expanded(
          child: AppContainer(
            decoration: BoxDecoration(
              color: theme.colors.white16,
              borderRadius: BorderRadius.only(
                topRight: theme.radius.rad16,
                bottomRight: theme.radius.rad16,
                bottomLeft: theme.radius.rad16,
                topLeft: theme.radius.rad4,
              ),
            ),
            padding: const AppEdgeInsets.symmetric(
              horizontal: AppGapSize.s12,
              vertical: AppGapSize.s8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (profileName != null)
                      Flexible(
                        child: AppText.bold12(
                          profileName!,
                          color: theme.colors.white66,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (timestamp != null) ...[
                      const AppGap.s8(),
                      AppText.reg12(
                        TimestampFormatter.format(timestamp!,
                            format: TimestampFormat.relative),
                        color: theme.colors.white33,
                      ),
                    ],
                  ],
                ),
                AppText.reg14(
                  message,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
