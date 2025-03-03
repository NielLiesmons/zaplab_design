import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppSettingSection extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? description;
  final VoidCallback? onTap;

  const AppSettingSection({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.onTap,
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
            children: [
              AppContainer(
                width: theme.sizes.s48,
                height: theme.sizes.s48,
                decoration: BoxDecoration(
                  color: theme.colors.grey66,
                  borderRadius: theme.radius.asBorderRadius().rad16,
                ),
                child: Center(child: icon),
              ),
              const AppGap.s12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText.med14(title),
                    description != null
                        ? AppText.reg12(description!,
                            color: theme.colors.white66)
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              const AppGap.s12(),
              AppIcon.s16(
                theme.icons.characters.chevronRight,
                outlineThickness: LineThicknessData.normal().medium,
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
