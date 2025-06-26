import 'package:zaplab_design/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

enum LabTextLevel {
  /// App Typography
  h1,
  h2,
  h3,
  bold16,
  med16,
  reg16,
  bold14,
  med14,
  reg14,
  bold12,
  med12,
  reg12,
  bold10,
  med10,
  reg10,
  bold8,
  med8,
  reg8,
  link,

  /// Long Form Typography
  longformh1,
  longformh2,
  longformh3,
  longformh4,
  longformh5,
  boldArticle,
  regArticle,
  linkArticle,
  boldWiki,
  regWiki,
  linkWiki,
  code,
  caption,
}

class LabText extends StatelessWidget {
  const LabText(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
    this.level = LabTextLevel.med16,
  });

  /// App Typography
  const LabText.h1(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.h1;

  const LabText.h2(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.h2;

  const LabText.h3(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.h3;

  const LabText.bold16(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.bold16;

  const LabText.med16(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.med16;

  const LabText.reg16(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.reg16;

  const LabText.bold14(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.bold14;

  const LabText.med14(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.med14;

  const LabText.reg14(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.reg14;

  const LabText.bold12(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.bold12;

  const LabText.med12(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.med12;

  const LabText.reg12(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.reg12;

  const LabText.bold10(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.bold10;

  const LabText.med10(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.med10;

  const LabText.reg10(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.reg10;

  const LabText.bold8(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.bold8;

  const LabText.med8(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.med8;

  const LabText.reg8(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.reg8;

  const LabText.link(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.link;

  /// Long Form Typography
  const LabText.longformh1(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.longformh1;

  const LabText.longformh2(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.longformh2;

  const LabText.longformh3(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.longformh3;

  const LabText.longformh4(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.longformh4;

  const LabText.longformh5(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.longformh5;

  const LabText.regArticle(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.regArticle;

  const LabText.boldArticle(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.boldArticle;

  const LabText.linkArticle(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.linkArticle;

  const LabText.regWiki(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.regWiki;

  const LabText.boldWiki(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.boldWiki;

  const LabText.linkWiki(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.linkWiki;

  const LabText.code(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.code;

  const LabText.caption(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
  }) : level = LabTextLevel.caption;

  final String data;
  final LabTextLevel level;
  final Color? color;
  final Gradient? gradient;
  final double? fontSize;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final defaultColor = theme.colors.white;
    final resolvedColor = gradient == null ? (color ?? defaultColor) : null;
    final style = _getTextStyle(theme, level);

    // Use ShaderMask for gradient text
    final text = Text(
      data,
      style: style.copyWith(
        color: resolvedColor,
        fontSize: fontSize,
      ),
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
    );

    if (gradient != null) {
      return ShaderMask(
        shaderCallback: (bounds) {
          return gradient!.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          );
        },
        blendMode: BlendMode.srcIn,
        child: text,
      );
    }

    return text;
  }

  TextStyle _getTextStyle(LabThemeData theme, LabTextLevel level) {
    switch (level) {
      case LabTextLevel.h1:
        return theme.typography.h1;
      case LabTextLevel.h2:
        return theme.typography.h2;
      case LabTextLevel.h3:
        return theme.typography.h3;
      case LabTextLevel.bold16:
        return theme.typography.bold16;
      case LabTextLevel.med16:
        return theme.typography.med16;
      case LabTextLevel.reg16:
        return theme.typography.reg16;
      case LabTextLevel.bold14:
        return theme.typography.bold14;
      case LabTextLevel.med14:
        return theme.typography.med14;
      case LabTextLevel.reg14:
        return theme.typography.reg14;
      case LabTextLevel.bold12:
        return theme.typography.bold12;
      case LabTextLevel.med12:
        return theme.typography.med12;
      case LabTextLevel.reg12:
        return theme.typography.reg12;
      case LabTextLevel.bold10:
        return theme.typography.bold10;
      case LabTextLevel.med10:
        return theme.typography.med10;
      case LabTextLevel.reg10:
        return theme.typography.reg10;
      case LabTextLevel.bold8:
        return theme.typography.bold8;
      case LabTextLevel.med8:
        return theme.typography.med8;
      case LabTextLevel.reg8:
        return theme.typography.reg8;
      case LabTextLevel.link:
        return theme.typography.link;
      case LabTextLevel.longformh1:
        return theme.typography.longformh1;
      case LabTextLevel.longformh2:
        return theme.typography.longformh2;
      case LabTextLevel.longformh3:
        return theme.typography.longformh3;
      case LabTextLevel.longformh4:
        return theme.typography.longformh4;
      case LabTextLevel.longformh5:
        return theme.typography.longformh5;
      case LabTextLevel.boldArticle:
        return theme.typography.boldArticle;
      case LabTextLevel.regArticle:
        return theme.typography.regArticle;
      case LabTextLevel.linkArticle:
        return theme.typography.linkArticle;
      case LabTextLevel.boldWiki:
        return theme.typography.boldWiki;
      case LabTextLevel.regWiki:
        return theme.typography.regWiki;
      case LabTextLevel.linkWiki:
        return theme.typography.linkWiki;
      case LabTextLevel.code:
        return theme.typography.code;
      case LabTextLevel.caption:
        return theme.typography.caption;
    }
  }
}
