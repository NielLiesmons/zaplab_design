import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabSettingSection extends StatelessWidget {
  final Widget? icon;
  final String title;
  final String? description;
  final VoidCallback? onTap;
  final List<HostingStatus>? hostingStatuses;

  const LabSettingSection({
    super.key,
    this.icon,
    required this.title,
    this.description,
    this.onTap,
    this.hostingStatuses,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return TapBuilder(
      onTap: onTap,
      builder: (context, state, hasFocus) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.99;
        }

        return Transform.scale(
          scale: scaleFactor,
          child: Row(
            crossAxisAlignment: title == 'Hosting'
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              if (title == 'Hosting' && hostingStatuses != null)
                LabHostingIcon(
                  hostingStatuses: hostingStatuses,
                )
              else
                LabContainer(
                  width: theme.sizes.s48,
                  height: theme.sizes.s48,
                  decoration: BoxDecoration(
                    color: theme.colors.gray66,
                    borderRadius: theme.radius.asBorderRadius().rad12,
                  ),
                  child: Center(child: icon),
                ),
              const LabGap.s14(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title == 'Hosting') const LabGap.s6(),
                    LabText.med14(title),
                    const LabGap.s2(),
                    description != null
                        ? LabText.reg12(description!,
                            color: theme.colors.white66)
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              const LabGap.s12(),
              if (title == 'Hosting')
                Column(
                  children: [
                    const LabGap.s16(),
                    LabIcon.s16(
                      theme.icons.characters.chevronRight,
                      outlineThickness: LabLineThicknessData.normal().medium,
                      outlineColor: theme.colors.white33,
                    ),
                  ],
                )
              else
                LabIcon.s16(
                  theme.icons.characters.chevronRight,
                  outlineThickness: LabLineThicknessData.normal().medium,
                  outlineColor: theme.colors.white33,
                ),
              const LabGap.s12(),
            ],
          ),
        );
      },
    );
  }
}
