import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabOtherProfileCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onSelect;
  final VoidCallback? onShare;
  final VoidCallback? onView;
  const LabOtherProfileCard({
    super.key,
    required this.profile,
    this.onSelect,
    this.onShare,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabContainer(
      width: 256,
      height: 144,
      padding: const LabEdgeInsets.all(LabGapSize.s16),
      decoration: BoxDecoration(
        color: theme.colors.gray33,
        borderRadius: theme.radius.asBorderRadius().rad16,
        border: Border.all(
          color: theme.colors.gray,
          width: LabLineThicknessData.normal().medium,
        ),
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
                    child: LabProfilePic.s48(
                      profile.author.value,
                      onTap: onView,
                    ),
                  ),
                ),
                const LabGap.s12(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onView,
                    child: Column(
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
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              LabSmallButton(
                onTap: onSelect,
                rounded: true,
                color: theme.colors.white8,
                children: [
                  const LabGap.s4(),
                  LabText.med12(
                    'Select',
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
