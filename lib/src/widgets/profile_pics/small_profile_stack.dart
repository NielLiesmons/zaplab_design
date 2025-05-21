import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppSmallProfileStack extends StatelessWidget {
  final List<Profile> profiles;
  final Profile? currentProfile;
  final VoidCallback onTap;
  AppSmallProfileStack({
    super.key,
    required this.profiles,
    this.currentProfile,
    VoidCallback? onTap,
  }) : onTap = onTap ?? (() {});

  List<Profile> get _visibleProfiles {
    final list = profiles.toList();
    if (currentProfile != null && list.contains(currentProfile)) {}
    return list.take(5).toList().reversed.toList();
  }

  String _getDisplayText() {
    if (profiles.isEmpty) return 'No Recipients';

    final isCurrentProfileFirst = currentProfile != null &&
        profiles.isNotEmpty &&
        profiles.first.pubkey == currentProfile!.pubkey;

    if (profiles.length == 1) {
      return isCurrentProfileFirst
          ? 'You'
          : profiles.first.name ?? formatNpub(profiles.first.npub);
    }

    if (profiles.length == 2) {
      final secondName = profiles[1].name ?? formatNpub(profiles[1].npub);
      return isCurrentProfileFirst
          ? 'You & $secondName'
          : '${profiles.first.name ?? formatNpub(profiles.first.npub)} & $secondName';
    }

    return isCurrentProfileFirst
        ? 'You & ${profiles.length - 1} others'
        : '${profiles.first.name ?? formatNpub(profiles.first.npub)} & ${profiles.length - 1} others';
  }

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
            width: 210,
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
                            theme.sizes.s8 + (_visibleProfiles.length - 1) * 16,
                            0),
                        child: AppContainer(
                          height: theme.sizes.s20,
                          padding: const AppEdgeInsets.only(
                            left: AppGapSize.s20,
                            right: AppGapSize.s12,
                          ),
                          child: Center(
                            child: AppText.reg12(
                              _getDisplayText(),
                              color: theme.colors.white66,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _visibleProfiles.isEmpty
                            ? 0
                            : theme.sizes.s20 +
                                (_visibleProfiles.length - 1) * 16,
                        height: theme.sizes.s20,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            for (int i = 0; i < _visibleProfiles.length; i++)
                              Positioned(
                                left: (_visibleProfiles.length - 1 - i) * 16.0,
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
                                    _visibleProfiles[i],
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
