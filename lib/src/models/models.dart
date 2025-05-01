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

// Group

class Group extends ReplaceableModel<Group> {
  Group.fromMap(super.map, super.ref) : super.fromMap();

  String get name => event.getFirstTagValue('name')!;
  Set<String> get relayUrls => event.getTagSetValues('r');
  String? get description => event.getFirstTagValue('description');

  Set<GroupContentSection> get contentSections {
    final sections = <GroupContentSection>{};
    String? currentContent;
    Set<int> currentKinds = {};
    int? currentFeeInSats;

    for (final tag in event.tags) {
      final [key, value, ..._] = tag;

      if (key == 'content') {
        // Finalize previous section if one was being built
        if (currentContent != null) {
          sections.add(GroupContentSection(
            content: currentContent,
            kinds: currentKinds,
            feeInSats: currentFeeInSats,
          ));
        }
        // Start new section
        currentContent = value;
        currentKinds = {}; // Reset kinds for the new section
        currentFeeInSats = null; // Reset fee for the new section
      } else if (currentContent != null) {
        // Only process 'k' and 'fee' if we are inside a section
        if (key == 'k') {
          final kind = int.tryParse(value);
          if (kind != null) {
            currentKinds.add(kind);
          }
        } else if (key == 'fee') {
          currentFeeInSats = int.tryParse(value);
        } else {
          // Found a tag not belonging to the current section, finalize the current section
          sections.add(GroupContentSection(
            content: currentContent,
            kinds: currentKinds,
            feeInSats: currentFeeInSats,
          ));
          // Reset section tracking
          currentContent = null;
          currentKinds = {};
          currentFeeInSats = null;
        }
      }
    }

    // Finalize the last section if one was being built
    if (currentContent != null) {
      sections.add(GroupContentSection(
        content: currentContent,
        kinds: currentKinds,
        feeInSats: currentFeeInSats,
      ));
    }

    return sections.toSet();
  }

  Set<String> get blossomUrls => event.getTagSetValues('blossom');
  Set<String> get cashuMintUrls => event.getTagSetValues('mint');
  String? get termsOfService => event.getFirstTagValue('tos');
}

class PartialGroup extends ReplaceablePartialModel<Group> {
  PartialGroup(
      {required String name,
      DateTime? createdAt,
      required Set<String> relayUrls,
      String? description,
      Set<GroupContentSection>? contentSections,
      Set<String> blossomUrls = const {},
      Set<String> cashuMintUrls = const {},
      String? termsOfService}) {
    event.addTagValue('name', name);
    if (createdAt != null) {
      event.createdAt = createdAt;
    }
    for (final relayUrl in relayUrls) {
      event.addTagValue('r', relayUrl);
    }
    event.addTagValue('description', description);
    if (contentSections != null) {
      for (final section in contentSections) {
        event.addTagValue('content', section.content);
        for (final k in section.kinds) {
          event.addTagValue('k', k.toString());
        }
        if (section.feeInSats != null) {
          event.addTag('fee', [section.feeInSats!.toString(), 'sat']);
        }
      }
    }
    for (final url in blossomUrls) {
      event.addTagValue('blossom', url);
    }
    for (final url in cashuMintUrls) {
      event.addTagValue('mint', url);
    }
    event.addTagValue('tos', termsOfService);
  }
}

class GroupContentSection {
  final String content;
  final Set<int> kinds;
  final int? feeInSats;

  GroupContentSection(
      {required this.content, required this.kinds, this.feeInSats});
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
