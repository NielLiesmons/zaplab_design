//// These models are only temporary and will be replaced by the models of our separet Models package

// Community
class Community {
  final String profilePicUrl;
  final String communityName;
  final String ncommunity;
  final String? description;
  final List<Profile>? inYourNetwork;

  const Community({
    required this.profilePicUrl,
    required this.communityName,
    required this.ncommunity,
    this.description,
    this.inYourNetwork,
  });
}

// Message
class Message {
  final String nevent;
  final String message;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;
  final List<Reaction> reactions;
  final List<Zap> zaps;

  const Message({
    required this.nevent,
    required this.message,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
    this.reactions = const [],
    this.zaps = const [],
  });
}

// Reaction
typedef NostrEmojiResolver = Future<String> Function(String identifier);

class Reaction {
  final String emojiUrl;
  final String emojiName;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;

  const Reaction({
    required this.emojiUrl,
    required this.emojiName,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
  });
}

// Zap
class Zap {
  final String nevent;
  final int amount;
  final String profileName;
  final String profilePicUrl;
  final String? comment;
  final DateTime timestamp;

  const Zap({
    required this.nevent,
    required this.amount,
    required this.profileName,
    required this.profilePicUrl,
    this.comment,
    required this.timestamp,
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

// Profile
typedef NostrProfileResolver = Future<Profile> Function(String identifier);

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

// Hashtag
typedef NostrHashtagResolver = Future<void Function()?> Function(
    String identifier);

// Links
typedef LinkTapHandler = void Function(String url);
