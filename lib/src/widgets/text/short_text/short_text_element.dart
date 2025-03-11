enum AppShortTextElementType {
  paragraph, // Regular text
  blockQuote, // Add this
  codeBlock, // [source,language]
  listItem, // * List items
  link, // https://... or [text](url)
  horizontalRule, // --- or *** or '''
  styledText, //
  image, // url.png or url.jpg or url.gif or url.svg
  nostrProfile, // nostr:npub1... or nostr:nprofile1...
  nostrEvent, // nostr:nevent1...
  emoji, // :emoji:
  hashtag, // Add this
}

class AppShortTextElement {
  final AppShortTextElementType type;
  final String content;
  final Map<String, String>? attributes; // For code blocks: language, etc.
  final int level; // For nested lists
  final bool? checked; // For checklists
  final List<AppShortTextElement>? children; // Add this for nested styling

  const AppShortTextElement({
    required this.type,
    required this.content,
    this.attributes,
    this.level = 0,
    this.checked,
    this.children,
  });
}
