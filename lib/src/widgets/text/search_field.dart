import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter/services.dart';
import 'package:tap_builder/tap_builder.dart';

class AppSearchField extends StatefulWidget {
  final List<Widget>? placeholder;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? style;
  final List<AppTextSelectionMenuItem>? contextMenuItems;
  final Color? backgroundColor;
  final bool singleLine;
  final bool autoCapitalize;

  const AppSearchField({
    super.key,
    this.placeholder,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.style,
    this.contextMenuItems,
    this.backgroundColor,
    this.singleLine = true,
    this.autoCapitalize = true,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  void _clearText() {
    widget.controller?.clear();
    widget.onChanged?.call('');
    widget.focusNode?.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isInsideModal = ModalScope.of(context);

    final defaultTextStyle = theme.typography.reg16.copyWith(
      color: theme.colors.white,
    );

    final textStyle = widget.style?.copyWith(
          color: theme.colors.white,
        ) ??
        defaultTextStyle;

    return AppContainer(
      decoration: BoxDecoration(
        color: widget.backgroundColor ??
            (isInsideModal ? theme.colors.black33 : theme.colors.gray33),
        borderRadius: theme.radius.asBorderRadius().rad16,
        border: Border.all(
          color: theme.colors.white33,
          width: AppLineThicknessData.normal().thin,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x00FFFFFF),
                Color(0x99FFFFFF),
                Color(0xFFFFFFFF),
                Color(0xFFFFFFFF),
                Color(0x99FFFFFF),
                Color(0x00FFFFFF),
              ],
              stops: [0.00, 0.03, 0.06, 0.94, 0.97, 1.00],
            ).createShader(bounds),
            child: AppContainer(
              clipBehavior: Clip.hardEdge,
              padding: const AppEdgeInsets.symmetric(
                horizontal: AppGapSize.s16,
                vertical: AppGapSize.s12,
              ),
              decoration: BoxDecoration(
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: Row(
                children: [
                  AppIcon.s20(
                    theme.icons.characters.search,
                    outlineColor: theme.colors.white66,
                    outlineThickness: AppLineThicknessData.normal().medium,
                  ),
                  const AppGap.s12(),
                  Expanded(
                    child: AppEditableInputText(
                      text: widget.controller?.text ?? '',
                      style: textStyle,
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      onChanged: widget.onChanged,
                      contextMenuItems: widget.contextMenuItems,
                      placeholder: widget.placeholder,
                      maxLines: widget.singleLine ? 1 : null,
                      minLines: widget.singleLine ? 1 : null,
                      textCapitalization: widget.autoCapitalize
                          ? TextCapitalization.sentences
                          : TextCapitalization.none,
                      inputFormatters: widget.singleLine
                          ? [
                              FilteringTextInputFormatter.singleLineFormatter,
                            ]
                          : null,
                    ),
                  ),
                  if (widget.controller != null)
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: widget.controller!,
                      builder: (context, value, child) {
                        return value.text.isNotEmpty
                            ? Row(
                                children: [
                                  const AppGap.s12(),
                                  AppCrossButton.s24(
                                    onTap: _clearText,
                                  ),
                                ],
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
