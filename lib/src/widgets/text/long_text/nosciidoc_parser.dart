import 'package:zaplab_design/src/widgets/text/long_text/long_text_element.dart';

class LabNosciiDocParser {
  final _listCounter = _ListCounter();
  bool inBlockQuote = false;
  int blockQuoteLevel = 0;
  final blockQuoteBuffer = StringBuffer();

  List<LongTextElement> parse(String text) {
    final List<LongTextElement> elements = [];
    final List<String> lines = text.split('\n');
    int? lastListLevel;

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();

      // Handle block quotes
      if (line.startsWith('>')) {
        if (!inBlockQuote) {
          inBlockQuote = true;
          blockQuoteLevel = 1;
          // Count additional > for nested quotes
          while (line.startsWith('>' * (blockQuoteLevel + 1))) {
            blockQuoteLevel++;
          }
          line = line.substring(blockQuoteLevel).trim();
        } else {
          line = line.substring(blockQuoteLevel).trim();
        }
        blockQuoteBuffer.writeln(line);
        continue;
      } else if (inBlockQuote) {
        // End of block quote
        elements.add(LongTextElement(
          type: LongTextElementType.blockQuote,
          content: blockQuoteBuffer.toString().trim(),
          level: blockQuoteLevel,
          children: _parseStyledText(blockQuoteBuffer.toString().trim()),
        ));
        blockQuoteBuffer.clear();
        inBlockQuote = false;
        blockQuoteLevel = 0;
      }

      // Handle empty lines by creating empty paragraphs
      if (line.isEmpty) {
        continue;
      }

      // Handle horizontal rules
      if (line == '---' || line == '- - -' || line == '***') {
        elements.add(const LongTextElement(
          type: LongTextElementType.horizontalRule,
          content: '',
        ));
        continue;
      }

      // Reset counters only when we hit a non-list item
      if (!line.startsWith('=') &&
          !RegExp(r'^\*+\s')
              .hasMatch(line) && // Match one or more * followed by space
          !line.startsWith('.') &&
          !line.startsWith('-') &&
          !line.startsWith('+') &&
          !line.startsWith(RegExp(r'^\d+\.'))) {
        _listCounter.reset();
        lastListLevel = null;
      }

      // Handle images and their captions first
      if (line.startsWith('image::') ||
          (line.startsWith('.') &&
              i + 1 < lines.length &&
              lines[i + 1].startsWith('image::'))) {
        if (line.startsWith('.')) {
          // Skip this iteration as we'll handle it in the next one
          continue;
        }

        // Rest of the image handling code...
        final RegExp imagePattern = RegExp(r'image::([^\[]+)\[(.*?)\]');
        final Match? match = imagePattern.firstMatch(line);

        if (match != null) {
          final String path = match.group(1)!;
          final String attributesStr =
              match.group(2) ?? ''; // Default to empty string if no attributes

          String? title;
          if (i > 0 && lines[i - 1].trim().startsWith('.')) {
            title = lines[i - 1].substring(1).trim();
          }

          elements.add(LongTextElement(
            type: LongTextElementType.image,
            content: path,
            attributes: {
              if (title != null) 'title': title,
              'alt': attributesStr,
            },
          ));
          continue;
        }
      }

      // Unordered lists (including AsciiDoc's multiple asterisks)
      if (RegExp(r'^\*+\s').hasMatch(line)) {
        final int level = _countLeadingAsterisks(line);
        final String content = line.replaceAll(RegExp(r'^\*+\s*'), '').trim();

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

      // Ordered lists
      if (line.startsWith('.')) {
        final int level = _countLeadingDots(line);

        // // Only reset if we went to a shallower level
        // if (lastListLevel != null && level < lastListLevel) {
        //   // _listCounter.reset();
        // }
        lastListLevel = level - 1;

        elements.add(LongTextElement(
          type: LongTextElementType.orderedListItem,
          content: line.replaceAll(RegExp(r'^\.+\s*'), '').trim(),
          level: level - 1,
          attributes: {'number': _listCounter.nextNumber(level)},
          children:
              _parseStyledText(line.replaceAll(RegExp(r'^\.+\s*'), '').trim()),
        ));
        continue;
      }

      // Description lists
      else if (line.contains('::')) {
        final parts = line.split('::');
        if (parts.length == 2) {
          elements.add(LongTextElement(
            type: LongTextElementType.descriptionListItem,
            content: parts[0].trim(),
            attributes: {'description': parts[1].trim()},
          ));
        }
      }

      if (line.startsWith('=====')) {
        elements.add(LongTextElement(
          type: LongTextElementType.heading5,
          content: line.replaceAll('=====', '').trim(),
        ));
      } else if (line.startsWith('====')) {
        elements.add(LongTextElement(
          type: LongTextElementType.heading4,
          content: line.replaceAll('====', '').trim(),
        ));
      } else if (line.startsWith('===')) {
        elements.add(LongTextElement(
          type: LongTextElementType.heading3,
          content: line.replaceAll('===', '').trim(),
        ));
      } else if (line.startsWith('==')) {
        elements.add(LongTextElement(
          type: LongTextElementType.heading2,
          content: line.replaceAll('==', '').trim(),
        ));
      } else if (line.startsWith('=')) {
        elements.add(LongTextElement(
          type: LongTextElementType.heading1,
          content: line.replaceAll('=', '').trim(),
        ));
      }

      // Handle code blocks
      else if (line.startsWith('----')) {
        final StringBuffer codeContent = StringBuffer();
        i++; // Skip the opening delimiter

        // If previous line had brackets, we need to remove the paragraph that was added
        if (i > 1 && lines[i - 2].startsWith('[')) {
          elements.removeLast();
        }

        while (i < lines.length && !lines[i].startsWith('----')) {
          codeContent.writeln(lines[i]);
          i++;
        }

        elements.add(LongTextElement(
          type: LongTextElementType.codeBlock,
          content: codeContent.toString().trimRight(),
          attributes: {'language': 'plain'},
        ));
        continue;
      }

      if (line == '____') {
        final StringBuffer quoteContent = StringBuffer();
        i++; // Skip the opening delimiter

        while (i < lines.length && !lines[i].startsWith('____')) {
          quoteContent.writeln(lines[i]);
          i++;
        }

        elements.add(LongTextElement(
          type: LongTextElementType.blockQuote,
          content: quoteContent.toString().trim(),
          children: _parseStyledText(quoteContent.toString().trim()),
        ));
        continue;
      }

      if (line.startsWith('[quote')) {
        // Skip the [quote] line
        i++;
        if (i < lines.length) {
          final StringBuffer quoteContent = StringBuffer();
          while (i < lines.length && lines[i].trim().isNotEmpty) {
            quoteContent.writeln(lines[i]);
            i++;
          }
          elements.add(LongTextElement(
            type: LongTextElementType.blockQuote,
            content: quoteContent.toString().trim(),
            children: _parseStyledText(quoteContent.toString().trim()),
          ));
        }
        continue;
      }

      // Handle admonitions
      if (line.startsWith('NOTE:') ||
          line.startsWith('TIP:') ||
          line.startsWith('IMPORTANT:') ||
          line.startsWith('WARNING:') ||
          line.startsWith('CAUTION:')) {
        final int colonIndex = line.indexOf(':');
        final String type = line.substring(0, colonIndex);
        final String admonitionContent = line.substring(colonIndex + 1).trim();

        elements.add(LongTextElement(
          type: LongTextElementType.admonition,
          content: admonitionContent,
          attributes: {'type': type.toLowerCase()},
        ));
      }

      // In the parse method, before handling paragraphs, add this check
      if (line.startsWith('[.lead]')) {
        // Skip this line and process the next one as a lead paragraph
        i++;
        if (i < lines.length) {
          final String paragraphContent = lines[i].trim();
          elements.add(LongTextElement(
            type: LongTextElementType.paragraph,
            content: paragraphContent,
            attributes: {'role': 'lead'},
          ));
        }
        continue;
      }

      // Handle paragraph with styled text
      if (!line.startsWith('=') &&
          !RegExp(r'^\*+\s').hasMatch(line) &&
          !line.startsWith('.') &&
          !line.startsWith('NOTE:') &&
          !line.startsWith('TIP:') &&
          !line.startsWith('IMPORTANT:') &&
          !line.startsWith('WARNING:') &&
          !line.startsWith('CAUTION:') &&
          !line.startsWith('----') &&
          !line.startsWith('image::')) {
        final children = _parseStyledText(line);

        elements.add(LongTextElement(
          type: LongTextElementType.paragraph,
          content: line,
          children: children,
        ));
      }
    }

    // Handle any remaining block quote
    if (inBlockQuote) {
      elements.add(LongTextElement(
        type: LongTextElementType.blockQuote,
        content: blockQuoteBuffer.toString().trim(),
        level: blockQuoteLevel,
      ));
    }

    return elements;
  }

  int _countLeadingAsterisks(String line) {
    int count = 0;
    for (int i = 0; i < line.length; i++) {
      if (line[i] == '*') {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  int _countLeadingDots(String line) {
    int count = 0;
    for (int i = 0; i < line.length; i++) {
      if (line[i] == '.') {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  bool? _parseCheckboxState(String content) {
    if (content.startsWith('[ ]')) return false;
    if (content.startsWith('[*]') || content.startsWith('[x]')) return true;
    return null;
  }

  List<LongTextElement>? _parseStyledText(String text) {
    if (!text.contains('*') &&
        !text.contains('_') &&
        !text.contains('`') &&
        !text.contains('nostr:') &&
        !text.contains(':') &&
        !text.contains('#') &&
        !text.contains('http') &&
        !text.contains('www') &&
        !text.contains("'")) {
      return null;
    }

    final List<LongTextElement> styledElements = [];
    // Make combined patterns more specific and check them first
    final RegExp combinedPattern =
        RegExp(r'\*_(.*?)_\*'); // Only match *_text_* pattern
    final RegExp combinedPattern2 =
        RegExp(r'_\*(.*?)\*_'); // Only match _*text*_ pattern
    final RegExp boldPattern = RegExp(
        r'\*\*([^*]+)\*\*|' // Markdown bold (this needs to checked first for it to work)
        r'\*(?!_)(.*?)(?<!_)\*' // AsciiDoc bold
        );
    final RegExp italicPattern =
        RegExp(r'_(?!\*)(.*?)(?<!\*)_'); // Match _ but not _* or *_
    final RegExp underlinePattern = RegExp(r'\[\.underline\]#(.*?)#');
    final RegExp lineThroughPattern = RegExp(r'\[\.line-through\]#(.*?)#');
    final RegExp nostrModelPattern = RegExp(r'nostr:nevent1\w+');
    final RegExp nostrProfilePattern = RegExp(r'nostr:n(?:pub1|profile1)\w+');
    final RegExp emojiPattern = RegExp(r':([a-zA-Z0-9_-]+):');
    final RegExp hashtagPattern = RegExp(r'(?<=^|\s)#([a-zA-Z0-9_-]+)');
    final RegExp urlPattern = RegExp(
      r'(?:https?:\/\/|www\.)([-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&//=]*))',
      caseSensitive: false,
    );
    final RegExp monospacePattern = RegExp(r'`([^`]+)`');
    final RegExp namedLinkPattern = RegExp(r'(https?://[^\s\[]+)\[([^\]]+)\]');
    int currentPosition = 0;

    while (currentPosition < text.length) {
      final Match? combined1Match =
          combinedPattern.matchAsPrefix(text, currentPosition);
      final Match? combined2Match =
          combinedPattern2.matchAsPrefix(text, currentPosition);
      final Match? boldMatch = boldPattern.matchAsPrefix(text, currentPosition);
      final Match? italicMatch =
          italicPattern.matchAsPrefix(text, currentPosition);
      final Match? underlineMatch =
          underlinePattern.matchAsPrefix(text, currentPosition);
      final Match? lineThroughMatch =
          lineThroughPattern.matchAsPrefix(text, currentPosition);
      final Match? nostrModelMatch =
          nostrModelPattern.matchAsPrefix(text, currentPosition);
      final Match? nostrProfileMatch =
          nostrProfilePattern.firstMatch(text.substring(currentPosition));
      final Match? emojiMatch =
          emojiPattern.matchAsPrefix(text, currentPosition);
      final Match? hashtagMatch =
          hashtagPattern.matchAsPrefix(text, currentPosition);
      final Match? urlMatch = urlPattern.matchAsPrefix(text, currentPosition);
      final Match? monospaceMatch =
          monospacePattern.firstMatch(text.substring(currentPosition));
      final Match? namedLinkMatch =
          namedLinkPattern.firstMatch(text.substring(currentPosition));

      final List<Match?> matches = [
        combined1Match,
        combined2Match,
        boldMatch,
        italicMatch,
        underlineMatch,
        lineThroughMatch,
        monospaceMatch,
        nostrModelMatch,
        nostrProfileMatch,
        emojiMatch,
        hashtagMatch,
        urlMatch,
        namedLinkMatch,
      ].where((m) => m != null).toList();

      if (matches.isEmpty) {
        // If no matches found, add one character and continue
        if (currentPosition < text.length) {
          styledElements.add(LongTextElement(
            type: LongTextElementType.styledText,
            content: text[currentPosition],
          ));
        }
        currentPosition++;
        continue;
      }

      final Match firstMatch =
          matches.reduce((a, b) => a!.start < b!.start ? a : b)!;

      // Add any text before the match
      if (firstMatch.start > currentPosition) {
        styledElements.add(LongTextElement(
          type: LongTextElementType.styledText,
          content: text.substring(currentPosition, firstMatch.start),
        ));
      }

      if (firstMatch == boldMatch ||
          firstMatch == italicMatch ||
          firstMatch == combined1Match ||
          firstMatch == combined2Match ||
          firstMatch == underlineMatch ||
          firstMatch == lineThroughMatch) {
        final String content = firstMatch == boldMatch
            ? (firstMatch.group(1) ?? firstMatch.group(2))!
            : firstMatch.group(1)!;
        final String style =
            (firstMatch == combined1Match || firstMatch == combined2Match)
                ? 'bold-italic'
                : firstMatch == boldMatch
                    ? 'bold'
                    : firstMatch == italicMatch
                        ? 'italic'
                        : firstMatch == underlineMatch
                            ? 'underline'
                            : 'line-through';

        styledElements.add(LongTextElement(
          type: LongTextElementType.styledText,
          content: content,
          attributes: {'style': style},
        ));
      } else if (firstMatch == emojiMatch) {
        styledElements.add(LongTextElement(
          type: LongTextElementType.emoji,
          content: firstMatch.group(1)!,
        ));
      } else if (firstMatch == hashtagMatch) {
        styledElements.add(LongTextElement(
          type: LongTextElementType.hashtag,
          content: firstMatch.group(1)!,
        ));
      } else if (firstMatch == nostrModelMatch) {
        styledElements.add(LongTextElement(
          type: LongTextElementType.nostrModel,
          content: firstMatch[0]!.trim(),
        ));
      } else if (firstMatch == nostrProfileMatch) {
        styledElements.add(LongTextElement(
          type: LongTextElementType.nostrProfile,
          content: firstMatch[0]!,
        ));
      } else if (firstMatch == urlMatch) {
        styledElements.add(LongTextElement(
          type: LongTextElementType.link,
          content: firstMatch[0]!,
        ));
      } else if (firstMatch == namedLinkMatch) {
        styledElements.add(LongTextElement(
          type: LongTextElementType.link,
          content: firstMatch.group(2)!,
          attributes: {'url': firstMatch.group(1)!},
        ));
      } else if (firstMatch == monospaceMatch) {
        styledElements.add(LongTextElement(
          type: LongTextElementType.monospace,
          content: firstMatch.group(1)!,
        ));
      }

      currentPosition = firstMatch.end;
    }

    return styledElements;
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
      if (text.startsWith('_', currentPos)) {
        final endPos = text.indexOf('_', currentPos + 1);
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
    final specials = ['**', '_', '[', '`', 'http', 'www'];
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
    // Initialize if needed
    while (_numbers.length < level) {
      _numbers.add(0);
    }

    // If we're moving to a higher level (fewer dots)
    if (_lastLevel != null && level < _lastLevel!) {
      // Clear deeper levels
      _numbers.length = level + 1;
      // Increment this level
      _numbers[level - 1]++;
    }
    // If we're at the same level
    else if (level == _lastLevel) {
      // Always increment when at the same level
      _numbers[level - 1]++;
    }
    // If we're moving to a deeper level or first number
    else {
      // If we're moving deeper, keep parent numbers
      if (level > 1 && _lastLevel != null && _lastLevel! < level) {
        // Ensure we have space for the new level
        while (_numbers.length < level) {
          _numbers.add(0);
        }
        // Initialize this level at 1
        _numbers[level - 1] = 1;
      }
      // If it's the first number at this level
      else if (_numbers[level - 1] == 0) {
        _numbers[level - 1] = 1;
      }
      // If we're at the same level but after a deeper level
      else if (level == _lastLevel) {
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
