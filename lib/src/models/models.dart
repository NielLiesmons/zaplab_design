import 'package:models/models.dart';

// Profile
typedef NostrProfileResolver = Future<Profile> Function(String identifier);
typedef NostrProfileSearch = Future<List<Profile>> Function(String query);

// Reaction
typedef NostrEmojiResolver = Future<String> Function(String identifier);
typedef NostrEmojiSearch = Future<List<Emoji>> Function(String query);

class Emoji {
  final String emojiUrl;
  final String emojiName;

  const Emoji({required this.emojiUrl, required this.emojiName});
}

// Reaction

// Event
typedef NostrEventResolver = Future<Event> Function(String identifier);

// Hashtag
typedef NostrHashtagResolver = Future<void Function()?> Function(
    String identifier);

// Links
typedef LinkTapHandler = void Function(String url);
