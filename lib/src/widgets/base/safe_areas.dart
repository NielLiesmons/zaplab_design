import 'dart:io' show Platform;
import 'package:flutter/widgets.dart';

/// A widget that creates empty space with the height of the top system bar
class AppTopSafeArea extends StatelessWidget {
  const AppTopSafeArea({super.key});

  @override
  Widget build(BuildContext context) {
    final isOnMobile = Platform.isIOS || Platform.isAndroid;
    return SizedBox(
      height: isOnMobile ? MediaQuery.of(context).padding.top : 24.0,
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
