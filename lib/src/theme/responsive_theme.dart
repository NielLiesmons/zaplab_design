import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'theme.dart';

enum LabThemeColorMode {
  light,
  gray,
  dark,
}

enum LabTextScale {
  small,
  normal,
  large,
}

enum LabSystemScale {
  small,
  normal,
  large,
}

/// Updates automatically the [LabTheme] regarding the current [MediaQuery],
/// unless the color mode is overridden or set explicitly through the app settings.
class LabResponsiveTheme extends StatefulWidget {
  const LabResponsiveTheme({
    super.key,
    required this.child,
    this.colorMode,
    this.formFactor,
    this.textScale,
    this.systemScale,
    this.colorsOverride,
  });

  final LabThemeColorMode? colorMode;
  final LabFormFactor? formFactor;
  final LabTextScale? textScale;
  final LabSystemScale? systemScale;
  final Widget child;
  final LabColorsOverride? colorsOverride;

  static LabResponsiveThemeState of(BuildContext context) {
    return context.findAncestorStateOfType<LabResponsiveThemeState>()!;
  }

  static LabThemeColorMode colorModeOf(BuildContext context) {
    if (kIsWeb) {
      // For web, we'll use the system preference through MediaQuery
      final platformBrightness = MediaQuery.platformBrightnessOf(context);
      return platformBrightness == ui.Brightness.dark
          ? LabThemeColorMode.dark
          : LabThemeColorMode.light;
    }

    // For native platforms, use the existing logic
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final highContrast = MediaQuery.highContrastOf(context);
    if (platformBrightness == ui.Brightness.dark || highContrast) {
      return LabThemeColorMode.dark;
    }
    return LabThemeColorMode.light;
  }

  static LabTextScale textScaleOf(BuildContext context) => LabTextScale.normal;

  @override
  State<LabResponsiveTheme> createState() => LabResponsiveThemeState();
}

class LabResponsiveThemeState extends State<LabResponsiveTheme> {
  LabThemeColorMode? _colorMode;
  LabTextScale? _textScale;
  LabSystemScale? _systemScale;

  // Cache theme data to avoid recreating on every build
  LabThemeData? _cachedThemeData;
  LabThemeColorMode? _lastColorMode;
  LabTextScale? _lastTextScale;
  LabSystemScale? _lastSystemScale;
  LabColorsOverride? _lastColorsOverride;

  // Cache MediaQuery values to avoid calls on every build (Material-style caching)
  ui.Brightness? _lastPlatformBrightness;
  bool? _lastHighContrast;

  LabThemeColorMode get colorMode =>
      _colorMode ?? widget.colorMode ?? LabResponsiveTheme.colorModeOf(context);

  LabTextScale get textScale =>
      _textScale ?? widget.textScale ?? LabResponsiveTheme.textScaleOf(context);

  LabSystemScale get systemScale {
    final scale = _systemScale ?? widget.systemScale ?? LabSystemScale.normal;
    return scale;
  }

  void setColorMode(LabThemeColorMode? mode) {
    if (_colorMode != mode) {
      setState(() => _colorMode = mode);
    }
  }

  void setTextScale(LabTextScale scale) {
    if (_textScale != scale) {
      setState(() => _textScale = scale);
    }
  }

  void setSystemScale(LabSystemScale scale) {
    if (_systemScale != scale) {
      setState(() => _systemScale = scale);
    }
  }

  // Efficient theme data creation with caching
  LabThemeData _createThemeData() {
    final currentColorMode = colorMode;
    final currentTextScale = textScale;
    final currentSystemScale = systemScale;
    final currentColorsOverride = widget.colorsOverride;

    // Check if we can reuse cached theme data
    if (_cachedThemeData != null &&
        _lastColorMode == currentColorMode &&
        _lastTextScale == currentTextScale &&
        _lastSystemScale == currentSystemScale &&
        _lastColorsOverride == currentColorsOverride) {
      return _cachedThemeData!;
    }

    // Create new theme data
    var theme = LabThemeData.normal();

    // Apply typography based on text scale
    switch (currentTextScale) {
      case LabTextScale.small:
        theme = theme.withTypography(LabTypographyData.small());
        break;
      case LabTextScale.large:
        theme = theme.withTypography(LabTypographyData.large());
        break;
      default:
        theme = theme.withTypography(LabTypographyData.normal());
    }

    // Apply colors
    theme = switch (currentColorMode) {
      LabThemeColorMode.dark =>
        theme.withColors(LabColorsData.dark(currentColorsOverride)),
      LabThemeColorMode.gray =>
        theme.withColors(LabColorsData.gray(currentColorsOverride)),
      LabThemeColorMode.light =>
        theme.withColors(LabColorsData.light(currentColorsOverride)),
    };

    // Cache the theme data and current values
    _cachedThemeData = theme;
    _lastColorMode = currentColorMode;
    _lastTextScale = currentTextScale;
    _lastSystemScale = currentSystemScale;
    _lastColorsOverride = currentColorsOverride;

    return theme;
  }

  @override
  Widget build(BuildContext context) {
    final currentPlatformBrightness = MediaQuery.platformBrightnessOf(context);
    final currentHighContrast = MediaQuery.highContrastOf(context);

    // Check if we need to invalidate theme cache due to system changes
    if (currentPlatformBrightness != _lastPlatformBrightness ||
        currentHighContrast != _lastHighContrast) {
      _lastPlatformBrightness = currentPlatformBrightness;
      _lastHighContrast = currentHighContrast;
      // Invalidate theme cache when system preferences change
      _cachedThemeData = null;
    }

    final theme = _createThemeData();

    if (widget.formFactor != null) {
      return LabTheme(
        data: theme.withFormFactor(widget.formFactor!),
        child: widget.child,
      );
    }

    // Use default form factor instead of trying to calculate from MediaQuery
    final finalTheme = theme.withFormFactor(LabFormFactor.medium);

    return LabTheme(
      data: finalTheme,
      child: widget.child,
    );
  }
}
