import 'package:zaplab_design/zaplab_design.dart';
import 'package:zaplab_design/src/utils/npub_utils.dart';

class AppCurrentProfileCard extends StatelessWidget {
  final String npub;
  final String profileName;
  final String profilePicUrl;

  const AppCurrentProfileCard({
    super.key,
    required this.npub,
    required this.profileName,
    required this.profilePicUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      width: 256,
      padding: const AppEdgeInsets.all(AppGapSize.s16),
      decoration: BoxDecoration(
        color: theme.colors.grey66,
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
                    child: AppProfilePic.s48(profilePicUrl),
                  ),
                ),
                const AppGap.s12(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.bold16(
                      profileName,
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
                                    npubToColor(npub).substring(1),
                                    radix: 16,
                                  ) +
                                  0xFF000000,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        const AppGap.s8(),
                        AppContainer(
                          child: AppText.med12(
                            formatNpub(npub),
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
          const AppGap.s40(),
          Row(
            children: [
              AppSmallButton(
                rounded: true,
                inactiveColor: theme.colors.white8,
                content: [
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
                rounded: true,
                inactiveColor: theme.colors.white8,
                content: [
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
                rounded: true,
                square: true,
                inactiveColor: theme.colors.white8,
                content: [
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
