import 'package:zaplab_design/src/utils/named.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class LabSizesData extends Equatable {
  const LabSizesData({
    required this.phi,
    required this.s2,
    required this.s4,
    required this.s6,
    required this.s8,
    required this.s10,
    required this.s12,
    required this.s14,
    required this.s16,
    required this.s18,
    required this.s20,
    required this.s24,
    required this.s28,
    required this.s32,
    required this.s38,
    required this.s40,
    required this.s48,
    required this.s56,
    required this.s64,
    required this.s72,
    required this.s80,
    required this.s96,
    required this.s104,
  });

  factory LabSizesData.normal() => const LabSizesData(
        phi: 1.618033988749895,
        s2: 2,
        s4: 4,
        s6: 6,
        s8: 8,
        s10: 10,
        s12: 12,
        s14: 14,
        s16: 16,
        s18: 18,
        s20: 20,
        s24: 24,
        s28: 28,
        s32: 32,
        s38: 38,
        s40: 40,
        s48: 48,
        s56: 56,
        s64: 64,
        s72: 72,
        s80: 80,
        s96: 96,
        s104: 104,
      );

  final double phi;
  final double s2;
  final double s4;
  final double s6;
  final double s8;
  final double s10;
  final double s12;
  final double s14;
  final double s16;
  final double s18;
  final double s20;
  final double s24;
  final double s28;
  final double s32;
  final double s38;
  final double s40;
  final double s48;
  final double s56;
  final double s64;
  final double s72;
  final double s80;
  final double s96;
  final double s104;

  LabEdgeInsetsSizesData asInsets() => LabEdgeInsetsSizesData(this);

  @override
  List<Object?> get props => [
        phi.named('phi'),
        s2.named('s2'),
        s4.named('s4'),
        s6.named('s6'),
        s8.named('s8'),
        s10.named('s10'),
        s12.named('s12'),
        s14.named('s14'),
        s16.named('s16'),
        s18.named('s18'),
        s20.named('s20'),
        s24.named('s24'),
        s28.named('s28'),
        s32.named('s32'),
        s38.named('s38'),
        s40.named('s40'),
        s48.named('s48'),
        s56.named('s56'),
        s64.named('s64'),
        s72.named('s72'),
        s80.named('s80'),
        s96.named('s96'),
        s104.named('s104'),
      ];
}

class LabEdgeInsetsSizesData extends Equatable {
  const LabEdgeInsetsSizesData(this._sizes);

  EdgeInsets get s2 => EdgeInsets.all(_sizes.s2);
  EdgeInsets get s4 => EdgeInsets.all(_sizes.s4);
  EdgeInsets get s6 => EdgeInsets.all(_sizes.s6);
  EdgeInsets get s8 => EdgeInsets.all(_sizes.s8);
  EdgeInsets get s12 => EdgeInsets.all(_sizes.s12);
  EdgeInsets get s10 => EdgeInsets.all(_sizes.s10);
  EdgeInsets get s14 => EdgeInsets.all(_sizes.s14);
  EdgeInsets get s16 => EdgeInsets.all(_sizes.s16);
  EdgeInsets get s18 => EdgeInsets.all(_sizes.s18);
  EdgeInsets get s20 => EdgeInsets.all(_sizes.s20);
  EdgeInsets get s24 => EdgeInsets.all(_sizes.s24);
  EdgeInsets get s28 => EdgeInsets.all(_sizes.s28);
  EdgeInsets get s32 => EdgeInsets.all(_sizes.s32);
  EdgeInsets get s40 => EdgeInsets.all(_sizes.s40);
  EdgeInsets get s48 => EdgeInsets.all(_sizes.s48);
  EdgeInsets get s56 => EdgeInsets.all(_sizes.s56);
  EdgeInsets get s64 => EdgeInsets.all(_sizes.s64);
  EdgeInsets get s72 => EdgeInsets.all(_sizes.s72);
  EdgeInsets get s80 => EdgeInsets.all(_sizes.s80);
  EdgeInsets get s96 => EdgeInsets.all(_sizes.s96);
  EdgeInsets get s104 => EdgeInsets.all(_sizes.s104);

  final LabSizesData _sizes;

  @override
  List<Object?> get props => [_sizes];
}
