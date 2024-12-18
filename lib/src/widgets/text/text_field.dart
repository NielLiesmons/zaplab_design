import 'package:zaplab_design/zaplab_design.dart';
import 'text_selection.dart';
import 'text_selection_controls.dart';

class AppTextField extends StatefulWidget {
  final String? placeholder;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? textStyle;
  final TextStyle? placeholderStyle;
  final Color? placeholderColor;
  final List<AppTextSelectionMenuItem>? contextMenuItems;

  const AppTextField({
    super.key,
    this.placeholder,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.textStyle,
    this.placeholderStyle,
    this.placeholderColor,
    this.contextMenuItems,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final _selectionControls = AppTextSelectionControls();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller.addListener(_handleTextChange);
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _focusNode.removeListener(_handleFocusChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleTextChange() {
    final hadText = _hasText;
    final hasText = _controller.text.isNotEmpty;

    if (hadText != hasText) {
      setState(() {
        _hasText = hasText;
      });

      // Maintain focus when text is cleared
      if (!hasText && _focusNode.hasFocus) {
        _focusNode.requestFocus();
      }
    }
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        // Force rebuild when focused to ensure proper cursor display
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final defaultTextStyle = theme.typography.reg14;
    final defaultPlaceholderStyle = theme.typography.med14.copyWith(
      color: widget.placeholderColor ?? theme.colors.white33,
    );

    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (!_hasText && widget.placeholder != null)
          IgnorePointer(
            child: AppTextSelection(
              text: widget.placeholder!,
              style: widget.placeholderStyle ?? defaultPlaceholderStyle,
              editable: false,
            ),
          ),
        AppTextSelection(
          text: _controller.text,
          style: widget.textStyle ?? defaultTextStyle,
          editable: true,
          controller: _controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          contextMenuItems: widget.contextMenuItems,
          selectionControls: _selectionControls,
        ),
      ],
    );
  }
}
