import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppCommunityCard extends StatelessWidget {
  final Community community;
  final VoidCallback onTap;
  final Profile? profile;
  final String? profileLabel;
  final List<Profile>? relevantProfiles;
  final VoidCallback onProfilesTap;

  const AppCommunityCard({
    super.key,
    required this.community,
    required this.onTap,
    this.profile,
    this.profileLabel,
    this.relevantProfiles,
    required this.onProfilesTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppPanelButton(
      onTap: onTap,
      padding: const AppEdgeInsets.all(AppGapSize.none),
      child: Column(
        children: [
          if (profile != null && profileLabel != null)
            AppContainer(
              padding: const AppEdgeInsets.symmetric(
                vertical: AppGapSize.s8,
                horizontal: AppGapSize.s12,
              ),
              decoration: BoxDecoration(
                color: theme.colors.white8,
              ),
              child: Row(
                children: [
                  AppProfilePic.s18(profile!.pictureUrl ?? ''),
                  const AppGap.s8(),
                  AppText.reg12(
                      "${profile!.name ?? formatNpub(profile!.npub)} is $profileLabel",
                      color: theme.colors.white66,
                      textOverflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          AppContainer(
            padding: const AppEdgeInsets.symmetric(
              vertical: AppGapSize.s8,
              horizontal: AppGapSize.s12,
            ),
            child: Row(
              children: [
                AppProfilePic.s56(community.author.value?.pictureUrl ?? ''),
                const AppGap.s12(),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.med14(community.name),
                      const AppGap.s2(),
                      AppText.reg12(community.description ?? '',
                          color: theme.colors.white66,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const AppDivider(),
          AppContainer(
            padding: const AppEdgeInsets.symmetric(
              vertical: AppGapSize.s8,
              horizontal: AppGapSize.s12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppProfileStack(
                  profiles: relevantProfiles ?? [],
                  description: "Followers in your network",
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
