import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppProfileStack extends StatelessWidget {
  AppProfileStack({
    super.key,
    required this.profiles,
    VoidCallback? onTap,
  }) : onTap = onTap ?? (() {});

  final List<Profile> profiles;
  final VoidCallback onTap;

  List<Profile> get _visibleProfiles => profiles.take(3).toList();

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
            width: 148,
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
                            theme.sizes.s16 +
                                (_visibleProfiles.length - 1) * 24,
                            0),
                        child: AppContainer(
                          height: theme.sizes.s32,
                          padding: const AppEdgeInsets.only(
                            left: AppGapSize.s24,
                            right: AppGapSize.s12,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colors.white16,
                            borderRadius: theme.radius.asBorderRadius().rad24,
                          ),
                          child: Center(
                            child: AppText.med12(
                              '${profiles.length}',
                              color: theme.colors.white66,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _visibleProfiles.isEmpty
                            ? 0
                            : theme.sizes.s32 +
                                (_visibleProfiles.length - 1) * 24,
                        height: theme.sizes.s32,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            for (int i = _visibleProfiles.length - 1;
                                i >= 0;
                                i--)
                              Positioned(
                                left: i * 24.0,
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
                                  child: AppProfilePic.s32(
                                    _visibleProfiles[i].profilePicUrl,
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
