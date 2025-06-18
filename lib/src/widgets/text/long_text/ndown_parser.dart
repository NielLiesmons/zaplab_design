import 'package:zaplab_design/src/widgets/text/long_text/long_text_element.dart';

class LabNDownParser {
  final _listCounter = _ListCounter();

  List<LongTextElement> parse(String text) {
    final List<LongTextElement> elements = [];
    final List<String> lines = text.split('\n');
    int? lastListLevel;
    var inCodeBlock = false;
    var codeBlockLanguage = '';
    var codeBlockContent = '';
    var inBlockQuote = false;
    var blockQuoteContent = '';

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();

      // Skip empty lines
      if (line.isEmpty) {
        continue;
      }

      // Handle horizontal rules
      if (line == '---' || line == '***' || line == '___') {
        elements.add(const LongTextElement(
          type: LongTextElementType.horizontalRule,
          content: '',
        ));
        continue;
      }

      // Reset counters only when we hit a non-list item
      if (!line.startsWith('-') &&
          !line.startsWith('*') &&
          !line.startsWith('+') &&
          !line.startsWith(RegExp(r'^\d+\.'))) {
        _listCounter.reset();
        lastListLevel = null;
      }

      // Handle images and their captions
      if (line.startsWith('![') || line.startsWith('![')) {
        final RegExp imagePattern = RegExp(r'!\[(.*?)\]\((.*?)\)');
        final Match? match = imagePattern.firstMatch(line);

        if (match != null) {
          final String alt = match.group(1)!;
          final String path = match.group(2)!;

          elements.add(LongTextElement(
            type: LongTextElementType.image,
            content: path,
            attributes: {
              'alt': alt,
            },
          ));
          continue;
        }
      }

      // Unordered lists
      if ((line.startsWith('- ') ||
          line.startsWith('* ') ||
          line.startsWith('+ '))) {
        final int level = _countLeadingIndent(line);
        final String content = line.replaceAll(RegExp(r'^[-*+]\s*'), '').trim();

        // Check if it's a checklist item
        if (content.startsWith('[')) {
          final bool? checked = _parseCheckboxState(content);
          if (checked != null) {
            elements.add(LongTextElement(
              type: LongTextElementType.checkListItem,
              content: content.substring(4).trim(), // Remove checkbox
              level: level,
              checked: checked,
            ));
            continue;
          }
        }

        elements.add(LongTextElement(
          type: LongTextElementType.listItem,
          content: content,
          level: level,
          children: _parseInlineContent(content),
        ));
        continue;
      }

      // Handle ordered lists
      if (RegExp(r'^\d+\. ').hasMatch(line)) {
        final match = RegExp(r'^(\d+)\. ').firstMatch(line);
        elements.add(LongTextElement(
          type: LongTextElementType.orderedListItem,
          content: line.substring(match!.end),
          attributes: {'number': match.group(1)!},
        ));
        continue;
      }

      // Headings
      if (line.startsWith('#')) {
        final int level = _countLeadingHashes(line);
        final String content = line.replaceAll(RegExp(r'^#+\s*'), '').trim();

        elements.add(LongTextElement(
          type: LongTextElementType.values[level - 1],
          content: content,
        ));
        continue;
      }

      // Handle code blocks
      if (line.startsWith('```')) {
        if (!inCodeBlock) {
          inCodeBlock = true;
          codeBlockLanguage = line.substring(3).trim();
          codeBlockContent = '';
        } else {
          inCodeBlock = false;
          elements.add(LongTextElement(
            type: LongTextElementType.codeBlock,
            content: codeBlockContent,
            attributes: {'language': codeBlockLanguage},
          ));
        }
        continue;
      }

      if (inCodeBlock) {
        codeBlockContent += '$line\n';
        continue;
      }

      // Handle block quotes
      if (line.startsWith('> ')) {
        if (!inBlockQuote) {
          inBlockQuote = true;
          blockQuoteContent = line.substring(2);
        } else {
          blockQuoteContent += '\n${line.substring(2)}';
        }
        continue;
      } else if (inBlockQuote) {
        inBlockQuote = false;
        elements.add(LongTextElement(
          type: LongTextElementType.blockQuote,
          content: blockQuoteContent,
          level: 1,
          children: _parseInlineContent(blockQuoteContent),
        ));
      }

      // Handle paragraph with styled text
      final children = _parseInlineContent(line);

      elements.add(LongTextElement(
        type: LongTextElementType.paragraph,
        content: line,
        children: children,
      ));
    }

    // Handle any remaining block quote
    if (inBlockQuote) {
      elements.add(LongTextElement(
        type: LongTextElementType.blockQuote,
        content: blockQuoteContent,
        level: 1,
        children: _parseInlineContent(blockQuoteContent),
      ));
    }

    return elements;
  }

  int _countLeadingIndent(String line) {
    int count = 0;
    for (int i = 0; i < line.length; i++) {
      if (line[i] == ' ' || line[i] == '\t') {
        count++;
      } else {
        break;
      }
    }
    return count ~/ 2; // Assuming 2 spaces per level
  }

  int _countLeadingHashes(String line) {
    int count = 0;
    for (int i = 0; i < line.length; i++) {
      if (line[i] == '#') {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  bool? _parseCheckboxState(String content) {
    if (content.startsWith('[ ]')) return false;
    if (content.startsWith('[x]') || content.startsWith('[X]')) return true;
    return null;
  }

  List<LongTextElement> _parseInlineContent(String text) {
    final elements = <LongTextElement>[];
    var currentPos = 0;

    while (currentPos < text.length) {
      // Handle bold
      if (text.startsWith('**', currentPos)) {
        final endPos = text.indexOf('**', currentPos + 2);
        if (endPos != -1) {
          elements.add(LongTextElement(
            type: LongTextElementType.styledText,
            content: text.substring(currentPos + 2, endPos),
            attributes: {'style': 'bold'},
          ));
          currentPos = endPos + 2;
          continue;
        }
      }

      // Handle italic
      if (text.startsWith('*', currentPos)) {
        final endPos = text.indexOf('*', currentPos + 1);
        if (endPos != -1) {
          elements.add(LongTextElement(
            type: LongTextElementType.styledText,
            content: text.substring(currentPos + 1, endPos),
            attributes: {'style': 'italic'},
          ));
          currentPos = endPos + 1;
          continue;
        }
      }

      // Handle links
      final linkMatch =
          RegExp(r'\[(.*?)\]\((.*?)\)').matchAsPrefix(text, currentPos);
      if (linkMatch != null) {
        elements.add(LongTextElement(
          type: LongTextElementType.link,
          content: linkMatch.group(1)!,
          attributes: {'url': linkMatch.group(2)!},
        ));
        currentPos = linkMatch.end;
        continue;
      }

      // Handle monospace
      if (text.startsWith('`', currentPos)) {
        final endPos = text.indexOf('`', currentPos + 1);
        if (endPos != -1) {
          elements.add(LongTextElement(
            type: LongTextElementType.monospace,
            content: text.substring(currentPos + 1, endPos),
          ));
          currentPos = endPos + 1;
          continue;
        }
      }

      // Handle plain URLs
      final urlMatch = RegExp(
        r'(?:https?:\/\/|www\.)([-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&//=]*))',
        caseSensitive: false,
      ).matchAsPrefix(text, currentPos);
      if (urlMatch != null) {
        elements.add(LongTextElement(
          type: LongTextElementType.link,
          content: urlMatch.group(0)!,
        ));
        currentPos = urlMatch.end;
        continue;
      }

      // Handle plain text
      final nextSpecial = _findNextSpecial(text, currentPos);
      if (nextSpecial != -1) {
        elements.add(LongTextElement(
          type: LongTextElementType.styledText,
          content: text.substring(currentPos, nextSpecial),
        ));
        currentPos = nextSpecial;
      } else {
        elements.add(LongTextElement(
          type: LongTextElementType.styledText,
          content: text.substring(currentPos),
        ));
        break;
      }
    }

    return elements;
  }

  int _findNextSpecial(String text, int startPos) {
    final specials = ['**', '*', '[', '`', 'http', 'www'];
    var earliestPos = text.length;

    for (final special in specials) {
      final pos = text.indexOf(special, startPos);
      if (pos != -1 && pos < earliestPos) {
        earliestPos = pos;
      }
    }

    return earliestPos < text.length ? earliestPos : -1;
  }
}

class _ListCounter {
  final List<int> _numbers = [];
  int? _lastLevel;

  String nextNumber(int level) {
    if (level <= 0) {
      return '1';
    }

    while (_numbers.length < level) {
      _numbers.add(0);
    }

    if (_lastLevel != null && level < _lastLevel!) {
      _numbers.length = level + 1;
      _numbers[level - 1]++;
    } else if (level == _lastLevel) {
      _numbers[level - 1]++;
    } else {
      if (level > 1 && _lastLevel != null && _lastLevel! < level) {
        while (_numbers.length < level) {
          _numbers.add(0);
        }
        _numbers[level - 1] = 1;
      } else if (_numbers[level - 1] == 0) {
        _numbers[level - 1] = 1;
      } else if (level == _lastLevel) {
        _numbers[level - 1]++;
      }
    }

    _lastLevel = level;

    List<String> displayNumbers = [];
    for (int i = 0; i < level; i++) {
      displayNumbers.add(_numbers[i].toString());
    }
    return displayNumbers.join('.');
  }

  void reset() {
    _numbers.clear();
    _lastLevel = null;
  }
}




// LabMarkDownParser