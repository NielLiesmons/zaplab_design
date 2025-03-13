import 'package:flutter/material.dart' show Material, Colors;
import 'package:flutter/rendering.dart' show RenderEditable;
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

class InlineSpanController extends TextEditingController {
  final Map<String, WidgetBuilder> triggerSpans;
  final Map<int, InlineSpan> _activeSpans = {};

  InlineSpanController({
    String? text,
    required this.triggerSpans,
  }) : super(text: text);

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
      if (offset > lastOffset) {
        children.add(TextSpan(
          style: style,
          text: text.substring(lastOffset, offset),
        ));
      }
      children.add(_activeSpans[offset]!);
      lastOffset = offset + 1;
    }

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

  void removeSpan(int offset) {
    _activeSpans.remove(offset);
    notifyListeners();
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
      text: widget.controller?.text ?? widget.text,
      triggerSpans: {
        '@': (context) {
          final theme = AppTheme.of(context);
          print('Building mention span. Current text: $_currentMentionText');
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
    );
    _focusNode = widget.focusNode ?? FocusNode();
    _gestureDetectorBuilder =
        custom.TextSelectionGestureDetectorBuilder(delegate: this);

    // Set initial text state
    _hasText = _controller.text.isNotEmpty;
    _isEmpty.value = _controller.text.isEmpty;

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

    final selection = _controller.selection;
    if (!selection.isValid) return;

    final text = _controller.text;
    final offset = selection.baseOffset;

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

          _controller.notifyListeners();
        }
      }
    }

    // Check for new @ trigger
    if (offset > 0 && text[offset - 1] == '@' && _mentionStartOffset == null) {
      _mentionStartOffset = offset - 1;
      _currentMentionText = '';
      _showPlaceholder.value = true;
      _controller.insertSpan(offset - 1, '@');
      _resolveMentions(''); // Show menu with empty query to get all profiles
    }

    // Check if we've moved away from the mention
    if (_mentionStartOffset != null &&
        (offset <= _mentionStartOffset! || text[_mentionStartOffset!] != '@')) {
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

    // Replace the @mention text with the selected profile
    final newText = text.replaceRange(
      _mentionStartOffset!,
      currentOffset,
      '@${profile.profileName} ', // Add a space after the mention
    );

    print('New text: "$newText"');

    // Calculate new cursor position (after the space)
    final newCursorPosition = _mentionStartOffset! +
        profile.profileName.length +
        2; // +2 for @ and space

    // Update the text and cursor position
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      _controller.clearSpans();

      // Ensure focus is maintained and cursor is visible
      _focusNode.requestFocus();
      editableTextKey.currentState?.showToolbar();
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
    _mentionOverlay?.remove();
    _showPlaceholder.dispose();
    _isEmpty.dispose();
    _controller.removeListener(_handleTextChanged);
    if (widget.controller != null) {
      widget.controller!.removeListener(_handleExternalControllerChange);
    }
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
