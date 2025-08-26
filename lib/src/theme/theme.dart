import 'package:flutter/material.dart';

import 'data/data.dart';

export 'data/data.dart';

export 'data/borders.dart';
export 'data/colors.dart';
export 'data/default_data.dart';
export 'data/durations.dart';
export 'data/form_factor.dart';
export 'data/icons.dart';
export 'data/line_thickness.dart';
export 'data/radius.dart';
export 'data/sizes.dart';
export 'data/system_data.dart';
export 'data/typography.dart';

class LabTheme extends InheritedWidget {
  const LabTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final LabThemeData data;

  static LabThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<LabTheme>();
    return widget!.data;
  }

  @override
  bool updateShouldNotify(covariant LabTheme oldWidget) {
    return data != oldWidget.data;
  }
}
