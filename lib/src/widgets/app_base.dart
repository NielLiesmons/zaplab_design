import 'package:flutter/services.dart';
import 'package:zapchat_design/zapchat_design.dart';
import 'dart:ui';

class AppBase extends StatelessWidget {
  final String title;
  final RouterConfig<Object> routerConfig;
  final Widget appLogo;
  final Widget darkAppLogo;
  final Locale? locale;
  final List<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final double? textScaleFactor;

  const AppBase({
    super.key,
    required this.title,
    required this.routerConfig,
    required this.appLogo,
    required this.darkAppLogo,
    this.locale,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.localizationsDelegates,
    this.textScaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0x00000000), // Fully transparent
        systemNavigationBarColor: Color(0x00000000), // Fully transparent
        systemNavigationBarDividerColor: Color(0x00000000), // Fully transparent
      ),
    );

    // Enable edge-to-edge
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );

    final brightness = MediaQuery.of(context).platformBrightness;
    final colorMode = brightness == Brightness.dark
        ? AppThemeColorMode.dark
        : AppThemeColorMode.light;

    return AppResponsiveWrapper(
      child: AppResponsiveTheme(
        colorMode: colorMode,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: textScaleFactor ?? 1.0,
          ),
          child: WidgetsApp.router(
            routerConfig: routerConfig,
            builder: (context, child) {
              return AppScaffold(
                body: child ?? const SizedBox.shrink(),
              );
            },
            title: title,
            locale: locale,
            localizationsDelegates: localizationsDelegates,
            supportedLocales: supportedLocales,
            color: const Color(0xFF000000),
          ),
        ),
      ),
    );
  }
}
