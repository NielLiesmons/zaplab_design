import 'package:zaplab_design/zaplab_design.dart';
import 'text_selection_gesture_detector_builder.dart' as custom;

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

class MentionSpan extends TextSpan {
  final String npub;
  final Profile profile;
  final BuildContext context;

  MentionSpan({
    required this.npub,
    required this.profile,
    required this.context,
  }) : super(
          text: 'nostr:$npub',
          style: TextStyle(
            color: AppTheme.of(context).colors.white.withOpacity(0),
            fontSize: 0,
            height: 0,
            letterSpacing: 0,
            wordSpacing: 0,
          ),
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: AppProfileInline(
                profileName: profile.profileName,
                profilePicUrl: profile.profilePicUrl,
                onTap: profile.onTap,
              ),
            ),
          ],
        );
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
      // Remove all spans that are at or after the current offset
      final spansToRemove = _activeSpans.keys
          .where((spanOffset) => spanOffset >= offset)
          .toList();

      for (final spanOffset in spansToRemove) {
        _activeSpans.remove(spanOffset);
      }

      // Remove any spans that are beyond the text length
      final invalidSpans = _activeSpans.keys
          .where((spanOffset) => spanOffset >= text.length)
          .toList();

      for (final spanOffset in invalidSpans) {
        _activeSpans.remove(spanOffset);
      }
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

  void insertNostrProfile(int offset, String npub) async {
    print('Inserting nostr profile span at offset $offset for npub: $npub');

    try {
      final profiles = await onResolveMentions(npub);
      if (profiles.isEmpty) {
        print('No profile found for npub: $npub');
        return;
      }

      final profile = profiles.first;
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

    // Update spans based on text changes
    _controller._updateSpans(text, offset);

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

    // Check for new @ trigger
    if (offset > 0 && text[offset - 1] == '@' && _mentionStartOffset == null) {
      print('New @ trigger detected at offset ${offset - 1}');
      _mentionStartOffset = offset - 1;
      _currentMentionText = '';
      _showPlaceholder.value = true;
      _controller.insertSpan(offset - 1, '@');
      _resolveMentions(''); // Show menu with empty query to get all profiles
    }

    // Check if we've moved away from the mention
    if (_mentionStartOffset != null &&
        (offset <= _mentionStartOffset! || text[_mentionStartOffset!] != '@')) {
      print('Moved away from mention');
      _mentionStartOffset = null;
      _currentMentionText = '';
      _showPlaceholder.value = false;
      _mentionOverlay?.remove();
      _mentionOverlay = null;
      _controller.clearSpans();
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

    // Insert the nostr profile span
    _controller.insertNostrProfile(_mentionStartOffset!, profile.npub);

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
          ],
        ),
      ),
    );
  }
}
