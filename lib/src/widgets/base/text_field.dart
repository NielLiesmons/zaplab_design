import 'package:zaplab_design/zaplab_design.dart';

class AppTextField extends StatelessWidget {
  final String? placeholder;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? textStyle;
  final TextStyle? placeholderStyle;
  final Color? placeholderColor;

  const AppTextField({
    super.key,
    this.placeholder,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.textStyle,
    this.placeholderStyle,
    this.placeholderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final defaultTextStyle = theme.typography.reg14;
    final defaultPlaceholderStyle = theme.typography.med14.copyWith(
      color: placeholderColor ?? theme.colors.white66,
    );

    final textController = controller ?? TextEditingController();

    return Stack(
      children: [
        if (textController.text.isEmpty && placeholder != null)
          Text(
            placeholder!,
            style: placeholderStyle ?? defaultPlaceholderStyle,
          ),
        EditableText(
          controller: textController,
          focusNode: focusNode ?? FocusNode(),
          style: textStyle ?? defaultTextStyle,
          cursorColor: theme.colors.white,
          backgroundCursorColor: theme.colors.white,
          onChanged: onChanged ?? (_) {},
        ),
      ],
    );
  }
}
