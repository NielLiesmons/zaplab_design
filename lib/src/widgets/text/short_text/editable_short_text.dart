import 'package:zaplab_design/zaplab_design.dart';
import '../text_selection_gesture_detector_builder.dart' as custom;
import 'package:flutter/services.dart';
import 'package:models/models.dart';

bool isEditingText = false;

// Styling range data structure
class StylingRange {
  final int start;
  final int end;
  final TextStyle style;

  StylingRange({
    required this.start,
    required this.end,
    required this.style,
  });

  bool contains(int offset) => offset >= start && offset < end;
  bool overlaps(int start, int end) => this.start < end && this.end > start;
}

// Change tracking enums and classes
enum ChangeType { insertion, deletion, replacement, unknown }

class ChangeInfo {
  final ChangeType type;
  final int offset;
  final int oldLength;
  final int newLength;

  ChangeInfo({
    required this.type,
    required this.offset,
    required this.oldLength,
    required this.newLength,
  });
}

class LabEditableShortText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onRawTextChanged;
  final List<LabTextSelectionMenuItem>? contextMenuItems;
  final List<Widget>? placeholder;
  final NostrProfileSearch onSearchProfiles;
  final NostrEmojiSearch onSearchEmojis;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;

  const LabEditableShortText({
    super.key,
    required this.text,
    this.style,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onRawTextChanged,
    this.contextMenuItems,
    this.placeholder,
    required this.onSearchProfiles,
    required this.onSearchEmojis,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
  });

  @override
  State<LabEditableShortText> createState() => _LabEditableShortTextState();
}

class InlineSpanController extends TextEditingController {
  final Map<String, WidgetBuilder> triggerSpans;
  final Map<int, InlineSpan> _activeSpans = {};
  final List<StylingRange> _stylingRanges = [];
  final NostrProfileSearch onSearchProfiles;
  final NostrEmojiSearch onSearchEmojis;
  final BuildContext context;
  bool _isDisposing = false;
  bool _isUpdating = false;
  bool _isNotifying = false;

  // Track previous text state for change detection
  String _previousText = '';
  TextSelection _previousSelection = TextSelection.collapsed(offset: 0);

  InlineSpanController({
    super.text,
    required this.triggerSpans,
    required this.onSearchProfiles,
    required this.onSearchEmojis,
    required this.context,
  }) {
    _previousText = text;
    _previousSelection = TextSelection.collapsed(offset: text.length);
  }

  bool hasSpanAt(int offset) {
    return _activeSpans.containsKey(offset);
  }

  @override
  void dispose() {
    _isDisposing = true;
    _isNotifying = true;
    _activeSpans.clear();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposing && !_isUpdating && !_isNotifying) {
      _isNotifying = true;
      try {
        super.notifyListeners();
      } finally {
        _isNotifying = false;
      }
    }
  }

  void _updateSpans(String text, int offset) {
    if (_isDisposing) return;

    _isUpdating = true;

    try {
      print('=== _updateSpans Debug ===');
      print('Current text: "$text"');
      print('Current offset: $offset');
      print('Previous text length: ${this.text.length}');
      print('New text length: ${text.length}');
      print('Current spans: ${_activeSpans.keys.toList()}');

      // Create a new map to store updated span positions
      final Map<int, InlineSpan> updatedSpans = {};

      // Get all spans and sort them by offset
      final spans = _activeSpans.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      // Find all @ and : characters in the text
      int lastTriggerIndex = -1;
      while (true) {
        final atIndex = text.indexOf('@', lastTriggerIndex + 1);
        final colonIndex = text.indexOf(':', lastTriggerIndex + 1);

        // Find the next trigger character
        final nextTriggerIndex = atIndex == -1
            ? colonIndex
            : colonIndex == -1
                ? atIndex
                : atIndex < colonIndex
                    ? atIndex
                    : colonIndex;

        if (nextTriggerIndex == -1) break;

        // Find the corresponding span for this trigger
        if (spans.isEmpty) {
          // No spans to update, skip this trigger
          lastTriggerIndex = nextTriggerIndex;
          continue;
        }

        final span = spans.firstWhere(
          (s) => s.key == lastTriggerIndex + 1 || s.key == nextTriggerIndex,
          orElse: () => spans.first,
        );

        print(
            'Found trigger at index: $nextTriggerIndex, updating span from ${span.key}');
        updatedSpans[nextTriggerIndex] = span.value;
        lastTriggerIndex = nextTriggerIndex;
      }

      print('Updated spans: ${updatedSpans.keys.toList()}');

      // Clear old spans and add updated ones
      _activeSpans.clear();
      _activeSpans.addAll(updatedSpans);
      notifyListeners();
    } finally {
      _isUpdating = false;
    }
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext? context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (_activeSpans.isEmpty && _stylingRanges.isEmpty) {
      return TextSpan(
        style: style,
        text: text,
      );
    }

    final List<InlineSpan> children = [];
    int lastOffset = 0;
    final baseStyle = style ?? const TextStyle();

    // Get all widget spans (mentions, emojis) and sort them
    final sortedWidgetOffsets = _activeSpans.keys.toList()..sort();

    // Process text character by character, handling widget spans and styling
    for (int i = 0; i < text.length; i++) {
      final char = text[i];

      // Check if this position has a widget span
      if (_activeSpans.containsKey(i)) {
        // Add text before the widget span with appropriate styling
        if (i > lastOffset) {
          final textBefore = text.substring(lastOffset, i);
          final styledText =
              _applyStylingToText(textBefore, lastOffset, baseStyle);
          children.addAll(styledText);
        }

        // Add the widget span
        children.add(_activeSpans[i]!);
        lastOffset = i + 1;
        continue;
      }
    }

    // Add remaining text after the last span with styling
    if (lastOffset < text.length) {
      final remainingText = text.substring(lastOffset);
      final styledText =
          _applyStylingToText(remainingText, lastOffset, baseStyle);
      children.addAll(styledText);
    }

    return TextSpan(
      style: style,
      children: children,
    );
  }

  List<InlineSpan> _applyStylingToText(
      String text, int textStartOffset, TextStyle baseStyle) {
    if (_stylingRanges.isEmpty) {
      return [TextSpan(style: baseStyle, text: text)];
    }

    final List<InlineSpan> spans = [];
    int lastOffset = 0;

    for (int i = 0; i < text.length; i++) {
      final globalOffset = textStartOffset + i;
      final applicableRanges = _stylingRanges
          .where((range) => range.contains(globalOffset))
          .toList();

      if (applicableRanges.isNotEmpty) {
        // Add text before this styled character
        if (i > lastOffset) {
          spans.add(TextSpan(
            style: baseStyle,
            text: text.substring(lastOffset, i),
          ));
        }

        // Create combined style from all applicable ranges
        TextStyle combinedStyle = baseStyle;
        for (final range in applicableRanges) {
          combinedStyle = combinedStyle.merge(range.style);
        }

        // Add the styled character
        spans.add(TextSpan(
          style: combinedStyle,
          text: text[i],
        ));
        lastOffset = i + 1;
      }
    }

    // Add remaining unstyled text
    if (lastOffset < text.length) {
      spans.add(TextSpan(
        style: baseStyle,
        text: text.substring(lastOffset),
      ));
    }

    return spans;
  }

  void insertSpan(int offset, String trigger) {
    if (triggerSpans.containsKey(trigger)) {
      _activeSpans[offset] = WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: Builder(builder: triggerSpans[trigger]!),
      );
      notifyListeners();
    }
  }

  void insertNostrProfile(int offset, String npub,
      ({Profile profile, VoidCallback? onTap}) profile) async {
    print('Inserting nostr profile span at offset $offset for npub: $npub');

    try {
      _activeSpans[offset] = WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: LabProfileInline(
          profile: profile.profile,
          onTap: profile.onTap,
          isEditableText: true,
        ),
      );
      notifyListeners();
    } catch (e) {
      print('Error inserting nostr profile: $e');
    }
  }

  void insertEmoji(int offset, String emojiUrl, String emojiName) {
    print('Inserting emoji span at offset $offset for emoji: $emojiName');

    try {
      _activeSpans[offset] = WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: LabEmojiImage(
          emojiUrl: emojiUrl,
          emojiName: emojiName,
          size: 24,
        ),
      );
      notifyListeners();
    } catch (e) {
      print('Error inserting emoji: $e');
    }
  }

  void clearSpans() {
    _activeSpans.clear();
    notifyListeners();
  }

  void clearStyling() {
    _stylingRanges.clear();
    notifyListeners();
  }

  /// Update styling ranges when text changes (insertions/deletions)
  void _updateStylingRanges(String oldText, String newText,
      TextSelection oldSelection, TextSelection newSelection) {
    final List<StylingRange> updatedRanges = [];

    // Detect the type of change
    final changeType =
        _detectChangeType(oldText, newText, oldSelection, newSelection);

    switch (changeType.type) {
      case ChangeType.insertion:
        _handleInsertion(changeType, updatedRanges);
        break;
      case ChangeType.deletion:
        _handleDeletion(changeType, updatedRanges);
        break;
      case ChangeType.replacement:
        _handleReplacement(changeType, updatedRanges);
        break;
      case ChangeType.unknown:
        // For unknown changes, try to preserve as much styling as possible
        _handleUnknownChange(changeType, updatedRanges);
        break;
    }

    _stylingRanges.clear();
    _stylingRanges.addAll(updatedRanges);
  }

  /// Detect what type of change occurred
  ChangeInfo _detectChangeType(String oldText, String newText,
      TextSelection oldSelection, TextSelection newSelection) {
    final oldLength = oldText.length;
    final newLength = newText.length;
    final lengthDiff = newLength - oldLength;

    if (lengthDiff > 0) {
      // Insertion
      final insertOffset = newSelection.baseOffset - lengthDiff;
      return ChangeInfo(
        type: ChangeType.insertion,
        offset: insertOffset,
        oldLength: 0,
        newLength: lengthDiff,
      );
    } else if (lengthDiff < 0) {
      // Deletion
      final deleteOffset = newSelection.baseOffset;
      return ChangeInfo(
        type: ChangeType.deletion,
        offset: deleteOffset,
        oldLength: -lengthDiff,
        newLength: 0,
      );
    } else {
      // Same length - could be replacement or cursor movement
      // For now, treat as unknown
      return ChangeInfo(
        type: ChangeType.unknown,
        offset: 0,
        oldLength: 0,
        newLength: 0,
      );
    }
  }

  void _handleInsertion(ChangeInfo change, List<StylingRange> updatedRanges) {
    for (final range in _stylingRanges) {
      if (range.end <= change.offset) {
        // Range is before insertion, keep as is
        updatedRanges.add(range);
      } else if (range.start >= change.offset) {
        // Range is after insertion, shift by insertion length
        updatedRanges.add(StylingRange(
          start: range.start + change.newLength,
          end: range.end + change.newLength,
          style: range.style,
        ));
      } else if (range.start < change.offset && range.end > change.offset) {
        // Range spans insertion point, extend the range
        updatedRanges.add(StylingRange(
          start: range.start,
          end: range.end + change.newLength,
          style: range.style,
        ));
      }
    }
  }

  void _handleDeletion(ChangeInfo change, List<StylingRange> updatedRanges) {
    for (final range in _stylingRanges) {
      if (range.end <= change.offset) {
        // Range is before deletion, keep as is
        updatedRanges.add(range);
      } else if (range.start >= change.offset + change.oldLength) {
        // Range is after deletion, shift by deletion length
        updatedRanges.add(StylingRange(
          start: range.start - change.oldLength,
          end: range.end - change.oldLength,
          style: range.style,
        ));
      } else if (range.start < change.offset &&
          range.end > change.offset + change.oldLength) {
        // Range spans deletion, shrink the range
        updatedRanges.add(StylingRange(
          start: range.start,
          end: range.end - change.oldLength,
          style: range.style,
        ));
      } else if (range.start >= change.offset &&
          range.end <= change.offset + change.oldLength) {
        // Range is completely within deletion, remove it
        continue;
      } else if (range.start < change.offset &&
          range.end <= change.offset + change.oldLength) {
        // Range starts before but ends within deletion, truncate
        updatedRanges.add(StylingRange(
          start: range.start,
          end: change.offset,
          style: range.style,
        ));
      } else if (range.start >= change.offset &&
          range.start < change.offset + change.oldLength &&
          range.end > change.offset + change.oldLength) {
        // Range starts within deletion but ends after, adjust start
        updatedRanges.add(StylingRange(
          start: change.offset,
          end: range.end - change.oldLength,
          style: range.style,
        ));
      }
    }
  }

  void _handleReplacement(ChangeInfo change, List<StylingRange> updatedRanges) {
    // Treat replacement as deletion + insertion
    _handleDeletion(change, updatedRanges);
    final tempRanges = List<StylingRange>.from(updatedRanges);
    updatedRanges.clear();

    // Now handle the insertion part
    for (final range in tempRanges) {
      if (range.end <= change.offset) {
        updatedRanges.add(range);
      } else if (range.start >= change.offset) {
        updatedRanges.add(StylingRange(
          start: range.start + change.newLength,
          end: range.end + change.newLength,
          style: range.style,
        ));
      } else if (range.start < change.offset && range.end > change.offset) {
        updatedRanges.add(StylingRange(
          start: range.start,
          end: range.end + change.newLength,
          style: range.style,
        ));
      }
    }
  }

  void _handleUnknownChange(
      ChangeInfo change, List<StylingRange> updatedRanges) {
    // For unknown changes, try to preserve styling by adjusting ranges
    // This is a fallback that may not be perfect but should work for most cases
    for (final range in _stylingRanges) {
      if (range.end <= text.length) {
        updatedRanges.add(range);
      }
    }
  }

  /// Apply bold styling to selected text
  void applyBold(TextSelection selection) {
    if (!selection.isValid || selection.isCollapsed) return;

    final start = selection.start;
    final end = selection.end;

    // Add bold styling range
    _stylingRanges.add(StylingRange(
      start: start,
      end: end,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ));

    // Keep cursor at the end of selection (natural position)
    this.selection = TextSelection.collapsed(offset: end);
    notifyListeners();
  }

  /// Apply italic styling to selected text
  void applyItalic(TextSelection selection) {
    if (!selection.isValid || selection.isCollapsed) return;

    final start = selection.start;
    final end = selection.end;

    // Add italic styling range
    _stylingRanges.add(StylingRange(
      start: start,
      end: end,
      style: const TextStyle(fontStyle: FontStyle.italic),
    ));

    // Keep cursor at the end of selection (natural position)
    this.selection = TextSelection.collapsed(offset: end);
    notifyListeners();
  }

  /// Apply underline styling to selected text
  void applyUnderline(TextSelection selection) {
    if (!selection.isValid || selection.isCollapsed) return;

    final start = selection.start;
    final end = selection.end;

    // Add underline styling range
    _stylingRanges.add(StylingRange(
      start: start,
      end: end,
      style: const TextStyle(decoration: TextDecoration.underline),
    ));

    // Keep cursor at the end of selection (natural position)
    this.selection = TextSelection.collapsed(offset: end);
    notifyListeners();
  }

  /// Apply strikethrough styling to selected text
  void applyStrikethrough(TextSelection selection) {
    if (!selection.isValid || selection.isCollapsed) return;

    final start = selection.start;
    final end = selection.end;

    // Add strikethrough styling range
    _stylingRanges.add(StylingRange(
      start: start,
      end: end,
      style: const TextStyle(decoration: TextDecoration.lineThrough),
    ));

    // Keep cursor at the end of selection (natural position)
    this.selection = TextSelection.collapsed(offset: end);
    notifyListeners();
  }

  /// Apply code/monospace styling to selected text
  void applyCode(TextSelection selection) {
    if (!selection.isValid || selection.isCollapsed) return;

    final start = selection.start;
    final end = selection.end;

    // Add code styling range
    _stylingRanges.add(StylingRange(
      start: start,
      end: end,
      style: const TextStyle(
        fontFamily: 'monospace',
        backgroundColor: Color(0x1AFFFFFF), // Light background
      ),
    ));

    // Keep cursor at the end of selection (natural position)
    this.selection = TextSelection.collapsed(offset: end);
    notifyListeners();
  }
}

class _LabEditableShortTextState extends State<LabEditableShortText>
    implements custom.TextSelectionGestureDetectorBuilderDelegate {
  @override
  GlobalKey<EditableTextState> get editableTextKey => _editableTextKey;
  final GlobalKey<EditableTextState> _editableTextKey =
      GlobalKey<EditableTextState>();

  late InlineSpanController _controller;
  late FocusNode _focusNode;
  late custom.TextSelectionGestureDetectorBuilder _gestureDetectorBuilder;
  final ValueNotifier<bool> _isEmpty = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _showPlaceholder = ValueNotifier<bool>(false);

  // Track mention state
  String _currentMentionText = '';
  int? _mentionStartOffset;
  List<LabTextMentionMenuItem> _mentionItems = [];
  OverlayEntry? _mentionOverlay;

  // Track emoji state
  String _currentEmojiText = '';
  int? _emojiStartOffset;
  List<LabTextEmojiMenuItem> _emojiItems = [];
  OverlayEntry? _emojiOverlay;

  @override
  bool get forcePressEnabled => false;

  @override
  bool get selectionEnabled => true;

  bool _hasText = false;
  bool _hasSelection = false;

  @override
  void initState() {
    super.initState();
    _controller = InlineSpanController(
      text: widget.text,
      triggerSpans: {
        '@': (context) {
          final theme = LabTheme.of(context);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LabProfilePic.s24(null),
                  const LabGap.s4(),
                ],
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _showPlaceholder,
                builder: (context, show, child) => show
                    ? Positioned(
                        left: 32,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: LabText.med16(
                            'Profile Name',
                            color: theme.colors.white33,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          );
        },
        ':': (context) {
          final theme = LabTheme.of(context);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      const LabGap.s2(),
                      LabIcon.s20(
                        theme.icons.characters.emojiFill,
                        gradient: theme.colors.graydient33,
                      ),
                    ],
                  ),
                  const LabGap.s4(),
                ],
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _showPlaceholder,
                builder: (context, show, child) => show
                    ? Positioned(
                        left: 32,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: LabText.med16(
                            'Emoji Name',
                            color: theme.colors.white33,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          );
        },
      },
      onSearchProfiles: widget.onSearchProfiles,
      onSearchEmojis: widget.onSearchEmojis,
      context: context,
    );
    _focusNode = widget.focusNode ?? FocusNode();
    _gestureDetectorBuilder = custom.TextSelectionGestureDetectorBuilder(
      delegate: this,
    );
    _controller.addListener(_handleTextChanged);
    if (widget.controller != null) {
      widget.controller!.addListener(_handleExternalControllerChange);
    }
  }

  void _handleTextChanged() {
    _hasText = _controller.text.isNotEmpty;
    _isEmpty.value = _controller.text.isEmpty;

    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }

    final text = _controller.text;
    final selection = _controller.selection;
    if (!selection.isValid) return;

    final offset = selection.baseOffset;

    // Update styling ranges when text changes
    if (_controller._previousText.isNotEmpty) {
      _controller._updateStylingRanges(
        _controller._previousText,
        text,
        _controller._previousSelection,
        selection,
      );
    }

    // Update previous state for next change detection
    _controller._previousText = text;
    _controller._previousSelection = selection;

    print('Text changed: "$text" (length: ${text.length})');
    print('Current offset: $offset');
    print('Active spans: ${_controller._activeSpans.keys.toList()}');

    // Clear all spans if text is empty
    if (text.isEmpty) {
      print('Text is empty, clearing all spans');
      _controller.clearSpans();
      _mentionStartOffset = null;
      _currentMentionText = '';
      _showPlaceholder.value = false;
      _mentionOverlay?.remove();
      _mentionOverlay = null;
      _emojiStartOffset = null;
      _currentEmojiText = '';
      _emojiOverlay?.remove();
      _emojiOverlay = null;
      return;
    }

    // Check if cursor is trying to enter or is inside a profile or emoji span
    for (final spanOffset in _controller._activeSpans.keys) {
      if (offset == spanOffset || offset == spanOffset + 1) {
        final span = _controller._activeSpans[spanOffset];
        if (span is WidgetSpan &&
            (span.child is LabProfileInline || span.child is LabEmojiImage)) {
          // Always move cursor after the span
          final newOffset = spanOffset + 1;
          if (newOffset <= text.length) {
            _controller.selection = TextSelection.collapsed(offset: newOffset);
          }
          return;
        }
      }
    }

    // Handle mention typing
    if (_mentionStartOffset != null) {
      if (offset > _mentionStartOffset!) {
        final newMentionText = text.substring(_mentionStartOffset! + 1, offset);
        if (newMentionText != _currentMentionText) {
          print('Mention text changed: $newMentionText');
          _currentMentionText = newMentionText;
          _showPlaceholder.value = newMentionText.isEmpty;

          // Only resolve mentions if we're actively typing (not after selection)
          if (newMentionText.isNotEmpty && _mentionOverlay != null) {
            _resolveMentions(newMentionText);
          } else {
            _mentionOverlay?.remove();
            _mentionOverlay = null;
          }
        }
      }
    }

    // Handle emoji typing
    if (_emojiStartOffset != null) {
      if (offset > _emojiStartOffset!) {
        final newEmojiText = text.substring(_emojiStartOffset! + 1, offset);
        if (newEmojiText != _currentEmojiText) {
          print('Emoji text changed: $newEmojiText');
          _currentEmojiText = newEmojiText;
          _showPlaceholder.value = newEmojiText.isEmpty;

          // Only resolve emojis if we're actively typing (not after selection)
          if (newEmojiText.isNotEmpty && _emojiOverlay != null) {
            _resolveEmojis(newEmojiText);
          } else {
            _emojiOverlay?.remove();
            _emojiOverlay = null;
          }
        }
      }
    }

    // Check for new @ trigger - only after a space
    if (offset > 0 && text[offset - 1] == '@' && _mentionStartOffset == null) {
      // Check if @ is after a space or at the start of text
      if (offset == 1 || text[offset - 2] == ' ') {
        print('New @ trigger detected at offset ${offset - 1}');
        _mentionStartOffset = offset - 1;
        _currentMentionText = '';
        _showPlaceholder.value = true;
        _controller.insertSpan(offset - 1, '@');
        _resolveMentions(''); // Show menu with empty query to get all profiles
      }
    }

    // Check for new : trigger - only after a space
    if (offset > 0 && text[offset - 1] == ':' && _emojiStartOffset == null) {
      // Check if : is after a space or at the start of text
      if (offset == 1 || text[offset - 2] == ' ') {
        print('New : trigger detected at offset ${offset - 1}');
        _emojiStartOffset = offset - 1;
        _currentEmojiText = '';
        _showPlaceholder.value = true;
        _controller.insertSpan(offset - 1, ':');
        _resolveEmojis(''); // Show menu with empty query to get all emojis
      }
    }

    // Check if we've moved away from the mention
    if (_mentionStartOffset != null) {
      if (offset <= _mentionStartOffset! || text[_mentionStartOffset!] != '@') {
        print('Moved away from mention');
        // Remove the @ symbol if we're moving back
        if (offset < _mentionStartOffset!) {
          final newText = text.replaceRange(
              _mentionStartOffset!, _mentionStartOffset! + 1, '');
          final newOffset = offset;
          _controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: newOffset),
          );
        }
        _mentionStartOffset = null;
        _currentMentionText = '';
        _showPlaceholder.value = false;
        _mentionOverlay?.remove();
        _mentionOverlay = null;
      }
    }

    // Check if we've moved away from the emoji
    if (_emojiStartOffset != null) {
      if (offset <= _emojiStartOffset! || text[_emojiStartOffset!] != ':') {
        print('Moved away from emoji');
        // Remove the : symbol if we're moving back
        if (offset < _emojiStartOffset!) {
          final newText =
              text.replaceRange(_emojiStartOffset!, _emojiStartOffset! + 1, '');
          final newOffset = offset;
          _controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: newOffset),
          );
        }
        _emojiStartOffset = null;
        _currentEmojiText = '';
        _showPlaceholder.value = false;
        _emojiOverlay?.remove();
        _emojiOverlay = null;
      }
    }

    // Update spans on any text change
    print('Calling _updateSpans with text: "$text" and offset: $offset');
    _controller._updateSpans(text, offset);
  }

  void _handleExternalControllerChange() {
    if (_controller.text != widget.controller!.text) {
      _controller.text = widget.controller!.text;
    }
  }

  void _showMentionMenu() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;

    // Find the EditableText widget first
    final editableTextState = editableTextKey.currentState;
    if (editableTextState == null) {
      print('EditableTextState is null');
      return;
    }

    // Get the render object from the EditableText
    final renderEditable = editableTextState.renderEditable;
    if (renderEditable == null) {
      print('RenderEditable is null');
      return;
    }

    final spanOffset = _mentionStartOffset ?? 0;
    final TextPosition position = TextPosition(offset: spanOffset);

    // Get the offset of the @ symbol
    final Offset offset = renderEditable.getLocalRectForCaret(position).topLeft;
    final Offset globalOffset = renderBox.localToGlobal(offset);

    // Position the menu above and slightly to the left of the @ symbol
    final pos = Offset(
      globalOffset.dx - 8, // Move 8 pixels to the left
      globalOffset.dy - 64, // Move 64 pixels up
    );

    print('Showing menu at position: $pos');

    if (_mentionOverlay == null) {
      _mentionOverlay = OverlayEntry(
        builder: (context) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _mentionOverlay?.remove();
                  _mentionOverlay = null;
                },
              ),
            ),
            Positioned(
              left: pos.dx,
              top: pos.dy,
              child: LabTextMentionMenu(
                key: ValueKey(_currentMentionText),
                position: pos,
                editableTextState: editableTextState,
                menuItems: _mentionItems,
              ),
            ),
          ],
        ),
      );

      overlay.insert(_mentionOverlay!);
    } else {
      _mentionOverlay!.markNeedsBuild();
    }
  }

  void _insertMention(({Profile profile, VoidCallback? onTap}) profile) {
    print('Inserting mention for profile: ${profile.profile.name}');
    if (_mentionStartOffset == null) {
      print('_mentionStartOffset is null, cannot insert mention');
      return;
    }

    final text = _controller.text;
    final currentOffset = _controller.selection.baseOffset;

    print('Current text: "$text"');
    print('Replacing from offset ${_mentionStartOffset!} to $currentOffset');

    // Insert the nostr profile span with the specific profile
    _controller.insertNostrProfile(
        _mentionStartOffset!, profile.profile.npub, profile);

    // Then update the cursor position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        // Remove the text after @ up to current cursor and add a space
        final newText = text.replaceRange(
          _mentionStartOffset! + 1, // Start after the @
          currentOffset,
          ' ', // Replace with a space
        );

        // Calculate new cursor position (after the space)
        final newCursorPosition = _mentionStartOffset! + 2;

        _controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newCursorPosition),
        );

        // Clean up mention state
        _mentionStartOffset = null;
        _currentMentionText = '';
        _showPlaceholder.value = false;
        _mentionOverlay?.remove();
        _mentionOverlay = null;

        // Ensure focus is maintained and cursor is visible
        _focusNode.requestFocus();
        editableTextKey.currentState?.showToolbar();
      } catch (e) {
        print('Error in post frame callback: $e');
      }
    });

    print('Mention insertion complete');
  }

  void _resolveMentions(String query) async {
    print('Searching profiles for query: $query');
    final profiles = await widget.onSearchProfiles(query);
    print('Found profiles: $profiles');

    if (!mounted) return;

    setState(() {
      _mentionItems = profiles
          .map((profile) => LabTextMentionMenuItem(
                profile: profile,
                onTap: (state) {
                  print('Profile selected: ${profile.name}');
                  _insertMention(
                      (profile: profile, onTap: () {})); // TODO: Add onTap
                  _mentionOverlay?.remove();
                  _mentionOverlay = null;
                },
              ))
          .toList();

      if (_mentionItems.isNotEmpty) {
        _showMentionMenu();
      }
    });
  }

  void _showEmojiMenu() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;

    // Find the EditableText widget first
    final editableTextState = editableTextKey.currentState;
    if (editableTextState == null) {
      print('EditableTextState is null');
      return;
    }

    // Get the render object from the EditableText
    final renderEditable = editableTextState.renderEditable;
    if (renderEditable == null) {
      print('RenderEditable is null');
      return;
    }

    final spanOffset = _emojiStartOffset ?? 0;
    final TextPosition position = TextPosition(offset: spanOffset);

    // Get the offset of the : symbol
    final Offset offset = renderEditable.getLocalRectForCaret(position).topLeft;
    final Offset globalOffset = renderBox.localToGlobal(offset);

    // Position the menu above and slightly to the left of the : symbol
    final pos = Offset(
      globalOffset.dx - 8, // Move 8 pixels to the left
      globalOffset.dy - 64, // Move 64 pixels up
    );

    print('Showing emoji menu at position: $pos');

    if (_emojiOverlay == null) {
      _emojiOverlay = OverlayEntry(
        builder: (context) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _emojiOverlay?.remove();
                  _emojiOverlay = null;
                },
              ),
            ),
            Positioned(
              left: pos.dx,
              top: pos.dy,
              child: LabTextEmojiMenu(
                key: ValueKey(_currentEmojiText),
                position: pos,
                editableTextState: editableTextState,
                menuItems: _emojiItems,
              ),
            ),
          ],
        ),
      );

      overlay.insert(_emojiOverlay!);
    } else {
      _emojiOverlay!.markNeedsBuild();
    }
  }

  void _insertEmoji(String emojiUrl, String emojiName) {
    print('Inserting emoji: $emojiName');
    if (_emojiStartOffset == null) {
      print('_emojiStartOffset is null, cannot insert emoji');
      return;
    }

    final text = _controller.text;
    final currentOffset = _controller.selection.baseOffset;

    print('Current text: "$text"');
    print('Replacing from offset ${_emojiStartOffset!} to $currentOffset');

    // Insert the emoji span
    _controller.insertEmoji(_emojiStartOffset!, emojiUrl, emojiName);

    // Then update the cursor position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        // Remove the text after : up to current cursor and add a space
        final newText = text.replaceRange(
          _emojiStartOffset! + 1, // Start after the :
          currentOffset,
          ' ', // Replace with a space
        );

        // Calculate new cursor position (after the space)
        final newCursorPosition = _emojiStartOffset! + 2;

        _controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newCursorPosition),
        );

        // Clean up emoji state
        _emojiStartOffset = null;
        _currentEmojiText = '';
        _showPlaceholder.value = false;
        _emojiOverlay?.remove();
        _emojiOverlay = null;

        // Ensure focus is maintained and cursor is visible
        _focusNode.requestFocus();
        editableTextKey.currentState?.showToolbar();
      } catch (e) {
        print('Error in post frame callback: $e');
      }
    });

    print('Emoji insertion complete');
  }

  void _resolveEmojis(String query) async {
    print('Searching emojis for query: $query');
    final emojis = await widget.onSearchEmojis(query);
    print('Found emojis: $emojis');

    if (!mounted) return;

    setState(() {
      _emojiItems = emojis
          .map((emoji) => LabTextEmojiMenuItem(
                emojiUrl: emoji.emojiUrl,
                emojiName: emoji.emojiName,
                onTap: (state) {
                  print('Emoji selected: ${emoji.emojiName}');
                  _insertEmoji(emoji.emojiUrl, emoji.emojiName);
                  _emojiOverlay?.remove();
                  _emojiOverlay = null;
                },
              ))
          .toList();

      if (_emojiItems.isNotEmpty) {
        _showEmojiMenu();
      }
    });
  }

  @override
  void dispose() {
    // First remove listeners to prmodel any callbacks during disposal
    _controller.removeListener(_handleTextChanged);
    if (widget.controller != null) {
      widget.controller!.removeListener(_handleExternalControllerChange);
    }

    // Then clean up overlays and other UI elements
    _mentionOverlay?.remove();
    _showPlaceholder.dispose();
    _isEmpty.dispose();

    // Finally dispose of the controller and focus node
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final defaultStyle = theme.typography.reg16.copyWith();

    final textStyle = (widget.style ?? defaultStyle).copyWith(
      height: defaultStyle.height,
      leadingDistribution: defaultStyle.leadingDistribution,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: theme.sizes.s38,
        maxHeight: 2 * theme.sizes.s104,
      ),
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        physics: LabPlatformUtils.isMobile
            ? const ClampingScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            if (widget.placeholder != null)
              ValueListenableBuilder<bool>(
                valueListenable: _isEmpty,
                builder: (context, isEmpty, child) => Align(
                  alignment: Alignment.topLeft,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: isEmpty ? 1.0 : 0.0,
                      child: Row(
                        children: widget.placeholder!,
                      ),
                    ),
                  ),
                ),
              ),
            _gestureDetectorBuilder.buildGestureDetector(
              behavior: HitTestBehavior.deferToChild,
              child: KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (event) {
                  if (event is KeyDownEvent) {
                    final selection = _controller.selection;
                    if (!selection.isValid) return;

                    final offset = selection.baseOffset;

                    // Handle Enter, Tab, and Space keys to cancel mention/emoji selection
                    if (event.logicalKey == LogicalKeyboardKey.enter ||
                        event.logicalKey == LogicalKeyboardKey.tab ||
                        event.logicalKey == LogicalKeyboardKey.space) {
                      if (_mentionStartOffset != null ||
                          _emojiStartOffset != null) {
                        // Cancel mention/emoji selection
                        if (_mentionStartOffset != null) {
                          print('Enter/Tab pressed, canceling mention');
                          // Remove the @ character and any text after it
                          final newText = _controller.text
                              .replaceRange(_mentionStartOffset!, offset, '');
                          final newOffset =
                              _mentionStartOffset!; // Cursor goes back to where @ was

                          _controller.value = TextEditingValue(
                            text: newText,
                            selection:
                                TextSelection.collapsed(offset: newOffset),
                          );

                          // Clear the span and reset mention state
                          _controller._activeSpans.remove(offset);
                          _mentionStartOffset = null;
                          _currentMentionText = '';
                          _showPlaceholder.value = false;
                          _mentionOverlay?.remove();
                          _mentionOverlay = null;
                        }
                        if (_emojiStartOffset != null) {
                          print('Enter/Tab pressed, canceling emoji');
                          // Remove the : character and any text after it
                          final newText = _controller.text
                              .replaceRange(_emojiStartOffset!, offset, '');
                          final newOffset =
                              _emojiStartOffset!; // Cursor goes back to where : was

                          _controller.value = TextEditingValue(
                            text: newText,
                            selection:
                                TextSelection.collapsed(offset: newOffset),
                          );

                          // Clear the span and reset emoji state
                          _controller._activeSpans.remove(offset);
                          _emojiStartOffset = null;
                          _currentEmojiText = '';
                          _showPlaceholder.value = false;
                          _emojiOverlay?.remove();
                          _emojiOverlay = null;
                        }
                        return;
                      }
                    }

                    // Find the next span before and after the current offset
                    int? nextSpanBefore;
                    int? nextSpanAfter;

                    for (final spanOffset in _controller._activeSpans.keys) {
                      if (spanOffset < offset) {
                        nextSpanBefore = spanOffset;
                      } else if (spanOffset > offset) {
                        nextSpanAfter = spanOffset;
                        break;
                      }
                    }

                    // Handle backspace/delete on spans (mentions and emojis only)
                    if (event.logicalKey == LogicalKeyboardKey.backspace) {
                      // Check if cursor is at the start of a span
                      if (_controller._activeSpans.containsKey(offset)) {
                        print('Backspace on span at offset $offset');
                        // Remove the span and the character at that position
                        _controller._activeSpans.remove(offset);

                        // Remove the character from the text
                        final newText = _controller.text
                            .replaceRange(offset, offset + 1, '');
                        final newOffset = offset;

                        _controller.value = TextEditingValue(
                          text: newText,
                          selection: TextSelection.collapsed(offset: newOffset),
                        );
                        return;
                      }
                    } else if (event.logicalKey == LogicalKeyboardKey.delete) {
                      // Check if cursor is at the start of a span
                      if (_controller._activeSpans.containsKey(offset)) {
                        print('Delete on span at offset $offset');
                        // Remove the span and the character at that position
                        _controller._activeSpans.remove(offset);

                        // Remove the character from the text
                        final newText = _controller.text
                            .replaceRange(offset, offset + 1, '');
                        final newOffset = offset;

                        _controller.value = TextEditingValue(
                          text: newText,
                          selection: TextSelection.collapsed(offset: newOffset),
                        );
                        return;
                      }
                    }

                    // Handle arrow keys
                    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                      if (nextSpanBefore != null) {
                        // Move cursor before the previous span
                        _controller.selection =
                            TextSelection.collapsed(offset: nextSpanBefore);
                        return;
                      }
                    } else if (event.logicalKey ==
                        LogicalKeyboardKey.arrowRight) {
                      if (nextSpanAfter != null) {
                        // Move cursor after the next span
                        _controller.selection =
                            TextSelection.collapsed(offset: nextSpanAfter + 1);
                        return;
                      }
                    }
                  }
                },
                child: EditableText(
                  key: editableTextKey,
                  controller: _controller,
                  focusNode: _focusNode,
                  style: textStyle,
                  cursorColor: theme.colors.white,
                  backgroundCursorColor: theme.colors.white33,
                  onChanged: widget.onChanged,
                  onSelectionChanged: (selection, cause) {
                    isEditingText = !selection.isCollapsed;
                    _hasSelection = !selection.isCollapsed;
                    if (!selection.isCollapsed && isEditingText) {
                      editableTextKey.currentState?.showToolbar();
                    } else {
                      editableTextKey.currentState?.hideToolbar();
                    }
                  },
                  maxLines: null,
                  minLines: 1,
                  textAlign: TextAlign.left,
                  textCapitalization: TextCapitalization.sentences,
                  selectionControls: LabTextSelectionControls(),
                  enableInteractiveSelection: true,
                  showSelectionHandles: true,
                  showCursor: true,
                  rendererIgnoresPointer: false,
                  enableSuggestions: true,
                  readOnly: false,
                  selectionColor:
                      theme.colors.blurpleLightColor.withValues(alpha: 0.33),
                  contextMenuBuilder: widget.contextMenuItems == null
                      ? null
                      : (context, editableTextState) {
                          return LabTextSelectionMenu(
                            position: editableTextState
                                .contextMenuAnchors.primaryAnchor,
                            editableTextState: editableTextState,
                            menuItems: widget.contextMenuItems,
                          );
                        },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
