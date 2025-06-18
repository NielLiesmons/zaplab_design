import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabCommunityStack extends StatelessWidget {
  final List<Community>? communities;
  final VoidCallback? onTap;
  const LabCommunityStack({
    super.key,
    this.communities,
    this.onTap,
  });

  List<Community> get _visibleCommunities =>
      communities?.take(5).toList().reversed.toList() ?? [];

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return TapBuilder(
      onTap: onTap,
      builder: (context, state, isFocused) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.99;
        } else if (state == TapState.hover) {
          scaleFactor = 1.01;
        }

        return Transform.scale(
          scale: scaleFactor,
          child: communities == null || communities!.isEmpty
              ? IntrinsicWidth(
                  child: LabContainer(
                    height: theme.sizes.s20,
                    padding: const LabEdgeInsets.symmetric(
                      horizontal: LabGapSize.s12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colors.white8,
                      borderRadius: theme.radius.asBorderRadius().rad16,
                    ),
                    child: Center(
                      child: LabText.reg12(
                        'No target found',
                        color: theme.colors.white33,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                )
              : LabContainer(
                  width: 240,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Transform.translate(
                              offset: Offset(
                                  theme.sizes.s6 +
                                      (_visibleCommunities.length - 1) * 16,
                                  0),
                              child: LabContainer(
                                height: theme.sizes.s20,
                                padding: const LabEdgeInsets.only(
                                  left: LabGapSize.s20,
                                  right: LabGapSize.s12,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colors.white16,
                                  borderRadius:
                                      theme.radius.asBorderRadius().rad16,
                                ),
                                child: Center(
                                  child: LabText.reg12(
                                    communities!.length == 1
                                        ? communities!
                                                .first.author.value?.name ??
                                            formatNpub(communities!
                                                    .first.author.value?.npub ??
                                                '')
                                        : '${communities!.length} Communities',
                                    color: theme.colors.white66,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: _visibleCommunities.isEmpty
                                  ? 0
                                  : theme.sizes.s20 +
                                      (_visibleCommunities.length - 1) * 16,
                              height: theme.sizes.s20,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  for (int i = 0;
                                      i < _visibleCommunities.length;
                                      i++)
                                    Positioned(
                                      left:
                                          (_visibleCommunities.length - 1 - i) *
                                              16.0,
                                      child: LabContainer(
                                        decoration: BoxDecoration(
                                          borderRadius: theme.radius
                                              .asBorderRadius()
                                              .rad16,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  LabColorsData.dark().black33,
                                              blurRadius: 4,
                                              offset: const Offset(3, 0),
                                            ),
                                          ],
                                        ),
                                        child: LabProfilePic.s20(
                                          _visibleCommunities[i].author.value!,
                                          onTap: onTap,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
