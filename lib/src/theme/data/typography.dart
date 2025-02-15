import 'package:zaplab_design/src/utils/named.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

class AppTypographyData extends Equatable {
  const AppTypographyData({
    /// App Typography
    required this.h1,
    required this.h2,
    required this.h3,
    required this.bold16,
    required this.med16,
    required this.reg16,
    required this.bold14,
    required this.med14,
    required this.reg14,
    required this.bold12,
    required this.med12,
    required this.reg12,
    required this.bold10,
    required this.med10,
    required this.reg10,
    required this.link,

    /// Long Form Typography
    required this.longformh1,
    required this.longformh2,
    required this.longformh3,
    required this.longformh4,
    required this.longformh5,
    required this.boldArticle,
    required this.regArticle,
    required this.linkArticle,
    required this.boldWiki,
    required this.regWiki,
    required this.linkWiki,
    required this.code,
    required this.caption,
  });

  factory AppTypographyData.normal() => const AppTypographyData(
        /// App Typography
        h1: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w600, // technically semibold
          fontSize: 24,
          height: 1.5,
          letterSpacing: 0.3,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        h2: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w600, // technically semibold
          fontSize: 20,
          height: 1.5,
          letterSpacing: 0.3,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        h3: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w600, // technically semibold
          fontSize: 12,
          height: 1.5,
          letterSpacing: 2.2,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        bold16: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontVariations: [
            FontVariation('wght', 600),
          ], // technically semibold
          fontSize: 16,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        med16: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w500,
          fontVariations: [
            FontVariation('wght', 500),
          ],
          fontSize: 16,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        reg16: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w400, // regular
          fontSize: 16,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        bold14: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w600, // technically semibold
          fontSize: 14.5,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        med14: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w500,
          fontVariations: [
            FontVariation('wght', 500),
          ], // medium
          fontSize: 14.5,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        reg14: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w400, // regular
          fontSize: 14.5,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        bold12: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w600, // technically semibold
          fontSize: 12,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        med12: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w500,
          fontVariations: [
            FontVariation('wght', 500),
          ], // medium
          fontSize: 12,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        reg12: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w400, // regular
          fontSize: 12,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        bold10: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w600, // technically semibold
          fontSize: 10,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        med10: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w500,
          fontVariations: [
            FontVariation('wght', 500),
          ], // medium
          fontSize: 10,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        reg10: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w400, // regular
          fontSize: 10,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        link: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w500,
          fontVariations: [
            FontVariation('wght', 500),
          ], // medium
          fontSize: 14.5,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),

        /// Long Form Typography
        longformh1: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w600, // technically semibold
          fontSize: 20,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        longformh2: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w600, // technically semibold
          fontSize: 16,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        longformh3: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w600, // technically semibold
          fontSize: 14.5,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        longformh4: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w600, // technically semibold
          fontSize: 14.5,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        longformh5: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w600, // technically semibold
          fontSize: 12,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        boldArticle: TextStyle(
          fontFamily: 'Lora',
          package: 'zaplab_design',
          fontWeight: FontWeight.w600, // technically semibold
          fontSize: 16,
          height: 1.7,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        regArticle: TextStyle(
          fontFamily: 'Lora',
          package: 'zaplab_design',
          fontVariations: [
            FontVariation('wght', 450), // Custom weight for great reading
          ],
          fontSize: 16,
          height: 1.7,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        linkArticle: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontVariations: [
            FontVariation('wght', 500),
          ], // medium
          fontSize: 16,
          height: 1.7,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        boldWiki: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w600, // technically semibold
          fontSize: 16,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        regWiki: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontWeight: FontWeight.w400, // regular
          fontSize: 16,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        linkWiki: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontVariations: [
            FontVariation('wght', 500),
          ], // medium
          fontSize: 16,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        code: TextStyle(
          fontFamily: 'Courier-Prime',
          package: 'zaplab_design',
          fontWeight: FontWeight.w400, // regular
          fontSize: 15,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
        caption: TextStyle(
          fontFamily: 'Inter',
          package: 'zaplab_design',
          fontVariations: [
            FontVariation('wght', 500),
          ], // medium
          fontSize: 12,
          height: 1.5,
          letterSpacing: 0.15,
          leadingDistribution: TextLeadingDistribution.even,
          decoration: TextDecoration.none,
        ),
      );

  /// App Typography
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle bold16;
  final TextStyle med16;
  final TextStyle reg16;
  final TextStyle bold14;
  final TextStyle med14;
  final TextStyle reg14;
  final TextStyle bold12;
  final TextStyle med12;
  final TextStyle reg12;
  final TextStyle bold10;
  final TextStyle med10;
  final TextStyle reg10;
  final TextStyle link;

  /// Long Form Typography
  final TextStyle longformh1;
  final TextStyle longformh2;
  final TextStyle longformh3;
  final TextStyle longformh4;
  final TextStyle longformh5;
  final TextStyle boldArticle;
  final TextStyle regArticle;
  final TextStyle linkArticle;
  final TextStyle boldWiki;
  final TextStyle regWiki;
  final TextStyle linkWiki;
  final TextStyle code;
  final TextStyle caption;

  @override
  List<Object?> get props => [
        /// App Typography
        h1.named('h1'),
        h2.named('h2'),
        h3.named('h3'),
        bold16.named('bold16'),
        med16.named('med16'),
        reg16.named('reg16'),
        bold14.named('bold14'),
        med14.named('med14'),
        reg14.named('reg14'),
        bold12.named('bold12'),
        med12.named('med12'),
        reg12.named('reg26'),
        bold10.named('bold10'),
        med10.named('med10'),
        reg10.named('reg10'),
        link.named('link'),

        /// Long Form Typography
        longformh1.named('longformh1'),
        longformh2.named('longformh2'),
        longformh3.named('longformh3'),
        longformh4.named('longformh4'),
        longformh5.named('longformh5'),
        boldArticle.named('boldArticle'),
        regArticle.named('regArticle'),
        linkArticle.named('linkArticle'),
        boldWiki.named('boldArticle'),
        regWiki.named('regWiki'),
        linkWiki.named('linkWiki'),
      ];
}
