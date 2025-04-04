// feed of AppFeedPost

import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppPostsFeed extends StatelessWidget {
  final List<Note> posts;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;

  const AppPostsFeed({
    super.key,
    required this.posts,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final post in posts)
          AppFeedPost(
            nevent: post.internal.shareableId,
            content: post.content,
            profileName: post.author.value!.nameOrNpub,
            profilePicUrl: post.author.value!.pictureUrl!,
            timestamp: post.createdAt,
            onReply: (_) {}, // TODO: Implement reply handling
            onActions: (_) {}, // TODO: Implement actions handling
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
