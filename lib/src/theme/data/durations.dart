import 'package:zapchat_design/src/utils/named.dart';
import 'package:equatable/equatable.dart';

class AppDurationsData extends Equatable {
  const AppDurationsData({
    required this.areAnimationEnabled,
    required this.normal,
    required this.fast,
  });

  factory AppDurationsData.normal() => const AppDurationsData(
        areAnimationEnabled: true,
        normal: Duration(milliseconds: 184),
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
