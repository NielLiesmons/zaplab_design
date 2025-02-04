import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:zaplab_design/src/widgets/text/text_selection.dart';
import 'package:zaplab_design/src/widgets/text/text_selection_controls.dart';

class AppInputField extends StatefulWidget {
  final List<Widget>? placeholder;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? style;
  final List<AppTextSelectionMenuItem>? contextMenuItems;
  final Color? backgroundColor;

  const AppInputField({
    super.key,
    this.placeholder,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.style,
    this.contextMenuItems,
    this.backgroundColor,
  });

  AppInputField copyWith({
    List<Widget>? placeholder,
    void Function(String)? onChanged,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextStyle? style,
    List<AppTextSelectionMenuItem>? contextMenuItems,
    Color? backgroundColor,
  }) {
    return AppInputField(
      placeholder: placeholder ?? this.placeholder,
      onChanged: onChanged ?? this.onChanged,
      controller: controller ?? this.controller,
      focusNode: focusNode ?? this.focusNode,
      style: style ?? this.style,
      contextMenuItems: contextMenuItems ?? this.contextMenuItems,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final _selectionControls = AppTextSelectionControls();
  bool _hasText = false;
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final hadText = _hasText;
    final hasText = _controller.text.isNotEmpty;

    if (hadText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {});
    }
  }

  void _scrollUp() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset - 50,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset + 50,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isMobile = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;

    final defaultTextStyle = theme.typography.reg14.copyWith(
      color: theme.colors.white,
    );

    final textStyle = widget.style?.copyWith(
          color: theme.colors.white,
        ) ??
        defaultTextStyle;

    return AppContainer(
      padding: const AppEdgeInsets.symmetric(
        horizontal: AppGapSize.s12,
        vertical: AppGapSize.s8,
      ),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.colors.black33,
        borderRadius: theme.radius.asBorderRadius().rad16,
        border: Border.all(
          color: theme.colors.white33,
          width: LineThicknessData.normal().thin,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: theme.sizes.s38,
              maxHeight: 2 * theme.sizes.s104,
            ),
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  if (event.scrollDelta.dy > 0) {
                    _scrollDown();
                  } else if (event.scrollDelta.dy < 0) {
                    _scrollUp();
                  }
                }
              },
              child: SingleChildScrollView(
                physics: isMobile
                    ? const ClampingScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    if (!_hasText && widget.placeholder != null)
                      IgnorePointer(
                        child: Row(
                          children: widget.placeholder!,
                        ),
                      ),
                    AppSelectableText(
                      text: _controller.text,
                      style: textStyle,
                      editable: true,
                      controller: _controller,
                      focusNode: _focusNode,
                      onChanged: widget.onChanged,
                      contextMenuItems: widget.contextMenuItems,
                      selectionControls: _selectionControls,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const AppGap.s8(),
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSmallButton(
                    square: true,
                    content: [
                      AppIcon.s16(
                        theme.icons.characters.camera,
                        color: theme.colors.white33,
                      ),
                    ],
                    onTap: () {},
                    inactiveColor: theme.colors.white8,
                    pressedColor: theme.colors.white8,
                  ),
                  const AppGap.s8(),
                  AppSmallButton(
                    square: true,
                    content: [
                      AppIcon.s12(
                        theme.icons.characters.gif,
                        color: theme.colors.white33,
                      ),
                    ],
                    onTap: () {},
                    inactiveColor: theme.colors.white8,
                    pressedColor: theme.colors.white8,
                  ),
                  const AppGap.s8(),
                  AppSmallButton(
                    square: true,
                    content: [
                      AppIcon.s16(
                        theme.icons.characters.plus,
                        outlineColor: theme.colors.white33,
                        outlineThickness: LineThicknessData.normal().thick,
                      ),
                    ],
                    onTap: () {},
                    inactiveColor: theme.colors.white8,
                    pressedColor: theme.colors.white8,
                  ),
                ],
              ),
              const Spacer(),
              AppSmallButton(
                content: [
                  // AppIcon.s16(
                  //   theme.icons.characters.send,
                  //   color: AppColorsData.dark().white,
                  // ),
                  AppText.med14(
                    'Done',
                    color: AppColorsData.dark().white,
                  ),
                ],
                onTap: () {
                  // Handle send action
                },
                // onChevronTap: () {
                //   // Handle chevron action
                // },
                inactiveGradient: theme.colors.blurple,
                pressedGradient: theme.colors.blurple,
              ),
            ],
          ),
          const AppGap.s4(),
        ],
      ),
    );
  }
}
