import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_svg/flutter_svg.dart';

import 'borders.dart';
import 'colors.dart';
import 'durations.dart';
import 'form_factor.dart';
import 'icons.dart';
import 'images.dart';
import 'line_thickness.dart';
import 'radius.dart';
import 'spacing.dart';
import 'typography.dart';

class AppThemeData extends Equatable {
  const AppThemeData({
    required this.borders,
    required this.colors,
    required this.durations,
    required this.formFactor,
    required this.radius,
    required this.spacing,
    required this.typography,
    TargetPlatform? platform,
  }) : _platform = platform;

  factory AppThemeData.normal() => AppThemeData(
        borders: AppBorderData.fromThickness(LineThicknessData.normal()),
        colors: AppColorsData.light(),
        durations: AppDurationsData.normal(),
        formFactor: AppFormFactor.small,
        radius: const AppRadiusData.normal(),
        spacing: AppSpacingData.normal(),
        typography: AppTypographyData.normal(),
      );

  final AppBorderData borders;
  final AppColorsData colors;
  final AppDurationsData durations;
  final AppFormFactor formFactor;
  final AppRadiusData radius;
  final AppSpacingData spacing;
  final AppTypographyData typography;
  final TargetPlatform? _platform;
  TargetPlatform get platform => defaultTargetPlatform;

  @override
  List<Object?> get props => [
        borders,
        colors,
        durations,
        radius,
        spacing,
        typography,
        platform,
      ];

  AppThemeData withColors(AppColorsData colors) {
    return AppThemeData(
      colors: colors,
      durations: durations,
      formFactor: formFactor,
      radius: radius,
      spacing: spacing,
      typography: typography,
      borders: borders,
      platform: platform,
    );
  }

  AppThemeData withFormFactor(AppFormFactor form_factor) {
    return AppThemeData(
      colors: colors,
      durations: durations,
      formFactor: formFactor,
      radius: radius,
      spacing: spacing,
      typography: typography,
      borders: borders,
      platform: platform,
    );
  }
}
