import 'package:flutter/widgets.dart';
import 'package:zaplab_design/src/utils/platform.dart';

/// A widget that creates empty space with the height of the top system bar
class AppTopSafeArea extends StatelessWidget {
  const AppTopSafeArea({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          PlatformUtils.isMobile ? MediaQuery.of(context).padding.top : 20.0,
    );
  }
}

/// A widget that creates empty space with the height of the bottom system bar
class AppBottomSafeArea extends StatelessWidget {
  const AppBottomSafeArea({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).padding.bottom,
    );
  }
}
