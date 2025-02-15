import 'package:zaplab_design/zaplab_design.dart';

class ShortTextParser {
  final _listCounter = _ListCounter();

  List<ShortTextElement> parse(String text) {
    final List<ShortTextElement> elements = [];
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
        elements.add(const ShortTextElement(
          type: ShortTextElementType.horizontalRule,
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

          elements.add(ShortTextElement(
            type: ShortTextElementType.image,
            content: path,
            attributes: {
              if (title != null) 'title': title,
              'alt': attributesStr,
            },
          ));
          continue;
        }
      }

      if (line.startsWith('=====')) {
        elements.add(ShortTextElement(
          type: ShortTextElementType.heading5,
          content: line.replaceAll('=====', '').trim(),
        ));
      } else if (line.startsWith('====')) {
        elements.add(ShortTextElement(
          type: ShortTextElementType.heading4,
          content: line.replaceAll('====', '').trim(),
        ));
      } else if (line.startsWith('===')) {
        elements.add(ShortTextElement(
          type: ShortTextElementType.heading3,
          content: line.replaceAll('===', '').trim(),
        ));
      } else if (line.startsWith('==')) {
        elements.add(ShortTextElement(
          type: ShortTextElementType.heading2,
          content: line.replaceAll('==', '').trim(),
        ));
      } else if (line.startsWith('=')) {
        elements.add(ShortTextElement(
          type: ShortTextElementType.heading1,
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

        elements.add(ShortTextElement(
          type: ShortTextElementType.codeBlock,
          content: codeContent.toString().trimRight(),
          attributes: {'language': 'plain'},
        ));
      }

      // Handle paragraph with styled text
      if (!line.startsWith('=') &&
          !line.startsWith('*') &&
          !line.startsWith('.') &&
          !line.startsWith('----')) {
        final children = _parseStyledText(line);

        elements.add(ShortTextElement(
          type: ShortTextElementType.paragraph,
          content: line,
          children: children,
        ));
      }
    }

    return elements;
  }

  List<ShortTextElement>? _parseStyledText(String text) {
    if (!text.contains('*') &&
        !text.contains('_') &&
        !text.contains('[.') &&
        !text.contains('nostr:') &&
        !text.contains(':') &&
        !text.contains('#') &&
        !text.contains('http') &&
        !text.contains('https')) {
      return null;
    }

    final List<ShortTextElement> styledElements = [];
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
    final RegExp hashtagPattern = RegExp(r'(?<=^|\s)#([a-zA-Z0-9_]+)');
    final RegExp imageUrlPattern = RegExp(
        r'https?:\/\/[^\s<>"]+?\/[^\s<>"]+?\.(png|jpe?g|gif|webp|avif)(\?[^"\s<>]*)?',
        caseSensitive: false);
    final RegExp urlPattern = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
      caseSensitive: false,
    );

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
      final Match? imageUrlMatch =
          imageUrlPattern.matchAsPrefix(text, currentPosition);
      final Match? urlMatch = urlPattern.matchAsPrefix(text, currentPosition);

      final List<Match?> matches = [
        combined1Match,
        combined2Match,
        boldMatch,
        italicMatch,
        underlineMatch,
        lineThroughMatch,
        nostrEventMatch,
        nostrProfileMatch,
        emojiMatch,
        hashtagMatch,
        imageUrlMatch,
        urlMatch,
      ].where((m) => m != null).toList();

      if (matches.isEmpty) {
        // If no matches found, add one character and continue
        if (currentPosition < text.length) {
          styledElements.add(ShortTextElement(
            type: ShortTextElementType.styledText,
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
        styledElements.add(ShortTextElement(
          type: ShortTextElementType.styledText,
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

        styledElements.add(ShortTextElement(
          type: ShortTextElementType.styledText,
          content: content,
          attributes: {'style': style},
        ));
      } else if (firstMatch == emojiMatch) {
        styledElements.add(ShortTextElement(
          type: ShortTextElementType.emoji,
          content: firstMatch.group(1)!,
        ));
      } else if (firstMatch == hashtagMatch) {
        styledElements.add(ShortTextElement(
          type: ShortTextElementType.hashtag,
          content: firstMatch.group(1)!,
        ));
      } else if (firstMatch == nostrEventMatch) {
        styledElements.add(ShortTextElement(
          type: ShortTextElementType.nostrEvent,
          content: firstMatch[0]!,
        ));
      } else if (firstMatch == nostrProfileMatch) {
        styledElements.add(ShortTextElement(
          type: ShortTextElementType.nostrProfile,
          content: firstMatch[0]!,
        ));
      } else if (firstMatch == imageUrlMatch) {
        styledElements.add(ShortTextElement(
          type: ShortTextElementType.image,
          content: firstMatch[0]!,
        ));
      } else if (firstMatch == urlMatch) {
        styledElements.add(ShortTextElement(
          type: ShortTextElementType.link,
          content: firstMatch[0]!,
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

    _lastLevel = level; // Changed this to maintain the actual level

    // Build the number string
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
