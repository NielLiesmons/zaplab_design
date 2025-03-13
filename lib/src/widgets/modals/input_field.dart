import 'package:zaplab_design/zaplab_design.dart';

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

    return AppContainer(
      clipBehavior: Clip.hardEdge,
      padding: const AppEdgeInsets.only(
        left: AppGapSize.s12,
        right: AppGapSize.s12,
        top: AppGapSize.s10,
        bottom: AppGapSize.s8,
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
          AppEditableText(
            text: widget.controller?.text ?? '',
            style: textStyle,
            controller: widget.controller,
            focusNode: widget.focusNode,
            onChanged: widget.onChanged,
            contextMenuItems: widget.contextMenuItems,
            placeholder: widget.placeholder,
            onResolveMentions: (query) async {
              print('Querying mentions for: $query');
              // For testing, return some dummy data
              return [
                Profile(
                  npub: 'npub1hjghklk',
                  profileName: 'Franzap',
                  profilePicUrl:
                      'https://primal.b-cdn.net/media-cache?s=m&a=1&u=https%3A%2F%2Fnostr.build%2Fi%2Fnostr.build_1732d9a6cd9614c6c4ac3b8f0ee4a8242e9da448e2aacb82e7681d9d0bc36568.jpg',
                ),
                Profile(
                  npub: 'npub1hjghklk',
                  profileName: 'Pip',
                  profilePicUrl: 'https://m.primal.net/IfSZ.jpg',
                ),
                Profile(
                  npub: 'npub1hjghklk',
                  profileName: 'Verbricha',
                  profilePicUrl:
                      'https://primal.b-cdn.net/media-cache?s=m&a=1&u=https%3A%2F%2Fnostr.download%2F1aba957814cac9c324c54d94e0ba6606dc50af17f7c08654e9b9f139a9720d6d.jpeg',
                ),
              ];
            },
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
