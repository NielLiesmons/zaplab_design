class Message {
  final String eventId;
  final String content;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;
  final List<Reaction> reactions;
  final List<Zap> zaps;

  const Message({
    required this.eventId,
    required this.content,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
    this.reactions = const [],
    this.zaps = const [],
  });
}

class Reaction {
  final String emojiUrl;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;

  const Reaction({
    required this.emojiUrl,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
  });
}

class Zap {
  final int amount;
  final String profileName;
  final String profilePicUrl;
  final String? comment;
  final DateTime timestamp;

  const Zap({
    required this.amount,
    required this.profileName,
    required this.profilePicUrl,
    this.comment,
    required this.timestamp,
  });
}

class QuotedMessage {
  final String eventId;
  final String content;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;

  const QuotedMessage({
    required this.eventId,
    required this.content,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
  });
}

class NostrEventData {
  final String contentType;
  final String? title;
  final String? message;
  final String? imageUrl;
  final String profileName;
  final String profilePicUrl;
  final DateTime? timestamp;
  final String? amount;
  final void Function()? onTap;

  const NostrEventData({
    required this.contentType,
    this.title,
    this.message,
    this.imageUrl,
    required this.profileName,
    required this.profilePicUrl,
    this.timestamp,
    this.onTap,
    this.amount,
  });
}

class NostrProfileData {
  final String name;
  final String? imageUrl;
  final void Function()? onTap;

  const NostrProfileData({
    required this.name,
    this.imageUrl,
    this.onTap,
  });
}

typedef NostrEventResolver = Future<NostrEventData> Function(String identifier);
typedef NostrProfileResolver = Future<NostrProfileData> Function(
    String identifier);
typedef NostrEmojiResolver = Future<String> Function(String identifier);
typedef NostrHashtagResolver = Future<void Function()?> Function(
    String identifier);
typedef LinkTapHandler = void Function(String url);
