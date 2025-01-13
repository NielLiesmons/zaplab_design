import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'theme.dart';

enum AppThemeColorMode {
  light,
  grey,
  dark,
}

/// Updates automatically the [AppTheme] regarding the current [MediaQuery],
/// unless the color mode is overridden or set explicitly through the app settings.
class AppResponsiveTheme extends StatefulWidget {
  const AppResponsiveTheme({
    super.key,
    required this.child,
    this.colorMode,
    this.formFactor,
  });

  final AppThemeColorMode? colorMode;
  final AppFormFactor? formFactor;
  final Widget child;

  static _AppResponsiveThemeState of(BuildContext context) {
    return context.findAncestorStateOfType<_AppResponsiveThemeState>()!;
  }

  static AppThemeColorMode colorModeOf(BuildContext context) {
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final highContrast = MediaQuery.highContrastOf(context);
    if (platformBrightness == ui.Brightness.dark || highContrast) {
      return AppThemeColorMode.dark;
    }
    return AppThemeColorMode.light;
  }

  static AppFormFactor formFactorOf(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (mediaQuery.size.width < 440) {
      return AppFormFactor.small;
    } else if (mediaQuery.size.width >= 440 && mediaQuery.size.width < 880) {
      return AppFormFactor.medium;
    } else {
      return AppFormFactor.big;
    }
  }

  static double scaleOf(BuildContext context) {
    return 1.15;
  }

  @override
  State<AppResponsiveTheme> createState() => _AppResponsiveThemeState();
}

class _AppResponsiveThemeState extends State<AppResponsiveTheme> {
  AppThemeColorMode? _colorMode;

  AppThemeColorMode get colorMode =>
      _colorMode ?? widget.colorMode ?? AppResponsiveTheme.colorModeOf(context);

  void setColorMode(AppThemeColorMode? mode) {
    setState(() => _colorMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    var theme = AppThemeData.normal();
    final scale = AppResponsiveTheme.scaleOf(context);
    theme = theme.withScale(scale);

    final colorMode = this.colorMode;
    switch (colorMode) {
      case AppThemeColorMode.dark:
        theme = theme.withColors(AppColorsData.dark());
        break;
      case AppThemeColorMode.grey:
        theme = theme.withColors(AppColorsData.grey());
        break;
      case AppThemeColorMode.light:
      default:
        theme = theme.withColors(AppColorsData.light());
        break;
    }

    var formFactor =
        widget.formFactor ?? AppResponsiveTheme.formFactorOf(context);
    theme = theme.withFormFactor(formFactor);

    return AppTheme(
      data: theme,
      child: widget.child,
    );
  }
}
