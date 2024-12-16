import 'package:zaplab_design/zaplab_design.dart';
import 'text_selection_controls.dart';

class AppTextSelection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final defaultStyle = theme.typography.reg14;
    final textStyle = (style ?? defaultStyle).copyWith(
      height: defaultStyle.height,
      leadingDistribution: defaultStyle.leadingDistribution,
    );

    return EditableText(
      controller: controller ?? TextEditingController(text: text),
      focusNode: focusNode ?? FocusNode(),
      style: textStyle,
      cursorColor: theme.colors.white,
      backgroundCursorColor: theme.colors.white,
      onChanged: editable ? (onChanged ?? (_) {}) : (_) {},
      maxLines: null,
      minLines: 1,
      textAlign: TextAlign.left,
      selectionControls: selectionControls ?? AppTextSelectionControls(),
      enableInteractiveSelection: true,
      showSelectionHandles: true,
      showCursor: true,
      rendererIgnoresPointer: !editable,
      enableSuggestions: editable,
      readOnly: !editable,
      selectionColor: const Color(0xFF5C58FF).withOpacity(0.33),
    );
  }
}
