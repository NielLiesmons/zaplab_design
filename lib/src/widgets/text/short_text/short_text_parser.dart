import 'package:zaplab_design/zaplab_design.dart';

class LabShortTextParser {
  final _listCounter = _ListCounter();

  List<LabShortTextElement> parse(String text) {
    final List<LabShortTextElement> elements = [];
    final List<String> lines = text.split('\n');
    int? lastListLevel;

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];

      // Handle empty lines by adding a line break
      if (line.isEmpty) {
        elements.add(LabShortTextElement(
          type: LabShortTextElementType.styledText,
          content: '',
        ));
        continue;
      }

      line = line.trim();

      // Handle unordered lists
      if (line.startsWith('- ') ||
          line.startsWith('* ') ||
          line.startsWith('+ ')) {
        final int level = _countLeadingIndent(line);
        final String content = line.replaceAll(RegExp(r'^[-*+]\s*'), '').trim();

        elements.add(LabShortTextElement(
          type: LabShortTextElementType.listItem,
          content: content,
          level: level,
          children: _parseInlineContent(content),
        ));
        continue;
      }

      // Handle ordered lists
      final orderedListMatch = RegExp(r'^\d+\.\s').firstMatch(line);
      if (orderedListMatch != null) {
        final int level = _countLeadingIndent(line);
        final String content = line.replaceAll(RegExp(r'^\d+\.\s*'), '').trim();

        elements.add(LabShortTextElement(
          type: LabShortTextElementType.orderedListItem,
          content: content,
          level: level,
          children: _parseInlineContent(content),
        ));
        continue;
      }

      // Handle headings
      final headingMatch = RegExp(r'^(#{1,5})\s+(.+)').firstMatch(line);
      if (headingMatch != null) {
        final int level = headingMatch.group(1)!.length;
        final String content = headingMatch.group(2)!.trim();
        print('Found heading with level $level: $line');
        print('Creating heading element with content: $content');
        elements.add(LabShortTextElement(
          type: switch (level) {
            1 => LabShortTextElementType.heading1,
            2 => LabShortTextElementType.heading2,
            3 => LabShortTextElementType.heading3,
            4 => LabShortTextElementType.heading4,
            5 => LabShortTextElementType.heading5,
            _ => LabShortTextElementType.paragraph,
          },
          content: content,
        ));
        continue;
      }

      // Reset counters only when we hit a non-list item
      if (!line.startsWith('.')) {
        _listCounter.reset();
        lastListLevel = null;
      }

      // Handle code blocks (both AsciiDoc and Markdown)
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

        elements.add(LabShortTextElement(
          type: LabShortTextElementType.codeBlock,
          content: codeContent.toString().trimRight(),
          attributes: {'language': 'plain'},
        ));
        continue;
      }

      // Handle Markdown code blocks
      if (line.startsWith('```')) {
        final StringBuffer codeContent = StringBuffer();
        final String language = line.substring(3).trim();
        i++; // Skip the opening delimiter

        while (i < lines.length && !lines[i].startsWith('```')) {
          codeContent.writeln(lines[i]);
          i++;
        }

        elements.add(LabShortTextElement(
          type: LabShortTextElementType.codeBlock,
          content: codeContent.toString().trimRight(),
          attributes: {'language': language.isEmpty ? 'plain' : language},
        ));
        continue;
      }

      // Handle block quotes
      if (line.startsWith('>')) {
        final String content = line.substring(1).trim();
        final children = _parseStyledText(content);

        elements.add(LabShortTextElement(
          type: LabShortTextElementType.blockQuote,
          content: content,
          children: children,
        ));
        continue;
      }

      // Handle paragraph with styled text
      final children = _parseStyledText(line);

      // If this is a single emoji or utfEmoji, return it as a standalone element
      if (children != null &&
          children.length == 1 &&
          (children[0].type == LabShortTextElementType.emoji ||
              children[0].type == LabShortTextElementType.utfEmoji)) {
        elements.add(children[0]);
        continue;
      }

      elements.add(LabShortTextElement(
        type: LabShortTextElementType.paragraph,
        content: line,
        children: children ??
            [
              LabShortTextElement(
                type: LabShortTextElementType.styledText,
                content: line,
              ),
            ],
      ));
    }

    return _combineConsecutiveImageElements(elements);
  }

  List<LabShortTextElement> _combineConsecutiveImageElements(
      List<LabShortTextElement> elements) {
    final List<LabShortTextElement> result = [];
    List<String>? currentImageUrls;
    List<LabShortTextElement>? textBeforeImages;

    for (final element in elements) {
      bool hasProcessedImages = false;

      // Check if this is a paragraph that ends with an image
      if (element.type == LabShortTextElementType.paragraph &&
          element.children != null) {
        // Find the last non-text element
        var lastNonText = element.children!.lastWhere(
          (child) => child.type != LabShortTextElementType.styledText,
          orElse: () => element.children!.first,
        );

        // If it's an image, we'll process this paragraph specially
        if (lastNonText.type == LabShortTextElementType.images) {
          // Keep any text that comes before the image
          var textElements = element.children!
              .takeWhile((child) => child != lastNonText)
              .toList();
          if (textElements.isNotEmpty) {
            if (currentImageUrls != null) {
              // If we have pending images, add them before this text

              result.add(LabShortTextElement(
                type: LabShortTextElementType.images,
                content: currentImageUrls.join('\n'),
              ));
              currentImageUrls = null;
            }
            // Add the text as a new paragraph
            result.add(LabShortTextElement(
              type: LabShortTextElementType.paragraph,
              content: element.content,
              children: textElements,
            ));
          }

          // Add this image's URLs to our collection
          final urls = lastNonText.content.split('\n');
          if (currentImageUrls == null) {
            currentImageUrls = urls;
          } else {
            currentImageUrls.addAll(urls);
          }
          hasProcessedImages = true;
        }
      }

      // Handle standalone image elements
      if (!hasProcessedImages &&
          element.type == LabShortTextElementType.images) {
        final urls = element.content.split('\n');
        if (currentImageUrls == null) {
          currentImageUrls = urls;
        } else {
          currentImageUrls.addAll(urls);
        }
        hasProcessedImages = true;
      }

      // If this element wasn't an image and wasn't a paragraph ending with an image
      if (!hasProcessedImages) {
        // Add any pending images before this element
        if (currentImageUrls != null) {
          result.add(LabShortTextElement(
            type: LabShortTextElementType.images,
            content: currentImageUrls.join('\n'),
          ));
          currentImageUrls = null;
        }
        result.add(element);
      }
    }

    // Add any remaining image URLs
    if (currentImageUrls != null) {
      result.add(LabShortTextElement(
        type: LabShortTextElementType.images,
        content: currentImageUrls.join('\n'),
      ));
    }

    return result;
  }

  List<LabShortTextElement>? _parseStyledText(String text) {
    if (!text.contains('*') &&
        !text.contains('_') &&
        !text.contains('~') &&
        !text.contains('`') &&
        !text.contains('nostr:') &&
        !text.contains(':') &&
        !text.contains('#') &&
        !text.contains('http') &&
        !text.contains('https') &&
        !text.contains(RegExp(
            r'[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]|[\u{1F000}-\u{1F02F}]|[\u{1F0A0}-\u{1F0FF}]|[\u{1F100}-\u{1F64F}]|[\u{1F680}-\u{1F6FF}]|[\u{1F900}-\u{1F9FF}]|[\u{1F1E6}-\u{1F1FF}]',
            unicode: true))) {
      return null;
    }

    final List<LabShortTextElement> styledElements = [];
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
    final RegExp monospacePattern = RegExp(r'`([^`]+)`');
    final RegExp nostrModelPattern = RegExp(r'nostr:nevent1\w+');
    final RegExp nostrProfilePattern = RegExp(r'nostr:n(?:pub1|profile1)\w+');
    final RegExp emojiPattern = RegExp(r':([a-zA-Z0-9_-]+):');
    final RegExp markdownLinkPattern = RegExp(r'\[([^\]]+)\]\(([^)]+)\)');
    final RegExp utfEmojiPattern = RegExp(
        r'[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]|[\u{1F000}-\u{1F02F}]|[\u{1F0A0}-\u{1F0FF}]|[\u{1F100}-\u{1F64F}]|[\u{1F680}-\u{1F6FF}]|[\u{1F900}-\u{1F9FF}]|[\u{1F1E6}-\u{1F1FF}]',
        unicode: true);
    final RegExp hashtagPattern = RegExp(r'(?<=^|\s)#([a-zA-Z0-9_]+)');
    final RegExp imageUrlPattern = RegExp(
        r'https?:\/\/[^\s<>"]+?\/[^\s<>"]+?\.(png|jpe?g|gif|webp|avif)(\?[^"\s<>]*)?',
        caseSensitive: false);
    final RegExp audioUrlPattern = RegExp(
        r'https?:\/\/[^\s<>"]+?\/[^\s<>"]+?\.(mp3|wav|ogg|m4a)(\?[^"\s<>]*)?',
        caseSensitive: false);
    final RegExp urlPattern = RegExp(
      r'(?:https?:\/\/|www\.)([-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&//=]*))',
      caseSensitive: false,
    );

    int currentPosition = 0;

    while (currentPosition < text.length) {
      // First check for utfEmoji in the current text
      final utfEmojiMatch =
          utfEmojiPattern.matchAsPrefix(text.substring(currentPosition));
      if (utfEmojiMatch != null) {
        // Add any text before the emoji
        if (utfEmojiMatch.start > 0) {
          styledElements.add(LabShortTextElement(
            type: LabShortTextElementType.styledText,
            content: text.substring(
                currentPosition, currentPosition + utfEmojiMatch.start),
          ));
        }
        // Add the emoji
        styledElements.add(LabShortTextElement(
          type: LabShortTextElementType.utfEmoji,
          content: utfEmojiMatch[0]!,
        ));
        currentPosition += utfEmojiMatch.end;
        continue;
      }

      // Use substring for all matchers and offset indices
      final String remainingText = text.substring(currentPosition);
      final Match? imageUrlMatch = imageUrlPattern.matchAsPrefix(remainingText);
      final Match? audioUrlMatch = audioUrlPattern.matchAsPrefix(remainingText);
      final Match? combined1Match =
          combinedPattern.matchAsPrefix(remainingText);
      final Match? combined2Match =
          combinedPattern2.matchAsPrefix(remainingText);
      final Match? boldMatch = boldPattern.matchAsPrefix(remainingText);
      final Match? italicMatch = italicPattern.matchAsPrefix(remainingText);
      final Match? underlineMatch =
          underlinePattern.matchAsPrefix(remainingText);
      final Match? lineThroughMatch =
          lineThroughPattern.matchAsPrefix(remainingText);
      final Match? monospaceMatch =
          monospacePattern.matchAsPrefix(remainingText);
      final Match? nostrModelMatch =
          nostrModelPattern.matchAsPrefix(remainingText);
      final Match? nostrProfileMatch =
          nostrProfilePattern.matchAsPrefix(remainingText);
      final Match? emojiMatch = emojiPattern.matchAsPrefix(remainingText);
      final Match? markdownLinkMatch =
          markdownLinkPattern.matchAsPrefix(remainingText);
      final Match? hashtagMatch = hashtagPattern.matchAsPrefix(remainingText);
      final Match? urlMatch = urlPattern.matchAsPrefix(remainingText);

      // Offset all matches to be relative to the original string
      List<Match?> allMatches = [
        imageUrlMatch,
        audioUrlMatch,
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
        markdownLinkMatch,
        hashtagMatch,
        urlMatch,
      ];
      final List<Match?> matches = allMatches.where((m) => m != null).toList();

      if (matches.isEmpty) {
        if (currentPosition < text.length) {
          styledElements.add(LabShortTextElement(
            type: LabShortTextElementType.styledText,
            content: text[currentPosition],
          ));
        }
        currentPosition++;
        continue;
      }

      // Find the first match (lowest start)
      Match firstMatch = matches.reduce((a, b) {
        if (a!.start == b!.start) {
          if (a == imageUrlMatch) return a;
          if (b == imageUrlMatch) return b;
          if (a == audioUrlMatch) return a;
          if (b == audioUrlMatch) return b;
        }
        return a.start < b.start ? a : b;
      })!;
      // Offset start/end to original string
      int matchStart = currentPosition + firstMatch.start;
      int matchEnd = currentPosition + firstMatch.end;

      // Add any text before the match
      if (matchStart > currentPosition) {
        styledElements.add(LabShortTextElement(
          type: LabShortTextElementType.styledText,
          content: text.substring(currentPosition, matchStart),
        ));
      }

      // Now handle the match as before, but use matchStart/matchEnd for substringing if needed
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
        styledElements.add(LabShortTextElement(
          type: LabShortTextElementType.styledText,
          content: content,
          attributes: {'style': style},
        ));
      } else if (firstMatch == monospaceMatch) {
        styledElements.add(LabShortTextElement(
          type: LabShortTextElementType.monospace,
          content: firstMatch.group(1)!,
        ));
      } else if (firstMatch == emojiMatch) {
        styledElements.add(LabShortTextElement(
          type: LabShortTextElementType.emoji,
          content: firstMatch.group(1)!,
        ));
      } else if (firstMatch == hashtagMatch) {
        styledElements.add(LabShortTextElement(
          type: LabShortTextElementType.hashtag,
          content: firstMatch.group(1)!,
        ));
      } else if (firstMatch == nostrModelMatch) {
        styledElements.add(LabShortTextElement(
          type: LabShortTextElementType.nostrModel,
          content: firstMatch[0]!.trim(),
        ));
        int nextPosition = matchEnd;
        while (nextPosition < text.length && text[nextPosition] == ' ') {
          nextPosition++;
        }
        currentPosition = nextPosition;
        continue;
      } else if (firstMatch == nostrProfileMatch) {
        styledElements.add(LabShortTextElement(
          type: LabShortTextElementType.nostrProfile,
          content: firstMatch[0]!,
        ));
      } else if (firstMatch == imageUrlMatch) {
        // Collect all consecutive image URLs
        final List<String> imageUrls = [firstMatch[0]!.trim()];

        // Look ahead through the entire remaining text for consecutive image URLs
        String remainingText = text.substring(firstMatch.end);

        // Skip any text until we find another image or non-whitespace
        while (true) {
          remainingText = remainingText.trimLeft();
          if (remainingText.isEmpty) break;

          // Try to match another image URL
          final nextMatch = imageUrlPattern.matchAsPrefix(remainingText);
          if (nextMatch != null) {
            // Found another image URL
            final nextUrl = nextMatch[0]!.trim();

            imageUrls.add(nextUrl);
            remainingText = remainingText.substring(nextMatch.end);
            continue;
          }

          // If we find any non-whitespace that isn't an image URL, stop looking
          if (remainingText.trimLeft().isNotEmpty) break;
          break;
        }

        styledElements.add(LabShortTextElement(
          type: LabShortTextElementType.images,
          content: imageUrls.join('\n'),
        ));

        // Update current position to skip all processed URLs
        currentPosition = text.length - remainingText.length;
        continue;
      } else if (firstMatch == audioUrlMatch) {
        styledElements.add(LabShortTextElement(
          type: LabShortTextElementType.audio,
          content: firstMatch[0]!.trim(),
        ));

        // Skip any whitespace after the match before continuing
        int nextPosition = matchEnd;
        while (nextPosition < text.length && text[nextPosition] == ' ') {
          nextPosition++;
        }
        currentPosition = nextPosition;
        continue;
      } else if (firstMatch == markdownLinkMatch) {
        styledElements.add(LabShortTextElement(
          type: LabShortTextElementType.link,
          content: firstMatch.group(1)!, // The link text
          attributes: {'url': firstMatch.group(2)!}, // The URL
        ));
      } else if (firstMatch == urlMatch) {
        styledElements.add(LabShortTextElement(
          type: LabShortTextElementType.link,
          content: firstMatch[0]!,
        ));
      }

      currentPosition = matchEnd;
      continue;
    }

    return styledElements;
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

  int _countLeadingIndent(String line) {
    int count = 0;
    for (int i = 0; i < line.length; i++) {
      if (line[i] == ' ') {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  List<LabShortTextElement> _parseInlineContent(String content) {
    // For now, just return a single styled text element with the content
    return [
      LabShortTextElement(
        type: LabShortTextElementType.styledText,
        content: content,
      ),
    ];
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
