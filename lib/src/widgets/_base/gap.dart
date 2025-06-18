import 'package:zaplab_design/src/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

enum LabGapSize {
  none,
  s2,
  s4,
  s6,
  s8,
  s10,
  s12,
  s14,
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

extension LabGapSizeExtension on LabGapSize {
  double getSizes(LabThemeData theme) {
    switch (this) {
      case LabGapSize.none:
        return 0;
      case LabGapSize.s2:
        return theme.sizes.s2;
      case LabGapSize.s4:
        return theme.sizes.s4;
      case LabGapSize.s6:
        return theme.sizes.s6;
      case LabGapSize.s8:
        return theme.sizes.s8;
      case LabGapSize.s10:
        return theme.sizes.s10;
      case LabGapSize.s12:
        return theme.sizes.s12;
      case LabGapSize.s14:
        return theme.sizes.s14;
      case LabGapSize.s16:
        return theme.sizes.s16;
      case LabGapSize.s20:
        return theme.sizes.s20;
      case LabGapSize.s24:
        return theme.sizes.s24;
      case LabGapSize.s32:
        return theme.sizes.s32;
      case LabGapSize.s38:
        return theme.sizes.s38;
      case LabGapSize.s40:
        return theme.sizes.s40;
      case LabGapSize.s48:
        return theme.sizes.s48;
      case LabGapSize.s56:
        return theme.sizes.s56;
      case LabGapSize.s64:
        return theme.sizes.s64;
      case LabGapSize.s72:
        return theme.sizes.s72;
      case LabGapSize.s80:
        return theme.sizes.s80;
    }
  }
}

class LabGap extends StatelessWidget {
  const LabGap(
    this.size, {
    super.key,
  });

  const LabGap.s2({
    super.key,
  }) : size = LabGapSize.s2;

  const LabGap.s4({
    super.key,
  }) : size = LabGapSize.s4;

  const LabGap.s6({
    super.key,
  }) : size = LabGapSize.s6;

  const LabGap.s8({
    super.key,
  }) : size = LabGapSize.s8;

  const LabGap.s10({
    super.key,
  }) : size = LabGapSize.s10;

  const LabGap.s12({
    super.key,
  }) : size = LabGapSize.s12;

  const LabGap.s14({
    super.key,
  }) : size = LabGapSize.s14;

  const LabGap.s16({
    super.key,
  }) : size = LabGapSize.s16;

  const LabGap.s20({
    super.key,
  }) : size = LabGapSize.s20;

  const LabGap.s24({
    super.key,
  }) : size = LabGapSize.s24;

  const LabGap.s32({
    super.key,
  }) : size = LabGapSize.s32;

  const LabGap.s38({
    super.key,
  }) : size = LabGapSize.s38;

  const LabGap.s40({
    super.key,
  }) : size = LabGapSize.s40;

  const LabGap.s48({
    super.key,
  }) : size = LabGapSize.s48;

  const LabGap.s56({
    super.key,
  }) : size = LabGapSize.s56;

  const LabGap.s64({
    super.key,
  }) : size = LabGapSize.s64;

  const LabGap.s72({
    super.key,
  }) : size = LabGapSize.s72;

  const LabGap.s80({
    super.key,
  }) : size = LabGapSize.s80;

  final LabGapSize size;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    return Gap(size.getSizes(theme));
  }
}
