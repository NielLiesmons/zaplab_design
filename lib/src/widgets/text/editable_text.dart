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
        alignment: PlaceholderAlignment.middle,
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
          return AppContainer(
            height: 24,
            padding: const AppEdgeInsets.symmetric(horizontal: AppGapSize.s4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppProfilePic('none', size: AppProfilePicSize.s20),
                const AppGap.s4(),
                AppText.med16(
                  'Profile Name',
                  color: theme.colors.white33,
                  fontSize: 16,
                ),
              ],
            ),
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
    if (!selection.isValid || !selection.isCollapsed) return;

    final text = _controller.text;
    final offset = selection.baseOffset;

    // Check for trigger character and ensure we haven't already added a span here
    if (offset > 0 &&
        text[offset - 1] == '@' &&
        !_controller._activeSpans.containsKey(offset - 1)) {
      _controller.insertSpan(offset - 1, '@');
      _resolveMentions(text.substring(offset));
    }

    // Remove invalid spans
    for (final spanOffset in _controller._activeSpans.keys.toList()) {
      if (spanOffset >= text.length || text[spanOffset] != '@') {
        _controller.removeSpan(spanOffset);
      }
    }
  }

  void _handleExternalControllerChange() {
    if (_controller.text != widget.controller!.text) {
      _controller.text = widget.controller!.text;
    }
  }

  void _resolveMentions(String query) async {
    final profiles = await widget.onResolveMentions(query);
    // TODO: Use the resolved profiles to update the widget span
    print('Resolved profiles for query "$query": $profiles');
  }

  @override
  void dispose() {
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
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
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
