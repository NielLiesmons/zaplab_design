import 'package:zaplab_design/zaplab_design.dart';

class AppShortTextParser {
  final _listCounter = _ListCounter();

  List<AppShortTextElement> parse(String text) {
    final List<AppShortTextElement> elements = [];
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
        elements.add(const AppShortTextElement(
          type: AppShortTextElementType.horizontalRule,
          content: '',
        ));
        continue;
      }

      // Reset counters only when we hit a non-list item
      if (!line.startsWith('.')) {
        _listCounter.reset();
        lastListLevel = null;
      }

      // Handle code blocks
      if (line.startsWith('----')) {
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

        elements.add(AppShortTextElement(
          type: AppShortTextElementType.codeBlock,
          content: codeContent.toString().trimRight(),
          attributes: {'language': 'plain'},
        ));
        continue;
      }

      // Handle block quotes
      if (line.startsWith('>')) {
        final String content = line.substring(1).trim();
        final children = _parseStyledText(content);

        elements.add(AppShortTextElement(
          type: AppShortTextElementType.blockQuote,
          content: content,
          children: children,
        ));
        continue;
      }

      // Handle paragraph with styled text
      final children = _parseStyledText(line);

      elements.add(AppShortTextElement(
        type: AppShortTextElementType.paragraph,
        content: line,
        children: children ??
            [
              AppShortTextElement(
                type: AppShortTextElementType.styledText,
                content: line,
              ),
            ],
      ));
    }

    return elements;
  }

  List<AppShortTextElement>? _parseStyledText(String text) {
    if (!text.contains('*') &&
        !text.contains('_') &&
        !text.contains('~') &&
        !text.contains('nostr:') &&
        !text.contains(':') &&
        !text.contains('#') &&
        !text.contains('http') &&
        !text.contains('https')) {
      return null;
    }

    final List<AppShortTextElement> styledElements = [];
    final RegExp combinedPattern =
        RegExp(r'\*_(.*?)_\*'); // Only match *_text_* pattern
    final RegExp combinedPattern2 =
        RegExp(r'_\*(.*?)\*_'); // Only match _*text*_ pattern
    final RegExp boldPattern = RegExp(
        r'\*\*([^*]+)\*\*|' // Markdown bold (this needs to checked first for it to work)
        r'\*(?!_)(.*?)(?<!_)\*' // AsciiDoc bold
        );
    final RegExp italicPattern =
        RegExp(r'_(?!\*)(.*?)(?<!\*)_|' // AsciiDoc italic
            r'_([^_]+)_' // Markdown italic
            );
    final RegExp underlinePattern = RegExp(r'__([^_]+)__');
    final RegExp lineThroughPattern = RegExp(r'~~([^~]+)~~');
    final RegExp nostrEventPattern = RegExp(r'nostr:nevent1\w+');
    final RegExp nostrProfilePattern = RegExp(r'nostr:n(?:pub1|profile1)\w+');
    final RegExp emojiPattern = RegExp(r':([a-zA-Z0-9_-]+):');
    final RegExp hashtagPattern = RegExp(r'(?<=^|\s)#([a-zA-Z0-9_]+)');
    final RegExp imageUrlPattern = RegExp(
        r'https?:\/\/[^\s<>"]+?\/[^\s<>"]+?\.(png|jpe?g|gif|webp|avif)(\?[^"\s<>]*)?',
        caseSensitive: false);
    final RegExp urlPattern = RegExp(
      r'(?:https?:\/\/|www\.)([-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&//=]*))',
      caseSensitive: false,
    );

    int currentPosition = 0;

    while (currentPosition < text.length) {
      final Match? imageUrlMatch =
          imageUrlPattern.matchAsPrefix(text, currentPosition);
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
          nostrProfilePattern.matchAsPrefix(text, currentPosition);
      final Match? emojiMatch =
          emojiPattern.matchAsPrefix(text, currentPosition);
      final Match? hashtagMatch =
          hashtagPattern.matchAsPrefix(text, currentPosition);
      final Match? urlMatch = urlPattern.matchAsPrefix(text, currentPosition);

      final List<Match?> matches = [
        imageUrlMatch,
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
        urlMatch,
      ].where((m) => m != null).toList();

      if (matches.isEmpty) {
        // If no matches found, add one character and continue
        if (currentPosition < text.length) {
          styledElements.add(AppShortTextElement(
            type: AppShortTextElementType.styledText,
            content: text[currentPosition],
          ));
        }
        currentPosition++;
        continue;
      }

      final Match firstMatch = matches.reduce((a, b) {
        // If starts are equal, prioritize image URLs over regular URLs
        if (a!.start == b!.start) {
          if (a == imageUrlMatch) return a;
          if (b == imageUrlMatch) return b;
        }
        return a.start < b.start ? a : b;
      })!;

      // Add any text before the match
      if (firstMatch.start > currentPosition) {
        styledElements.add(AppShortTextElement(
          type: AppShortTextElementType.styledText,
          content: text.substring(currentPosition, firstMatch.start),
        ));
      }

      if (firstMatch == boldMatch ||
          firstMatch == italicMatch ||
          firstMatch == combined1Match ||
          firstMatch == combined2Match ||
          firstMatch == underlineMatch ||
          firstMatch == lineThroughMatch) {
        // Get content from the appropriate capture group
        final String content = firstMatch == boldMatch
            ? (firstMatch.group(1) ??
                firstMatch.group(2))! // Try both capture groups
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

        styledElements.add(AppShortTextElement(
          type: AppShortTextElementType.styledText,
          content: content,
          attributes: {'style': style},
        ));
      } else if (firstMatch == emojiMatch) {
        styledElements.add(AppShortTextElement(
          type: AppShortTextElementType.emoji,
          content: firstMatch.group(1)!,
        ));
      } else if (firstMatch == hashtagMatch) {
        styledElements.add(AppShortTextElement(
          type: AppShortTextElementType.hashtag,
          content: firstMatch.group(1)!,
        ));
      } else if (firstMatch == nostrEventMatch) {
        styledElements.add(AppShortTextElement(
          type: AppShortTextElementType.nostrEvent,
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
        styledElements.add(AppShortTextElement(
          type: AppShortTextElementType.nostrProfile,
          content: firstMatch[0]!,
        ));
      } else if (firstMatch == imageUrlMatch) {
        styledElements.add(AppShortTextElement(
          type: AppShortTextElementType.image,
          content: firstMatch[0]!.trim(),
        ));

        // Skip any whitespace after the match before continuing
        int nextPosition = firstMatch.end;
        while (nextPosition < text.length && text[nextPosition] == ' ') {
          nextPosition++;
        }
        currentPosition = nextPosition;
        continue;
      } else if (firstMatch == urlMatch) {
        styledElements.add(AppShortTextElement(
          type: AppShortTextElementType.link,
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
