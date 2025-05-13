import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppOtherProfileCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onSelect;
  final VoidCallback? onShare;
  final VoidCallback? onView;
  const AppOtherProfileCard({
    super.key,
    required this.profile,
    this.onSelect,
    this.onShare,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      width: 256,
      height: 144,
      padding: const AppEdgeInsets.all(AppGapSize.s16),
      decoration: BoxDecoration(
        color: theme.colors.gray33,
        borderRadius: theme.radius.asBorderRadius().rad16,
        border: Border.all(
          color: theme.colors.gray,
          width: AppLineThicknessData.normal().medium,
        ),
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
                    child: AppProfilePic.s48(
                      profile.author.value,
                      onTap: onView,
                    ),
                  ),
                ),
                const AppGap.s12(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onView,
                    child: Column(
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
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              AppSmallButton(
                onTap: onSelect,
                rounded: true,
                inactiveColor: theme.colors.white8,
                children: [
                  const AppGap.s4(),
                  AppText.med12(
                    'Select',
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
