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
  s28,
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
  double getSpacing(AppThemeData theme) {
    switch (this) {
      case AppGapSize.none:
        return 0;
      case AppGapSize.s2:
        return theme.spacing.s2;
      case AppGapSize.s4:
        return theme.spacing.s4;
      case AppGapSize.s6:
        return theme.spacing.s6;
      case AppGapSize.s8:
        return theme.spacing.s8;
      case AppGapSize.s12:
        return theme.spacing.s12;
      case AppGapSize.s16:
        return theme.spacing.s16;
      case AppGapSize.s20:
        return theme.spacing.s20;
      case AppGapSize.s24:
        return theme.spacing.s24;
      case AppGapSize.s32:
        return theme.spacing.s32;
      case AppGapSize.s38:
        return theme.spacing.s38;
      case AppGapSize.s40:
        return theme.spacing.s40;
      case AppGapSize.s48:
        return theme.spacing.s48;
      case AppGapSize.s56:
        return theme.spacing.s56;
      case AppGapSize.s64:
        return theme.spacing.s64;
      case AppGapSize.s72:
        return theme.spacing.s72;
      case AppGapSize.s80:
        return theme.spacing.s80;
    }
  }
}

class AppGap extends StatelessWidget {
  const AppGap(
    this.size, {
    Key? key,
  }) : super(key: key);

  const AppGap.s2({
    Key? key,
  })  : size = AppGapSize.s2,
        super(key: key);

  const AppGap.s4({
    Key? key,
  })  : size = AppGapSize.s4,
        super(key: key);

  const AppGap.s6({
    Key? key,
  })  : size = AppGapSize.s6,
        super(key: key);

  const AppGap.s8({
    Key? key,
  })  : size = AppGapSize.s8,
        super(key: key);

  const AppGap.s12({
    Key? key,
  })  : size = AppGapSize.s12,
        super(key: key);

  const AppGap.s16({
    Key? key,
  })  : size = AppGapSize.s16,
        super(key: key);

  const AppGap.s20({
    Key? key,
  })  : size = AppGapSize.s20,
        super(key: key);

  const AppGap.s24({
    Key? key,
  })  : size = AppGapSize.s24,
        super(key: key);

  const AppGap.s32({
    Key? key,
  })  : size = AppGapSize.s32,
        super(key: key);

  const AppGap.s38({
    Key? key,
  })  : size = AppGapSize.s38,
        super(key: key);

  const AppGap.s40({
    Key? key,
  })  : size = AppGapSize.s40,
        super(key: key);

  const AppGap.s48({
    Key? key,
  })  : size = AppGapSize.s48,
        super(key: key);

  const AppGap.s56({
    Key? key,
  })  : size = AppGapSize.s56,
        super(key: key);

  const AppGap.s64({
    Key? key,
  })  : size = AppGapSize.s64,
        super(key: key);

  const AppGap.s72({
    Key? key,
  })  : size = AppGapSize.s72,
        super(key: key);

  const AppGap.s80({
    Key? key,
  })  : size = AppGapSize.s80,
        super(key: key);

  final AppGapSize size;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Gap(size.getSpacing(theme));
  }
}
