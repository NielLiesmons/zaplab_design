import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabProfileStack extends StatelessWidget {
  LabProfileStack({
    super.key,
    required this.profiles,
    this.description,
    VoidCallback? onTap,
  }) : onTap = onTap ?? (() {});

  final List<Profile> profiles;
  final String? description;
  final VoidCallback onTap;

  List<Profile> get _visibleProfiles => profiles.take(3).toList();

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
                            theme.sizes.s16 +
                                (_visibleProfiles.length - 1) * 24,
                            0),
                        child: Row(
                          children: [
                            LabContainer(
                              height: theme.sizes.s32,
                              padding: const LabEdgeInsets.only(
                                left: LabGapSize.s24,
                                right: LabGapSize.s12,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colors.white16,
                                borderRadius:
                                    theme.radius.asBorderRadius().rad24,
                              ),
                              child: Center(
                                child: LabText.med12(
                                  '${profiles.length}',
                                  color: theme.colors.white66,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            if (description != null) ...[
                              const LabGap.s8(),
                              SizedBox(
                                width: 120,
                                child: LabText.reg10(
                                  description!,
                                  color: theme.colors.white33,
                                  maxLines: 2,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
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
                                  child: LabProfilePic.s32(
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
