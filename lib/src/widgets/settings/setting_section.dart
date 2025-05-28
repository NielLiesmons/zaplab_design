import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppSettingSection extends StatelessWidget {
  final Widget? icon;
  final String title;
  final String? description;
  final VoidCallback? onTap;
  final List<HostingStatus>? hostingStatuses;

  const AppSettingSection({
    super.key,
    this.icon,
    required this.title,
    this.description,
    this.onTap,
    this.hostingStatuses,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

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
                AppHostingIcon(
                  hostingStatuses: hostingStatuses,
                )
              else
                AppContainer(
                  width: theme.sizes.s48,
                  height: theme.sizes.s48,
                  decoration: BoxDecoration(
                    color: theme.colors.gray66,
                    borderRadius: theme.radius.asBorderRadius().rad12,
                  ),
                  child: Center(child: icon),
                ),
              const AppGap.s14(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title == 'Hosting') const AppGap.s6(),
                    AppText.med14(title),
                    const AppGap.s2(),
                    description != null
                        ? AppText.reg12(description!,
                            color: theme.colors.white66)
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              const AppGap.s12(),
              if (title == 'Hosting')
                Column(
                  children: [
                    const AppGap.s16(),
                    AppIcon.s16(
                      theme.icons.characters.chevronRight,
                      outlineThickness: AppLineThicknessData.normal().medium,
                      outlineColor: theme.colors.white33,
                    ),
                  ],
                )
              else
                AppIcon.s16(
                  theme.icons.characters.chevronRight,
                  outlineThickness: AppLineThicknessData.normal().medium,
                  outlineColor: theme.colors.white33,
                ),
              const AppGap.s12(),
            ],
          ),
        );
      },
    );
  }
}
