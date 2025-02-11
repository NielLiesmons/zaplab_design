import 'package:zaplab_design/zaplab_design.dart';

class AppZapCard extends StatelessWidget {
  final String profileName;
  final String profilePicUrl;
  final String amount;
  final String? message;
  final VoidCallback? onTap;

  const AppZapCard({
    super.key,
    required this.profileName,
    required this.profilePicUrl,
    required this.amount,
    this.message,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppPanelButton(
      padding: const AppEdgeInsets.all(AppGapSize.none),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppContainer(
            padding: const AppEdgeInsets.symmetric(
              horizontal: AppGapSize.s12,
            ),
            height: theme.sizes.s38,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppProfilePic.s18(profilePicUrl),
                const AppGap.s10(),
                Expanded(
                  child: AppText.bold14(profileName),
                ),
                Row(
                  children: [
                    AppIcon.s12(
                      theme.icons.characters.zap,
                      gradient: theme.colors.gold,
                    ),
                    const AppGap.s4(),
                    AppText.bold14(amount),
                  ],
                ),
              ],
            ),
          ),
          if (message != null) ...[
            const AppDivider(),
            AppContainer(
              padding: const AppEdgeInsets.symmetric(
                horizontal: AppGapSize.s12,
                vertical: AppGapSize.s8,
              ),
              child: AppText.reg14(
                message!,
                color: theme.colors.white66,
                maxLines: 3,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
