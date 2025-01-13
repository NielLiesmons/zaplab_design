import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter/widgets.dart';

class AppCrossButton extends StatelessWidget {
  const AppCrossButton({
    super.key,
    required this.size,
    this.onTap,
  });

  const AppCrossButton.s20({
    super.key,
    this.onTap,
  }) : size = AppCrossButtonSize.s20;

  const AppCrossButton.s24({
    super.key,
    this.onTap,
  }) : size = AppCrossButtonSize.s24;

  const AppCrossButton.s32({
    super.key,
    this.onTap,
  }) : size = AppCrossButtonSize.s32;

  final VoidCallback? onTap;
  final AppCrossButtonSize size;

  @override
  Widget build(BuildContext context) {
    return TapBuilder(
      onTap: onTap,
      builder: (context, state, hasFocus) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.97;
        } else if (state == TapState.hover) {
          scaleFactor = 1.01;
        }

        return Transform.scale(
          scale: scaleFactor,
          child: AppCrossButtonLayout(
            size: size,
          ),
        );
      },
    );
  }
}

enum AppCrossButtonSize {
  s20,
  s24,
  s32,
}

class AppCrossButtonLayout extends StatelessWidget {
  const AppCrossButtonLayout({
    super.key,
    required this.size,
  });

  final AppCrossButtonSize size;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    double buttonSize;
    AppIconSize iconSize;
    double outlineThickness;

    switch (size) {
      case AppCrossButtonSize.s20:
        buttonSize = theme.sizes.s20;
        iconSize = AppIconSize.s8;
        outlineThickness = LineThicknessData.normal().medium;
      case AppCrossButtonSize.s24:
        buttonSize = theme.sizes.s24;
        iconSize = AppIconSize.s8;
        outlineThickness = LineThicknessData.normal().medium;
      case AppCrossButtonSize.s32:
        buttonSize = theme.sizes.s32;
        iconSize = AppIconSize.s12;
        outlineThickness = LineThicknessData.normal().thick;
    }

    return AppContainer(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: theme.colors.white8,
        borderRadius: BorderRadius.circular(buttonSize / 2),
      ),
      child: Center(
        child: AppIcon(
          theme.icons.characters.cross,
          size: iconSize,
          outlineColor: theme.colors.white33,
          outlineThickness: outlineThickness,
        ),
      ),
    );
  }
}
