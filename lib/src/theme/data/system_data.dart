import 'package:zaplab_design/src/utils/named.dart';
import 'package:equatable/equatable.dart';

class AppSystemData extends Equatable {
  final double scale;

  const AppSystemData({
    required this.scale,
  });

  factory AppSystemData.normal() => const AppSystemData(
        scale: 1.15,
      );

  @override
  List<Object?> get props => [
        scale.named('scale'),
      ];
}
