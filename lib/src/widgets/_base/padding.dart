import 'package:zaplab_design/src/theme/theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'gap.dart';

class LabEdgeInsets extends Equatable {
  const LabEdgeInsets.all(LabGapSize value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const LabEdgeInsets.symmetric({
    LabGapSize vertical = LabGapSize.none,
    LabGapSize horizontal = LabGapSize.none,
  })  : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;

  const LabEdgeInsets.only({
    this.left = LabGapSize.none,
    this.top = LabGapSize.none,
    this.right = LabGapSize.none,
    this.bottom = LabGapSize.none,
  });

  const LabEdgeInsets.s4()
      : left = LabGapSize.s4,
        top = LabGapSize.s4,
        right = LabGapSize.s4,
        bottom = LabGapSize.s4;

  const LabEdgeInsets.s8()
      : left = LabGapSize.s8,
        top = LabGapSize.s8,
        right = LabGapSize.s8,
        bottom = LabGapSize.s8;

  const LabEdgeInsets.s12()
      : left = LabGapSize.s12,
        top = LabGapSize.s12,
        right = LabGapSize.s12,
        bottom = LabGapSize.s12;

  const LabEdgeInsets.s16()
      : left = LabGapSize.s16,
        top = LabGapSize.s16,
        right = LabGapSize.s16,
        bottom = LabGapSize.s16;

  const LabEdgeInsets.s20()
      : left = LabGapSize.s20,
        top = LabGapSize.s20,
        right = LabGapSize.s20,
        bottom = LabGapSize.s20;

  const LabEdgeInsets.s24()
      : left = LabGapSize.s24,
        top = LabGapSize.s24,
        right = LabGapSize.s24,
        bottom = LabGapSize.s24;

  const LabEdgeInsets.s32()
      : left = LabGapSize.s32,
        top = LabGapSize.s32,
        right = LabGapSize.s32,
        bottom = LabGapSize.s32;

  final LabGapSize left;
  final LabGapSize top;
  final LabGapSize right;
  final LabGapSize bottom;

  @override
  List<Object?> get props => [
        left,
        top,
        right,
        bottom,
      ];

  EdgeInsets toEdgeInsets(LabThemeData theme) {
    return EdgeInsets.only(
      left: left.getSizes(theme),
      top: top.getSizes(theme),
      right: right.getSizes(theme),
      bottom: bottom.getSizes(theme),
    );
  }
}

class LabPadding extends StatelessWidget {
  const LabPadding({
    super.key,
    this.padding = const LabEdgeInsets.all(LabGapSize.none),
    this.child,
  });

  const LabPadding.s4({
    super.key,
    this.child,
  }) : padding = const LabEdgeInsets.all(LabGapSize.s4);

  const LabPadding.s8({
    super.key,
    this.child,
  }) : padding = const LabEdgeInsets.all(LabGapSize.s8);

  const LabPadding.s12({
    super.key,
    this.child,
  }) : padding = const LabEdgeInsets.all(LabGapSize.s12);

  const LabPadding.s16({
    super.key,
    this.child,
  }) : padding = const LabEdgeInsets.all(LabGapSize.s16);

  const LabPadding.s20({
    super.key,
    this.child,
  }) : padding = const LabEdgeInsets.all(LabGapSize.s20);

  const LabPadding.s24({
    super.key,
    this.child,
  }) : padding = const LabEdgeInsets.all(LabGapSize.s24);

  const LabPadding.s32({
    super.key,
    this.child,
  }) : padding = const LabEdgeInsets.all(LabGapSize.s32);

  final LabEdgeInsets padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    return Padding(
      padding: padding.toEdgeInsets(theme),
      child: child,
    );
  }
}
