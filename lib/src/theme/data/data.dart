import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'borders.dart';
import 'colors.dart';
import 'durations.dart';
import 'form_factor.dart';
import 'icons.dart';
import 'line_thickness.dart';
import 'radius.dart';
import 'sizes.dart';
import 'typography.dart';
import 'system_data.dart';

class LabThemeData extends Equatable {
  const LabThemeData({
    required this.borders,
    required this.colors,
    required this.durations,
    required this.formFactor,
    required this.icons,
    required this.radius,
    required this.sizes,
    required this.typography,
    required this.system,
    TargetPlatform? platform,
  }) : _platform = platform;

  factory LabThemeData.normal() => LabThemeData(
        borders: LabBorderData.fromThickness(LabLineThicknessData.normal()),
        colors: LabColorsData.light(),
        durations: LabDurationsData.normal(),
        formFactor: LabFormFactor.small,
        icons: LabIconsData.normal(),
        radius: const LabRadiusData.normal(),
        sizes: LabSizesData.normal(),
        typography: LabTypographyData.normal(),
        system: LabSystemData.normal(),
      );

  final LabBorderData borders;
  final LabColorsData colors;
  final LabDurationsData durations;
  final LabFormFactor formFactor;
  final LabIconsData icons;
  final LabRadiusData radius;
  final LabSizesData sizes;
  final LabTypographyData typography;
  final LabSystemData system;
  final TargetPlatform? _platform;
  TargetPlatform get platform => _platform ?? defaultTargetPlatform;

  @override
  List<Object?> get props => [
        borders,
        colors,
        durations,
        formFactor,
        icons,
        radius,
        sizes,
        typography,
        platform,
      ];

  LabThemeData withColors(LabColorsData colors) {
    return LabThemeData(
      borders: borders,
      colors: colors,
      durations: durations,
      formFactor: formFactor,
      icons: icons,
      radius: radius,
      sizes: sizes,
      typography: typography,
      system: system,
      platform: platform,
    );
  }

  LabThemeData withFormFactor(LabFormFactor formFactor) {
    return LabThemeData(
      borders: borders,
      colors: colors,
      durations: durations,
      formFactor: formFactor,
      icons: icons,
      radius: radius,
      sizes: sizes,
      typography: typography,
      system: system,
      platform: platform,
    );
  }

  LabThemeData copyWith({
    LabColorsData? colors,
    LabTypographyData? typography,
    LabFormFactor? formFactor,
  }) {
    return LabThemeData(
      borders: borders,
      colors: colors ?? this.colors,
      durations: durations,
      formFactor: formFactor ?? this.formFactor,
      icons: icons,
      radius: radius,
      sizes: sizes,
      typography: typography ?? this.typography,
      system: system,
      platform: platform,
    );
  }

  LabThemeData withScale(double scale) {
    return LabThemeData(
      borders: borders,
      colors: colors,
      durations: durations,
      formFactor: formFactor,
      icons: icons,
      radius: radius,
      sizes: sizes,
      typography: typography,
      system: LabSystemData(scale: scale),
      platform: platform,
    );
  }

  LabThemeData withTypography(LabTypographyData typography) {
    return LabThemeData(
      borders: borders,
      colors: colors,
      durations: durations,
      formFactor: formFactor,
      icons: icons,
      radius: radius,
      sizes: sizes,
      typography: typography,
      system: system,
      platform: platform,
    );
  }
}
