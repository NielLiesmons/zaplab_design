import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabSmallProfileStack extends StatelessWidget {
  final List<Profile> profiles;
  final Profile? activeProfile;
  final String? description;
  final VoidCallback onTap;
  LabSmallProfileStack({
    super.key,
    required this.profiles,
    this.activeProfile,
    this.description,
    VoidCallback? onTap,
  }) : onTap = onTap ?? (() {});

  List<Profile> get _visibleProfiles {
    final list = profiles.toList();
    if (activeProfile != null && list.contains(activeProfile)) {}
    return list.take(5).toList().reversed.toList();
  }

  String _getDisplayText() {
    if (description != null) return description!;
    if (profiles.isEmpty) return '0 Profiles';

    final isactiveProfileFirst = activeProfile != null &&
        profiles.isNotEmpty &&
        profiles.first.pubkey == activeProfile!.pubkey;

    if (profiles.length == 1) {
      return isactiveProfileFirst
          ? 'You'
          : profiles.first.name ?? formatNpub(profiles.first.npub);
    }

    if (profiles.length == 2) {
      final secondName = profiles[1].name ?? formatNpub(profiles[1].npub);
      return isactiveProfileFirst
          ? 'You & $secondName'
          : '${profiles.first.name ?? formatNpub(profiles.first.npub)} & $secondName';
    }

    return isactiveProfileFirst
        ? 'You & ${profiles.length - 1} others'
        : '${profiles.first.name ?? formatNpub(profiles.first.npub)} & ${profiles.length - 1} others';
  }

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
          child: LabContainer(
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
                        offset: profiles.isEmpty
                            ? Offset.zero
                            : Offset(
                                theme.sizes.s8 +
                                    (_visibleProfiles.length - 1) * 16,
                                0),
                        child: LabContainer(
                          height: theme.sizes.s20,
                          padding: LabEdgeInsets.only(
                            left: profiles.isEmpty
                                ? LabGapSize.s10
                                : LabGapSize.s20,
                            right: profiles.isEmpty
                                ? LabGapSize.s10
                                : LabGapSize.s12,
                          ),
                          decoration: BoxDecoration(
                            color: profiles.isEmpty
                                ? theme.colors.white8
                                : theme.colors.white16,
                            borderRadius: theme.radius.asBorderRadius().rad24,
                          ),
                          child: Center(
                            child: LabText.reg12(
                              _getDisplayText(),
                              color: profiles.isEmpty
                                  ? theme.colors.white33
                                  : theme.colors.white66,
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
                                child: LabContainer(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        theme.radius.asBorderRadius().rad16,
                                    boxShadow: [
                                      BoxShadow(
                                        color: LabColorsData.dark().black33,
                                        blurRadius: 4,
                                        offset: const Offset(3, 0),
                                      ),
                                    ],
                                  ),
                                  child: LabProfilePic.s20(
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
