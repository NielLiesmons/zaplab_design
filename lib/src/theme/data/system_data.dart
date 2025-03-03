import 'package:zaplab_design/src/utils/named.dart';
import 'package:equatable/equatable.dart';
import 'dart:io' show Platform;

const mobileScaleFactor = 1.15;
const desktopScaleFactor = 1.08;

class AppSystemData extends Equatable {
  final double scale;

  const AppSystemData({
    required this.scale,
  });

  factory AppSystemData.normal() => AppSystemData(
        scale: Platform.isAndroid || Platform.isIOS
            ? mobileScaleFactor
            : desktopScaleFactor,
      );

  factory AppSystemData.small() => AppSystemData(
        scale: (Platform.isAndroid || Platform.isIOS
                ? mobileScaleFactor
                : desktopScaleFactor) *
            0.95,
      );

  factory AppSystemData.large() => AppSystemData(
        scale: (Platform.isAndroid || Platform.isIOS
                ? mobileScaleFactor
                : desktopScaleFactor) *
            1.05,
      );

  @override
  List<Object?> get props => [scale.named('scale')];
}
