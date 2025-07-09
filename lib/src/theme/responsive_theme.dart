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

  static LabFormFactor formFactorOf(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (mediaQuery.size.width < 440) {
      return LabFormFactor.small;
    } else if (mediaQuery.size.width >= 440 && mediaQuery.size.width < 880) {
      return LabFormFactor.medium;
    } else {
      return LabFormFactor.big;
    }
  }

  static LabTextScale textScaleOf(BuildContext context) => LabTextScale.normal;

  @override
  State<LabResponsiveTheme> createState() => LabResponsiveThemeState();
}

class LabResponsiveThemeState extends State<LabResponsiveTheme> {
  LabThemeColorMode? _colorMode;
  LabTextScale? _textScale;
  LabSystemScale? _systemScale;

  LabThemeColorMode get colorMode =>
      _colorMode ?? widget.colorMode ?? LabResponsiveTheme.colorModeOf(context);

  LabTextScale get textScale =>
      _textScale ?? widget.textScale ?? LabResponsiveTheme.textScaleOf(context);

  LabSystemScale get systemScale {
    final scale = _systemScale ?? widget.systemScale ?? LabSystemScale.normal;
    return scale;
  }

  void setColorMode(LabThemeColorMode? mode) {
    setState(() => _colorMode = mode);
  }

  void setTextScale(LabTextScale scale) {
    setState(() => _textScale = scale);
  }

  void setSystemScale(LabSystemScale scale) {
    setState(() => _systemScale = scale);
  }

  @override
  Widget build(BuildContext context) {
    var theme = LabThemeData.normal();

    // Get system scale based on selection
    final systemData = switch (systemScale) {
      LabSystemScale.small => LabSystemData.small(),
      LabSystemScale.large => LabSystemData.large(),
      LabSystemScale.normal => LabSystemData.normal(),
    };

    // Apply typography based on text scale
    switch (textScale) {
      case LabTextScale.small:
        theme = theme.withTypography(LabTypographyData.small());
        break;
      case LabTextScale.large:
        theme = theme.withTypography(LabTypographyData.large());
        break;
      default:
        theme = theme.withTypography(LabTypographyData.normal());
    }

    // Apply system scale to UI elements
    theme = theme.withScale(systemData.scale);

    final colorMode = this.colorMode;
    theme = switch (colorMode) {
      LabThemeColorMode.dark =>
        theme.withColors(LabColorsData.dark(widget.colorsOverride)),
      LabThemeColorMode.gray =>
        theme.withColors(LabColorsData.gray(widget.colorsOverride)),
      LabThemeColorMode.light =>
        theme.withColors(LabColorsData.light(widget.colorsOverride)),
    };

    var formFactor =
        widget.formFactor ?? LabResponsiveTheme.formFactorOf(context);
    theme = theme.withFormFactor(formFactor);

    return LabTheme(
      data: theme,
      child: widget.child,
    );
  }
}
