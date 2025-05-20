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
    Model<Task>() => 'task',
    Model<Repository>() => 'repo',
    Model<Mail>() => 'mail',
    Model<Job>() => 'job',
    Model<Group>() => 'group',
    Model<Community>() => 'community',
    Model<Book>() => 'book',
    _ => 'nostr',
  };
}

String getModelName(Model? model) {
  final type = getModelContentType(model);
  if (type == 'nostr') return 'Nostr Publication';
  return type[0].toUpperCase() + type.substring(1);
}

String getModelDisplayText(Model<dynamic>? model) {
  return switch (model) {
    Model<Article>() => (model as Article).title ?? '',
    Model<ChatMessage>() => (model as ChatMessage).content,
    Model<Note>() => (model as Note).content,
    Model<App>() => (model as App).name ?? 'App Name',
    Model<Book>() => (model as Book).title ?? 'Book Title',
    Model<Repository>() => (model as Repository).name ?? 'Repo Name',
    Model<Community>() => (model as Community).name,
    Model<Job>() => (model as Job).title ?? 'Job Title',
    Model<Mail>() => (model as Mail).title ?? 'Mail Title',
    Model<Task>() => (model as Task).title ?? 'Task Title',
    _ => model?.event.content ?? '',
  };
}

// Profile
typedef NostrProfileResolver = Future<({Profile profile, VoidCallback? onTap})>
    Function(String npub);
typedef NostrProfileSearch = Future<List<Profile>> Function(String query);

// Emoji
typedef NostrEmojiResolver = Future<String> Function(String identifier);
typedef NostrEmojiSearch = Future<List<Emoji>> Function(String query);

// // Reply
// class Reply extends RegularModel<Reply> {
//   Reply.fromMap(super.map, super.ref) : super.fromMap();
// }

// class PartialReply extends RegularPartialModel<Reply> {
//   PartialReply(String content) {
//     event.content = content;
//   }
// }

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

// Job

class Job extends ParameterizableReplaceableModel<Job> {
  Job.fromMap(super.map, super.ref) : super.fromMap();
  String? get title => event.getFirstTagValue('title');
  String get content => event.content;
  String? get location => event.getFirstTagValue('location');
  String? get employmentType => event.getFirstTagValue('employment_type');
  String get slug => event.getFirstTagValue('d')!;
  DateTime? get publishedAt =>
      event.getFirstTagValue('published_at')?.toInt()?.toDate();
  Set<String> get labels => event.tags
      .where((tag) => tag.length > 1 && tag[0] == 't')
      .map((tag) => tag[1])
      .toSet();

  PartialJob copyWith({
    String? title,
    String? content,
    String? location,
    String? employmentType,
    DateTime? publishedAt,
  }) {
    return PartialJob(
      title ?? this.title ?? '',
      content ?? event.content,
      location: location ?? this.location,
      employment: employmentType ?? this.employmentType,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}

class PartialJob extends ParameterizableReplaceablePartialEvent<Job> {
  PartialJob(String title, String content,
      {DateTime? publishedAt,
      String? slug,
      Set<String>? labels,
      String? location,
      String? employment}) {
    this.title = title;
    this.publishedAt = publishedAt;
    this.location = location;
    this.employment = employment;
    this.slug = slug ?? Utils.generateRandomHex64();
    event.content = content;
    if (labels != null) {
      for (final label in labels) {
        event.addTagValue('t', label);
      }
    }
  }
  set title(String value) => event.addTagValue('title', value);
  set slug(String value) => event.addTagValue('d', value);
  set content(String value) => event.content = value;
  set location(String? value) => event.addTagValue('location', value);
  set employment(String? value) => event.addTagValue('employment_type', value);
  set publishedAt(DateTime? value) =>
      event.addTagValue('published_at', value?.toSeconds().toString());
  set labels(Set<String> value) {
    for (final label in value) {
      event.addTagValue('t', label);
    }
  }
}

// Mail

class Mail extends RegularModel<Mail> {
  Mail.fromMap(super.map, super.ref) : super.fromMap();

  String? get title => event.getFirstTagValue('title');
  String get content => event.content;
  Set<String> get recipientPubkeys => event.getTagSetValues('p');
}

class PartialMail extends RegularPartialModel<Mail> {
  PartialMail(String title, String content, {Set<String>? recipientPubkeys}) {
    event.content = content;
    event.addTagValue('title', title);
    if (recipientPubkeys != null) {
      for (final pubkey in recipientPubkeys) {
        event.addTagValue('p', pubkey);
      }
    }
  }
}

// Repository

class Repository extends ParameterizableReplaceableModel<Repository> {
  Repository.fromMap(super.map, super.ref) : super.fromMap();
  String? get name => event.getFirstTagValue('name');
  String? get description => event.getFirstTagValue('description');
  String? get slug => event.getFirstTagValue('d');
  DateTime? get publishedAt =>
      event.getFirstTagValue('published_at')?.toInt()?.toDate();

  PartialRepository copyWith({
    String? name,
    String? description,
    DateTime? publishedAt,
  }) {
    return PartialRepository(
      name ?? this.name ?? '',
      description ?? event.content,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}

class PartialRepository
    extends ParameterizableReplaceablePartialEvent<Repository> {
  PartialRepository(String name, String description,
      {DateTime? publishedAt, String? slug}) {
    this.name = name;
    this.description = description;
    this.publishedAt = publishedAt;
    this.slug = slug ?? Utils.generateRandomHex64();
    event.content = description;
  }
  set name(String value) => event.addTagValue('name', value);
  set description(String value) => event.addTagValue('description', value);
  set slug(String value) => event.addTagValue('d', value);
  set content(String value) => event.content = value;
  set publishedAt(DateTime? value) =>
      event.addTagValue('published_at', value?.toSeconds().toString());
}

// Task

class Task extends ParameterizableReplaceableModel<Task> {
  Task.fromMap(super.map, super.ref) : super.fromMap();
  String? get title => event.getFirstTagValue('title');
  String get content => event.content;
  String? get status => event.getFirstTagValue('status');
  String get slug => event.getFirstTagValue('d')!;
  DateTime? get publishedAt =>
      event.getFirstTagValue('published_at')?.toInt()?.toDate();

  PartialTask copyWith({
    String? title,
    String? content,
    String? status,
    DateTime? publishedAt,
  }) {
    return PartialTask(
      title ?? this.title ?? '',
      content ?? event.content,
      status: status ?? this.status,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}

class PartialTask extends ParameterizableReplaceablePartialEvent<Task> {
  PartialTask(String title, String content,
      {DateTime? publishedAt, String? slug, String? status}) {
    this.title = title;
    this.publishedAt = publishedAt;
    this.slug = slug ?? Utils.generateRandomHex64();
    this.status = status;
    event.content = content;
  }
  set title(String value) => event.addTagValue('title', value);
  set slug(String value) => event.addTagValue('d', value);
  set content(String value) => event.content = value;
  set status(String? value) => event.addTagValue('status',
      value); // This data should actually come from a separate event, not as part of the kind 35000
  set publishedAt(DateTime? value) =>
      event.addTagValue('published_at', value?.toSeconds().toString());
}
