import 'package:zaplab_design/src/widgets/text/asciidoc/asciidoc_element.dart';

class AsciiDocParser {
  List<AsciiDocElement> parse(String content) {
    final List<AsciiDocElement> elements = [];
    final List<String> lines = content.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];

      if (line.startsWith('=====')) {
        elements.add(AsciiDocElement(
          type: AsciiDocElementType.heading5,
          content: line.replaceAll('=====', '').trim(),
        ));
      } else if (line.startsWith('====')) {
        elements.add(AsciiDocElement(
          type: AsciiDocElementType.heading4,
          content: line.replaceAll('====', '').trim(),
        ));
      } else if (line.startsWith('===')) {
        elements.add(AsciiDocElement(
          type: AsciiDocElementType.heading3,
          content: line.replaceAll('===', '').trim(),
        ));
      } else if (line.startsWith('==')) {
        elements.add(AsciiDocElement(
          type: AsciiDocElementType.heading2,
          content: line.replaceAll('==', '').trim(),
        ));
      } else if (line.startsWith('=')) {
        elements.add(AsciiDocElement(
          type: AsciiDocElementType.heading1,
          content: line.replaceAll('=', '').trim(),
        ));
      }

      // Handle code blocks
      else if (line.startsWith('----')) {
        final StringBuffer codeContent = StringBuffer();
        i++; // Skip the opening delimiter

        // If previous line had brackets, we need to remove the paragraph that was added
        if (i > 1 && lines[i - 2].startsWith('[')) {
          elements
              .removeLast(); // Remove the bracket line that was added as paragraph
        }

        while (i < lines.length && !lines[i].startsWith('----')) {
          codeContent.writeln(lines[i]);
          i++;
        }

        elements.add(AsciiDocElement(
          type: AsciiDocElementType.codeBlock,
          content: codeContent.toString().trimRight(),
          attributes: {'language': 'plain'},
        ));
      }

      // Handle regular paragraphs
      else if (line.isNotEmpty) {
        elements.add(AsciiDocElement(
          type: AsciiDocElementType.paragraph,
          content: line,
        ));
      }
    }

    return elements;
  }
}
