import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabCommunityCard extends StatelessWidget {
  final Community community;
  final VoidCallback onTap;
  final Profile? profile;
  final String? profileLabel;
  final List<Profile>? relevantProfiles;
  final String? relevantProfilesDescription;
  final VoidCallback onProfilesTap;

  const LabCommunityCard({
    super.key,
    required this.community,
    required this.onTap,
    this.profile,
    this.profileLabel,
    this.relevantProfiles,
    this.relevantProfilesDescription,
    required this.onProfilesTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabPanelButton(
      onTap: onTap,
      padding: const LabEdgeInsets.all(LabGapSize.none),
      child: Column(
        children: [
          if (profile != null && profileLabel != null)
            LabContainer(
              padding: const LabEdgeInsets.symmetric(
                vertical: LabGapSize.s8,
                horizontal: LabGapSize.s12,
              ),
              decoration: BoxDecoration(
                color: theme.colors.white8,
              ),
              child: Row(
                children: [
                  LabProfilePic.s18(profile!),
                  const LabGap.s8(),
                  LabText.reg12(
                      "${profile!.name ?? formatNpub(profile!.npub)} is $profileLabel",
                      color: theme.colors.white66,
                      textOverflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          LabContainer(
            padding: const LabEdgeInsets.symmetric(
              vertical: LabGapSize.s8,
              horizontal: LabGapSize.s12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabProfilePic.s56(community.author.value),
                const LabGap.s12(),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabText.med14(community.name),
                      const LabGap.s2(),
                      LabText.reg12(community.description ?? '',
                          color: theme.colors.white66,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const LabDivider(),
          LabContainer(
            padding: const LabEdgeInsets.symmetric(
              vertical: LabGapSize.s8,
              horizontal: LabGapSize.s12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LabProfileStack(
                  profiles: relevantProfiles ?? [],
                  description: relevantProfilesDescription,
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
