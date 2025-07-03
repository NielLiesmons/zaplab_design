enum LongTextElementType {
  heading1, // = or # Heading
  heading2, // == or ## Heading
  heading3, // === or ### Heading
  heading4, // ==== or #### Heading
  heading5, // ===== or ##### Heading
  paragraph, // Regular text
  codeBlock, // [source,language]
  listItem, // * or - or + List items
  orderedListItem, //. List Item OR . List items
  checkListItem, // [x] List items
  descriptionListItem, // : List items
  qandaListItem, // ? List items
  link, // https://... or [text](url)
  admonition, // NOTE: or TIP: or IMPORTANT: or WARNING: or CAUTION:
  horizontalRule, // --- or *** or '''
  styledText, //
  image, // image::url[caption]
  nostrProfile, // nostr:npub1... or nostr:nprofile1...
  nostrModel, // nostr:nevent1...
  emoji, // :emoji:
  utfEmoji, // 💬
  hashtag, // Add this
  monospace, // `text`
  blockQuote, // > Quote
}

class LongTextElement {
  final LongTextElementType type;
  final String content;
  final Map<String, String>? attributes; // For code blocks: language, etc.
  final int level; // For nested lists
  final bool? checked; // For checklists
  final List<LongTextElement>? children; // Add this for nested styling

  const LongTextElement({
    required this.type,
    required this.content,
    this.attributes,
    this.level = 0,
    this.checked,
    this.children,
  });

  LongTextElement copyWith({
    LongTextElementType? type,
    String? content,
    Map<String, String>? attributes,
    int? level,
    bool? checked,
    List<LongTextElement>? children,
  }) {
    return LongTextElement(
      type: type ?? this.type,
      content: content ?? this.content,
      attributes: attributes ?? this.attributes,
      level: level ?? this.level,
      checked: checked ?? this.checked,
      children: children ?? this.children,
    );
  }
}
