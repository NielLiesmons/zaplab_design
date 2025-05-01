import 'package:flutter/foundation.dart';
import 'package:models/models.dart';

// Model
typedef NostrEventResolver = Future<({Model model, VoidCallback? onTap})>
    Function(String nevent);

String getModelContentType(Model? model) {
  return switch (model) {
    Model<Article>() => 'article',
    Model<ChatMessage>() => 'chat',
    Model<Note>() => 'thread',
    Model<App>() => 'app',
    Model<Book>() => 'book',
    _ => 'nostr',
  };
}

String getModelDisplayText(Model<dynamic>? model) {
  return switch (model) {
    Model<Article>() => (model as Article).title ?? '',
    Model<ChatMessage>() => (model as ChatMessage).content ?? '',
    Model<Note>() => (model as Note).content ?? '',
    Model<App>() => (model as App).name ?? 'App Name',
    Model<Book>() => (model as Book).title ?? '',
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

// Reply
class Reply extends RegularModel<Reply> {
  Reply.fromMap(super.map, super.ref) : super.fromMap();
}

class PartialReply extends RegularPartialModel<Reply> {
  PartialReply(String content) {
    event.content = content;
  }
}

// Hashtag
typedef NostrHashtagResolver = Future<void Function()?> Function(
    String identifier);

// Links
typedef LinkTapHandler = void Function(String url);

// Book

class Book extends RegularModel<Book> {
  Book.fromMap(super.map, super.ref) : super.fromMap();

  String? get title => event.getFirstTagValue('title');
  String? get writer => event.getFirstTagValue('writer');
  String? get imageUrl => event.getFirstTagValue('image_url');
  DateTime? get publishedAt =>
      event.getFirstTagValue('published_at')?.toInt()?.toDate();
}

class PartialBook extends RegularPartialModel<Book> {
  PartialBook(String title, String content,
      {String? writer, String? imageUrl, DateTime? publishedAt}) {
    event.content = content;
    event.addTagValue('title', title);
    if (writer != null) {
      event.addTagValue('writer', writer);
    }
    if (imageUrl != null) {
      event.addTagValue('image_url', imageUrl);
    }
    if (publishedAt != null) {
      event.addTagValue('published_at', publishedAt.toSeconds().toString());
    }
  }
}

// Emoj

class Emoji {
  final String emojiUrl;
  final String emojiName;

  const Emoji({
    required this.emojiUrl,
    required this.emojiName,
  });
}
