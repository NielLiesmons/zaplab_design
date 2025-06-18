import 'package:zaplab_design/src/utils/named.dart';
import 'package:equatable/equatable.dart';

class LabDurationsData extends Equatable {
  const LabDurationsData({
    required this.areAnimationEnabled,
    required this.normal,
    required this.fast,
  });

  factory LabDurationsData.normal() => const LabDurationsData(
        areAnimationEnabled: true,
        normal: Duration(milliseconds: 222),
        fast: Duration(milliseconds: 128),
      );

  final bool areAnimationEnabled;
  final Duration normal;
  final Duration fast;

  @override
  List<Object?> get props => [
        areAnimationEnabled,
        normal.named('normal'),
        fast.named('fast'),
      ];
}
