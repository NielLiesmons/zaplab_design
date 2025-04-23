import 'package:flutter/foundation.dart';
import 'package:models/models.dart';

// Model
typedef NostrEventResolver = Future<({Model model, VoidCallback? onTap})>
    Function(String nevent);

String getModelContentType(Model? model) {
  return switch (model) {
    Model<Article>() => 'article',
    Model<ChatMessage>() => 'chat',
    Model<Note>() => 'post',
    Model<App>() => 'app',
    _ => 'nostr',
  };
}

String getModelDisplayText(Model<dynamic>? model) {
  return switch (model) {
    Model<Article>() => (model as Article).title ?? '',
    Model<ChatMessage>() => (model as ChatMessage).content ?? '',
    Model<Note>() => (model as Note).content ?? '',
    Model<App>() => (model as App).name ?? 'App Name',
    _ => '',
  };
}

// Profile
typedef NostrProfileResolver = Future<({Profile profile, VoidCallback? onTap})>
    Function(String npub);
typedef NostrProfileSearch = Future<List<Profile>> Function(String query);

// Emoji
typedef NostrEmojiResolver = Future<String> Function(String identifier);
typedef NostrEmojiSearch = Future<List<Emoji>> Function(String query);

// Emoj

class Emoji {
  final String emojiUrl;
  final String emojiName;

  const Emoji({
    required this.emojiUrl,
    required this.emojiName,
  });
}

// Hashtag
typedef NostrHashtagResolver = Future<void Function()?> Function(
    String identifier);

// Links
typedef LinkTapHandler = void Function(String url);
