import 'package:flutter/material.dart';

import 'data/data.dart';

export 'data/data.dart';

export 'data/borders.dart';
export 'data/colors.dart';
export 'data/form_factor.dart';
export 'data/icons.dart';
export 'data/images.dart';
export 'data/line_thickness.dart';
export 'data/radius.dart';
export 'data/sizes.dart';
export 'data/system_ui_wrapper.dart';
export 'data/typography.dart';

class AppTheme extends InheritedWidget {
  const AppTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final AppThemeData data;

  static AppThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<AppTheme>();
    return widget!.data;
  }

  @override
  bool updateShouldNotify(covariant AppTheme oldWidget) {
    return data != oldWidget.data;
  }
}
