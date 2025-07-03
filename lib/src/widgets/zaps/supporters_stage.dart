import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabSupportersStage extends StatelessWidget {
  final List<Profile> topThreeSupporters;

  const LabSupportersStage({
    super.key,
    required this.topThreeSupporters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final isInsideScope = LabScope.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabProfilePic.s56(topThreeSupporters[0].author.value),
              const SizedBox(height: 8),
              LabContainer(
                width: double.infinity,
                padding:
                    const LabEdgeInsets.symmetric(horizontal: LabGapSize.s12),
                child: LabText.med14(
                  topThreeSupporters[0].author.value?.name ??
                      formatNpub(
                          topThreeSupporters[0].author.value?.npub ?? ''),
                  color: theme.colors.white,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                fit: FlexFit.loose,
                child: SizedBox(
                  height: 64,
                  child: LabContainer(
                    padding: const LabEdgeInsets.only(top: LabGapSize.s12),
                    decoration: BoxDecoration(
                      color: isInsideScope
                          ? theme.colors.white8
                          : theme.colors.gray66,
                      borderRadius: BorderRadius.only(
                        topLeft: theme.radius.asBorderRadius().rad16.topRight,
                        bottomLeft:
                            theme.radius.asBorderRadius().rad16.bottomRight,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: LabText.med14(
                        '2',
                        color: theme.colors.white66,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Second place (center - winner)
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabProfilePic.s56(topThreeSupporters[1].author.value),
              const SizedBox(height: 8),
              LabContainer(
                width: double.infinity,
                padding:
                    const LabEdgeInsets.symmetric(horizontal: LabGapSize.s12),
                child: LabText.med14(
                  topThreeSupporters[1].author.value?.name ??
                      formatNpub(
                          topThreeSupporters[1].author.value?.npub ?? ''),
                  color: theme.colors.white,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                fit: FlexFit.loose,
                child: SizedBox(
                  height: 96,
                  child: LabContainer(
                    padding: const LabEdgeInsets.only(top: LabGapSize.s12),
                    decoration: BoxDecoration(
                      color: isInsideScope
                          ? theme.colors.white8
                          : theme.colors.gray66,
                      borderRadius: BorderRadius.only(
                        topRight: theme.radius.asBorderRadius().rad16.topRight,
                        topLeft:
                            theme.radius.asBorderRadius().rad16.bottomRight,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: LabText.med14(
                        '1',
                        color: theme.colors.white66,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Third place (right)
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabProfilePic.s56(topThreeSupporters[2].author.value),
              const SizedBox(height: 8),
              LabContainer(
                width: double.infinity,
                padding:
                    const LabEdgeInsets.symmetric(horizontal: LabGapSize.s12),
                child: LabText.med14(
                  topThreeSupporters[2].author.value?.name ??
                      formatNpub(
                          topThreeSupporters[2].author.value?.npub ?? ''),
                  color: theme.colors.white,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                fit: FlexFit.loose,
                child: SizedBox(
                  height: 48,
                  child: LabContainer(
                    padding: const LabEdgeInsets.only(top: LabGapSize.s12),
                    decoration: BoxDecoration(
                      color: isInsideScope
                          ? theme.colors.white8
                          : theme.colors.gray66,
                      borderRadius: BorderRadius.only(
                        topRight: theme.radius.asBorderRadius().rad16.topRight,
                        bottomRight:
                            theme.radius.asBorderRadius().rad16.bottomRight,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: LabText.med14(
                        '3',
                        color: theme.colors.white66,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
