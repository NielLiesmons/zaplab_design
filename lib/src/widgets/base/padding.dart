import 'package:zaplab_design/src/theme/theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'gap.dart';

class AppEdgeInsets extends Equatable {
  const AppEdgeInsets.all(AppGapSize value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const AppEdgeInsets.symmetric({
    AppGapSize vertical = AppGapSize.none,
    AppGapSize horizontal = AppGapSize.none,
  })  : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;

  const AppEdgeInsets.only({
    this.left = AppGapSize.none,
    this.top = AppGapSize.none,
    this.right = AppGapSize.none,
    this.bottom = AppGapSize.none,
  });

  const AppEdgeInsets.s4()
      : left = AppGapSize.s4,
        top = AppGapSize.s4,
        right = AppGapSize.s4,
        bottom = AppGapSize.s4;

  const AppEdgeInsets.s8()
      : left = AppGapSize.s8,
        top = AppGapSize.s8,
        right = AppGapSize.s8,
        bottom = AppGapSize.s8;

  const AppEdgeInsets.s12()
      : left = AppGapSize.s12,
        top = AppGapSize.s12,
        right = AppGapSize.s12,
        bottom = AppGapSize.s12;

  const AppEdgeInsets.s16()
      : left = AppGapSize.s16,
        top = AppGapSize.s16,
        right = AppGapSize.s16,
        bottom = AppGapSize.s16;

  const AppEdgeInsets.s20()
      : left = AppGapSize.s20,
        top = AppGapSize.s20,
        right = AppGapSize.s20,
        bottom = AppGapSize.s20;

  const AppEdgeInsets.s24()
      : left = AppGapSize.s24,
        top = AppGapSize.s24,
        right = AppGapSize.s24,
        bottom = AppGapSize.s24;

  const AppEdgeInsets.s32()
      : left = AppGapSize.s32,
        top = AppGapSize.s32,
        right = AppGapSize.s32,
        bottom = AppGapSize.s32;

  final AppGapSize left;
  final AppGapSize top;
  final AppGapSize right;
  final AppGapSize bottom;

  @override
  List<Object?> get props => [
        left,
        top,
        right,
        bottom,
      ];

  EdgeInsets toEdgeInsets(AppThemeData theme) {
    return EdgeInsets.only(
      left: left.getSizes(theme),
      top: top.getSizes(theme),
      right: right.getSizes(theme),
      bottom: bottom.getSizes(theme),
    );
  }
}

class AppPadding extends StatelessWidget {
  const AppPadding({
    super.key,
    this.padding = const AppEdgeInsets.all(AppGapSize.none),
    this.child,
  });

  const AppPadding.s4({
    super.key,
    this.child,
  }) : padding = const AppEdgeInsets.all(AppGapSize.s4);

  const AppPadding.s8({
    super.key,
    this.child,
  }) : padding = const AppEdgeInsets.all(AppGapSize.s8);

  const AppPadding.s12({
    super.key,
    this.child,
  }) : padding = const AppEdgeInsets.all(AppGapSize.s12);

  const AppPadding.s16({
    super.key,
    this.child,
  }) : padding = const AppEdgeInsets.all(AppGapSize.s16);

  const AppPadding.s20({
    super.key,
    this.child,
  }) : padding = const AppEdgeInsets.all(AppGapSize.s20);

  const AppPadding.s24({
    super.key,
    this.child,
  }) : padding = const AppEdgeInsets.all(AppGapSize.s24);

  const AppPadding.s32({
    super.key,
    this.child,
  }) : padding = const AppEdgeInsets.all(AppGapSize.s32);

  final AppEdgeInsets padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: padding.toEdgeInsets(theme),
      child: child,
    );
  }
}
