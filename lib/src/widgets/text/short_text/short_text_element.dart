enum ShortTextElementType {
  heading1, // = Heading
  heading2, // == Heading
  heading3, // === Heading
  heading4, // ==== Heading
  heading5, // ===== Heading
  paragraph, // Regular text
  codeBlock, // [source,language]
  listItem, // * List items
  orderedListItem, // . List items
  checkListItem, // [x] List items
  descriptionListItem, // : List items
  qandaListItem, // ? List items
  link, // https://... or [text](url)
  admonition, // NOTE: or TIP: or IMPORTANT: or WARNING: or CAUTION:
  horizontalRule, // --- or *** or '''
  styledText, //
  image, // image::url[caption]
  nostrProfile, // nostr:npub1... or nostr:nprofile1...
  nostrEvent, // nostr:nevent1...
  emoji, // :emoji:
  hashtag, // Add this
}

class ShortTextElement {
  final ShortTextElementType type;
  final String content;
  final Map<String, String>? attributes; // For code blocks: language, etc.
  final int level; // For nested lists
  final bool? checked; // For checklists
  final List<ShortTextElement>? children; // Add this for nested styling

  const ShortTextElement({
    required this.type,
    required this.content,
    this.attributes,
    this.level = 0,
    this.checked,
    this.children,
  });
}
