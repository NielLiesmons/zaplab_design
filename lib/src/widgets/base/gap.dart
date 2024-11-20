import 'package:zapchat_design/src/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

enum AppGapSize {
  none,
  s2,
  s4,
  s6,
  s8,
  s12,
  s16,
  s20,
  s24,
  s32,
  s38,
  s40,
  s48,
  s56,
  s64,
  s72,
  s80,
}

extension AppGapSizeExtension on AppGapSize {
  double getSizes(AppThemeData theme) {
    switch (this) {
      case AppGapSize.none:
        return 0;
      case AppGapSize.s2:
        return theme.sizes.s2;
      case AppGapSize.s4:
        return theme.sizes.s4;
      case AppGapSize.s6:
        return theme.sizes.s6;
      case AppGapSize.s8:
        return theme.sizes.s8;
      case AppGapSize.s12:
        return theme.sizes.s12;
      case AppGapSize.s16:
        return theme.sizes.s16;
      case AppGapSize.s20:
        return theme.sizes.s20;
      case AppGapSize.s24:
        return theme.sizes.s24;
      case AppGapSize.s32:
        return theme.sizes.s32;
      case AppGapSize.s38:
        return theme.sizes.s38;
      case AppGapSize.s40:
        return theme.sizes.s40;
      case AppGapSize.s48:
        return theme.sizes.s48;
      case AppGapSize.s56:
        return theme.sizes.s56;
      case AppGapSize.s64:
        return theme.sizes.s64;
      case AppGapSize.s72:
        return theme.sizes.s72;
      case AppGapSize.s80:
        return theme.sizes.s80;
    }
  }
}

class AppGap extends StatelessWidget {
  const AppGap(
    this.size, {
    super.key,
  });

  const AppGap.s2({
    super.key,
  }) : size = AppGapSize.s2;

  const AppGap.s4({
    super.key,
  }) : size = AppGapSize.s4;

  const AppGap.s6({
    super.key,
  }) : size = AppGapSize.s6;

  const AppGap.s8({
    super.key,
  }) : size = AppGapSize.s8;

  const AppGap.s12({
    super.key,
  }) : size = AppGapSize.s12;

  const AppGap.s16({
    super.key,
  }) : size = AppGapSize.s16;

  const AppGap.s20({
    super.key,
  }) : size = AppGapSize.s20;

  const AppGap.s24({
    super.key,
  }) : size = AppGapSize.s24;

  const AppGap.s32({
    super.key,
  }) : size = AppGapSize.s32;

  const AppGap.s38({
    super.key,
  }) : size = AppGapSize.s38;

  const AppGap.s40({
    super.key,
  }) : size = AppGapSize.s40;

  const AppGap.s48({
    super.key,
  }) : size = AppGapSize.s48;

  const AppGap.s56({
    super.key,
  }) : size = AppGapSize.s56;

  const AppGap.s64({
    super.key,
  }) : size = AppGapSize.s64;

  const AppGap.s72({
    super.key,
  }) : size = AppGapSize.s72;

  const AppGap.s80({
    super.key,
  }) : size = AppGapSize.s80;

  final AppGapSize size;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Gap(size.getSizes(theme));
  }
}
