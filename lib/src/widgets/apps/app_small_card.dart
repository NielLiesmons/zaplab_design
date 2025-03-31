import 'package:zaplab_design/zaplab_design.dart';

class AppAppSmallCard extends StatelessWidget {
  final String appName;
  final String version;
  final String profilePicUrl;
  final VoidCallback onUpdate;

  const AppAppSmallCard({
    super.key,
    required this.appName,
    required this.version,
    required this.profilePicUrl,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppPanel(
      isLight: true,
      padding: const AppEdgeInsets.symmetric(
        horizontal: AppGapSize.s12,
        vertical: AppGapSize.s12,
      ),
      child: Row(
        children: [
          AppProfilePicSquare.s56(profilePicUrl),
          const AppGap.s16(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.med16(appName),
                const AppGap.s4(),
                AppText.reg12(
                  version,
                  color: theme.colors.white66,
                ),
              ],
            ),
          ),
          const AppGap.s16(),
          AppSmallButton(
            rounded: true,
            children: [
              AppText.med14(
                'Update',
                color: AppColorsData.dark().white,
              ),
            ],
            onTap: onUpdate,
          ),
        ],
      ),
    );
  }
}
