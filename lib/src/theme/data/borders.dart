import 'package:zapchat_design/src/utils/named.dart';
import 'package:equatable/equatable.dart';
import 'line_thickness.dart';

class AppBorderData extends Equatable {
  final double thin;
  final double medium;
  final double thick;

  const AppBorderData({
    required this.thin,
    required this.medium,
    required this.thick,
  });

  factory AppBorderData.fromThickness(LineThicknessData thicknessData) =>
      AppBorderData(
        thin: thicknessData.thin,
        medium: thicknessData.medium,
        thick: thicknessData.thick,
      );

  @override
  List<Object?> get props => [
        thin.named('thin'),
        medium.named('medium'),
        thick.named('thick'),
      ];
}
