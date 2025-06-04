import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter/services.dart';

class AppInputTextField extends StatefulWidget {
  final List<Widget>? placeholderWidget;
  final String? placeholder;
  final String? title;
  final String? warning;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? style;
  final List<AppTextSelectionMenuItem>? contextMenuItems;
  final Color? backgroundColor;
  final bool singleLine;
  final bool autoCapitalize;
  final bool obscureText;

  const AppInputTextField({
    super.key,
    this.placeholderWidget,
    this.placeholder,
    this.title,
    this.warning,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.style,
    this.contextMenuItems,
    this.backgroundColor,
    this.singleLine = false,
    this.autoCapitalize = true,
    this.obscureText = false,
  });

  AppInputTextField copyWith({
    List<Widget>? placeholder,
    String? placeholderText,
    void Function(String)? onChanged,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextStyle? style,
    List<AppTextSelectionMenuItem>? contextMenuItems,
    Color? backgroundColor,
    bool? singleLine,
    bool? autoCapitalize,
    bool? obscureText,
  }) {
    return AppInputTextField(
      placeholderWidget: placeholder ?? placeholderWidget,
      placeholder: placeholderText ?? this.placeholder,
      onChanged: onChanged ?? this.onChanged,
      controller: controller ?? this.controller,
      focusNode: focusNode ?? this.focusNode,
      style: style ?? this.style,
      contextMenuItems: contextMenuItems ?? this.contextMenuItems,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      singleLine: singleLine ?? this.singleLine,
      autoCapitalize: autoCapitalize ?? this.autoCapitalize,
      obscureText: obscureText ?? this.obscureText,
    );
  }

  @override
  State<AppInputTextField> createState() => _AppInputTextFieldState();
}

class _AppInputTextFieldState extends State<AppInputTextField> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final defaultTextStyle = theme.typography.reg16.copyWith(
      color: theme.colors.white,
    );

    final textStyle = widget.style?.copyWith(
          color: theme.colors.white,
        ) ??
        defaultTextStyle;

    final placeholderWidgets = widget.placeholderWidget ??
        [
          if (widget.placeholder != null)
            AppText.reg16(
              widget.placeholder!,
              color: theme.colors.white33,
              fontSize: textStyle.fontSize,
            ),
        ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null)
          Row(
            children: [
              const AppGap.s16(),
              AppText.reg14(widget.title!, color: theme.colors.white),
              const AppGap.s12(),
            ],
          ),
        if (widget.title != null) const AppGap.s8(),
        AppContainer(
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? theme.colors.black33,
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
                  child: AppEditableInputText(
                    text: widget.controller?.text ?? '',
                    style: textStyle,
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    onChanged: widget.onChanged,
                    contextMenuItems: widget.contextMenuItems,
                    placeholder: placeholderWidgets,
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
                    obscureText: widget.obscureText,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.warning != null)
          AppContainer(
            padding: const AppEdgeInsets.symmetric(
              horizontal: AppGapSize.s14,
            ),
            child: Column(
              children: [
                CustomPaint(
                  size: const Size(24, 10),
                  painter: TrianglePainter(
                    color: theme.colors.white16,
                  ),
                ),
                AppContainer(
                  padding: const AppEdgeInsets.symmetric(
                    horizontal: AppGapSize.s14,
                    vertical: AppGapSize.s10,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colors.white16,
                    borderRadius: theme.radius.asBorderRadius().rad16,
                  ),
                  child: Row(
                    children: [
                      AppIcon.s20(theme.icons.characters.alert,
                          outlineColor: theme.colors.white66,
                          outlineThickness:
                              AppLineThicknessData.normal().medium),
                      const AppGap.s12(),
                      AppText.reg14(widget.warning!,
                          color: theme.colors.white66),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  final double cornerRadius;

  TrianglePainter({
    required this.color,
    this.cornerRadius = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0) // Top point
      ..lineTo(0, size.height) // Bottom left
      ..lineTo(size.width, size.height) // Bottom right
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) =>
      color != oldDelegate.color || cornerRadius != oldDelegate.cornerRadius;
}
