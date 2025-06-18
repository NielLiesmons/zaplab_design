import 'package:zaplab_design/src/utils/named.dart';
import 'package:equatable/equatable.dart';
import 'package:zaplab_design/src/utils/platform.dart';

const mobileScaleFactor = 1.15;
const desktopScaleFactor = 1.08;

class LabSystemData extends Equatable {
  final double scale;

  const LabSystemData({
    required this.scale,
  });

  factory LabSystemData.normal() => LabSystemData(
        scale:
            LabPlatformUtils.isMobile ? mobileScaleFactor : desktopScaleFactor,
      );

  factory LabSystemData.small() => LabSystemData(
        scale: (LabPlatformUtils.isMobile
                ? mobileScaleFactor
                : desktopScaleFactor) *
            0.95,
      );

  factory LabSystemData.large() => LabSystemData(
        scale: (LabPlatformUtils.isMobile
                ? mobileScaleFactor
                : desktopScaleFactor) *
            1.05,
      );

  @override
  List<Object?> get props => [scale.named('scale')];
}
