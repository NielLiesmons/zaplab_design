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
            nevent: 'nevent1bla', //  TODO
            content: post.content,
            profileName: post.event.pubkey,
            profilePicUrl: 'profile-pic!', // TODO
            timestamp: post.event.createdAt,
            onReply: (_) {}, // TODO: Implement reply handling
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
