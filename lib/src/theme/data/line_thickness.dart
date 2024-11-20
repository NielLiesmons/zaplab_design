import 'package:zapchat_design/src/utils/named.dart';
import 'package:equatable/equatable.dart';

class LineThicknessData extends Equatable {
  final double thin;
  final double medium;
  final double thick;

  const LineThicknessData({
    required this.thin,
    required this.medium,
    required this.thick,
  });

  factory LineThicknessData.normal() => const LineThicknessData(
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
