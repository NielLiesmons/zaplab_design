import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_svg/flutter_svg.dart';

import 'colors.dart';
import 'durations.dart';
import 'form_factor.dart';
import 'icons.dart';
import 'radius.dart';
import 'images.dart';
import 'spacing.dart';
import 'typography.dart';

class AppThemeData extends Equatable {
  const AppThemeData({
    required this.colors,
    required this.typography,
    required this.radius,
    required this.spacing,
    required this.durations,
    required this.formFactor,
    TargetPlatform? platform,
  }) : _platform = platform;

  factory AppThemeData.normal({
  }) =>
      AppThemeData(
        formFactor: AppFormFactor.medium,
        typography: AppTypographyData.normal(),
        colors: AppColorsData.dark(),
        radius: const AppRadiusData.normal(),
        spacing: AppSpacingData.normal(),
        durations: AppDurationsData.normal(),
      );

//   final AppIconsData icons;
  final AppColorsData colors;
  final AppTypographyData typography;
  final AppRadiusData radius;
  final AppSpacingData spacing;
  final AppDurationsData durations;
  final AppFormFactor formFactor;
  final TargetPlatform? _platform;
  TargetPlatform get platform => defaultTargetPlatform;

  @override
  List<Object?> get props => [
        platform,
        colors,
        typography,
        radius,
        spacing,
        durations,
      ];

  AppThemeData withColors(AppColorsData colors) {
    return AppThemeData(
      platform: platform,
      formFactor: formFactor,
      colors: colors,
      durations: durations,
      radius: radius,
      spacing: spacing,
      typography: typography,
    );
  }

  AppThemeData withFormFactor(AppFormFactor formFactor) {
    return AppThemeData(
      platform: platform,
      formFactor: formFactor,
      colors: colors,
      durations: durations,
      radius: radius,
      spacing: spacing,
      typography: typography,
    );
  }

  AppThemeData withTypography(AppTypographyData typography) {
    return AppThemeData(
      platform: platform,
      formFactor: formFactor,
      colors: colors,
      durations: durations,
      radius: radius,
      spacing: spacing,
      typography: typography,
    );
  }
}
