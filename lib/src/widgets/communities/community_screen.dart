import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

extension StringExtension on String {
  String formatTabLabel() {
    final capitalized = this[0].toUpperCase() + substring(1);
    return this == 'chat' || this == 'welcome' || this.endsWith('s')
        ? capitalized
        : '${capitalized}s';
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
  final Map<String, ({int count, Widget feed, Widget bottomBar})> contentTypes;
  // Other actions & settings
  final VoidCallback? onHomeTap;
  final VoidCallback? onNotificationsTap;
  final String? focusedMessageNmodel;
  // Short text rendering
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  // Actions on individual models
  final Function(Model) onActions;
  final Function(Model) onReply;
  final Function(Reaction) onReactionTap;
  final Function(Zap) onZapTap;
  // Initial tab
  final int? initialTab;
  // History
  final List<HistoryItem> history;

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
    this.focusedMessageNmodel,
    // Other actions & settings
    this.onHomeTap,
    this.onNotificationsTap,
    // Resolvers
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    // Actions on individual models
    required this.onActions,
    required this.onReply,
    required this.onReactionTap,
    required this.onZapTap,
    // Initial tab
    this.initialTab,
    // History
    this.history = const [],
  });

  @override
  State<AppCommunityScreen> createState() => _AppCommunityScreenState();
}

class _AppCommunityScreenState extends State<AppCommunityScreen> {
  late final AppTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = AppTabController(
      length: widget.contentTypes.length,
      initialIndex:
          widget.initialTab?.clamp(0, widget.contentTypes.length - 1) ?? 0,
    );
    _tabController.addListener(() {
      if (_tabController.index < 0 ||
          _tabController.index >= widget.contentTypes.length) {
        _tabController.animateTo(0);
      }
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
              AppProfilePic.s32(widget.community.author.value,
                  onTap: widget.onProfileTap),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AppGap.s12(),
                    Expanded(
                      child: TapBuilder(
                        onTap: widget.onProfileTap,
                        builder: (context, state, hasFocus) {
                          return AppText.bold14(
                            widget.community.author.value?.name ?? '',
                          );
                        },
                      ),
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
                                color: theme.colors.gray66,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: AppIcon(
                                  theme.icons.characters.bell,
                                  color: theme.colors.white33,
                                ),
                              ),
                            ),
                            if (mainCount > 0)
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
                                        color: theme.colors.whiteEnforced,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    if (mainCount > 0) const AppGap.s10(),
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
    if (_tabController.index < 0 ||
        _tabController.index >= contentTypes.length) {
      return const SizedBox.shrink();
    }
    final selectedType = contentTypes[_tabController.index];
    return widget.contentTypes[selectedType]?.feed ?? const SizedBox.shrink();
  }

  Widget _buildBottomBar() {
    final contentTypes = widget.contentTypes.keys.toList();
    if (_tabController.index < 0 ||
        _tabController.index >= contentTypes.length) {
      return const SizedBox.shrink();
    }
    final selectedType = contentTypes[_tabController.index];
    return widget.contentTypes[selectedType]?.bottomBar ??
        const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'AppCommunityScreen: History items: ${widget.history.map((i) => '${i.modelType} (${i.modelId})').join(', ')}');
    return AppScreen(
      alwaysShowTopBar: true,
      customTopBar: true,
      bottomBarContent: _buildBottomBar(),
      topBarContent: _buildTopBar(
        context,
        widget.mainCount ?? 0,
      ),
      onHomeTap: widget.onHomeTap ?? () {},
      history: widget.history,
      child: AppContainer(
        width: double.infinity,
        child: Column(
          children: [
            const AppGap.s80(),
            const AppGap.s24(),
            const AppGap.s2(),
            _buildContent(),
          ],
        ),
      ),
    );
  }
}
