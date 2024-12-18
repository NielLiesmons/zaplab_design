import 'package:zaplab_design/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

enum AppIconSize {
  s4,
  s8,
  s12,
  s16,
  s20,
  s24,
  s28,
  s32,
}

extension AppIconSizeExtension on AppIconSizesData {
  double resolve(AppIconSize size) {
    switch (size) {
      case AppIconSize.s4:
        return s4;
      case AppIconSize.s8:
        return s8;
      case AppIconSize.s12:
        return s12;
      case AppIconSize.s16:
        return s16;
      case AppIconSize.s20:
        return s20;
      case AppIconSize.s24:
        return s24;
      case AppIconSize.s28:
        return s28;
      case AppIconSize.s32:
        return s32;
    }
  }
}

/// Normal Icon
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.data, {
    Key? key,
    this.color,
    this.gradient,
    this.size = AppIconSize.s16,
    this.outlineColor,
    this.outlineThickness = 0.0,
  }) : super(key: key);

  const AppIcon.s4(
    this.data, {
    Key? key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  })  : size = AppIconSize.s4,
        super(key: key);

  const AppIcon.s8(
    this.data, {
    Key? key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  })  : size = AppIconSize.s8,
        super(key: key);

  const AppIcon.s12(
    this.data, {
    Key? key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  })  : size = AppIconSize.s12,
        super(key: key);

  const AppIcon.s16(
    this.data, {
    Key? key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  })  : size = AppIconSize.s16,
        super(key: key);

  const AppIcon.s20(
    this.data, {
    Key? key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  })  : size = AppIconSize.s20,
        super(key: key);

  const AppIcon.s24(
    this.data, {
    Key? key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  })  : size = AppIconSize.s24,
        super(key: key);

  const AppIcon.s28(
    this.data, {
    Key? key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  })  : size = AppIconSize.s28,
        super(key: key);

  const AppIcon.s32(
    this.data, {
    Key? key,
    this.color,
    this.gradient,
    this.outlineColor,
    this.outlineThickness = 0.0,
  })  : size = AppIconSize.s32,
        super(key: key);

  final String data;
  final Color? color;
  final Gradient? gradient;
  final AppIconSize size;
  final Color? outlineColor;
  final double outlineThickness;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
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
            color: gradient == null ? color ?? Color(0x00000000) : null,
          ),
        ),
      ],
    );
  }
}

/// Animated Icon
class AppAnimatedIcon extends StatelessWidget {
  const AppAnimatedIcon(
    this.data, {
    Key? key,
    this.color,
    this.size = AppIconSize.s16,
    this.outlineColor,
    this.outlineThickness = 0.0,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  final String data;
  final Color? color;
  final AppIconSize size;
  final Color? outlineColor;
  final double outlineThickness;
  final Duration duration;

  bool get isAnimated => duration.inMilliseconds > 0;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final resolvedSize = theme.icons.sizes.resolve(size);

    if (!isAnimated) {
      return AppIcon(
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
        color: Color(0x00000000), // Color will be handled in the layers
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
              color: color ?? Color(0x00000000),
              decoration: TextDecoration.none,
            ),
            child: Text(data),
          ),
        ],
      ),
    );
  }
}
