class NostrEventData {
  final String contentType;
  final String title;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;
  final void Function()? onTap;

  const NostrEventData({
    required this.contentType,
    required this.title,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
    this.onTap,
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
