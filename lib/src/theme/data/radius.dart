import 'package:zaplab_design/src/utils/named.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

class LabRadiusData extends Equatable {
  const LabRadiusData({
    required this.rad4,
    required this.rad8,
    required this.rad12,
    required this.rad16,
    required this.rad24,
    required this.rad32,
    required this.rad40,
  });

  const LabRadiusData.normal()
      : rad4 = const Radius.circular(4),
        rad8 = const Radius.circular(8),
        rad12 = const Radius.circular(12),
        rad16 = const Radius.circular(16),
        rad24 = const Radius.circular(24),
        rad32 = const Radius.circular(32),
        rad40 = const Radius.circular(40);

  final Radius rad4;
  final Radius rad8;
  final Radius rad12;
  final Radius rad16;
  final Radius rad24;
  final Radius rad32;
  final Radius rad40;

  LabBorderRadiusData asBorderRadius() => LabBorderRadiusData(this);

  @override
  List<Object?> get props => [
        rad4.named('rad4'),
        rad8.named('rad8'),
        rad12.named('rad12'),
        rad16.named('rad16'),
        rad24.named('rad24'),
        rad32.named('rad32'),
        rad40.named('rad40'),
      ];
}

class LabBorderRadiusData extends Equatable {
  const LabBorderRadiusData(this._radius);

  BorderRadius get rad4 => BorderRadius.all(_radius.rad4);
  BorderRadius get rad8 => BorderRadius.all(_radius.rad8);
  BorderRadius get rad12 => BorderRadius.all(_radius.rad12);
  BorderRadius get rad16 => BorderRadius.all(_radius.rad16);
  BorderRadius get rad24 => BorderRadius.all(_radius.rad24);
  BorderRadius get rad32 => BorderRadius.all(_radius.rad32);
  BorderRadius get rad40 => BorderRadius.all(_radius.rad40);

  final LabRadiusData _radius;

  @override
  List<Object?> get props => [_radius];
}
