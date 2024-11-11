import 'package:zapchat_design/src/theme/theme.dart';
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
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.level = AppTextLevel.med16,
  }) : super(key: key);

  /// App Typography
  const AppText.h1(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.h1,
        super(key: key);

  const AppText.h2(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.h2,
        super(key: key);

  const AppText.h3(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.h3,
        super(key: key);

  const AppText.bold16(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.bold16,
        super(key: key);

  const AppText.med16(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.med16,
        super(key: key);

  const AppText.reg16(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.reg16,
        super(key: key);

  const AppText.bold14(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.bold14,
        super(key: key);

  const AppText.med14(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.med14,
        super(key: key);

  const AppText.reg14(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.reg14,
        super(key: key);

  const AppText.bold12(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.bold12,
        super(key: key);

  const AppText.med12(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.med12,
        super(key: key);

  const AppText.reg12(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.reg12,
        super(key: key);

  const AppText.bold10(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.bold10,
        super(key: key);

  const AppText.med10(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.med10,
        super(key: key);

  const AppText.reg10(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.reg10,
        super(key: key);

  const AppText.link(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.link,
        super(key: key);

  /// Long Form Typography
  const AppText.longformh1(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.longformh1,
        super(key: key);

  const AppText.longformh2(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.longformh2,
        super(key: key);

  const AppText.longformh3(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.longformh3,
        super(key: key);

  const AppText.longformh4(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.longformh4,
        super(key: key);

  const AppText.longformh5(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.longformh5,
        super(key: key);

  const AppText.regArticle(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.regArticle,
        super(key: key);

  const AppText.boldArticle(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.boldArticle,
        super(key: key);

  const AppText.linkArticle(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.linkArticle,
        super(key: key);

  const AppText.regWiki(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.regWiki,
        super(key: key);

  const AppText.boldWiki(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.boldWiki,
        super(key: key);

  const AppText.linkWiki(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.linkWiki,
        super(key: key);

  const AppText.code(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.code,
        super(key: key);

  const AppText.caption(
    this.data, {
    Key? key,
    this.color,
    this.fontSize,
    this.maxLines,
  })  : level = AppTextLevel.caption,
        super(key: key);

  final String data;
  final AppTextLevel level;
  final Color? color;
  final double? fontSize;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final color = this.color ?? theme.colors.white;
    final style = () {
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
    }();
    return Text(
      data,
      style: style.copyWith(
        color: color,
        fontSize: fontSize,
      ),
      maxLines: maxLines,
    );
  }
}
