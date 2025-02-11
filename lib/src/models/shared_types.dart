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
  final String profileName;
  final String profilePicUrl;
  final DateTime? timestamp;
  final String? amount;
  final void Function()? onTap;

  const NostrEventData({
    required this.contentType,
    this.title,
    this.message,
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
