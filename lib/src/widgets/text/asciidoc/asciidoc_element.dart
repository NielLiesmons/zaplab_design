enum AsciiDocElementType {
  heading1, // = Heading
  heading2, // == Heading
  heading3, // === Heading
  heading4, // ==== Heading
  heading5, // ===== Heading
  paragraph, // Regular text
  codeBlock, // Code blocks
  listItem, // * List items
  orderedListItem,
  checkListItem,
  descriptionListItem,
  qandaListItem,
  link, // https://... or [text](url)
  admonition,
  horizontalRule, // Add this
  styledText, // Add this
}

class AsciiDocElement {
  final AsciiDocElementType type;
  final String content;
  final Map<String, String>? attributes; // For code blocks: language, etc.
  final int level; // For nested lists
  final bool? checked; // For checklists
  final List<AsciiDocElement>? children; // Add this for nested styling

  const AsciiDocElement({
    required this.type,
    required this.content,
    this.attributes,
    this.level = 0,
    this.checked,
    this.children,
  });
}
