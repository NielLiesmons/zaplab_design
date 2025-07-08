import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppactiveProfileCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onEdit;
  final VoidCallback? onView;
  final VoidCallback? onShare;

  const AppactiveProfileCard({
    super.key,
    required this.profile,
    this.onEdit,
    this.onView,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabContainer(
      width: 256,
      padding: const LabEdgeInsets.all(LabGapSize.s16),
      decoration: BoxDecoration(
        color: theme.colors.gray66,
        borderRadius: theme.radius.asBorderRadius().rad16,
      ),
      child: Column(
        children: [
          LabContainer(
            child: Row(
              children: [
                LabContainer(
                  width: theme.sizes.s56,
                  height: theme.sizes.s56,
                  child: Center(
                    child: LabProfilePic.s48(profile.author.value),
                  ),
                ),
                const LabGap.s12(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabText.bold16(
                      profile.author.value?.name ??
                          formatNpub(profile.author.value?.npub ?? ''),
                      color: theme.colors.white,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    LabNpubDisplay(profile: profile),
                  ],
                ),
              ],
            ),
          ),
          const LabGap.s40(),
          Row(
            children: [
              LabSmallButton(
                onTap: onView,
                rounded: true,
                color: theme.colors.white8,
                children: [
                  const LabGap.s4(),
                  LabText.med12(
                    'View',
                    color: theme.colors.white66,
                  ),
                  const LabGap.s4(),
                ],
              ),
              const LabGap.s12(),
              LabSmallButton(
                onTap: onEdit,
                rounded: true,
                color: theme.colors.white8,
                children: [
                  const LabGap.s4(),
                  LabText.med12(
                    'Edit',
                    color: theme.colors.white66,
                  ),
                  const LabGap.s4(),
                ],
              ),
              const Spacer(),
              LabSmallButton(
                onTap: onShare,
                rounded: true,
                square: true,
                color: theme.colors.white8,
                children: [
                  LabIcon.s16(
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
