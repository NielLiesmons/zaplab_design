import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'dart:io';

extension StringExtension on String {
  String formatTabLabel() {
    final capitalized = this[0].toUpperCase() + substring(1);
    return this == 'chat' ? capitalized : '${capitalized}s';
  }
}

class AppChatScreen extends StatefulWidget {
  const AppChatScreen({
    super.key,
    required this.npub,
    required this.profileName,
    required this.profilePicUrl,
    required this.messages,
    required this.posts,
    required this.articles,
    required this.currentNpub,
    this.focusedMessageNevent,
    this.mainCount,
    required this.contentCounts,
    this.onNostrEvent,
    this.onHomeTap,
  });

  final String npub;
  final String profileName;
  final String profilePicUrl;
  final List<Message> messages;
  final List<Post> posts;
  final List<Article> articles;
  final String currentNpub;
  final String? focusedMessageNevent;
  final int? mainCount;
  final Map<String, int> contentCounts;
  final void Function(NostrEvent event)? onNostrEvent;
  final VoidCallback? onHomeTap;

  @override
  State<AppChatScreen> createState() => _AppChatScreenState();
}

class _AppChatScreenState extends State<AppChatScreen> {
  late final AppTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = AppTabController(length: widget.contentCounts.length + 1);
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
    final contentTypes = widget.contentCounts.keys.toList();

    return Column(
      children: [
        // Your existing header
        AppContainer(
          padding: const AppEdgeInsets.only(
            left: AppGapSize.s12,
            right: AppGapSize.s12,
            top: AppGapSize.s4,
            bottom: AppGapSize.s12,
          ),
          child: Row(
            children: [
              AppProfilePic.s32(profilePicUrl),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AppGap.s12(),
                    Expanded(
                      child: AppText.bold14(
                        profileName,
                      ),
                    ),
                    Stack(
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
                    ),
                    const AppGap.s10(),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Modified tab bar
        AppTabView(
          controller: _tabController,
          tabs: [
            for (final contentType in contentTypes)
              TabData(
                label: contentType.formatTabLabel(),
                icon: AppEmojiContentType(contentType: contentType),
                content: const SizedBox(),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    final contentTypes = widget.contentCounts.keys.toList();
    final selectedType = contentTypes[_tabController.index];

    switch (selectedType) {
      case 'chat':
        return AppChatFeed(
          messages: widget.messages,
          currentNpub: widget.currentNpub,
          onResolveEvent: (id) async => throw UnimplementedError(),
          onResolveProfile: (id) async => throw UnimplementedError(),
          onResolveEmoji: (id) async => throw UnimplementedError(),
          onResolveHashtag: (id) async => throw UnimplementedError(),
          onLinkTap: (url) async => throw UnimplementedError(),
        );
      case 'post':
        return AppPostsFeed(
          posts: widget.posts,
          onResolveEvent: (id) async => throw UnimplementedError(),
          onResolveProfile: (id) async => throw UnimplementedError(),
          onResolveEmoji: (id) async => throw UnimplementedError(),
          onResolveHashtag: (id) async => throw UnimplementedError(),
          onLinkTap: (url) async => throw UnimplementedError(),
        );
      case 'article':
        return AppArticlesFeed(
          articles: widget.articles,
          onTap: (url) async => throw UnimplementedError(),
        );
      default:
        return Center(
          child: AppText.h1(selectedType.formatTabLabel()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      alwaysShowTopBar: true,
      customTopBar: true,
      bottomBarContent: const AppBottomBarChat(),
      topBarContent: _buildTopBar(
        context,
        widget.profileName,
        widget.profilePicUrl,
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
            (Platform.isIOS || Platform.isAndroid)
                ? const AppGap.s4()
                : const AppGap.s16(),
            const AppBottomSafeArea()
          ],
        ),
      ),
    );
  }
}
