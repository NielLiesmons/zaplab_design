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

class LabBase extends StatelessWidget {
  final String title;
  final RouterConfig<Object> routerConfig;
  final Widget? appLogo;
  final Widget? darkLabLogo;
  final Locale? locale;
  final List<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final double? textScaleFactor;
  final LabThemeColorMode? colorMode;
  final LabTextScale? textScale;
  final LabSystemScale? systemScale;
  final VoidCallback? onHomeTap;
  final VoidCallback? onBackTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onMailTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onProfilesTap;
  final Widget? historyMenu;
  final Profile? activeProfile;
  final LabColorsOverride? colorsOverride;

  LabBase({
    super.key,
    required this.title,
    required this.routerConfig,
    this.appLogo,
    this.darkLabLogo,
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
    this.onMailTap,
    this.onAddTap,
    this.onProfilesTap,
    this.historyMenu,
    this.activeProfile,
    this.colorsOverride,
  }) {
    // Initialize window settings for desktop platforms
    if (LabPlatformUtils.isDesktop) {
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
      child: LabResponsiveTheme(
        colorMode: colorMode,
        textScale: textScale,
        systemScale: systemScale,
        colorsOverride: colorsOverride,
        child: _LabBaseContent(
          title: title,
          routerConfig: routerConfig,
          appLogo: appLogo,
          darkLabLogo: darkLabLogo,
          locale: locale,
          supportedLocales: supportedLocales,
          localizationsDelegates: localizationsDelegates,
          textScaleFactor: textScaleFactor,
          colorMode: colorMode,
          onHomeTap: onHomeTap,
          onBackTap: onBackTap,
          onMailTap: onMailTap,
          onSearchTap: onSearchTap,
          onAddTap: onAddTap,
          onProfilesTap: onProfilesTap,
          historyWidget: historyMenu,
          activeProfile: activeProfile,
        ),
      ),
    );
  }
}

/// Internal widget that handles the actual base functionality
class _LabBaseContent extends StatefulWidget {
  final String title;
  final RouterConfig<Object> routerConfig;
  final Widget? appLogo;
  final Widget? darkLabLogo;
  final Locale? locale;
  final List<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final double? textScaleFactor;
  final LabThemeColorMode? colorMode;
  final VoidCallback? onHomeTap;
  final VoidCallback? onBackTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onMailTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onProfilesTap;
  final Widget? historyWidget;
  final Profile? activeProfile;

  const _LabBaseContent({
    required this.title,
    required this.routerConfig,
    this.appLogo,
    this.darkLabLogo,
    this.locale,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.localizationsDelegates,
    this.textScaleFactor,
    this.colorMode,
    this.onHomeTap,
    this.onBackTap,
    this.onSearchTap,
    this.onMailTap,
    this.onAddTap,
    this.onProfilesTap,
    this.historyWidget,
    this.activeProfile,
  });

  @override
  State<_LabBaseContent> createState() => _LabBaseContentState();
}

class _LabBaseContentState extends State<_LabBaseContent>
    with SingleTickerProviderStateMixin {
  bool _showHistoryMenu = false;
  late AnimationController _menuController;
  late Animation<double> _menuAnimation;

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      duration: LabDurationsData.normal().normal,
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
    if (!LabPlatformUtils.isWeb) {
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

    return LabResponsiveWrapper(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(widget.textScaleFactor ?? 1.0),
        ),
        child: WidgetsApp.router(
          routerConfig: widget.routerConfig,
          builder: (context, child) {
            return LabScaffold(
              body: Stack(
                children: [
                  Row(
                    children: [
                      // Sidebar (on desktop or web if any callbacks are provided)
                      if (!LabPlatformUtils.isMobile && _shouldShowSidebar)
                        LabContainer(
                          decoration: BoxDecoration(
                            color: LabTheme.of(context).colors.gray33,
                          ),
                          child: Row(
                            children: [
                              LabContainer(
                                padding: const LabEdgeInsets.all(LabGapSize.s4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const LabGap.s24(),
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
                                        icon: LabIcon.s20(
                                          LabTheme.of(context)
                                              .icons
                                              .characters
                                              .home,
                                          outlineColor: LabTheme.of(context)
                                              .colors
                                              .white66,
                                          outlineThickness:
                                              LabLineThicknessData.normal()
                                                  .medium,
                                        ),
                                        onTap: widget.onHomeTap!,
                                      ),
                                    if (widget.onMailTap != null)
                                      _buildSidebarItem(
                                        context,
                                        icon: LabIcon.s20(
                                          LabTheme.of(context)
                                              .icons
                                              .characters
                                              .mail,
                                          outlineColor: LabTheme.of(context)
                                              .colors
                                              .white66,
                                          outlineThickness:
                                              LabLineThicknessData.normal()
                                                  .medium,
                                        ),
                                        onTap: widget.onMailTap!,
                                      ),
                                    if (widget.onSearchTap != null)
                                      _buildSidebarItem(
                                        context,
                                        icon: LabIcon.s20(
                                          LabTheme.of(context)
                                              .icons
                                              .characters
                                              .search,
                                          outlineColor: LabTheme.of(context)
                                              .colors
                                              .white66,
                                          outlineThickness:
                                              LabLineThicknessData.normal()
                                                  .medium,
                                        ),
                                        onTap: widget.onSearchTap!,
                                      ),
                                    if (widget.onAddTap != null)
                                      _buildSidebarItem(
                                        context,
                                        icon: LabIcon.s20(
                                          LabTheme.of(context)
                                              .icons
                                              .characters
                                              .plus,
                                          outlineColor: LabTheme.of(context)
                                              .colors
                                              .white66,
                                          outlineThickness:
                                              LabLineThicknessData.normal()
                                                  .medium,
                                        ),
                                        onTap: widget.onAddTap!,
                                      ),
                                    const Spacer(),
                                    if (widget.onProfilesTap != null &&
                                        widget.activeProfile != null)
                                      LabProfilePic.s38(widget.activeProfile!,
                                          onTap: widget.onProfilesTap!),
                                    const LabGap.s12(),
                                  ],
                                ),
                              ),
                              LabContainer(
                                width: 1.4,
                                decoration: BoxDecoration(
                                  color: LabTheme.of(context).colors.white8,
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
                                  child: LabContainer(
                                    decoration: BoxDecoration(
                                      color:
                                          LabTheme.of(context).colors.black33,
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
                                      child: LabContainer(
                                        width: 320,
                                        decoration: BoxDecoration(
                                          color: LabTheme.of(context)
                                              .colors
                                              .gray66,
                                          border: Border(
                                            right: BorderSide(
                                              color: LabTheme.of(context)
                                                  .colors
                                                  .white16,
                                              width:
                                                  LabLineThicknessData.normal()
                                                      .thin,
                                            ),
                                          ),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const LabGap.s20(),
                                              LabContainer(
                                                padding:
                                                    const LabEdgeInsets.all(
                                                        LabGapSize.s12),
                                                child: LabScope(
                                                  isInsideScope: true,
                                                  child: widget.historyWidget!,
                                                ),
                                              ),
                                            ],
                                          ),
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
          color: LabTheme.of(context).colors.white,
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
    final theme = LabTheme.of(context);
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
            child: LabContainer(
              height: 38,
              width: 38,
              margin: const LabEdgeInsets.all(LabGapSize.s4),
              padding: isMenuOpen && showHistoryControls
                  ? const LabEdgeInsets.all(LabGapSize.none)
                  : const LabEdgeInsets.only(right: LabGapSize.s2),
              decoration: BoxDecoration(
                color: theme.colors.white8,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isMenuOpen && showHistoryControls
                    ? LabIcon.s14(
                        theme.icons.characters.cross,
                        outlineColor: theme.colors.white66,
                        outlineThickness: LabLineThicknessData.normal().medium,
                      )
                    : LabIcon.s16(
                        theme.icons.characters.chevronLeft,
                        outlineColor: theme.colors.white66,
                        outlineThickness: LabLineThicknessData.normal().medium,
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
    final theme = LabTheme.of(context);
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
            child: LabContainer(
              height: 48,
              width: 48,
              margin: const LabEdgeInsets.symmetric(
                vertical: LabGapSize.s2,
                horizontal: LabGapSize.s4,
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
