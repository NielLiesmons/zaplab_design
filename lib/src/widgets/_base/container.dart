import 'package:zaplab_design/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

import 'padding.dart';

class LabContainer extends StatelessWidget {
  const LabContainer({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.foregroundDecoration,
    this.alignment,
    this.clipBehavior = Clip.none,
    this.constraints,
    this.transform,
    this.transformAlignment,
    this.child,
  });

  final LabEdgeInsets? padding;
  final LabEdgeInsets? margin;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Widget? child;
  final Clip clipBehavior;
  final BoxConstraints? constraints;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;

  @override
  Widget build(BuildContext context) {
    // Early return for no-padding/no-margin case (most common)
    if (padding == null && margin == null) {
      return Container(
        width: width,
        height: height,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        alignment: alignment,
        clipBehavior: clipBehavior,
        constraints: constraints,
        transform: transform,
        transformAlignment: transformAlignment,
        child: child,
      );
    }

    // Cache theme lookup to avoid repeated calls
    final theme = LabTheme.of(context);

    // Pre-resolve padding and margin once
    final EdgeInsets? resolvedPadding = padding?.toEdgeInsets(theme);
    final EdgeInsets? resolvedMargin = margin?.toEdgeInsets(theme);

    return Container(
      width: width,
      height: height,
      padding: resolvedPadding,
      margin: resolvedMargin,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      alignment: alignment,
      clipBehavior: clipBehavior,
      constraints: constraints,
      transform: transform,
      transformAlignment: transformAlignment,
      child: child,
    );
  }
}
