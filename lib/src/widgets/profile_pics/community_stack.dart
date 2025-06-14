import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppCommunityStack extends StatelessWidget {
  final List<Community>? communities;
  final VoidCallback? onTap;
  const AppCommunityStack({
    super.key,
    this.communities,
    this.onTap,
  });

  List<Community> get _visibleCommunities =>
      communities?.take(5).toList().reversed.toList() ?? [];

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

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
                  child: AppContainer(
                    height: theme.sizes.s20,
                    padding: const AppEdgeInsets.symmetric(
                      horizontal: AppGapSize.s12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colors.white8,
                      borderRadius: theme.radius.asBorderRadius().rad16,
                    ),
                    child: Center(
                      child: AppText.reg12(
                        'No target found',
                        color: theme.colors.white33,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                )
              : AppContainer(
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
                              child: AppContainer(
                                height: theme.sizes.s20,
                                padding: const AppEdgeInsets.only(
                                  left: AppGapSize.s20,
                                  right: AppGapSize.s12,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colors.white16,
                                  borderRadius:
                                      theme.radius.asBorderRadius().rad16,
                                ),
                                child: Center(
                                  child: AppText.reg12(
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
                                      child: AppContainer(
                                        decoration: BoxDecoration(
                                          borderRadius: theme.radius
                                              .asBorderRadius()
                                              .rad16,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  AppColorsData.dark().black33,
                                              blurRadius: 4,
                                              offset: const Offset(3, 0),
                                            ),
                                          ],
                                        ),
                                        child: AppProfilePic.s20(
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
