import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabCrossButton extends StatelessWidget {
  const LabCrossButton({
    super.key,
    required this.size,
    this.onTap,
  });

  const LabCrossButton.s20({
    super.key,
    this.onTap,
  }) : size = LabCrossButtonSize.s20;

  const LabCrossButton.s24({
    super.key,
    this.onTap,
  }) : size = LabCrossButtonSize.s24;

  const LabCrossButton.s32({
    super.key,
    this.onTap,
  }) : size = LabCrossButtonSize.s32;

  final VoidCallback? onTap;
  final LabCrossButtonSize size;

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
          child: LabCrossButtonLayout(
            size: size,
          ),
        );
      },
    );
  }
}

enum LabCrossButtonSize {
  s20,
  s24,
  s32,
}

class LabCrossButtonLayout extends StatelessWidget {
  const LabCrossButtonLayout({
    super.key,
    required this.size,
  });

  final LabCrossButtonSize size;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    double buttonSize;
    LabIconSize iconSize;
    double outlineThickness;

    switch (size) {
      case LabCrossButtonSize.s20:
        buttonSize = theme.sizes.s20;
        iconSize = LabIconSize.s8;
        outlineThickness = LabLineThicknessData.normal().medium;
      case LabCrossButtonSize.s24:
        buttonSize = theme.sizes.s24;
        iconSize = LabIconSize.s8;
        outlineThickness = LabLineThicknessData.normal().medium;
      case LabCrossButtonSize.s32:
        buttonSize = theme.sizes.s32;
        iconSize = LabIconSize.s12;
        outlineThickness = LabLineThicknessData.normal().thick;
    }

    return LabContainer(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: theme.colors.white8,
        borderRadius: BorderRadius.circular(buttonSize / 2),
      ),
      child: Center(
        child: LabIcon(
          theme.icons.characters.cross,
          size: iconSize,
          outlineColor: theme.colors.white33,
          outlineThickness: outlineThickness,
        ),
      ),
    );
  }
}
