import 'package:zaplab_design/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

enum LabIconSize {
  s4,
  s8,
  s10,
  s12,
  s14,
  s16,
  s18,
  s20,
  s24,
  s28,
  s32,
  s38,
  s40,
  s48,
  s56,
  s64,
  s72,
  s80,
  s96,
}

extension LabIconSizeExtension on LabIconSizesData {
  double resolve(LabIconSize size) {
    switch (size) {
      case LabIconSize.s4:
        return s4;
      case LabIconSize.s8:
        return s8;
      case LabIconSize.s10:
        return s10;
      case LabIconSize.s12:
        return s12;
      case LabIconSize.s14:
        return s14;
      case LabIconSize.s16:
        return s16;
      case LabIconSize.s18:
        return s18;
      case LabIconSize.s20:
        return s20;
      case LabIconSize.s24:
        return s24;
      case LabIconSize.s28:
        return s28;
      case LabIconSize.s32:
        return s32;
      case LabIconSize.s38:
        return s38;
      case LabIconSize.s40:
        return s40;
      case LabIconSize.s48:
        return s48;
      case LabIconSize.s56:
        return s56;
      case LabIconSize.s64:
        return s64;
      case LabIconSize.s72:
        return s72;
      case LabIconSize.s80:
        return s80;

      case LabIconSize.s96:
        return s96;
    }
  }
}

/// Normal Icon
class LabIcon extends StatelessWidget {
  const LabIcon(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.size = LabIconSize.s16,
    this.outlineColor,
    this.outlineThickness = 0.0,
  });

  const LabIcon.s4(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s4;

  const LabIcon.s8(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s8;

  const LabIcon.s10(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s10;

  const LabIcon.s12(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s12;

  const LabIcon.s14(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s14;

  const LabIcon.s16(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s16;

  const LabIcon.s18(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s18;

  const LabIcon.s20(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s20;

  const LabIcon.s24(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s24;

  const LabIcon.s28(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s28;

  const LabIcon.s32(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s32;

  const LabIcon.s38(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s38;

  const LabIcon.s40(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s40;

  const LabIcon.s48(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s48;

  const LabIcon.s56(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s56;

  const LabIcon.s64(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s64;

  const LabIcon.s72(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s72;

  const LabIcon.s80(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s80;

  const LabIcon.s96(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : size = LabIconSize.s96;

  final String data;
  final Color? color;
  final Gradient? gradient;
  final LabIconSize size;
  final Color? outlineColor;
  final double outlineThickness;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final resolvedSize = theme.icons.sizes.resolve(size);

    return Stack(
      children: [
        // Outline layer
        if (outlineColor != null && outlineThickness > 0)
          Text(
            data,
            style: TextStyle(
              fontFamily: theme.icons.fontFamily,
              package: theme.icons.fontPackage,
              fontSize: resolvedSize,
              decoration: TextDecoration.none,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = outlineThickness
                ..color = outlineColor!
                ..strokeCap = StrokeCap.round
                ..strokeJoin = StrokeJoin.round,
            ),
          ),
        // Fill layer with gradient or color
        Text(
          data,
          style: TextStyle(
            fontFamily: theme.icons.fontFamily,
            package: theme.icons.fontPackage,
            fontSize: resolvedSize,
            decoration: TextDecoration.none,
            foreground: gradient != null
                ? (Paint()
                  ..shader = gradient!.createShader(
                    Rect.fromLTWH(0, 0, resolvedSize, resolvedSize),
                  ))
                : null,
            color: gradient == null ? color ?? const Color(0x00000000) : null,
          ),
        ),
      ],
    );
  }
}

/// Animated Icon
class LabAnimatedIcon extends StatelessWidget {
  const LabAnimatedIcon(
    this.data, {
    super.key,
    this.color,
    this.size = LabIconSize.s16,
    this.outlineColor,
    this.outlineThickness = 0.0,
    this.duration = const Duration(milliseconds: 200),
  });

  final String data;
  final Color? color;
  final LabIconSize size;
  final Color? outlineColor;
  final double outlineThickness;
  final Duration duration;

  bool get isAnimated => duration.inMilliseconds > 0;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final resolvedSize = theme.icons.sizes.resolve(size);

    if (!isAnimated) {
      return LabIcon(
        data,
        key: key,
        color: color,
        size: size,
        outlineColor: outlineColor,
        outlineThickness: outlineThickness,
      );
    }

    return AnimatedDefaultTextStyle(
      duration: duration,
      style: TextStyle(
        fontFamily: theme.icons.fontFamily,
        package: theme.icons.fontPackage,
        fontSize: resolvedSize,
        color: const Color(0x00000000), // Color will be handled in the layers
        decoration: TextDecoration.none,
      ),
      child: Stack(
        children: [
          // Animated Outline Layer
          if (outlineColor != null && outlineThickness > 0)
            AnimatedDefaultTextStyle(
              duration: duration,
              style: TextStyle(
                fontFamily: theme.icons.fontFamily,
                package: theme.icons.fontPackage,
                fontSize: resolvedSize,
                decoration: TextDecoration.none,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = outlineThickness
                  ..color = outlineColor!
                  ..strokeCap = StrokeCap.round
                  ..strokeJoin = StrokeJoin.round,
              ),
              child: Text(data),
            ),
          // Animated Fill Layer
          AnimatedDefaultTextStyle(
            duration: duration,
            style: TextStyle(
              fontFamily: theme.icons.fontFamily,
              package: theme.icons.fontPackage,
              fontSize: resolvedSize,
              color: color ?? const Color(0x00000000),
              decoration: TextDecoration.none,
            ),
            child: Text(data),
          ),
        ],
      ),
    );
  }
}
