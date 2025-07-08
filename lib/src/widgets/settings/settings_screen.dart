import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class LabSettingsScreen extends StatefulWidget {
  // Profiles in use
  final List<Profile> profiles;
  final Function(Profile) onSelect;
  final VoidCallback? onAddProfile;
  final Function(Profile)? onViewProfile;

  // Current profile
  final Profile activeProfile;

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
  final VoidCallback? onPreferencesTap;
  final String? preferencesDescription;
  final VoidCallback? onHostingTap;
  final String? hostingDescription;
  final List<HostingStatus>? hostingStatuses;
  final VoidCallback? onSignerTap;
  final String? signerDescription;
  final VoidCallback? onInviteTap;
  final VoidCallback? onDisconnectTap;

  // Other actions & settings
  final VoidCallback? onHomeTap;

  const LabSettingsScreen({
    super.key,
    required this.profiles,
    required this.onSelect,
    this.onAddProfile,
    this.onViewProfile,
    required this.activeProfile,
    this.settingSections,
    this.onHistoryTap,
    this.historyDescription,
    this.onDraftsTap,
    this.draftsDescription,
    this.onLabelsTap,
    this.labelsDescription,
    this.onPreferencesTap,
    this.preferencesDescription,
    this.onHostingTap,
    this.hostingDescription,
    this.hostingStatuses,
    this.onSignerTap,
    this.signerDescription,
    this.onInviteTap,
    this.onDisconnectTap,
    this.onHomeTap,
  });

  @override
  LabSettingsScreenState createState() => LabSettingsScreenState();
}

class LabSettingsScreenState extends State<LabSettingsScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _scaleController;
  Profile? _visuallyActiveProfile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _visuallyActiveProfile = widget.activeProfile;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LabSettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeProfile != oldWidget.activeProfile) {
      _visuallyActiveProfile = widget.activeProfile;
    }
  }

  Future<void> _animateProfileChange(VoidCallback onComplete) async {
    final theme = LabTheme.of(context);

    // First scroll to start
    await _scrollController.animateTo(
      0,
      duration: theme.durations.normal,
      curve: Curves.easeOut,
    );

    // Then pop the current profile card
    await _scaleController.forward();
    await _scaleController.reverse();

    // Add a longer delay to ensure animations are complete
    await Future.delayed(const Duration(milliseconds: 1000));

    onComplete();
  }

  Widget _buildTopBar(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabContainer(
      child: Row(
        children: [
          // Header
          LabContainer(
            width: theme.sizes.s38,
            child: LabContainer(
              width: theme.sizes.s32,
              height: theme.sizes.s32,
              decoration: BoxDecoration(
                color: theme.colors.gray66,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: LabIcon.s20(theme.icons.characters.profile,
                    color: theme.colors.white33),
              ),
            ),
          ),
          const LabGap.s12(),
          const LabText.h2('Profiles'),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = LabTheme.of(context);
    final activeProfile = _visuallyActiveProfile;

    if (activeProfile == null) {
      return const SizedBox.shrink();
    }

    // Use custom sections if provided, otherwise build preset sections
    final sectionWidgets =
        widget.settingSections ?? _buildPresetSections(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profiles section
        LabContainer(
          padding: const LabEdgeInsets.all(LabGapSize.s16),
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
                  child: AppactiveProfileCard(
                    profile: activeProfile,
                    onView: () {
                      widget.onViewProfile?.call(activeProfile);
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
                    .where((p) => p.npub != activeProfile.npub)
                    .map(
                      (profile) => Row(
                        children: [
                          const LabGap.s16(),
                          LabOtherProfileCard(
                            profile: profile,
                            onView: () {
                              widget.onViewProfile?.call(profile);
                            },
                            onSelect: () {
                              setState(() {
                                _visuallyActiveProfile = profile;
                                _isLoading = true;
                              });
                              _animateProfileChange(() {
                                widget.onSelect(profile);
                                setState(() {
                                  _isLoading = false;
                                });
                              });
                            },
                            onShare: () {
                              // TODO: Implement share profile
                            },
                          ),
                        ],
                      ),
                    ),
                // Add profile button
                const LabGap.s16(),
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
                      child: LabContainer(
                        width: 256,
                        height: 144,
                        padding: const LabEdgeInsets.all(LabGapSize.s16),
                        decoration: BoxDecoration(
                          color: theme.colors.gray33,
                          borderRadius: theme.radius.asBorderRadius().rad16,
                          border: Border.all(
                            color: theme.colors.gray,
                            width: LabLineThicknessData.normal().medium,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            LabContainer(
                              width: theme.sizes.s38,
                              height: theme.sizes.s38,
                              decoration: BoxDecoration(
                                color: theme.colors.white8,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: LabIcon.s16(
                                  theme.icons.characters.plus,
                                  outlineThickness:
                                      LabLineThicknessData.normal().thick,
                                  outlineColor: theme.colors.white33,
                                ),
                              ),
                            ),
                            const LabGap.s12(),
                            LabText.med14('Add Profile',
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
        const LabDivider(),
        if (_isLoading)
          LabContainer(
            padding: const LabEdgeInsets.all(LabGapSize.s32),
            child: Column(
              children: [
                LabContainer(
                  height: theme.sizes.s48,
                  child: LabLoadingDots(color: theme.colors.white66),
                ),
                LabText.med14('Loading Profile...',
                    color: theme.colors.white33),
              ],
            ),
          )
        else
          ...sectionWidgets,
      ],
    );
  }

  List<Widget> _buildPresetSections(BuildContext context) {
    final theme = LabTheme.of(context);
    final List<Widget> sections = [];

    // First group
    if (widget.onHistoryTap != null ||
        widget.onDraftsTap != null ||
        widget.onLabelsTap != null) {
      sections.add(LabContainer(
        padding: const LabEdgeInsets.all(LabGapSize.s16),
        child: Column(
          children: [
            if (widget.onHistoryTap != null)
              LabSettingSection(
                icon: LabIcon.s20(theme.icons.characters.clock,
                    gradient: theme.colors.graydient66),
                title: 'History',
                description: widget.historyDescription ?? '',
                onTap: widget.onHistoryTap,
              ),
            if (widget.onDraftsTap != null) ...[
              if (widget.onHistoryTap != null) const LabGap.s12(),
              LabSettingSection(
                icon: LabIcon.s20(theme.icons.characters.draft,
                    gradient: theme.colors.graydient66),
                title: 'Drafts',
                description: widget.draftsDescription ?? '',
                onTap: widget.onDraftsTap,
              ),
            ],
            if (widget.onLabelsTap != null) ...[
              if (widget.onHistoryTap != null || widget.onDraftsTap != null)
                const LabGap.s12(),
              LabSettingSection(
                icon: LabIcon.s24(theme.icons.characters.label,
                    gradient: theme.colors.graydient66),
                title: 'Labels',
                description: widget.labelsDescription ?? '',
                onTap: widget.onLabelsTap,
              ),
            ],
          ],
        ),
      ));
    }

    sections.add(const LabDivider());

    if (widget.onPreferencesTap != null) {
      sections.add(LabContainer(
        padding: const LabEdgeInsets.all(LabGapSize.s16),
        child: LabSettingSection(
          icon: LabIcon.s24(theme.icons.characters.appearance,
              gradient: theme.colors.gold),
          title: 'Preferences',
          description: widget.preferencesDescription ?? '',
          onTap: widget.onPreferencesTap,
        ),
      ));
    }

    sections.add(const LabDivider());

    if (widget.onSignerTap != null) {
      sections.add(LabContainer(
        padding: const LabEdgeInsets.all(LabGapSize.s16),
        child: LabSettingSection(
          title: 'Signer & Secret Key',
          icon: LabIcon.s32(theme.icons.characters.security,
              gradient: theme.colors.blurple),
          description: widget.signerDescription ?? '',
          onTap: widget.onSignerTap,
        ),
      ));
    }

    sections.add(const LabDivider());

    // Invite group0
    if (widget.onInviteTap != null) {
      sections.add(
        LabContainer(
          padding: const LabEdgeInsets.all(LabGapSize.s16),
          child: LabSettingSection(
            icon: LabIcon.s20(theme.icons.characters.heart,
                gradient: theme.colors.rouge),
            title: 'Invite Someone',
            description: 'To a Community, a Group or this App',
            onTap: widget.onInviteTap,
          ),
        ),
      );
    }

    sections.add(const LabDivider());

    if (widget.onHostingTap != null) {
      sections.add(LabContainer(
        padding: const LabEdgeInsets.all(LabGapSize.s16),
        child: LabSettingSection(
          icon: LabIcon.s20(theme.icons.characters.hosting,
              gradient: theme.colors.blurple),
          title: 'Hosting',
          description: widget.hostingDescription ?? '',
          hostingStatuses: widget.hostingStatuses,
          onTap: widget.onHostingTap,
        ),
      ));
    }

    sections.add(const LabDivider());

    if (widget.onDisconnectTap != null) {
      sections.add(
        LabContainer(
          padding: const LabEdgeInsets.all(LabGapSize.s16),
          child: LabButton(
            onTap: widget.onDisconnectTap,
            color: theme.colors.gray66,
            children: [
              LabText.med14('Disconnect Profile', color: theme.colors.white66)
            ],
          ),
        ),
      );
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return LabScreen(
      alwaysShowTopBar: true,
      topBarContent: _buildTopBar(context),
      onHomeTap: widget.onHomeTap ?? () {},
      child: LabContainer(
        width: double.infinity,
        child: Column(
          children: [
            const LabGap.s32(),
            const LabGap.s12(),
            _buildContent(context),
          ],
        ),
      ),
    );
  }
}
