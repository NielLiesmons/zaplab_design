import 'package:flutter/foundation.dart';
import 'package:models/models.dart';

// Cashu Zap
class CashuZap extends RegularEvent<CashuZap> {
  CashuZap.fromMap(super.map, super.ref) : super.fromMap();

  String get content => internal.content;
  int get amount =>
      int.tryParse(internal.getFirstTagValue('amount') ?? '0') ?? 0;
}

// Community
class ReplaceCommunity {
  final String npub;
  final String profilePicUrl;
  final String communityName;
  final String? description;
  final List<ReplaceProfile>? inYourNetwork;

  const ReplaceCommunity({
    required this.npub,
    required this.profilePicUrl,
    required this.communityName,
    this.description,
    this.inYourNetwork,
  });
}

// Profile
typedef NostrProfileResolver = Future<ReplaceProfile> Function(
    String identifier);
typedef NostrProfileSearch = Future<List<ReplaceProfile>> Function(
    String query);

class ReplaceProfile {
  final String npub;
  final String profileName;
  final String profilePicUrl;
  final void Function()? onTap;

  const ReplaceProfile({
    required this.npub,
    required this.profileName,
    required this.profilePicUrl,
    this.onTap,
  });
}

// Message
class ReplaceMessage {
  final String nevent;
  final String npub;
  final String? message;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;
  final List<ReplaceReaction> reactions;
  final List<ReplaceZap> zaps;
  final bool? isTyping;

  const ReplaceMessage({
    required this.nevent,
    required this.npub,
    this.message,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
    this.reactions = const [],
    this.zaps = const [],
    this.isTyping,
  });
}

// Emoji
typedef NostrEmojiResolver = Future<String> Function(String identifier);
typedef NostrEmojiSearch = Future<List<ReplaceEmoji>> Function(String query);

class ReplaceEmoji {
  final String emojiUrl;
  final String emojiName;

  const ReplaceEmoji({required this.emojiUrl, required this.emojiName});
}

// Reaction

class ReplaceReaction {
  final String npub;
  final String nevent;
  final String profileName;
  final String profilePicUrl;
  final String emojiUrl;
  final String emojiName;
  final DateTime? timestamp;
  final bool isOutgoing;

  const ReplaceReaction({
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
class ReplaceZap {
  final String npub;
  final String nevent;
  final int amount;
  final String profileName;
  final String profilePicUrl;
  final String? message;
  final DateTime timestamp;
  final bool isOutgoing;

  const ReplaceZap({
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
class ReplaceQuotedMessage {
  final String nevent;
  final String content;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;

  const ReplaceQuotedMessage({
    required this.nevent,
    required this.content,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
  });
}

// Event
typedef NostrEventResolver = Future<({Event event, VoidCallback? onTap})>
    Function(String nevent);

class ReplaceNostrEvent {
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

  const ReplaceNostrEvent({
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
class ReplacePost {
  final String npub;
  final String nevent;
  final String profileName;
  final String profilePicUrl;
  final String content;
  final DateTime timestamp;
  final List<ReplaceReaction> reactions;
  final List<ReplaceZap> zaps;

  const ReplacePost({
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
class ReplaceArticle {
  final String npub;
  final String nevent;
  final String profileName;
  final String profilePicUrl;
  final String title;
  final String? imageUrl;
  final String? content;
  final DateTime? timestamp;
  final List<ReplaceReaction>? reactions;
  final List<ReplaceZap>? zaps;
  final NostrEmojiResolver? onResolveEmoji;
  final NostrEventResolver? onResolveEvent;
  final NostrProfileResolver? onResolveProfile;
  final NostrHashtagResolver? onResolveHashtag;
  final LinkTapHandler? onLinkTap;

  const ReplaceArticle({
    required this.npub,
    required this.nevent,
    required this.profileName,
    required this.profilePicUrl,
    required this.title,
    this.imageUrl,
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
