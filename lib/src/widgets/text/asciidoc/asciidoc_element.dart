enum AsciiDocElementType {
  heading1, // = Heading
  heading2, // == Heading
  heading3, // === Heading
  heading4, // ==== Heading
  heading5, // ===== Heading
  paragraph, // Regular text
  codeBlock, // Code blocks
  listItem, // * List items
  link, // https://... or [text](url)
}

class AsciiDocElement {
  final AsciiDocElementType type;
  final String content;
  final Map<String, String>? attributes; // For code blocks: language, etc.

  const AsciiDocElement({
    required this.type,
    required this.content,
    this.attributes,
  });
}
