import 'package:zaplab_design/zaplab_design.dart';
import 'text_selection_gesture_detector_builder.dart' as custom;

bool isSelectingText = false;

class AppSelectableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool showContextMenu;
  final List<AppTextSelectionMenuItem>? contextMenuItems;
  final TextSelectionControls? selectionControls;
  final TextSpan? textSpan;

  const AppSelectableText({
    super.key,
    required this.text,
    this.style,
    this.showContextMenu = true,
    this.contextMenuItems,
    this.selectionControls,
    this.textSpan,
  });

  static AppSelectableText rich(
    TextSpan textSpan, {
    Key? key,
    TextStyle? style,
    bool showContextMenu = true,
    List<AppTextSelectionMenuItem>? contextMenuItems,
    TextSelectionControls? selectionControls,
  }) {
    return AppSelectableText(
      key: key,
      text: '',
      textSpan: textSpan,
      style: style,
      showContextMenu: showContextMenu,
      contextMenuItems: contextMenuItems,
      selectionControls: selectionControls,
    );
  }

  @override
  State<AppSelectableText> createState() => _AppSelectableTextState();
}

class _AppSelectableTextState extends State<AppSelectableText>
    implements custom.TextSelectionGestureDetectorBuilderDelegate {
  @override
  GlobalKey<EditableTextState> get editableTextKey => _editableTextKey;
  final GlobalKey<EditableTextState> _editableTextKey =
      GlobalKey<EditableTextState>();

  late TextEditingController _controller;
  late FocusNode _focusNode;
  late custom.TextSelectionGestureDetectorBuilder
      _selectionGestureDetectorBuilder;

  @override
  bool get forcePressEnabled => false;

  @override
  bool get selectionEnabled => true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _focusNode = FocusNode();
    _selectionGestureDetectorBuilder =
        custom.TextSelectionGestureDetectorBuilder(delegate: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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
      behavior: HitTestBehavior.deferToChild,
      child: EditableText(
        key: editableTextKey,
        controller: widget.textSpan != null
            ? _TextSpanEditingController(textSpan: widget.textSpan!)
            : _controller,
        focusNode: _focusNode,
        style: textStyle,
        cursorColor: theme.colors.white,
        backgroundCursorColor: theme.colors.white33,
        onChanged: (_) {},
        maxLines: null,
        minLines: 1,
        textAlign: TextAlign.left,
        selectionControls:
            widget.selectionControls ?? AppTextSelectionControls(),
        enableInteractiveSelection: true,
        showSelectionHandles: true,
        showCursor: false,
        rendererIgnoresPointer: true,
        enableSuggestions: false,
        readOnly: true,
        selectionColor: theme.colors.blurpleColor.withValues(
          alpha: 0.33,
        ),
        onSelectionChanged: (selection, cause) {
          isSelectingText = !selection.isCollapsed;
          if (!selection.isCollapsed && widget.showContextMenu) {
            editableTextKey.currentState?.showToolbar();
          } else {
            editableTextKey.currentState?.hideToolbar();
          }
        },
        contextMenuBuilder: (context, EditableTextState editableTextState) {
          return AppTextSelectionMenu(
            position: editableTextState.contextMenuAnchors.primaryAnchor,
            editableTextState: editableTextState,
            menuItems: widget.contextMenuItems,
          );
        },
      ),
    );
  }
}

class _TextSpanEditingController extends TextEditingController {
  _TextSpanEditingController({required TextSpan textSpan})
      : _textSpan = textSpan,
        super(text: textSpan.toPlainText(includeSemanticsLabels: false));

  final TextSpan _textSpan;

  @override
  TextSpan buildTextSpan({
    required BuildContext? context,
    TextStyle? style,
    required bool withComposing,
  }) {
    return _textSpan;
  }

  @override
  set text(String? newText) {
    // This should never be reached.
    throw UnimplementedError();
  }
}
