import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zaplab_design/zaplab_design.dart';

// Define window size constraints
const kMinWindowWidth = 400.0;
const kMinWindowHeight = 640.0;
const kMaxWindowWidth = 640.0;
const kMaxWindowHeight = 1280.0;
const kDefaultWindowWidth = 480.0;
const kDefaultWindowHeight = 776.0;

class AppBase extends StatelessWidget {
  final String title;
  final RouterConfig<Object> routerConfig;
  final Widget? appLogo;
  final Widget? darkAppLogo;
  final Locale? locale;
  final List<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final double? textScaleFactor;
  final AppThemeColorMode? colorMode;
  final AppTextScale? textScale;
  final AppSystemScale? systemScale;

  AppBase({
    super.key,
    required this.title,
    required this.routerConfig,
    this.appLogo,
    this.darkAppLogo,
    this.locale,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.localizationsDelegates,
    this.textScaleFactor,
    this.colorMode,
    this.textScale,
    this.systemScale,
  }) {
    // Initialize window settings for desktop platforms
    if (PlatformUtils.isDesktop) {
      windowManager.ensureInitialized();
      windowManager
          .setMinimumSize(const Size(kMinWindowWidth, kMinWindowHeight));
      windowManager
          .setMaximumSize(const Size(kMaxWindowWidth, kMaxWindowHeight));
      windowManager
          .setSize(const Size(kDefaultWindowWidth, kDefaultWindowHeight));
      windowManager.center();
      windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    }
  }

  @override
  Widget build(BuildContext context) {
    return createPlatformWrapper(
      child: AppResponsiveTheme(
        colorMode: colorMode,
        textScale: textScale,
        systemScale: systemScale,
        child: _AppBaseContent(
          title: title,
          routerConfig: routerConfig,
          appLogo: appLogo,
          darkAppLogo: darkAppLogo,
          locale: locale,
          supportedLocales: supportedLocales,
          localizationsDelegates: localizationsDelegates,
          textScaleFactor: textScaleFactor,
          colorMode: colorMode,
        ),
      ),
    );
  }
}

/// Internal widget that handles the actual base functionality
class _AppBaseContent extends StatelessWidget {
  final String title;
  final RouterConfig<Object> routerConfig;
  final Widget? appLogo;
  final Widget? darkAppLogo;
  final Locale? locale;
  final List<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final double? textScaleFactor;
  final AppThemeColorMode? colorMode;

  const _AppBaseContent({
    required this.title,
    required this.routerConfig,
    this.appLogo,
    this.darkAppLogo,
    this.locale,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.localizationsDelegates,
    this.textScaleFactor,
    this.colorMode,
  });

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style for native platforms only
    if (!PlatformUtils.isWeb) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Color(0x00000000),
          systemNavigationBarColor: Color(0x00000000),
          systemNavigationBarDividerColor: Color(0x00000000),
        ),
      );

      // Enable edge-to-edge
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
      );
    }

    return AppResponsiveWrapper(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScaleFactor ?? 1.0),
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
    );
  }
}
