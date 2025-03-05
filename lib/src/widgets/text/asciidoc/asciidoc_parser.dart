import 'package:zaplab_design/src/widgets/text/asciidoc/asciidoc_element.dart';

class AsciiDocParser {
  final _listCounter = _ListCounter();

  List<AsciiDocElement> parse(String text) {
    final List<AsciiDocElement> elements = [];
    final List<String> lines = text.split('\n');
    int? lastListLevel;

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();

      // Skip empty lines
      if (line.isEmpty) {
        continue;
      }

      // Handle horizontal rules
      if (line == '---' || line == '- - -' || line == '***') {
        elements.add(const AsciiDocElement(
          type: AsciiDocElementType.horizontalRule,
          content: '',
        ));
        continue;
      }

      // Reset counters only when we hit a non-list item
      if (!line.startsWith('.')) {
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

          elements.add(AsciiDocElement(
            type: AsciiDocElementType.image,
            content: path,
            attributes: {
              if (title != null) 'title': title,
              'alt': attributesStr,
            },
          ));
          continue;
        }
      }

      // Unordered lists
      if (line.startsWith('*')) {
        final int level = _countLeadingAsterisk(line);
        final String content = line.replaceAll(RegExp(r'^\*+\s*'), '').trim();

        // Check if it's a checklist item
        if (content.startsWith('[')) {
          final bool? checked = _parseCheckboxState(content);
          if (checked != null) {
            elements.add(AsciiDocElement(
              type: AsciiDocElementType.checkListItem,
              content: content.substring(4).trim(), // Remove checkbox
              level: level - 1,
              checked: checked,
            ));
            continue;
          }
        }

        elements.add(AsciiDocElement(
          type: AsciiDocElementType.listItem,
          content: content,
          level: level - 1,
        ));
      }

      // Ordered lists
      if (line.startsWith('.')) {
        final int level = _countLeadingDots(line);

        // // Only reset if we went to a shallower level
        // if (lastListLevel != null && level < lastListLevel) {
        //   // _listCounter.reset();
        // }
        lastListLevel = level - 1;

        elements.add(AsciiDocElement(
          type: AsciiDocElementType.orderedListItem,
          content: line.replaceAll(RegExp(r'^\.+\s*'), '').trim(),
          level: level - 1,
          attributes: {'number': _listCounter.nextNumber(level)},
        ));
        continue;
      }

      // Description lists
      else if (line.contains('::')) {
        final parts = line.split('::');
        if (parts.length == 2) {
          elements.add(AsciiDocElement(
            type: AsciiDocElementType.descriptionListItem,
            content: parts[0].trim(),
            attributes: {'description': parts[1].trim()},
          ));
        }
      }

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

      // Handle admonitions
      else if (line.startsWith('NOTE:') ||
          line.startsWith('TIP:') ||
          line.startsWith('IMPORTANT:') ||
          line.startsWith('WARNING:') ||
          line.startsWith('CAUTION:')) {
        final int colonIndex = line.indexOf(':');
        final String type = line.substring(0, colonIndex);
        final String admonitionContent = line.substring(colonIndex + 1).trim();

        elements.add(AsciiDocElement(
          type: AsciiDocElementType.admonition,
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
          elements.add(AsciiDocElement(
            type: AsciiDocElementType.paragraph,
            content: paragraphContent,
            attributes: {'role': 'lead'},
          ));
        }
        continue;
      }

      // Handle paragraph with styled text
      if (!line.startsWith('=') &&
          !line.startsWith('*') &&
          !line.startsWith('.') &&
          !line.startsWith('NOTE:') &&
          !line.startsWith('TIP:') &&
          !line.startsWith('IMPORTANT:') &&
          !line.startsWith('WARNING:') &&
          !line.startsWith('CAUTION:') &&
          !line.startsWith('----') &&
          !line.startsWith('image::')) {
        final children = _parseStyledText(line);

        elements.add(AsciiDocElement(
          type: AsciiDocElementType.paragraph,
          content: line,
          children: children,
        ));
      }
    }

    return elements;
  }

  int _countLeadingAsterisk(String line) {
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

  List<AsciiDocElement>? _parseStyledText(String text) {
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

    final List<AsciiDocElement> styledElements = [];
    // Make combined patterns more specific and check them first
    final RegExp combinedPattern =
        RegExp(r'\*_(.*?)_\*'); // Only match *_text_* pattern
    final RegExp combinedPattern2 =
        RegExp(r'_\*(.*?)\*_'); // Only match _*text*_ pattern
    final RegExp boldPattern =
        RegExp(r'\*(?!_)(.*?)(?<!_)\*'); // Match * but not *_ or _*
    final RegExp italicPattern =
        RegExp(r'_(?!\*)(.*?)(?<!\*)_'); // Match _ but not _* or *_
    final RegExp underlinePattern = RegExp(r'\[\.underline\]#(.*?)#');
    final RegExp lineThroughPattern = RegExp(r'\[\.line-through\]#(.*?)#');
    final RegExp nostrEventPattern = RegExp(r'nostr:nevent1\w+');
    final RegExp nostrProfilePattern = RegExp(r'nostr:n(?:pub1|profile1)\w+');
    final RegExp emojiPattern = RegExp(r':([a-zA-Z0-9_-]+):');
    final RegExp hashtagPattern = RegExp(r'(?<=^|\s)#([a-zA-Z0-9_-]+)');
    final RegExp urlPattern = RegExp(
      r'(?:https?:\/\/|www\.)([-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&//=]*))',
      caseSensitive: false,
    );
    final RegExp monospacePattern = RegExp(r"'([^']+)'");
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
      final Match? nostrEventMatch =
          nostrEventPattern.matchAsPrefix(text, currentPosition);
      final Match? nostrProfileMatch =
          nostrProfilePattern.firstMatch(text.substring(currentPosition));
      final Match? emojiMatch =
          emojiPattern.matchAsPrefix(text, currentPosition);
      final Match? hashtagMatch =
          hashtagPattern.matchAsPrefix(text, currentPosition);
      final Match? urlMatch = urlPattern.matchAsPrefix(text, currentPosition);
      final Match? monospaceMatch =
          monospacePattern.firstMatch(text.substring(currentPosition));

      final List<Match?> matches = [
        combined1Match,
        combined2Match,
        boldMatch,
        italicMatch,
        underlineMatch,
        lineThroughMatch,
        monospaceMatch,
        nostrEventMatch,
        nostrProfileMatch,
        emojiMatch,
        hashtagMatch,
        urlMatch,
      ].where((m) => m != null).toList();

      if (matches.isEmpty) {
        // If no matches found, add one character and continue
        if (currentPosition < text.length) {
          styledElements.add(AsciiDocElement(
            type: AsciiDocElementType.styledText,
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
        styledElements.add(AsciiDocElement(
          type: AsciiDocElementType.styledText,
          content: text.substring(currentPosition, firstMatch.start),
        ));
      }

      if (firstMatch == boldMatch ||
          firstMatch == italicMatch ||
          firstMatch == combined1Match ||
          firstMatch == combined2Match ||
          firstMatch == underlineMatch ||
          firstMatch == lineThroughMatch) {
        final String content = firstMatch.group(1) ?? '';
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

        styledElements.add(AsciiDocElement(
          type: AsciiDocElementType.styledText,
          content: content,
          attributes: {'style': style},
        ));
      } else if (firstMatch == emojiMatch) {
        styledElements.add(AsciiDocElement(
          type: AsciiDocElementType.emoji,
          content: firstMatch.group(1)!,
        ));
      } else if (firstMatch == hashtagMatch) {
        styledElements.add(AsciiDocElement(
          type: AsciiDocElementType.hashtag,
          content: firstMatch.group(1)!,
        ));
      } else if (firstMatch == nostrEventMatch) {
        styledElements.add(AsciiDocElement(
          type: AsciiDocElementType.nostrEvent,
          content: firstMatch[0]!.trim(),
        ));

        // Skip any whitespace after the match before continuing
        int nextPosition = firstMatch.end;
        while (nextPosition < text.length && text[nextPosition] == ' ') {
          nextPosition++;
        }
        currentPosition = nextPosition;
        continue;
      } else if (firstMatch == nostrProfileMatch) {
        styledElements.add(AsciiDocElement(
          type: AsciiDocElementType.nostrProfile,
          content: firstMatch[0]!,
        ));
        currentPosition = firstMatch == nostrProfileMatch
            ? currentPosition + firstMatch.end
            : firstMatch.end;
      } else if (firstMatch == urlMatch) {
        styledElements.add(AsciiDocElement(
          type: AsciiDocElementType.link,
          content: firstMatch[0]!,
        ));
      } else if (firstMatch == monospaceMatch) {
        styledElements.add(AsciiDocElement(
          type: AsciiDocElementType.monospace,
          content: firstMatch.group(1)!,
        ));
      }

      currentPosition = firstMatch.end;
    }

    return styledElements;
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
