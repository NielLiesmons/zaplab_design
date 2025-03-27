enum AppShortTextElementType {
  paragraph, // Regular text
  blockQuote, // > quote
  codeBlock, // ``` ``` or ```language```
  listItem, // * List items
  link, // https://...
  monospace, // `text`
  styledText, //
  images, // url.png or url.jpg or url.gif or url.svg
  audio, // url.mp3 or url.wav or url.ogg or url.m4a
  nostrProfile, // nostr:npub1... or nostr:nprofile1...
  nostrEvent, // nostr:nevent1... or nostr:naddr....
  emoji, // :emoji:
  utfEmoji, // Unicode emoji characters
  hashtag, // #hashtag
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
