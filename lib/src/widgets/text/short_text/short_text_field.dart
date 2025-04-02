import 'package:zaplab_design/zaplab_design.dart';

class AppShortTextField extends StatefulWidget {
  final List<Widget>? placeholder;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? style;
  final List<AppTextSelectionMenuItem>? contextMenuItems;
  final Color? backgroundColor;
  final Message? quotedMessage;
  final NostrProfileSearch onSearchProfiles;
  final NostrEmojiSearch onSearchEmojis;
  final VoidCallback onCameraTap;
  final VoidCallback onGifTap;
  final VoidCallback onAddTap;
  final VoidCallback? onSendTap;
  final VoidCallback? onDoneTap;
  final VoidCallback? onChevronTap;

  const AppShortTextField({
    super.key,
    this.placeholder,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.style,
    this.contextMenuItems,
    this.backgroundColor,
    this.quotedMessage,
    required this.onSearchProfiles,
    required this.onSearchEmojis,
    required this.onCameraTap,
    required this.onGifTap,
    required this.onAddTap,
    this.onSendTap,
    this.onDoneTap,
    this.onChevronTap,
  });

  AppShortTextField copyWith({
    List<Widget>? placeholder,
    void Function(String)? onChanged,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextStyle? style,
    List<AppTextSelectionMenuItem>? contextMenuItems,
    Color? backgroundColor,
    NostrProfileSearch? onSearchProfiles,
    NostrEmojiSearch? onSearchEmojis,
    VoidCallback? onCameraTap,
    VoidCallback? onGifTap,
    VoidCallback? onAddTap,
    VoidCallback? onSendTap,
    VoidCallback? onDoneTap,
    VoidCallback? onChevronTap,
  }) {
    return AppShortTextField(
      placeholder: placeholder ?? this.placeholder,
      onChanged: onChanged ?? this.onChanged,
      controller: controller ?? this.controller,
      focusNode: focusNode ?? this.focusNode,
      style: style ?? this.style,
      contextMenuItems: contextMenuItems ?? this.contextMenuItems,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      onSearchProfiles: onSearchProfiles ?? this.onSearchProfiles,
      onSearchEmojis: onSearchEmojis ?? this.onSearchEmojis,
      onCameraTap: onCameraTap ?? this.onCameraTap,
      onGifTap: onGifTap ?? this.onGifTap,
      onAddTap: onAddTap ?? this.onAddTap,
      onSendTap: onSendTap ?? this.onSendTap,
      onDoneTap: onDoneTap ?? this.onDoneTap,
      onChevronTap: onChevronTap ?? this.onChevronTap,
    );
  }

  @override
  State<AppShortTextField> createState() => _AppShortTextFieldState();
}

class _AppShortTextFieldState extends State<AppShortTextField> {
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
          if (widget.quotedMessage != null)
            AppContainer(
              padding: const AppEdgeInsets.only(
                left: AppGapSize.s8,
                right: AppGapSize.s8,
                top: AppGapSize.s8,
                bottom: AppGapSize.s2,
              ),
              child: AppQuotedMessage(
                profileName: widget.quotedMessage!.profileName,
                profilePicUrl: widget.quotedMessage!.profilePicUrl,
                message: widget.quotedMessage!.message ?? '',
                timestamp: widget.quotedMessage!.timestamp,
                onResolveEvent: (id) async => NostrEvent(
                  nevent: id,
                  npub: 'npub1test',
                  contentType: 'article',
                  title: 'Communi-keys',
                  imageUrl:
                      'https://cdn.satellite.earth/7273fad49b4c3a17a446781a330553e1bb8de7a238d6c6b6cee30b8f5caf21f4.png',
                  profileName: 'Niel Liesmons',
                  profilePicUrl:
                      'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
                  timestamp: DateTime.now(),
                  onTap: () {},
                ),
                onResolveProfile: (id) async => Profile(
                  npub: id,
                  profileName: 'Pip',
                  profilePicUrl: 'https://m.primal.net/IfSZ.jpg',
                  onTap: () {},
                ),
                onResolveEmoji: (id) async =>
                    'https://image.nostr.build/f1ac401d3f222908d2f80df7cfadc1d73f4e0afa3a3ff6e8421bf9f0b37372a6.gif',
              ),
            ),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0x00FFFFFF),
                const Color(0x99FFFFFF),
                const Color(0xFFFFFFFF),
                const Color(0xFFFFFFFF),
                const Color(0x99FFFFFF),
                const Color(0x00FFFFFF),
              ],
              stops: const [0.00, 0.03, 0.06, 0.94, 0.97, 1.00],
            ).createShader(bounds),
            child: AppContainer(
              clipBehavior: Clip.hardEdge,
              padding: const AppEdgeInsets.only(
                left: AppGapSize.s12,
                right: AppGapSize.s12,
                top: AppGapSize.s10,
                bottom: AppGapSize.s8,
              ),
              decoration: BoxDecoration(
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: AppEditableShortText(
                text: widget.controller?.text ?? '',
                style: textStyle,
                controller: widget.controller,
                focusNode: widget.focusNode,
                onChanged: widget.onChanged,
                contextMenuItems: widget.contextMenuItems,
                placeholder: widget.placeholder,
                onSearchProfiles: widget.onSearchProfiles,
                onSearchEmojis: widget.onSearchEmojis,
              ),
            ),
          ),
          AppContainer(
            padding: const AppEdgeInsets.only(
              left: AppGapSize.s12,
              right: AppGapSize.s12,
              bottom: AppGapSize.s8,
            ),
            child: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppSmallButton(
                      square: true,
                      onTap: widget.onCameraTap,
                      inactiveColor: theme.colors.white8,
                      pressedColor: theme.colors.white8,
                      children: [
                        AppIcon.s16(
                          theme.icons.characters.camera,
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const AppGap.s8(),
                    AppSmallButton(
                      square: true,
                      onTap: widget.onGifTap,
                      inactiveColor: theme.colors.white8,
                      pressedColor: theme.colors.white8,
                      children: [
                        AppIcon.s12(
                          theme.icons.characters.gif,
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const AppGap.s8(),
                    AppSmallButton(
                      square: true,
                      onTap: widget.onAddTap,
                      inactiveColor: theme.colors.white8,
                      pressedColor: theme.colors.white8,
                      children: [
                        AppIcon.s16(
                          theme.icons.characters.plus,
                          outlineColor: theme.colors.white33,
                          outlineThickness: LineThicknessData.normal().thick,
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                AppSmallButton(
                  onTap: () {
                    // Handle send action
                  },
                  inactiveGradient: theme.colors.blurple,
                  pressedGradient: theme.colors.blurple,
                  onChevronTap: widget.onChevronTap,
                  children: [
                    if (widget.onSendTap != null)
                      AppIcon.s16(
                        theme.icons.characters.send,
                        color: AppColorsData.dark().white,
                      ),
                    if (widget.onDoneTap != null)
                      AppText.med14(
                        'Done',
                        color: AppColorsData.dark().white,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const AppGap.s4(),
        ],
      ),
    );
  }
}
