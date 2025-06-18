import 'package:zaplab_design/zaplab_design.dart';
import 'text_selection_gesture_detector_builder.dart' as custom;
import 'package:flutter/services.dart';

bool isEditingInputText = false;

class LabEditableInputText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final List<LabTextSelectionMenuItem>? contextMenuItems;
  final List<Widget>? placeholder;
  final int? maxLines;
  final int? minLines;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;

  const LabEditableInputText({
    super.key,
    required this.text,
    this.style,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.contextMenuItems,
    this.placeholder,
    this.maxLines,
    this.minLines,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.obscureText = false,
  });

  @override
  State<LabEditableInputText> createState() => _LabEditableInputTextState();
}

class _LabEditableInputTextState extends State<LabEditableInputText>
    implements custom.TextSelectionGestureDetectorBuilderDelegate {
  @override
  GlobalKey<EditableTextState> get editableTextKey => _editableTextKey;
  final GlobalKey<EditableTextState> _editableTextKey =
      GlobalKey<EditableTextState>();

  late TextEditingController _controller;
  late FocusNode _focusNode;
  late custom.TextSelectionGestureDetectorBuilder _gestureDetectorBuilder;
  final ValueNotifier<bool> _isEmpty = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _showPlaceholder = ValueNotifier<bool>(false);
  bool _hasText = false;
  bool _hasSelection = false;

  @override
  bool get forcePressEnabled => false;

  @override
  bool get selectionEnabled => true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.text);
    _focusNode = widget.focusNode ?? FocusNode();
    _gestureDetectorBuilder = custom.TextSelectionGestureDetectorBuilder(
      delegate: this,
    );
    _hasText = _controller.text.isNotEmpty;
    _isEmpty.value = _controller.text.isEmpty;
    _hasSelection = false;
    _controller.addListener(_handleTextChanged);
    if (widget.controller != null) {
      widget.controller!.addListener(_handleExternalControllerChange);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.selection =
            TextSelection.collapsed(offset: _controller.text.length);
      }
    });
  }

  void _handleTextChanged() {
    _hasText = _controller.text.isNotEmpty;
    _isEmpty.value = _controller.text.isEmpty;
    _hasSelection = false;

    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }
  }

  void _handleExternalControllerChange() {
    if (_controller.text != widget.controller!.text) {
      _controller.text = widget.controller!.text;
      _hasText = _controller.text.isNotEmpty;
      _isEmpty.value = _controller.text.isEmpty;
      _hasSelection = false;
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

                    // Handle arrow keys
                    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                      if (offset > 0) {
                        _controller.selection =
                            TextSelection.collapsed(offset: offset - 1);
                      }
                    } else if (event.logicalKey ==
                        LogicalKeyboardKey.arrowRight) {
                      if (offset < _controller.text.length) {
                        _controller.selection =
                            TextSelection.collapsed(offset: offset + 1);
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
                    print(
                        'Selection changed: isCollapsed=${selection.isCollapsed}, base=${selection.baseOffset}, extent=${selection.extentOffset}, cause=$cause');
                    isEditingInputText = !selection.isCollapsed;
                    // Show selection handles for any non-collapsed selection
                    _hasSelection = !selection.isCollapsed &&
                        selection.baseOffset != selection.extentOffset;
                    print('_hasSelection: $_hasSelection');

                    // Only show toolbar for user-initiated selections
                    if (_hasSelection &&
                        (cause == SelectionChangedCause.drag ||
                            cause == SelectionChangedCause.longPress ||
                            cause == SelectionChangedCause.tap)) {
                      editableTextKey.currentState?.showToolbar();
                    } else {
                      editableTextKey.currentState?.hideToolbar();
                    }
                  },
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  textAlign: TextAlign.left,
                  selectionControls: LabTextSelectionControls(),
                  enableInteractiveSelection: true,
                  showSelectionHandles: true,
                  showCursor: true,
                  rendererIgnoresPointer: false,
                  enableSuggestions: true,
                  readOnly: false,
                  textCapitalization: widget.textCapitalization,
                  inputFormatters: widget.inputFormatters,
                  obscureText: widget.obscureText,
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
                  autofocus: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
