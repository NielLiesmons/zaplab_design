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

class AppThemeData extends Equatable {
  const AppThemeData({
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

  factory AppThemeData.normal() => AppThemeData(
        borders: AppBorderData.fromThickness(LineThicknessData.normal()),
        colors: AppColorsData.light(),
        durations: AppDurationsData.normal(),
        formFactor: AppFormFactor.small,
        icons: AppIconsData.normal(),
        radius: const AppRadiusData.normal(),
        sizes: AppSizesData.normal(),
        typography: AppTypographyData.normal(),
        system: AppSystemData.normal(),
      );

  final AppBorderData borders;
  final AppColorsData colors;
  final AppDurationsData durations;
  final AppFormFactor formFactor;
  final AppIconsData icons;
  final AppRadiusData radius;
  final AppSizesData sizes;
  final AppTypographyData typography;
  final AppSystemData system;
  final TargetPlatform? _platform;
  TargetPlatform get platform => defaultTargetPlatform;

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

  AppThemeData withColors(AppColorsData colors) {
    return AppThemeData(
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

  AppThemeData withFormFactor(AppFormFactor formFactor) {
    return AppThemeData(
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

  AppThemeData copyWith({
    AppColorsData? colors,
    AppTypographyData? typography,
    AppFormFactor? formFactor,
  }) {
    return AppThemeData(
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

  AppThemeData withScale(double scale) {
    return AppThemeData(
      borders: borders,
      colors: colors,
      durations: durations,
      formFactor: formFactor,
      icons: icons,
      radius: radius,
      sizes: sizes,
      typography: typography,
      system: AppSystemData(scale: scale),
      platform: platform,
    );
  }

  AppThemeData withTypography(AppTypographyData typography) {
    return AppThemeData(
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
