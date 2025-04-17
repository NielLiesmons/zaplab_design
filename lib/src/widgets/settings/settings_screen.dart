import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class AppSettingsScreen extends StatefulWidget {
  // Profiles in use
  final List<Profile> profiles;
  final Function(Profile) onSelect;
  final VoidCallback? onAddProfile;

  // Current profile
  final Profile currentProfile;

  // Settings sections
  // IF: you want to specify custom sections and/or widgets THEN: use this list
  final List<Widget>? settingSections;
  // IF: you are good with the presets THEN: use these
  final VoidCallback? onHistoryTap;
  final String? historyDescription;
  final VoidCallback? onDraftsTap;
  final String? draftsDescription;
  final VoidCallback? onLabelsTap;
  final String? labelsDescription;
  final VoidCallback? onAppearanceTap;
  final String? appearanceDescription;
  final VoidCallback? onHostingTap;
  final String? hostingDescription;
  final VoidCallback? onSecurityTap;
  final String? securityDescription;
  final VoidCallback? onOtherDevicesTap;
  final String? otherDevicesDescription;
  final VoidCallback? onInviteTap;
  final VoidCallback? onDisconnectTap;

  // Other actions & settings
  final VoidCallback? onHomeTap;

  const AppSettingsScreen({
    super.key,
    required this.profiles,
    required this.onSelect,
    this.onAddProfile,
    required this.currentProfile,
    this.settingSections,
    this.onHistoryTap,
    this.historyDescription,
    this.onDraftsTap,
    this.draftsDescription,
    this.onLabelsTap,
    this.labelsDescription,
    this.onAppearanceTap,
    this.appearanceDescription,
    this.onHostingTap,
    this.hostingDescription,
    this.onSecurityTap,
    this.securityDescription,
    this.onOtherDevicesTap,
    this.otherDevicesDescription,
    this.onInviteTap,
    this.onDisconnectTap,
    this.onHomeTap,
  });

  @override
  AppSettingsScreenState createState() => AppSettingsScreenState();
}

class AppSettingsScreenState extends State<AppSettingsScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _animateProfileChange() async {
    final theme = AppTheme.of(context);

    // First scroll to start
    await _scrollController.animateTo(
      0,
      duration: theme.durations.normal,
      curve: Curves.easeOut,
    );

    // Then pop the current profile card
    await _scaleController.forward();
    await _scaleController.reverse();
  }

  Widget _buildTopBar(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      child: Row(
        children: [
          // Header
          AppContainer(
            width: theme.sizes.s38,
            child: AppContainer(
              width: theme.sizes.s32,
              height: theme.sizes.s32,
              decoration: BoxDecoration(
                color: theme.colors.grey66,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppIcon.s20(theme.icons.characters.profile,
                    color: theme.colors.white33),
              ),
            ),
          ),
          const AppGap.s12(),
          const AppText.h2('Profiles'),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = AppTheme.of(context);
    final currentProfile = widget.profiles.firstWhere(
      (p) => p == widget.currentProfile,
      orElse: () =>
          widget.profiles.first, // Fallback to first profile if not found
    );

    // Use custom sections if provided, otherwise build preset sections
    final sectionWidgets =
        widget.settingSections ?? _buildPresetSections(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profiles section
        AppContainer(
          padding: const AppEdgeInsets.all(AppGapSize.s16),
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                ScaleTransition(
                  scale: Tween<double>(
                    begin: 1.0,
                    end: 1.04,
                  ).animate(CurvedAnimation(
                    parent: _scaleController,
                    curve: Curves.easeOut,
                  )),
                  child: AppCurrentProfileCard(
                    profile: currentProfile,
                    onView: () {
                      // TODO: Implement view profile
                    },
                    onEdit: () {
                      // TODO: Implement edit profile
                    },
                    onShare: () {
                      // TODO: Implement share profile
                    },
                  ),
                ),
                // Other profiles
                ...widget.profiles
                    .where((p) => p.npub != currentProfile.npub)
                    .map(
                      (profile) => Row(
                        children: [
                          const AppGap.s16(),
                          AppOtherProfileCard(
                            profile: profile,
                            onSelect: () {
                              widget.onSelect(profile);
                              _animateProfileChange();
                            },
                            onShare: () {
                              // TODO: Implement share profile
                            },
                          ),
                        ],
                      ),
                    ),
                // Add profile button
                const AppGap.s16(),
                TapBuilder(
                  onTap: widget.onAddProfile ?? () {},
                  builder: (context, state, hasFocus) {
                    double scaleFactor = 1.0;
                    if (state == TapState.pressed) {
                      scaleFactor = 0.98;
                    } else if (state == TapState.hover) {
                      scaleFactor = 1.02;
                    }

                    return Transform.scale(
                      scale: scaleFactor,
                      child: AppContainer(
                        width: 256,
                        height: 144,
                        padding: const AppEdgeInsets.all(AppGapSize.s16),
                        decoration: BoxDecoration(
                          color: theme.colors.grey33,
                          borderRadius: theme.radius.asBorderRadius().rad16,
                          border: Border.all(
                            color: theme.colors.grey,
                            width: LineThicknessData.normal().medium,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            AppContainer(
                              width: theme.sizes.s38,
                              height: theme.sizes.s38,
                              decoration: BoxDecoration(
                                color: theme.colors.white8,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: AppIcon.s16(
                                  theme.icons.characters.plus,
                                  outlineThickness:
                                      LineThicknessData.normal().thick,
                                  outlineColor: theme.colors.white33,
                                ),
                              ),
                            ),
                            const AppGap.s12(),
                            AppText.med14('Add Profile',
                                color: theme.colors.white33),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const AppDivider(),
        ...sectionWidgets,
      ],
    );
  }

  List<Widget> _buildPresetSections(BuildContext context) {
    final theme = AppTheme.of(context);
    final List<Widget> sections = [];

    // First group
    if (widget.onHistoryTap != null ||
        widget.onDraftsTap != null ||
        widget.onLabelsTap != null) {
      sections.add(AppContainer(
        padding: const AppEdgeInsets.all(AppGapSize.s16),
        child: Column(
          children: [
            if (widget.onHistoryTap != null)
              AppSettingSection(
                icon: AppIcon.s20(theme.icons.characters.clock,
                    gradient: theme.colors.greydient66),
                title: 'History',
                description: widget.historyDescription ?? '',
                onTap: widget.onHistoryTap,
              ),
            if (widget.onDraftsTap != null) ...[
              if (widget.onHistoryTap != null) const AppGap.s12(),
              AppSettingSection(
                icon: AppIcon.s20(theme.icons.characters.draft,
                    gradient: theme.colors.greydient66),
                title: 'Drafts',
                description: widget.draftsDescription ?? '',
                onTap: widget.onDraftsTap,
              ),
            ],
            if (widget.onLabelsTap != null) ...[
              if (widget.onHistoryTap != null || widget.onDraftsTap != null)
                const AppGap.s12(),
              AppSettingSection(
                icon: AppIcon.s20(theme.icons.characters.label,
                    gradient: theme.colors.greydient66),
                title: 'Labels',
                description: widget.labelsDescription ?? '',
                onTap: widget.onLabelsTap,
              ),
            ],
          ],
        ),
      ));
    }

    sections.add(const AppDivider());

    // Second group
    if (widget.onAppearanceTap != null ||
        widget.onHostingTap != null ||
        widget.onSecurityTap != null ||
        widget.onOtherDevicesTap != null) {
      sections.add(AppContainer(
        padding: const AppEdgeInsets.all(AppGapSize.s16),
        child: Column(
          children: [
            if (widget.onAppearanceTap != null)
              AppSettingSection(
                icon: AppIcon.s24(theme.icons.characters.appearance,
                    gradient: theme.colors.blurple),
                title: 'Appearance',
                description: widget.appearanceDescription ?? '',
                onTap: widget.onAppearanceTap,
              ),
            if (widget.onHostingTap != null) ...[
              if (widget.onAppearanceTap != null) const AppGap.s12(),
              AppSettingSection(
                icon: AppIcon.s20(theme.icons.characters.hosting,
                    gradient: theme.colors.blurple),
                title: 'Hosting',
                description: widget.hostingDescription ?? '',
                onTap: widget.onHostingTap,
              ),
            ],
            if (widget.onSecurityTap != null) ...[
              if (widget.onAppearanceTap != null || widget.onHostingTap != null)
                const AppGap.s12(),
              AppSettingSection(
                icon: AppIcon.s28(theme.icons.characters.security,
                    gradient: theme.colors.blurple),
                title: 'Security',
                description: widget.securityDescription ?? '',
                onTap: widget.onSecurityTap,
              ),
            ],
            if (widget.onOtherDevicesTap != null) ...[
              if (widget.onAppearanceTap != null ||
                  widget.onHostingTap != null ||
                  widget.onSecurityTap != null)
                const AppGap.s12(),
              AppSettingSection(
                icon: AppIcon.s20(theme.icons.characters.devices,
                    gradient: theme.colors.blurple),
                title: 'Other Devices',
                description: widget.otherDevicesDescription ?? '',
                onTap: widget.onOtherDevicesTap,
              ),
            ],
          ],
        ),
      ));
    }

    sections.add(const AppDivider());

    // Invite group
    if (widget.onInviteTap != null) {
      sections.add(AppContainer(
        padding: const AppEdgeInsets.all(AppGapSize.s16),
        child: AppSettingSection(
          icon: AppIcon.s20(theme.icons.characters.heart,
              gradient: theme.colors.rouge),
          title: 'Invite Someone',
          onTap: widget.onInviteTap,
        ),
      ));
    }

    sections.add(const AppDivider());

    // Disconnect group
    if (widget.onDisconnectTap != null) {
      sections.add(AppContainer(
        padding: const AppEdgeInsets.all(AppGapSize.s16),
        child: AppSettingSection(
          icon: AppIcon.s12(theme.icons.characters.cross,
              outlineColor: theme.colors.white33,
              outlineThickness: LineThicknessData.normal().thick),
          title: 'Disconnect Profile',
          onTap: widget.onDisconnectTap,
        ),
      ));
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      alwaysShowTopBar: true,
      topBarContent: _buildTopBar(context),
      onHomeTap: widget.onHomeTap ?? () {},
      child: AppContainer(
        width: double.infinity,
        child: Column(
          children: [
            const AppGap.s32(),
            const AppGap.s12(),
            _buildContent(context),
          ],
        ),
      ),
    );
  }
}
