import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'dart:ui';
import 'package:models/models.dart';

// Define window size constraints
const kMinWindowWidth = 500.0;
const kMinWindowHeight = 640.0;
const kMaxWindowWidth = 720.0;
const kMaxWindowHeight = 1280.0;
const kDefaultWindowWidth = 580.0;
const kDefaultWindowHeight = 800.0;

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
  final VoidCallback? onHomeTap;
  final VoidCallback? onBackTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onProfilesTap;
  final Widget? historyMenu;
  final Profile? currentProfile;

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
    this.onHomeTap,
    this.onBackTap,
    this.onSearchTap,
    this.onAddTap,
    this.onProfilesTap,
    this.historyMenu,
    this.currentProfile,
  }) {
    // Initialize window settings for desktop platforms
    if (PlatformUtils.isDesktop) {
      windowManager.ensureInitialized();
      windowManager
          .setMinimumSize(const Size(kMinWindowWidth, kMinWindowHeight));
      windowManager
          .setMaximumSize(const Size(kMaxWindowWidth, kMaxWindowHeight));

      // Only set default size if window has never been opened before
      windowManager.getSize().then((size) {
        if (size.width == 0 && size.height == 0) {
          windowManager
              .setSize(const Size(kDefaultWindowWidth, kDefaultWindowHeight));
          windowManager.center();
        }
      });

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
          onHomeTap: onHomeTap,
          onBackTap: onBackTap,
          onSearchTap: onSearchTap,
          onAddTap: onAddTap,
          onProfilesTap: onProfilesTap,
          historyWidget: historyMenu,
          currentProfile: currentProfile,
        ),
      ),
    );
  }
}

/// Internal widget that handles the actual base functionality
class _AppBaseContent extends StatefulWidget {
  final String title;
  final RouterConfig<Object> routerConfig;
  final Widget? appLogo;
  final Widget? darkAppLogo;
  final Locale? locale;
  final List<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final double? textScaleFactor;
  final AppThemeColorMode? colorMode;
  final VoidCallback? onHomeTap;
  final VoidCallback? onBackTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onProfilesTap;
  final Widget? historyWidget;
  final Profile? currentProfile;

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
    this.onHomeTap,
    this.onBackTap,
    this.onSearchTap,
    this.onAddTap,
    this.onProfilesTap,
    this.historyWidget,
    this.currentProfile,
  });

  @override
  State<_AppBaseContent> createState() => _AppBaseContentState();
}

class _AppBaseContentState extends State<_AppBaseContent>
    with SingleTickerProviderStateMixin {
  bool _showHistoryMenu = false;
  late AnimationController _menuController;
  late Animation<double> _menuAnimation;

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      duration: AppDurationsData.normal().normal,
      vsync: this,
    );
    _menuAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  void _toggleHistoryMenu(bool show) {
    setState(() {
      _showHistoryMenu = show;
      if (show) {
        _menuController.forward(from: 0);
      } else {
        _menuController.reverse();
      }
    });
  }

  bool get _shouldShowSidebar =>
      widget.onHomeTap != null ||
      widget.onBackTap != null ||
      widget.onSearchTap != null;

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
          textScaler: TextScaler.linear(widget.textScaleFactor ?? 1.0),
        ),
        child: WidgetsApp.router(
          routerConfig: widget.routerConfig,
          builder: (context, child) {
            return AppScaffold(
              body: Stack(
                children: [
                  Row(
                    children: [
                      // Sidebar (on desktop or web if any callbacks are provided)
                      if (!PlatformUtils.isMobile && _shouldShowSidebar)
                        AppContainer(
                          decoration: BoxDecoration(
                            color: AppTheme.of(context).colors.gray33,
                          ),
                          child: Row(
                            children: [
                              AppContainer(
                                padding: const AppEdgeInsets.all(AppGapSize.s4),
                                child: Column(
                                  children: [
                                    const AppGap.s24(),
                                    if (widget.onBackTap != null)
                                      GestureDetector(
                                        onLongPress:
                                            widget.historyWidget != null
                                                ? () => _toggleHistoryMenu(true)
                                                : null,
                                        onSecondaryTap:
                                            widget.historyWidget != null
                                                ? () => _toggleHistoryMenu(true)
                                                : null,
                                        child: _buildBackButton(
                                          context,
                                          onTap: _showHistoryMenu
                                              ? () => _toggleHistoryMenu(false)
                                              : widget.onBackTap!,
                                          isMenuOpen: _showHistoryMenu,
                                          showHistoryControls:
                                              widget.historyWidget != null,
                                        ),
                                      ),
                                    if (widget.onHomeTap != null)
                                      _buildSidebarItem(
                                        context,
                                        icon: AppIcon.s20(
                                          AppTheme.of(context)
                                              .icons
                                              .characters
                                              .home,
                                          outlineColor: AppTheme.of(context)
                                              .colors
                                              .white66,
                                          outlineThickness:
                                              LineThicknessData.normal().medium,
                                        ),
                                        onTap: widget.onHomeTap!,
                                      ),
                                    if (widget.onSearchTap != null)
                                      _buildSidebarItem(
                                        context,
                                        icon: AppIcon.s20(
                                          AppTheme.of(context)
                                              .icons
                                              .characters
                                              .search,
                                          outlineColor: AppTheme.of(context)
                                              .colors
                                              .white66,
                                          outlineThickness:
                                              LineThicknessData.normal().medium,
                                        ),
                                        onTap: widget.onSearchTap!,
                                      ),
                                    if (widget.onAddTap != null)
                                      _buildSidebarItem(
                                        context,
                                        icon: AppIcon.s20(
                                          AppTheme.of(context)
                                              .icons
                                              .characters
                                              .plus,
                                          outlineColor: AppTheme.of(context)
                                              .colors
                                              .white66,
                                          outlineThickness:
                                              LineThicknessData.normal().medium,
                                        ),
                                        onTap: widget.onAddTap!,
                                      ),
                                    const Spacer(),
                                    if (widget.onProfilesTap != null &&
                                        widget.currentProfile != null)
                                      AppProfilePic.s38(
                                          widget.currentProfile!.pictureUrl ??
                                              '',
                                          onTap: widget.onProfilesTap!),
                                    const AppGap.s12(),
                                  ],
                                ),
                              ),
                              AppContainer(
                                width: 1.4,
                                decoration: BoxDecoration(
                                  color: AppTheme.of(context).colors.white8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Main content area
                      Expanded(
                        child: child ?? const SizedBox.shrink(),
                      )
                    ],
                  ),
                  if (_showHistoryMenu && widget.historyWidget != null)
                    Positioned.fill(
                      child: Stack(
                        children: [
                          // Semi-transparent overlay
                          Positioned(
                            left: 64,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () => _toggleHistoryMenu(false),
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                  child: AppContainer(
                                    decoration: BoxDecoration(
                                      color:
                                          AppTheme.of(context).colors.black33,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // History menu
                          Positioned(
                            left: 64,
                            top: 0,
                            bottom: 0,
                            child: ClipRect(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                                child: AnimatedBuilder(
                                  animation: _menuAnimation,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(
                                        -240 * (1 - _menuAnimation.value),
                                        0,
                                      ),
                                      child: AppContainer(
                                        width: 240,
                                        decoration: BoxDecoration(
                                          color: AppTheme.of(context)
                                              .colors
                                              .gray66,
                                          border: Border(
                                            right: BorderSide(
                                              color: AppTheme.of(context)
                                                  .colors
                                                  .white16,
                                              width: LineThicknessData.normal()
                                                  .thin,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            const AppGap.s20(),
                                            AppContainer(
                                              padding: const AppEdgeInsets.all(
                                                  AppGapSize.s12),
                                              child: widget.historyWidget!,
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
          title: widget.title,
          locale: widget.locale,
          localizationsDelegates: widget.localizationsDelegates,
          supportedLocales: widget.supportedLocales,
          color: AppTheme.of(context).colors.white,
        ),
      ),
    );
  }

  Widget _buildBackButton(
    BuildContext context, {
    required VoidCallback onTap,
    bool isMenuOpen = false,
    bool showHistoryControls = false,
  }) {
    final theme = AppTheme.of(context);
    return MouseRegion(
      child: TapBuilder(
        onTap: onTap,
        builder: (context, state, isFocused) {
          double scaleFactor = 1.0;
          if (state == TapState.pressed) {
            scaleFactor = 0.97;
          } else if (state == TapState.hover) {
            scaleFactor = 1.01;
          }

          return Transform.scale(
            scale: scaleFactor,
            child: AppContainer(
              height: 38,
              width: 38,
              margin: const AppEdgeInsets.all(AppGapSize.s4),
              padding: isMenuOpen && showHistoryControls
                  ? const AppEdgeInsets.all(AppGapSize.none)
                  : const AppEdgeInsets.only(right: AppGapSize.s2),
              decoration: BoxDecoration(
                color: theme.colors.white8,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isMenuOpen && showHistoryControls
                    ? AppIcon.s14(
                        theme.icons.characters.cross,
                        outlineColor: theme.colors.white66,
                        outlineThickness: LineThicknessData.normal().medium,
                      )
                    : AppIcon.s16(
                        theme.icons.characters.chevronLeft,
                        outlineColor: theme.colors.white66,
                        outlineThickness: LineThicknessData.normal().medium,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSidebarItem(
    BuildContext context, {
    required Widget icon,
    required VoidCallback onTap,
  }) {
    final theme = AppTheme.of(context);
    return MouseRegion(
      child: TapBuilder(
        onTap: onTap,
        builder: (context, state, isFocused) {
          double scaleFactor = 1.0;
          if (state == TapState.pressed) {
            scaleFactor = 0.97;
          } else if (state == TapState.hover) {
            scaleFactor = 1.01;
          }

          return Transform.scale(
            scale: scaleFactor,
            child: AppContainer(
              height: 48,
              width: 48,
              margin: const AppEdgeInsets.symmetric(
                vertical: AppGapSize.s2,
                horizontal: AppGapSize.s4,
              ),
              decoration: BoxDecoration(
                color: state == TapState.hover ||
                        state == TapState.pressed ||
                        isFocused
                    ? theme.colors.white8
                    : null,
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: Center(
                child: icon,
              ),
            ),
          );
        },
      ),
    );
  }
}
