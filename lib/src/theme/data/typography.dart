import 'dart:io';

import 'package:zapchat_design/src/utils/named.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

class AppTypographyData extends Equatable {
  const AppTypographyData({
    // App Typography
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
    // Long Form Typography
    required this.longformh1,
    required this.longformh2,
    required this.longformh3,
    required this.longformh4,
    required this.longformh5,
    required this.boldArticle,
    required this.regArticle,
    required this.boldWiki,
    required this.regWiki,
    required this.code,
    required this.longformlink,
    required this.caption,
  });

  factory AppTypographyData.normal() => const AppTypographyData(
        // App Typography
        h1: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontWeight: FontWeight.w400,
          fontSize: 24,
          decoration: TextDecoration.none,
        ),
        h2: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontWeight: FontWeight.w400,
          fontSize: 20,
          decoration: TextDecoration.none,
        ),
        h3: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        bold16: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        med16: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        reg16: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        bold14: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        med14: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        reg14: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        bold12: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        med12: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        reg12: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        bold10: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        med10: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 10,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        reg10: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 10,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        link: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        // Long Form Typography
        longformh1: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        longformh2: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        longformh3: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        longformh4: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        longformh5: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        boldArticle: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        regArticle: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        boldWiki: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        regWiki: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        code: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        longformlink: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        caption: TextStyle(
          fontFamily: 'Inter',
          package: 'zapchat_design',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
      );

  // App Typography
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
  // Long Form Typography
  final TextStyle longformh1;
  final TextStyle longformh2;
  final TextStyle longformh3;
  final TextStyle longformh4;
  final TextStyle longformh5;
  final TextStyle boldArticle;
  final TextStyle regArticle;
  final TextStyle boldWiki;
  final TextStyle regWiki;
  final TextStyle code;
  final TextStyle longformlink;
  final TextStyle caption;

  @override
  List<Object?> get props => [
        h1.named('h1'),
        h2.named('h2'),
        h3.named('h3'),
        bold16.named('bold16'),
        med16.named('med16'),
        reg16.named('reg16'),
        bold16.named('bold16'),
        med16.named('med16'),
        reg16.named('reg16'),
        bold16.named('bold16'),
        med16.named('med16'),
        reg16.named('reg16'),
      ];
}
