import 'package:zaplab_design/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

enum AppTextLevel {
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

class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
    this.level = AppTextLevel.med16,
  });

  /// App Typography
  const AppText.h1(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.h1;

  const AppText.h2(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.h2;

  const AppText.h3(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.h3;

  const AppText.bold16(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.bold16;

  const AppText.med16(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.med16;

  const AppText.reg16(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.reg16;

  const AppText.bold14(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.bold14;

  const AppText.med14(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.med14;

  const AppText.reg14(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.reg14;

  const AppText.bold12(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.bold12;

  const AppText.med12(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.med12;

  const AppText.reg12(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.reg12;

  const AppText.bold10(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.bold10;

  const AppText.med10(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.med10;

  const AppText.reg10(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.reg10;

  const AppText.link(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.link;

  /// Long Form Typography
  const AppText.longformh1(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.longformh1;

  const AppText.longformh2(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.longformh2;

  const AppText.longformh3(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.longformh3;

  const AppText.longformh4(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.longformh4;

  const AppText.longformh5(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.longformh5;

  const AppText.regArticle(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.regArticle;

  const AppText.boldArticle(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.boldArticle;

  const AppText.linkArticle(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.linkArticle;

  const AppText.regWiki(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.regWiki;

  const AppText.boldWiki(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.boldWiki;

  const AppText.linkWiki(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.linkWiki;

  const AppText.code(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.code;

  const AppText.caption(
    this.data, {
    super.key,
    this.color,
    this.gradient,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.caption;

  final String data;
  final AppTextLevel level;
  final Color? color;
  final Gradient? gradient;
  final double? fontSize;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
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

  TextStyle _getTextStyle(AppThemeData theme, AppTextLevel level) {
    switch (level) {
      case AppTextLevel.h1:
        return theme.typography.h1;
      case AppTextLevel.h2:
        return theme.typography.h2;
      case AppTextLevel.h3:
        return theme.typography.h3;
      case AppTextLevel.bold16:
        return theme.typography.bold16;
      case AppTextLevel.med16:
        return theme.typography.med16;
      case AppTextLevel.reg16:
        return theme.typography.reg16;
      case AppTextLevel.bold14:
        return theme.typography.bold14;
      case AppTextLevel.med14:
        return theme.typography.med14;
      case AppTextLevel.reg14:
        return theme.typography.reg14;
      case AppTextLevel.bold12:
        return theme.typography.bold12;
      case AppTextLevel.med12:
        return theme.typography.med12;
      case AppTextLevel.reg12:
        return theme.typography.reg12;
      case AppTextLevel.bold10:
        return theme.typography.bold10;
      case AppTextLevel.med10:
        return theme.typography.med10;
      case AppTextLevel.reg10:
        return theme.typography.reg10;
      case AppTextLevel.link:
        return theme.typography.link;
      case AppTextLevel.longformh1:
        return theme.typography.longformh1;
      case AppTextLevel.longformh2:
        return theme.typography.longformh2;
      case AppTextLevel.longformh3:
        return theme.typography.longformh3;
      case AppTextLevel.longformh4:
        return theme.typography.longformh4;
      case AppTextLevel.longformh5:
        return theme.typography.longformh5;
      case AppTextLevel.boldArticle:
        return theme.typography.boldArticle;
      case AppTextLevel.regArticle:
        return theme.typography.regArticle;
      case AppTextLevel.linkArticle:
        return theme.typography.linkArticle;
      case AppTextLevel.boldWiki:
        return theme.typography.boldWiki;
      case AppTextLevel.regWiki:
        return theme.typography.regWiki;
      case AppTextLevel.linkWiki:
        return theme.typography.linkWiki;
      case AppTextLevel.code:
        return theme.typography.code;
      case AppTextLevel.caption:
        return theme.typography.caption;
    }
  }
}
