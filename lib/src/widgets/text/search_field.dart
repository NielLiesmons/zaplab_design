import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter/services.dart';
import 'package:tap_builder/tap_builder.dart';

class LabSearchField extends StatefulWidget {
  final List<Widget>? placeholderWidget;
  final String? placeholder;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? style;
  final List<LabTextSelectionMenuItem>? contextMenuItems;
  final Color? backgroundColor;
  final bool singleLine;
  final bool autoCapitalize;

  const LabSearchField({
    super.key,
    this.placeholderWidget,
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
  State<LabSearchField> createState() => _LabSearchFieldState();
}

class _LabSearchFieldState extends State<LabSearchField> {
  void _clearText() {
    widget.controller?.clear();
    widget.onChanged?.call('');
    widget.focusNode?.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final isInsideModal = ModalScope.of(context);
    final isInsideScope = LabScope.of(context);

    final defaultTextStyle = theme.typography.reg16.copyWith(
      color: theme.colors.white,
    );

    final textStyle = widget.style?.copyWith(
          color: theme.colors.white,
        ) ??
        defaultTextStyle;

    return LabContainer(
      decoration: BoxDecoration(
        color: widget.backgroundColor ??
            (isInsideModal || isInsideScope
                ? theme.colors.black33
                : theme.colors.gray33),
        borderRadius: theme.radius.asBorderRadius().rad16,
        border: Border.all(
          color: theme.colors.white33,
          width: LabLineThicknessData.normal().thin,
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
            child: LabContainer(
              clipBehavior: Clip.hardEdge,
              padding: const LabEdgeInsets.symmetric(
                horizontal: LabGapSize.s16,
                vertical: LabGapSize.s12,
              ),
              decoration: BoxDecoration(
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: Row(
                children: [
                  LabIcon.s20(
                    theme.icons.characters.search,
                    outlineColor: theme.colors.white66,
                    outlineThickness: LabLineThicknessData.normal().medium,
                  ),
                  const LabGap.s12(),
                  Expanded(
                    child: LabEditableInputText(
                      text: widget.controller?.text ?? '',
                      style: textStyle,
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      onChanged: widget.onChanged,
                      contextMenuItems: widget.contextMenuItems,
                      placeholder: widget.placeholder != null
                          ? [
                              LabText.reg16(widget.placeholder!,
                                  color: theme.colors.white33)
                            ]
                          : widget.placeholderWidget,
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
                                  const LabGap.s12(),
                                  LabCrossButton.s24(
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
