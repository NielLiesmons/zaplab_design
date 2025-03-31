import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppCommunityStack extends StatelessWidget {
  AppCommunityStack({
    super.key,
    required this.communities,
    VoidCallback? onTap,
  }) : onTap = onTap ?? (() {});

  final List<Community> communities;
  final VoidCallback onTap;

  List<Community> get _visibleCommunities => communities.take(5).toList();

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
          child: AppContainer(
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
                            borderRadius: theme.radius.asBorderRadius().rad16,
                          ),
                          child: Center(
                            child: AppText.reg12(
                              communities.length == 1
                                  ? communities.first.name
                                  : '${communities.length} Communities',
                              color: theme.colors.white66,
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
                            for (int i = 0; i < _visibleCommunities.length; i++)
                              Positioned(
                                left: i * 16.0,
                                child: AppContainer(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        theme.radius.asBorderRadius().rad16,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColorsData.dark().black33,
                                        blurRadius: 4,
                                        offset: const Offset(3, 0),
                                      ),
                                    ],
                                  ),
                                  child: AppProfilePic.s20(
                                    _visibleCommunities[i]
                                        .author
                                        .value!
                                        .pictureUrl!,
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
