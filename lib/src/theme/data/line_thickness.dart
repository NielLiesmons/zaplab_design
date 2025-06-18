import 'package:zaplab_design/src/utils/named.dart';
import 'package:equatable/equatable.dart';

class LabLineThicknessData extends Equatable {
  final double thin;
  final double medium;
  final double thick;

  const LabLineThicknessData({
    required this.thin,
    required this.medium,
    required this.thick,
  });

  factory LabLineThicknessData.normal() => const LabLineThicknessData(
        thin: 0.33,
        medium: 1.4,
        thick: 2.8,
      );

  @override
  List<Object?> get props => [
        thin.named('thin'),
        medium.named('medium'),
        thick.named('thick'),
      ];
}
