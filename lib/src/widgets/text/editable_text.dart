import 'package:zaplab_design/zaplab_design.dart';
import 'text_selection_gesture_detector_builder.dart' as custom;
import 'package:flutter/services.dart';

bool isEditingText = false;

class AppEditableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final List<AppTextSelectionMenuItem>? contextMenuItems;
  final List<Widget>? placeholder;
  final NostrMentionResolver onResolveMentions;

  const AppEditableText({
    super.key,
    required this.text,
    this.style,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.contextMenuItems,
    this.placeholder,
    required this.onResolveMentions,
  });

  @override
  State<AppEditableText> createState() => _AppEditableTextState();
}

class InlineSpanController extends TextEditingController {
  final Map<String, WidgetBuilder> triggerSpans;
  final Map<int, InlineSpan> _activeSpans = {};
  final NostrMentionResolver onResolveMentions;
  final BuildContext context;
  bool _isDisposing = false;
  bool _isUpdating = false;
  bool _isNotifying = false;

  InlineSpanController({
    String? text,
    required this.triggerSpans,
    required this.onResolveMentions,
    required this.context,
  }) : super(text: text);

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
      // Create a new map to store updated span positions
      final Map<int, InlineSpan> updatedSpans = {};

      // Get all profile spans
      final profileSpans = _activeSpans.entries
          .where((entry) =>
              entry.value is WidgetSpan &&
              (entry.value as WidgetSpan).child is AppProfileInline)
          .toList();

      // Sort spans by offset to process them in order
      profileSpans.sort((a, b) => a.key.compareTo(b.key));

      // Update each span's position based on text changes
      for (final span in profileSpans) {
        final oldOffset = span.key;

        // Calculate new offset based on text changes
        int newOffset = oldOffset;

        // If text was inserted before this span, move it forward
        if (offset <= oldOffset) {
          final textDiff = text.length - this.text.length;
          newOffset += textDiff;
        }

        // Ensure the span is still within text bounds
        if (newOffset >= 0 && newOffset < text.length) {
          updatedSpans[newOffset] = span.value;
        }
      }

      // Clear old spans and add updated ones
      _activeSpans.clear();
      _activeSpans.addAll(updatedSpans);
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
    if (_activeSpans.isEmpty) {
      return TextSpan(
        style: style,
        text: text,
      );
    }

    final List<InlineSpan> children = [];
    int lastOffset = 0;

    final sortedOffsets = _activeSpans.keys.toList()..sort();

    for (final offset in sortedOffsets) {
      // Add text before the span
      if (offset > lastOffset && offset <= text.length) {
        children.add(TextSpan(
          style: style,
          text: text.substring(lastOffset, offset),
        ));
      }

      // Add the span
      children.add(_activeSpans[offset]!);
      lastOffset = offset + 1;
    }

    // Add remaining text after the last span
    if (lastOffset < text.length) {
      children.add(TextSpan(
        style: style,
        text: text.substring(lastOffset),
      ));
    }

    return TextSpan(
      style: style,
      children: children,
    );
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

  void insertNostrProfile(int offset, String npub, Profile profile) async {
    print('Inserting nostr profile span at offset $offset for npub: $npub');

    try {
      final theme = AppTheme.of(context);
      _activeSpans[offset] = WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: AppProfileInline(
          profileName: profile.profileName,
          profilePicUrl: profile.profilePicUrl,
          onTap: profile.onTap,
          isEditableText: true,
        ),
      );
      notifyListeners();
    } catch (e) {
      print('Error inserting nostr profile: $e');
    }
  }

  void clearSpans() {
    _activeSpans.clear();
    notifyListeners();
  }
}

class _AppEditableTextState extends State<AppEditableText>
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
  List<AppTextMentionMenuItem> _mentionItems = [];
  OverlayEntry? _mentionOverlay;

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
          final theme = AppTheme.of(context);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppProfilePic.s24('none'),
                  const AppGap.s4(),
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
                          child: AppText.med16(
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
      },
      onResolveMentions: widget.onResolveMentions,
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
    final previousLength = _controller.text.length;

    print(
        'Text changed: "$text" (length: ${text.length}, previous: $previousLength)');
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
      return;
    }

    // Check if cursor is trying to enter or is inside a profile span
    for (final spanOffset in _controller._activeSpans.keys) {
      if (offset == spanOffset || offset == spanOffset + 1) {
        final span = _controller._activeSpans[spanOffset];
        if (span is WidgetSpan && span.child is AppProfileInline) {
          // Always move cursor after the span
          _controller.selection =
              TextSelection.collapsed(offset: spanOffset + 1);
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

    // Check if we've moved away from the mention
    if (_mentionStartOffset != null) {
      if (offset <= _mentionStartOffset! || text[_mentionStartOffset!] != '@') {
        print('Moved away from mention');
        // Remove the @ symbol if we're moving back
        if (offset < _mentionStartOffset!) {
          final newText = text.replaceRange(
              _mentionStartOffset!, _mentionStartOffset! + 1, '');
          _controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: offset),
          );
        }
        _mentionStartOffset = null;
        _currentMentionText = '';
        _showPlaceholder.value = false;
        _mentionOverlay?.remove();
        _mentionOverlay = null;
        _controller.clearSpans();
      }
    }

    // Update spans based on text changes
    if (text.length != previousLength) {
      final textDiff = text.length - previousLength;
      final Map<int, InlineSpan> updatedSpans = {};

      for (final entry in _controller._activeSpans.entries) {
        final oldOffset = entry.key;
        final span = entry.value;

        // If text was inserted before this span, move it forward
        if (offset <= oldOffset) {
          final newOffset = oldOffset + textDiff;
          if (newOffset >= 0 && newOffset < text.length) {
            updatedSpans[newOffset] = span;
          }
        } else {
          // Keep span in place if text was inserted after it
          updatedSpans[oldOffset] = span;
        }
      }

      _controller._activeSpans.clear();
      _controller._activeSpans.addAll(updatedSpans);
    }
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
              child: AppTextMentionMenu(
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

  void _insertMention(Profile profile) {
    print('Inserting mention for profile: ${profile.profileName}');
    if (_mentionStartOffset == null) {
      print('_mentionStartOffset is null, cannot insert mention');
      return;
    }

    final text = _controller.text;
    final currentOffset = _controller.selection.baseOffset;

    print('Current text: "$text"');
    print('Replacing from offset ${_mentionStartOffset!} to $currentOffset');

    // Insert the nostr profile span with the specific profile
    _controller.insertNostrProfile(_mentionStartOffset!, profile.npub, profile);

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
    print('Resolving mentions for query: $query');
    final profiles = await widget.onResolveMentions(query);
    print('Resolved profiles: $profiles');

    if (!mounted) return;

    setState(() {
      _mentionItems = profiles
          .map((profile) => AppTextMentionMenuItem(
                profile: profile,
                onTap: (state) {
                  print('Profile selected: ${profile.profileName}');
                  _insertMention(profile);
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

  @override
  void dispose() {
    // First remove listeners to prevent any callbacks during disposal
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
    final theme = AppTheme.of(context);
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
        physics: PlatformUtils.isMobile
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
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (event) {
                  if (event is RawKeyDownEvent) {
                    final selection = _controller.selection;
                    if (!selection.isValid) return;

                    final offset = selection.baseOffset;

                    // Find the next span before and after the current offset
                    int? nextSpanBefore = null;
                    int? nextSpanAfter = null;

                    for (final spanOffset in _controller._activeSpans.keys) {
                      if (spanOffset < offset) {
                        nextSpanBefore = spanOffset;
                      } else if (spanOffset > offset) {
                        nextSpanAfter = spanOffset;
                        break;
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
                  selectionControls: AppTextSelectionControls(),
                  enableInteractiveSelection: true,
                  showSelectionHandles: true,
                  showCursor: true,
                  rendererIgnoresPointer: false,
                  enableSuggestions: true,
                  readOnly: false,
                  selectionColor:
                      theme.colors.blurpleColor.withValues(alpha: 0.33),
                  contextMenuBuilder: widget.contextMenuItems == null
                      ? null
                      : (context, editableTextState) {
                          return AppTextSelectionMenu(
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
