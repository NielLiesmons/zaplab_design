import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

// Model
typedef NostrEventResolver = Future<({Model model, VoidCallback? onTap})>
    Function(String nevent);

String getModelContentType(Model? model) {
  return switch (model) {
    Model<Article>() => 'article',
    Model<ChatMessage>() => 'chat',
    Model<Comment>() => 'reply',
    Model<Note>() => 'thread',
    Model<App>() => 'app',
    Model<Book>() => 'book',
    Model<Task>() => 'task',
    Model<Repository>() => 'repo',
    Model<Mail>() => 'mail',
    Model<Job>() => 'job',
    Model<Service>() => 'service',
    Model<Group>() => 'group',
    Model<Community>() => 'community',
    Model<CashuZap>() => 'zap',
    Model<ForumPost>() => 'forum',
    _ => 'unknown',
  };
}

String getModelName(Model? model) {
  final type = getModelContentType(model);
  if (type == 'nostr') return 'Nostr Publication';
  if (type == 'chat') return 'Message';
  if (type == 'forum') return 'Forum Post';
  return type[0].toUpperCase() + type.substring(1);
}

String getModelNameFromContentType(String contenType) {
  if (contenType == 'nostr') return 'Nostr Publication';
  return contenType[0].toUpperCase() + contenType.substring(1);
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
    Model<Service>() => (model as Service).title ?? 'Service Title',
    Model<Mail>() => (model as Mail).title ?? 'Mail Title',
    Model<Task>() => (model as Task).title ?? 'Task Title',
    Model<ForumPost>() => (model as ForumPost).title ?? 'Forum Post Title',
    _ => model?.event.content ?? '',
  };
}

// Profile
typedef NostrProfileResolver = Future<({Profile profile, VoidCallback? onTap})>
    Function(String npub);
typedef NostrProfileSearch = Future<List<Profile>> Function(String queryText);

// Emoji
typedef NostrEmojiResolver = Future<String> Function(
    String identifier, Model model);
typedef NostrEmojiSearch = Future<List<Emoji>> Function(String queryText);

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

// Forum Post

class ForumPost extends RegularModel<ForumPost> {
  ForumPost.fromMap(super.map, super.ref) : super.fromMap();

  String? get title => event.getFirstTagValue('title');
  String get content => event.content;
}

class PartialForumPost extends RegularPartialModel<ForumPost> {
  PartialForumPost(String title, String content) {
    event.addTagValue('title', title);
    event.content = content;
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

// Poll

class Poll extends RegularModel<Poll> {
  Poll.fromMap(super.map, super.ref) : super.fromMap();

  String get content => event.content;

  List<({String id, String label})> get options {
    final options = <({String id, String label})>[];
    for (final tag in event.tags.where((tag) => tag[0] == 'option')) {
      if (tag.length >= 3) {
        options.add((id: tag[1], label: tag[2]));
      }
    }
    return options;
  }

  String get pollType => event.getFirstTagValue('polltype') ?? 'singlechoice';

  bool get isSingleChoice => pollType == 'singlechoice';

  bool get isMultipleChoice => pollType == 'multiplechoice';

  DateTime? get endsAt {
    final timestamp = event.getFirstTagValue('endsAt')?.toInt();
    return timestamp?.toDate();
  }

  bool get hasEnded {
    final endTime = endsAt;
    return endTime != null && DateTime.now().isAfter(endTime);
  }

  Duration? get timeRemaining {
    final endTime = endsAt;
    if (endTime == null) return null;
    final remaining = endTime.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }
}

class PartialPoll extends RegularPartialModel<Poll> {
  PartialPoll({
    required String content,
    required List<({String id, String label})> options,
    Set<String>? relayUrls,
    String pollType = 'singlechoice',
    DateTime? endsAt,
  }) {
    event.content = content;
    for (final option in options) {
      event.addTag('option', [option.id, option.label]);
    }
    event.addTagValue('polltype', pollType);
    if (endsAt != null) {
      event.addTagValue('endsAt', endsAt.toSeconds().toString());
    }
  }
}

class PollResponse extends RegularModel<PollResponse> {
  PollResponse.fromMap(super.map, super.ref) : super.fromMap();

  String get content => event.content;

  // Get the poll event ID this response is for
  String? get pollEventId => event.getFirstTagValue('e');

  // Get all selected option IDs
  List<String> get selectedOptionIds {
    return event.tags
        .where((tag) => tag[0] == 'response')
        .map((tag) => tag[1])
        .toList();
  }
}

class PartialPollResponse extends RegularPartialModel<PollResponse> {
  PartialPollResponse({
    required String pollEventId,
    required List<String> selectedOptionIds,
    String content = '',
  }) {
    event.content = content;
    event.addTagValue('e', pollEventId);
    for (final optionId in selectedOptionIds) {
      event.addTagValue('response', optionId);
    }
  }
}

// Badge

class Badge extends ParameterizableReplaceableModel<Badge> {
  Badge.fromMap(super.map, super.ref) : super.fromMap();

  String get slug => event.getFirstTagValue('d')!;
  String? get name => event.getFirstTagValue('name');
  String? get description => event.getFirstTagValue('description');
  String? get imageUrl => event.getFirstTagValue('image');
  String? get imageDimensions {
    final imageTag = event.tags.firstWhere(
      (tag) => tag[0] == 'image' && tag.length > 2,
      orElse: () => ['image', '', ''],
    );
    return imageTag[2];
  }

  Map<String, String> get thumbnails {
    final thumbs = <String, String>{};
    for (final tag in event.tags.where((tag) => tag[0] == 'thumb')) {
      if (tag.length > 1) {
        final dimensions = tag.length > 2 ? tag[2] : 'default';
        thumbs[dimensions] = tag[1];
      }
    }
    return thumbs;
  }
}

class PartialBadge extends ParameterizableReplaceablePartialEvent<Badge> {
  PartialBadge({
    required String slug,
    String? name,
    String? description,
    String? imageUrl,
    String? imageDimensions,
    Map<String, String>? thumbnails,
  }) {
    this.slug = slug;
    this.name = name;
    this.description = description;
    this.imageUrl = imageUrl;
    this.imageDimensions = imageDimensions;
    if (thumbnails != null) {
      this.thumbnails = thumbnails;
    }
  }

  set slug(String value) => event.addTagValue('d', value);
  set name(String? value) => event.addTagValue('name', value);
  set description(String? value) => event.addTagValue('description', value);
  set imageUrl(String? value) => event.addTagValue('image', value);
  set imageDimensions(String? value) {
    final currentImageUrl = event.getFirstTagValue('image') ?? '';
    event.addTag('image', [currentImageUrl, value ?? '']);
  }

  set thumbnails(Map<String, String> value) {
    for (final entry in value.entries) {
      event.addTag('thumb', [entry.value, entry.key]);
    }
  }
}

// CashuZap

class CashuZap extends RegularModel<CashuZap> {
  CashuZap.fromMap(super.map, super.ref) : super.fromMap();

  String get content => event.content;
  String get proof => event.getFirstTagValue('proof') ?? '';
  String get url => event.getFirstTagValue('u') ?? '';
  String get zappedEventId => event.getFirstTagValue('e') ?? '';
  String get recipientPubkey => event.getFirstTagValue('p') ?? '';

  // Parse the proof JSON to get amount
  int get amount {
    try {
      final proofJson = jsonDecode(proof);
      return proofJson['amount'] as int? ?? 0;
    } catch (_) {
      return 0;
    }
  }
}

class PartialCashuZap extends RegularPartialModel<CashuZap> {
  PartialCashuZap(
    String content, {
    required String proof,
    required String url,
    required String zappedEventId,
    required String recipientPubkey,
    DateTime? createdAt,
  }) {
    event.content = content;
    event.addTagValue('proof', proof);
    event.addTagValue('u', url);
    event.addTagValue('e', zappedEventId);
    event.addTagValue('p', recipientPubkey);
    if (createdAt != null) {
      event.createdAt = createdAt;
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

// Service

class Service extends ParameterizableReplaceableModel<Service> {
  Service.fromMap(super.map, super.ref) : super.fromMap();
  String? get title => event.getFirstTagValue('title');
  String get content => event.content;
  String? get summary => event.getFirstTagValue('summary');
  Set<String> get images => event.getTagSetValues('images');
  String get slug => event.getFirstTagValue('d')!;
  DateTime? get publishedAt =>
      event.getFirstTagValue('published_at')?.toInt()?.toDate();

  PartialService copyWith({
    String? title,
    String? content,
    String? summary,
    Set<String>? images,
    DateTime? publishedAt,
  }) {
    return PartialService(
      title ?? this.title ?? '',
      content ?? event.content,
      summary: summary ?? this.summary,
      images: images ?? this.images,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}

class PartialService extends ParameterizableReplaceablePartialEvent<Service> {
  PartialService(String title, String content,
      {DateTime? publishedAt,
      String? slug,
      String? summary,
      Set<String>? images}) {
    this.title = title;
    this.summary = summary;
    this.publishedAt = publishedAt;
    this.slug = slug ?? Utils.generateRandomHex64();
    event.content = content;
    if (images != null) {
      this.images = images;
    }
  }
  set title(String value) => event.addTagValue('title', value);
  set summary(String? value) => event.addTagValue('summary', value);
  set slug(String value) => event.addTagValue('d', value);
  set content(String value) => event.content = value;
  set images(Set<String> value) {
    for (final url in value) {
      event.addTagValue('images', url);
    }
  }

  set publishedAt(DateTime? value) =>
      event.addTagValue('published_at', value?.toSeconds().toString());
}

// Product

class Product extends ParameterizableReplaceableModel<Product> {
  Product.fromMap(super.map, super.ref) : super.fromMap();
  String? get title => event.getFirstTagValue('title');
  String? get price => event.getFirstTagValue('price');
  String get content => event.content;
  String? get summary => event.getFirstTagValue('summary');
  Set<String> get images => event.getTagSetValues('images');
  String get slug => event.getFirstTagValue('d')!;
  DateTime? get publishedAt =>
      event.getFirstTagValue('published_at')?.toInt()?.toDate();

  PartialProduct copyWith({
    String? title,
    String? price,
    String? content,
    String? summary,
    Set<String>? images,
    DateTime? publishedAt,
  }) {
    return PartialProduct(
      title ?? this.title ?? '',
      content ?? event.content,
      price: price ?? this.price ?? '',
      summary: summary ?? this.summary,
      images: images ?? this.images,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}

class PartialProduct extends ParameterizableReplaceablePartialEvent<Product> {
  PartialProduct(String title, String content,
      {DateTime? publishedAt,
      String? price,
      String? slug,
      String? summary,
      Set<String>? images}) {
    this.title = title;
    this.price = price ?? "21";
    this.summary = summary;
    this.publishedAt = publishedAt;
    this.slug = slug ?? Utils.generateRandomHex64();
    event.content = content;
    if (images != null) {
      this.images = images;
    }
  }
  set title(String value) => event.addTagValue('title', value);
  set price(String value) => event.addTagValue('price', value);

  set summary(String? value) => event.addTagValue('summary', value);
  set slug(String value) => event.addTagValue('d', value);
  set content(String value) => event.content = value;
  set images(Set<String> value) {
    for (final url in value) {
      event.addTagValue('images', url);
    }
  }

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

// Calendar Event

class CalendarEvent extends ParameterizableReplaceableModel<CalendarEvent> {
  CalendarEvent.fromMap(super.map, super.ref) : super.fromMap();
  String? get name => event.getFirstTagValue('name');
  String get content => event.content;
  String? get imageUrl => event.getFirstTagValue('imageUrl');
  String get slug => event.getFirstTagValue('d')!;
  DateTime? get publishedAt =>
      event.getFirstTagValue('published_at')?.toInt()?.toDate();

  PartialCalendarEvent copyWith({
    String? name,
    String? content,
    String? imageUrl,
    DateTime? publishedAt,
  }) {
    return PartialCalendarEvent(
      name ?? this.name ?? '',
      content ?? event.content,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}

class PartialCalendarEvent
    extends ParameterizableReplaceablePartialEvent<CalendarEvent> {
  PartialCalendarEvent(String name, String content,
      {DateTime? publishedAt, String? slug, String? imageUrl}) {
    this.name = name;
    this.publishedAt = publishedAt;
    this.slug = slug ?? Utils.generateRandomHex64();
    this.imageUrl = imageUrl;
    event.content = content;
  }
  set name(String value) => event.addTagValue('name', value);
  set slug(String value) => event.addTagValue('d', value);
  set content(String value) => event.content = value;
  set imageUrl(String? value) => event.addTagValue('imageUrl',
      value); // This data should actually come from a separate event, not as part of the kind 35000
  set publishedAt(DateTime? value) =>
      event.addTagValue('published_at', value?.toSeconds().toString());
}
