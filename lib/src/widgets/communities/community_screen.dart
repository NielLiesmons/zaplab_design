import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

extension StringExtension on String {
  String formatTabLabel() {
    final capitalized = this[0].toUpperCase() + substring(1);
    return this == 'chat' ? capitalized : '${capitalized}s';
  }
}

class AppCommunityScreen extends StatefulWidget {
  // Profile related
  final Community community;
  final VoidCallback? onProfileTap;
  // Current profile
  final Profile currentProfile;
  // Content related
  final int? mainCount;
  final Map<String, ({int count, Widget feed})> contentTypes;
  // Other actions & settings
  final VoidCallback? onHomeTap;
  final VoidCallback? onNotificationsTap;
  final String? focusedMessageNevent;
  // Short text rendering
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  // Actions on individual events
  final Function(Event) onActions;
  final Function(Event) onReply;
  final Function(Reaction) onReactionTap;
  final Function(CashuZap) onZapTap;

  const AppCommunityScreen({
    super.key,
    // Profile related
    required this.community,
    this.onProfileTap,
    // Current user
    required this.currentProfile,
    // Content related
    this.mainCount,
    required this.contentTypes,
    this.focusedMessageNevent,
    // Other actions & settings
    this.onHomeTap,
    this.onNotificationsTap,
    // Resolvers
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    // Actions on individual events
    required this.onActions,
    required this.onReply,
    required this.onReactionTap,
    required this.onZapTap,
  });

  @override
  State<AppCommunityScreen> createState() => _AppCommunityScreenState();
}

class _AppCommunityScreenState extends State<AppCommunityScreen> {
  late final AppTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = AppTabController(length: widget.contentTypes.length + 1);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTopBar(
    BuildContext context,
    String profileName,
    String profilePicUrl,
    int mainCount,
  ) {
    final theme = AppTheme.of(context);
    final contentTypes = widget.contentTypes.keys.toList();

    return Column(
      children: [
        // Header
        AppContainer(
          padding: const AppEdgeInsets.only(
            left: AppGapSize.s12,
            right: AppGapSize.s12,
            top: AppGapSize.s4,
            bottom: AppGapSize.s12,
          ),
          child: Row(
            children: [
              AppProfilePic.s32(profilePicUrl, onTap: widget.onProfileTap),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AppGap.s12(),
                    TapBuilder(
                      onTap: widget.onProfileTap,
                      builder: (context, state, hasFocus) {
                        return Expanded(
                          child: AppText.bold14(
                            profileName,
                          ),
                        );
                      },
                    ),
                    TapBuilder(
                      onTap: widget.onNotificationsTap,
                      builder: (context, state, hasFocus) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AppContainer(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                color: theme.colors.grey66,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: AppIcon(
                                  theme.icons.characters.bell,
                                  color: theme.colors.white33,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -4,
                              right: -10,
                              child: AppContainer(
                                height: theme.sizes.s20,
                                padding: const AppEdgeInsets.symmetric(
                                  horizontal: AppGapSize.s6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: theme.colors.blurple,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 8,
                                  ),
                                  child: Center(
                                    child: AppText.med10(
                                      '$mainCount',
                                      color: AppColorsData.dark().white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const AppGap.s10(),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Tab view, used as a Tab Bar only. The actual Tab content is rendered in _buildContent()
        AppTabView(
          controller: _tabController,
          tabs: [
            for (final contentType in contentTypes)
              TabData(
                label: contentType.formatTabLabel(),
                icon: AppEmojiContentType(contentType: contentType),
                content: const SizedBox(),
                count: widget.contentTypes[contentType]?.count ?? 0,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    final contentTypes = widget.contentTypes.keys.toList();
    final selectedType = contentTypes[_tabController.index];
    return widget.contentTypes[selectedType]?.feed ?? const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      alwaysShowTopBar: true,
      customTopBar: true,
      bottomBarContent: const AppBottomBarChat(),
      topBarContent: _buildTopBar(
        context,
        widget.community.author.value?.name ?? '',
        widget.community.author.value?.pictureUrl ?? '',
        widget.mainCount ?? 0,
      ),
      onHomeTap: widget.onHomeTap ?? () {},
      child: AppContainer(
        width: double.infinity,
        child: Column(
          children: [
            const AppGap.s80(),
            const AppGap.s24(),
            const AppGap.s2(),
            _buildContent(),
            const AppGap.s16(),
            const AppGap.s38(),
            PlatformUtils.isMobile ? const AppGap.s4() : const AppGap.s16(),
            const AppBottomSafeArea()
          ],
        ),
      ),
    );
  }
}
