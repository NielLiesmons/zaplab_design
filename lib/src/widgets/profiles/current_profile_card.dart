import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppCurrentProfileCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onEdit;
  final VoidCallback? onView;
  final VoidCallback? onShare;

  const AppCurrentProfileCard({
    super.key,
    required this.profile,
    this.onEdit,
    this.onView,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      width: 256,
      padding: const AppEdgeInsets.all(AppGapSize.s16),
      decoration: BoxDecoration(
        color: theme.colors.gray66,
        borderRadius: theme.radius.asBorderRadius().rad16,
      ),
      child: Column(
        children: [
          AppContainer(
            child: Row(
              children: [
                AppContainer(
                  width: theme.sizes.s56,
                  height: theme.sizes.s56,
                  child: Center(
                    child: AppProfilePic.s48(profile.author.value),
                  ),
                ),
                const AppGap.s12(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.bold16(
                      profile.author.value?.name ??
                          formatNpub(profile.author.value?.npub ?? ''),
                      color: theme.colors.white,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    AppNpubDisplay(profile: profile),
                  ],
                ),
              ],
            ),
          ),
          const AppGap.s40(),
          Row(
            children: [
              AppSmallButton(
                onTap: onView,
                rounded: true,
                inactiveColor: theme.colors.white8,
                children: [
                  const AppGap.s4(),
                  AppText.med12(
                    'View',
                    color: theme.colors.white66,
                  ),
                  const AppGap.s4(),
                ],
              ),
              const AppGap.s12(),
              AppSmallButton(
                onTap: onEdit,
                rounded: true,
                inactiveColor: theme.colors.white8,
                children: [
                  const AppGap.s4(),
                  AppText.med12(
                    'Edit',
                    color: theme.colors.white66,
                  ),
                  const AppGap.s4(),
                ],
              ),
              const Spacer(),
              AppSmallButton(
                onTap: onShare,
                rounded: true,
                square: true,
                inactiveColor: theme.colors.white8,
                children: [
                  AppIcon.s16(
                    theme.icons.characters.share,
                    color: theme.colors.white33,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
