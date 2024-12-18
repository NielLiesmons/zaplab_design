import 'package:zaplab_design/zaplab_design.dart';
import 'text_selection_controls.dart';
import 'text_selection_gesture_detector_builder.dart' as custom;

class AppTextSelection extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool editable;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final List<AppTextSelectionMenuItem>? contextMenuItems;
  final TextSelectionControls? selectionControls;

  const AppTextSelection({
    super.key,
    required this.text,
    this.style,
    this.editable = false,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.contextMenuItems,
    this.selectionControls,
  });

  @override
  State<AppTextSelection> createState() => _AppTextSelectionState();
}

class _AppTextSelectionState extends State<AppTextSelection>
    implements custom.TextSelectionGestureDetectorBuilderDelegate {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late custom.TextSelectionGestureDetectorBuilder
      _selectionGestureDetectorBuilder;

  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  @override
  bool get forcePressEnabled => false;

  @override
  bool get selectionEnabled => true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.controller == null) {
      _controller.text = widget.text;
    }
    _focusNode = widget.focusNode ?? FocusNode();
    _selectionGestureDetectorBuilder =
        custom.TextSelectionGestureDetectorBuilder(delegate: this);
  }

  @override
  void dispose() {
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
    final defaultStyle = theme.typography.reg14;
    final textStyle = (widget.style ?? defaultStyle).copyWith(
      height: defaultStyle.height,
      leadingDistribution: defaultStyle.leadingDistribution,
    );

    return _selectionGestureDetectorBuilder.buildGestureDetector(
      behavior: HitTestBehavior.translucent,
      child: EditableText(
        key: editableTextKey,
        controller: _controller,
        focusNode: _focusNode,
        style: textStyle,
        cursorColor: theme.colors.white,
        backgroundCursorColor: theme.colors.white,
        onChanged: widget.editable ? (widget.onChanged ?? (_) {}) : (_) {},
        maxLines: null,
        minLines: 1,
        textAlign: TextAlign.left,
        selectionControls:
            widget.selectionControls ?? AppTextSelectionControls(),
        enableInteractiveSelection: true,
        showSelectionHandles: true, // Changed to false initially
        showCursor: widget.editable,
        rendererIgnoresPointer: !widget.editable,
        enableSuggestions: widget.editable,
        readOnly: !widget.editable,
        selectionColor: const Color(0xFF5C58FF).withOpacity(0.33),
        onSelectionChanged: (selection, cause) {
          // Only show handles for actual selection, not cursor movement
          if (selection.isCollapsed) {
            editableTextKey.currentState?.hideToolbar();
          }
        },
      ),
    );
  }
}
