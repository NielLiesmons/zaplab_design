enum LabShortTextElementType {
  paragraph, // Regular text
  blockQuote, // > quote
  codeBlock, // ``` ``` or ```language```
  link, // https://...
  monospace, // `text`
  styledText, //
  images, // url.png or url.jpg or url.gif or url.svg
  audio, // url.mp3 or url.wav or url.ogg or url.m4a
  nostrProfile, // nostr:npub1... or nostr:nprofile1...
  nostrModel, // nostr:nevent1... or nostr:naddr....
  emoji, // :emoji:
  utfEmoji, // Unicode emoji characters
  hashtag, // #hashtag
  heading1, // # Heading
  heading2, // ## Heading
  heading3, // ### Heading
  heading4, // #### Heading
  heading5, // ##### Heading
  listItem, // * or - or + List items
  orderedListItem, // 1. or 2. or 3. List items
  checkListItem, // [x] or [ ] List items
}

class LabShortTextElement {
  final LabShortTextElementType type;
  final String content;
  final Map<String, String>? attributes; // For code blocks: language, etc.
  final int level; // For nested lists
  final bool? checked; // For checklists
  final List<LabShortTextElement>? children; // Add this for nested styling

  const LabShortTextElement({
    required this.type,
    required this.content,
    this.attributes,
    this.level = 0,
    this.checked,
    this.children,
  });
}
