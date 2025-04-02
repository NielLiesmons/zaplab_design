import 'package:zaplab_design/zaplab_design.dart';

class AppPostsFeed extends StatelessWidget {
  final List<Post> posts;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final void Function(String nevent)? onReply;
  final void Function(String nevent)? onActions;

  const AppPostsFeed({
    super.key,
    required this.posts,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    this.onReply,
    this.onActions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final post in posts)
          AppFeedPost(
            nevent: post.nevent,
            content: post.content,
            profileName: post.profileName,
            profilePicUrl: post.profilePicUrl,
            timestamp: post.timestamp,
            onReply: onReply ?? (_) {},
            onActions: onActions ?? (_) {},
            onReactionTap: (_) {}, // TODO: Implement reaction handling
            onZapTap: (_) {}, // TODO: Implement zap handling
            onResolveEvent: onResolveEvent,
            onResolveProfile: onResolveProfile,
            onResolveEmoji: onResolveEmoji,
            onResolveHashtag: onResolveHashtag,
            onLinkTap: onLinkTap,
          ),
      ],
    );
  }
}
