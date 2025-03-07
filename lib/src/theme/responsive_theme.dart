import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'theme.dart';

enum AppThemeColorMode {
  light,
  grey,
  dark,
}

enum AppTextScale {
  small,
  normal,
  large,
}

enum AppSystemScale {
  small,
  normal,
  large,
}

/// Updates automatically the [AppTheme] regarding the current [MediaQuery],
/// unless the color mode is overridden or set explicitly through the app settings.
class AppResponsiveTheme extends StatefulWidget {
  const AppResponsiveTheme({
    super.key,
    required this.child,
    this.colorMode,
    this.formFactor,
    this.textScale,
    this.systemScale,
  });

  final AppThemeColorMode? colorMode;
  final AppFormFactor? formFactor;
  final AppTextScale? textScale;
  final AppSystemScale? systemScale;
  final Widget child;

  static AppResponsiveThemeState of(BuildContext context) {
    return context.findAncestorStateOfType<AppResponsiveThemeState>()!;
  }

  static AppThemeColorMode colorModeOf(BuildContext context) {
    if (kIsWeb) {
      // For web, we'll use the system preference through MediaQuery
      final platformBrightness = MediaQuery.platformBrightnessOf(context);
      return platformBrightness == ui.Brightness.dark
          ? AppThemeColorMode.dark
          : AppThemeColorMode.light;
    }

    // For native platforms, use the existing logic
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

  static AppTextScale textScaleOf(BuildContext context) => AppTextScale.normal;

  @override
  State<AppResponsiveTheme> createState() => AppResponsiveThemeState();
}

class AppResponsiveThemeState extends State<AppResponsiveTheme> {
  AppThemeColorMode? _colorMode;
  AppTextScale? _textScale;
  AppSystemScale? _systemScale;

  AppThemeColorMode get colorMode =>
      _colorMode ?? widget.colorMode ?? AppResponsiveTheme.colorModeOf(context);

  AppTextScale get textScale =>
      _textScale ?? widget.textScale ?? AppResponsiveTheme.textScaleOf(context);

  AppSystemScale get systemScale {
    final scale = _systemScale ?? widget.systemScale ?? AppSystemScale.normal;
    print('Getting system scale: $scale'); // Debug print
    return scale;
  }

  void setColorMode(AppThemeColorMode? mode) {
    setState(() => _colorMode = mode);
  }

  void setTextScale(AppTextScale scale) {
    setState(() => _textScale = scale);
  }

  void setSystemScale(AppSystemScale scale) {
    print('Setting system scale to: $scale'); // Debug print
    setState(() => _systemScale = scale);
  }

  @override
  Widget build(BuildContext context) {
    var theme = AppThemeData.normal();

    // Get system scale based on selection
    final systemData = switch (systemScale) {
      AppSystemScale.small => AppSystemData.small(),
      AppSystemScale.large => AppSystemData.large(),
      AppSystemScale.normal => AppSystemData.normal(),
    };
    print('System data scale: ${systemData.scale}'); // Debug print

    // Apply typography based on text scale
    switch (textScale) {
      case AppTextScale.small:
        theme = theme.withTypography(AppTypographyData.small());
        break;
      case AppTextScale.large:
        theme = theme.withTypography(AppTypographyData.large());
        break;
      default:
        theme = theme.withTypography(AppTypographyData.normal());
    }

    // Apply system scale to UI elements
    theme = theme.withScale(systemData.scale);

    final colorMode = this.colorMode;
    theme = switch (colorMode) {
      AppThemeColorMode.dark => theme.withColors(AppColorsData.dark()),
      AppThemeColorMode.grey => theme.withColors(AppColorsData.grey()),
      AppThemeColorMode.light => theme.withColors(AppColorsData.light()),
    };

    var formFactor =
        widget.formFactor ?? AppResponsiveTheme.formFactorOf(context);
    theme = theme.withFormFactor(formFactor);

    return AppTheme(
      data: theme,
      child: widget.child,
    );
  }
}
