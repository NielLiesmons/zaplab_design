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

// Inline widget types
enum InlineWidgetType { mention, emoji }

class LabEditableLongText extends StatefulWidget {
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

  // Static key for accessing the state from parent widgets
  static final GlobalKey<LabEditableLongTextState> _key =
      GlobalKey<LabEditableLongTextState>();

  // Getter to access the state from parent widgets
  static LabEditableLongTextState? get state => _key.currentState;

  const LabEditableLongText({
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
  State<LabEditableLongText> createState() => LabEditableLongTextState();
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
  TextSelection _previousSelection = const TextSelection.collapsed(offset: 0);

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

    // Process text character by character, handling widget spans and styling
    for (int i = 0; i < text.length; i++) {
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

  /// Insert an inline widget at the specified offset
  void insertInlineWidget(int offset, Widget widget) {
    _activeSpans[offset] = WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: widget,
    );
    notifyListeners();
  }

  /// Insert a line-breaking widget at the specified offset
  void insertLineBreakWidget(int offset, Widget widget) {
    _activeSpans[offset] = WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: widget,
    );
    notifyListeners();
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

class LabEditableLongTextState extends State<LabEditableLongText>
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

  // Track inline widget state
  String _currentInlineWidgetText = '';
  int? _inlineWidgetStartOffset;
  InlineWidgetType? _currentWidgetType;
  List<LabTextMentionMenuItem> _mentionItems = [];
  List<LabTextEmojiMenuItem> _emojiItems = [];
  OverlayEntry? _inlineWidgetOverlay;

  @override
  bool get forcePressEnabled => false;

  @override
  bool get selectionEnabled => true;

  // ignore: unused_field
  bool _hasText = false;
  // ignore: unused_field
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
      _inlineWidgetStartOffset = null;
      _currentInlineWidgetText = '';
      _currentWidgetType = null;
      _showPlaceholder.value = false;
      _inlineWidgetOverlay?.remove();
      _inlineWidgetOverlay = null;
      return;
    }

    // Check if cursor is trying to enter or is inside an inline widget span
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

    // Handle inline widget typing
    if (_inlineWidgetStartOffset != null) {
      if (offset > _inlineWidgetStartOffset!) {
        final newWidgetText =
            text.substring(_inlineWidgetStartOffset! + 1, offset);
        if (newWidgetText != _currentInlineWidgetText) {
          print('Inline widget text changed: $newWidgetText');
          _currentInlineWidgetText = newWidgetText;
          _showPlaceholder.value = newWidgetText.isEmpty;

          // Only resolve widgets if we're actively typing (not after selection)
          if (newWidgetText.isNotEmpty && _inlineWidgetOverlay != null) {
            _resolveInlineWidgets(newWidgetText);
          } else {
            _inlineWidgetOverlay?.remove();
            _inlineWidgetOverlay = null;
          }
        }
      }
    }

    // Check for new inline widget triggers - only after a space
    if (offset > 0 &&
        text[offset - 1] == '@' &&
        _inlineWidgetStartOffset == null) {
      // Check if @ is after a space or at the start of text
      if (offset == 1 || text[offset - 2] == ' ') {
        print('New mention trigger detected at offset ${offset - 1}');
        _inlineWidgetStartOffset = offset - 1;
        _currentWidgetType = InlineWidgetType.mention;
        _currentInlineWidgetText = '';
        _showPlaceholder.value = true;
        _controller.insertInlineWidget(
            offset - 1, _buildPlaceholderWidget('Profile Name'));
        _resolveInlineWidgets(
            ''); // Show menu with empty query to get all profiles
      }
    }

    if (offset > 0 &&
        text[offset - 1] == ':' &&
        _inlineWidgetStartOffset == null) {
      // Check if : is after a space or at the start of text
      if (offset == 1 || text[offset - 2] == ' ') {
        print('New emoji trigger detected at offset ${offset - 1}');
        _inlineWidgetStartOffset = offset - 1;
        _currentWidgetType = InlineWidgetType.emoji;
        _currentInlineWidgetText = '';
        _showPlaceholder.value = true;
        _controller.insertInlineWidget(
            offset - 1, _buildPlaceholderWidget('Emoji Name'));
        _resolveInlineWidgets(
            ''); // Show menu with empty query to get all emojis
      }
    }

    // Check if we've moved away from the inline widget
    if (_inlineWidgetStartOffset != null) {
      final triggerChar =
          _currentWidgetType == InlineWidgetType.mention ? '@' : ':';
      if (offset <= _inlineWidgetStartOffset! ||
          text[_inlineWidgetStartOffset!] != triggerChar) {
        print('Moved away from inline widget');
        // Remove the trigger symbol if we're moving back
        if (offset < _inlineWidgetStartOffset!) {
          final newText = text.replaceRange(
              _inlineWidgetStartOffset!, _inlineWidgetStartOffset! + 1, '');
          final newOffset = offset;
          _controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: newOffset),
          );
        }
        _inlineWidgetStartOffset = null;
        _currentInlineWidgetText = '';
        _currentWidgetType = null;
        _showPlaceholder.value = false;
        _inlineWidgetOverlay?.remove();
        _inlineWidgetOverlay = null;
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

  /// Build a placeholder widget for inline widgets
  Widget _buildPlaceholderWidget(String placeholderText) {
    final theme = LabTheme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_currentWidgetType == InlineWidgetType.mention)
              LabProfilePic.s24(null)
            else
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
                      placeholderText,
                      color: theme.colors.white33,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }

  /// Resolve inline widgets based on type and query
  void _resolveInlineWidgets(String query) {
    if (_currentWidgetType == InlineWidgetType.mention) {
      _resolveMentions(query);
    } else if (_currentWidgetType == InlineWidgetType.emoji) {
      _resolveEmojis(query);
    }
  }

  void _showInlineWidgetMenu() {
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

    final spanOffset = _inlineWidgetStartOffset ?? 0;
    final TextPosition position = TextPosition(offset: spanOffset);

    // Get the offset of the trigger symbol
    final Offset offset = renderEditable.getLocalRectForCaret(position).topLeft;
    final Offset globalOffset = renderBox.localToGlobal(offset);

    // Position the menu above and slightly to the left of the trigger symbol
    final pos = Offset(
      globalOffset.dx - 8, // Move 8 pixels to the left
      globalOffset.dy - 64, // Move 64 pixels up
    );

    print('Showing inline widget menu at position: $pos');

    if (_inlineWidgetOverlay == null) {
      _inlineWidgetOverlay = OverlayEntry(
        builder: (context) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _inlineWidgetOverlay?.remove();
                  _inlineWidgetOverlay = null;
                },
              ),
            ),
            Positioned(
              left: pos.dx,
              top: pos.dy,
              child: _currentWidgetType == InlineWidgetType.mention
                  ? LabTextMentionMenu(
                      key: ValueKey(_currentInlineWidgetText),
                      position: pos,
                      editableTextState: editableTextState,
                      menuItems: _mentionItems,
                    )
                  : LabTextEmojiMenu(
                      key: ValueKey(_currentInlineWidgetText),
                      position: pos,
                      editableTextState: editableTextState,
                      menuItems: _emojiItems,
                    ),
            ),
          ],
        ),
      );

      overlay.insert(_inlineWidgetOverlay!);
    } else {
      _inlineWidgetOverlay!.markNeedsBuild();
    }
  }

  void _insertMention(({Profile profile, VoidCallback? onTap}) profile) {
    print('Inserting mention for profile: ${profile.profile.name}');
    if (_inlineWidgetStartOffset == null ||
        _currentWidgetType != InlineWidgetType.mention) {
      print(
          '_inlineWidgetStartOffset is null or wrong type, cannot insert mention');
      return;
    }

    final text = _controller.text;
    final currentOffset = _controller.selection.baseOffset;

    print('Current text: "$text"');
    print(
        'Replacing from offset ${_inlineWidgetStartOffset!} to $currentOffset');

    // Insert the nostr profile span with the specific profile
    _controller.insertNostrProfile(
        _inlineWidgetStartOffset!, profile.profile.npub, profile);

    // Then update the cursor position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        // Remove the text after @ up to current cursor and add a space
        final newText = text.replaceRange(
          _inlineWidgetStartOffset! + 1, // Start after the @
          currentOffset,
          ' ', // Replace with a space
        );

        // Calculate new cursor position (after the space)
        final newCursorPosition = _inlineWidgetStartOffset! + 2;

        _controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newCursorPosition),
        );

        // Clean up inline widget state
        _inlineWidgetStartOffset = null;
        _currentInlineWidgetText = '';
        _currentWidgetType = null;
        _showPlaceholder.value = false;
        _inlineWidgetOverlay?.remove();
        _inlineWidgetOverlay = null;

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
                  _inlineWidgetOverlay?.remove();
                  _inlineWidgetOverlay = null;
                },
              ))
          .toList();

      if (_mentionItems.isNotEmpty) {
        _showInlineWidgetMenu();
      }
    });
  }

  void _insertEmoji(String emojiUrl, String emojiName) {
    print('Inserting emoji: $emojiName');
    if (_inlineWidgetStartOffset == null ||
        _currentWidgetType != InlineWidgetType.emoji) {
      print(
          '_inlineWidgetStartOffset is null or wrong type, cannot insert emoji');
      return;
    }

    final text = _controller.text;
    final currentOffset = _controller.selection.baseOffset;

    print('Current text: "$text"');
    print(
        'Replacing from offset ${_inlineWidgetStartOffset!} to $currentOffset');

    // Insert the emoji span
    _controller.insertEmoji(_inlineWidgetStartOffset!, emojiUrl, emojiName);

    // Then update the cursor position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        // Remove the text after : up to current cursor and add a space
        final newText = text.replaceRange(
          _inlineWidgetStartOffset! + 1, // Start after the :
          currentOffset,
          ' ', // Replace with a space
        );

        // Calculate new cursor position (after the space)
        final newCursorPosition = _inlineWidgetStartOffset! + 2;

        _controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newCursorPosition),
        );

        // Clean up inline widget state
        _inlineWidgetStartOffset = null;
        _currentInlineWidgetText = '';
        _currentWidgetType = null;
        _showPlaceholder.value = false;
        _inlineWidgetOverlay?.remove();
        _inlineWidgetOverlay = null;

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
                  _inlineWidgetOverlay?.remove();
                  _inlineWidgetOverlay = null;
                },
              ))
          .toList();

      if (_emojiItems.isNotEmpty) {
        _showInlineWidgetMenu();
      }
    });
  }

  // ===== PUBLIC METHODS FOR PARENT WIDGET ACCESS =====

  /// Insert an emoji at the current cursor position
  void insertEmoji(String emojiUrl, String emojiName) {
    print('Public insertEmoji called: $emojiName');
    final text = _controller.text;
    final currentOffset = _controller.selection.baseOffset;

    // Insert the emoji span at current cursor position
    _controller.insertEmoji(currentOffset, emojiUrl, emojiName);

    // Then update the cursor position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        // Add a space after the emoji
        final newText = text.replaceRange(currentOffset, currentOffset, ' ');
        final newCursorPosition = currentOffset + 1;

        _controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newCursorPosition),
        );

        // Ensure focus is maintained and cursor is visible
        _focusNode.requestFocus();
        editableTextKey.currentState?.showToolbar();
      } catch (e) {
        print('Error in post frame callback: $e');
      }
    });

    print('Public emoji insertion complete');
  }

  /// Insert a profile mention at the current cursor position
  void insertMention(({Profile profile, VoidCallback? onTap}) profile) {
    print('Public insertMention called: ${profile.profile.name}');
    final text = _controller.text;
    final currentOffset = _controller.selection.baseOffset;

    // Insert the nostr profile span at current cursor position
    _controller.insertNostrProfile(
        currentOffset, profile.profile.npub, profile);

    // Then update the cursor position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        // Add a space after the mention
        final newText = text.replaceRange(currentOffset, currentOffset, ' ');
        final newCursorPosition = currentOffset + 1;

        _controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newCursorPosition),
        );

        // Ensure focus is maintained and cursor is visible
        _focusNode.requestFocus();
        editableTextKey.currentState?.showToolbar();
      } catch (e) {
        print('Error in post frame callback: $e');
      }
    });

    print('Public mention insertion complete');
  }

  /// Insert a header at the current cursor position
  void insertHeader(int level) {
    print('Public insertHeader called: level $level');
    final text = _controller.text;
    final currentOffset = _controller.selection.baseOffset;

    // Ensure we're at the start of a line or add a newline
    final lineStart = _findLineStart(text, currentOffset);
    final shouldAddNewline = lineStart != currentOffset;

    // Create header markers
    final headerMarkers = '#' * level + ' ';

    // Insert header at appropriate position
    final insertOffset = shouldAddNewline ? lineStart : currentOffset;
    final newText =
        text.replaceRange(insertOffset, insertOffset, headerMarkers);

    // Position cursor after header markers
    final newCursorPosition = insertOffset + headerMarkers.length;

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );

    // Apply header styling
    final headerStyle = _getHeaderStyle(level);
    _controller._stylingRanges.add(StylingRange(
      start: insertOffset,
      end: newCursorPosition,
      style: headerStyle,
    ));

    // Ensure focus is maintained
    _focusNode.requestFocus();
    editableTextKey.currentState?.showToolbar();

    print('Public header insertion complete');
  }

  /// Insert Header 1 (H1)
  void insertH1() => insertHeader(1);

  /// Insert Header 2 (H2)
  void insertH2() => insertHeader(2);

  /// Insert Header 3 (H3)
  void insertH3() => insertHeader(3);

  /// Insert Header 4 (H4)
  void insertH4() => insertHeader(4);

  /// Insert Header 5 (H5)
  void insertH5() => insertHeader(5);

  /// Insert Header 6 (H6)
  void insertH6() => insertHeader(6);

  /// Apply bold styling to selected text
  void applyBold() {
    final selection = _controller.selection;
    if (selection.isValid && !selection.isCollapsed) {
      _controller.applyBold(selection);
    }
  }

  /// Apply italic styling to selected text
  void applyItalic() {
    final selection = _controller.selection;
    if (selection.isValid && !selection.isCollapsed) {
      _controller.applyItalic(selection);
    }
  }

  /// Apply underline styling to selected text
  void applyUnderline() {
    final selection = _controller.selection;
    if (selection.isValid && !selection.isCollapsed) {
      _controller.applyUnderline(selection);
    }
  }

  /// Apply strikethrough styling to selected text
  void applyStrikethrough() {
    final selection = _controller.selection;
    if (selection.isValid && !selection.isCollapsed) {
      _controller.applyStrikethrough(selection);
    }
  }

  /// Apply code/monospace styling to selected text
  void applyCode() {
    final selection = _controller.selection;
    if (selection.isValid && !selection.isCollapsed) {
      _controller.applyCode(selection);
    }
  }

  // ===== HELPER METHODS =====

  /// Find the start of the current line
  int _findLineStart(String text, int offset) {
    for (int i = offset - 1; i >= 0; i--) {
      if (text[i] == '\n') {
        return i + 1;
      }
    }
    return 0;
  }

  /// Get header style based on level using longform typography
  TextStyle _getHeaderStyle(int level) {
    final theme = LabTheme.of(context);
    final typography = theme.typography;

    switch (level) {
      case 1:
        return typography.longformh1;
      case 2:
        return typography.longformh2;
      case 3:
        return typography.longformh3;
      case 4:
        return typography.longformh4;
      case 5:
        return typography.longformh5;
      default:
        return typography.longformh1;
    }
  }

  @override
  void dispose() {
    // First remove listeners to prmodel any callbacks during disposal
    _controller.removeListener(_handleTextChanged);
    if (widget.controller != null) {
      widget.controller!.removeListener(_handleExternalControllerChange);
    }

    // Then clean up overlays and other UI elements
    _inlineWidgetOverlay?.remove();
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

                    // Handle Enter, Tab, and Space keys to cancel inline widget selection
                    if (event.logicalKey == LogicalKeyboardKey.enter ||
                        event.logicalKey == LogicalKeyboardKey.tab ||
                        event.logicalKey == LogicalKeyboardKey.space) {
                      if (_inlineWidgetStartOffset != null) {
                        // Cancel inline widget selection
                        print('Enter/Tab pressed, canceling inline widget');
                        // Remove the trigger character and any text after it
                        final newText = _controller.text.replaceRange(
                            _inlineWidgetStartOffset!, offset, '');
                        final newOffset =
                            _inlineWidgetStartOffset!; // Cursor goes back to where trigger was

                        _controller.value = TextEditingValue(
                          text: newText,
                          selection: TextSelection.collapsed(offset: newOffset),
                        );

                        // Clear the span and reset inline widget state
                        _controller._activeSpans.remove(offset);
                        _inlineWidgetStartOffset = null;
                        _currentInlineWidgetText = '';
                        _currentWidgetType = null;
                        _showPlaceholder.value = false;
                        _inlineWidgetOverlay?.remove();
                        _inlineWidgetOverlay = null;
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
