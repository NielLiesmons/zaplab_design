import 'package:zapchat_design/src/utils/named.dart';
import 'package:equatable/equatable.dart';

class LineThicknessData extends Equatable {
  final double thin16;
  final double thin33;
  final double medium;
  final double thick;

  LineThicknessData({
    required this.thin16,
    required this.thin33,
    required this.medium,
    required this.thick,
  });

  factory LineThicknessData.defaults() => LineThicknessData(
        thin16: 0.16,
        thin33: 0.33,
        medium: 1.4,
        thick: 2.8,
      );

  @override
  List<Object?> get props => [
        thin16.named('thin16'),
        thin33.named('thin33'),
        medium.named('medium'),
        thick.named('thick'),
      ];
}
