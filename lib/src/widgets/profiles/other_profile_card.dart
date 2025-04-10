import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppOtherProfileCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onSelect;
  final VoidCallback? onShare;

  const AppOtherProfileCard({
    super.key,
    required this.profile,
    this.onSelect,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      width: 256,
      height: 144,
      padding: const AppEdgeInsets.all(AppGapSize.s16),
      decoration: BoxDecoration(
        color: theme.colors.grey33,
        borderRadius: theme.radius.asBorderRadius().rad16,
        border: Border.all(
          color: theme.colors.grey,
          width: LineThicknessData.normal().medium,
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
                        profile.author.value?.pictureUrl ?? ''),
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
                    ),
                    Row(
                      children: [
                        AppContainer(
                          height: theme.sizes.s8,
                          width: theme.sizes.s8,
                          decoration: BoxDecoration(
                            color: Color(
                              int.parse(
                                    profileToColor(profile).substring(1),
                                    radix: 16,
                                  ) +
                                  0xFF000000,
                            ),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: theme.colors.white16,
                              width: LineThicknessData.normal().thin,
                            ),
                          ),
                        ),
                        const AppGap.s8(),
                        AppContainer(
                          child: AppText.med12(
                            formatNpub(profile.author.value?.npub ?? ''),
                            textOverflow: TextOverflow.ellipsis,
                            color: theme.colors.white66,
                          ),
                        ),
                      ],
                    ),
                  ],
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
