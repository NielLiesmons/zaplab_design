// Community
import 'package:zaplab_design/zaplab_design.dart';

class Community {
  final String npub;
  final String profilePicUrl;
  final String communityName;
  final String? description;
  final List<Profile>? inYourNetwork;

  const Community({
    required this.npub,
    required this.profilePicUrl,
    required this.communityName,
    this.description,
    this.inYourNetwork,
  });
}

// Profile
typedef NostrProfileResolver = Future<Profile> Function(String identifier);
typedef NostrProfileSearch = Future<List<Profile>> Function(String query);

class Profile {
  final String npub;
  final String profileName;
  final String profilePicUrl;
  final void Function()? onTap;

  const Profile({
    required this.npub,
    required this.profileName,
    required this.profilePicUrl,
    this.onTap,
  });
}

// Message
class Message {
  final String nevent;
  final String npub;
  final String message;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;
  final List<Reaction> reactions;
  final List<Zap> zaps;

  const Message({
    required this.nevent,
    required this.npub,
    required this.message,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
    this.reactions = const [],
    this.zaps = const [],
  });
}

// Emoji
typedef NostrEmojiResolver = Future<String> Function(String identifier);
typedef NostrEmojiSearch = Future<List<Emoji>> Function(String query);

class Emoji {
  final String emojiUrl;
  final String emojiName;

  const Emoji({required this.emojiUrl, required this.emojiName});
}

// Reaction

class Reaction {
  final String npub;
  final String nevent;
  final String profileName;
  final String profilePicUrl;
  final String emojiUrl;
  final String emojiName;
  final DateTime? timestamp;
  final bool isOutgoing;

  const Reaction({
    required this.npub,
    required this.nevent,
    required this.profileName,
    required this.profilePicUrl,
    required this.emojiUrl,
    required this.emojiName,
    this.timestamp,
    this.isOutgoing = false,
  });
}

// Zap
class Zap {
  final String npub;
  final String nevent;
  final int amount;
  final String profileName;
  final String profilePicUrl;
  final String? message;
  final DateTime timestamp;
  final bool isOutgoing;

  const Zap({
    required this.npub,
    required this.nevent,
    required this.amount,
    required this.profileName,
    required this.profilePicUrl,
    this.message,
    required this.timestamp,
    this.isOutgoing = false,
  });
}

// Quoted Message
class QuotedMessage {
  final String nevent;
  final String content;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;

  const QuotedMessage({
    required this.nevent,
    required this.content,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
  });
}

// Event
typedef NostrEventResolver = Future<NostrEvent> Function(String identifier);

class NostrEvent {
  final String npub;
  final String nevent;
  final String contentType;
  final String? title;
  final String? message;
  final String? content;
  final String? imageUrl;
  final String profileName;
  final String profilePicUrl;
  final DateTime? timestamp;
  final String? amount;
  final void Function()? onTap;

  const NostrEvent({
    required this.npub,
    required this.nevent,
    required this.contentType,
    this.title,
    this.message,
    this.content,
    this.imageUrl,
    required this.profileName,
    required this.profilePicUrl,
    this.timestamp,
    this.onTap,
    this.amount,
  });
}

// Hashtag
typedef NostrHashtagResolver = Future<void Function()?> Function(
    String identifier);

// Links
typedef LinkTapHandler = void Function(String url);

// Post
class Post {
  final String npub;
  final String nevent;
  final String profileName;
  final String profilePicUrl;
  final String content;
  final DateTime timestamp;
  final List<Reaction> reactions;
  final List<Zap> zaps;

  const Post({
    required this.npub,
    required this.nevent,
    required this.profileName,
    required this.profilePicUrl,
    required this.content,
    required this.timestamp,
    this.reactions = const [],
    this.zaps = const [],
  });
}

// Article
class Article {
  final String npub;
  final String nevent;
  final String profileName;
  final String profilePicUrl;
  final String title;
  final String imageUrl;
  final String? content;
  final DateTime? timestamp;
  final List<Reaction>? reactions;
  final List<Zap>? zaps;
  final NostrEmojiResolver? onResolveEmoji;
  final NostrEventResolver? onResolveEvent;
  final NostrProfileResolver? onResolveProfile;
  final NostrHashtagResolver? onResolveHashtag;
  final LinkTapHandler? onLinkTap;

  const Article({
    required this.npub,
    required this.nevent,
    required this.profileName,
    required this.profilePicUrl,
    required this.title,
    required this.imageUrl,
    this.content,
    this.timestamp,
    this.reactions,
    this.zaps,
    this.onResolveEmoji,
    this.onResolveEvent,
    this.onResolveProfile,
    this.onResolveHashtag,
    this.onLinkTap,
  });
}
