import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabShortTextField extends StatefulWidget {
  final List<Widget>? placeholder;
  final void Function(String)? onChanged;
  final void Function(String)? onRawTextChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? style;
  final List<LabTextSelectionMenuItem>? contextMenuItems;
  final Color? backgroundColor;
  final ChatMessage? quotedChatMessage;
  final CashuZap? quotedCashuZap;
  final Zap? quotedZap;
  final NostrProfileSearch onSearchProfiles;
  final NostrEmojiSearch onSearchEmojis;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final Function(Profile) onProfileTap;
  final VoidCallback onCameraTap;
  final VoidCallback onEmojiTap;
  final VoidCallback onGifTap;
  final VoidCallback onAddTap;
  final VoidCallback? onSendTap;
  final VoidCallback? onDoneTap;
  final VoidCallback? onChevronTap;

  const LabShortTextField({
    super.key,
    this.placeholder,
    this.onChanged,
    this.onRawTextChanged,
    this.controller,
    this.focusNode,
    this.style,
    this.contextMenuItems,
    this.backgroundColor,
    this.quotedChatMessage,
    this.quotedCashuZap,
    this.quotedZap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onSearchProfiles,
    required this.onSearchEmojis,
    required this.onCameraTap,
    required this.onEmojiTap,
    required this.onGifTap,
    required this.onAddTap,
    required this.onProfileTap,
    this.onSendTap,
    this.onDoneTap,
    this.onChevronTap,
  });

  LabShortTextField copyWith({
    List<Widget>? placeholder,
    void Function(String)? onChanged,
    void Function(String)? onRawTextChanged,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextStyle? style,
    List<LabTextSelectionMenuItem>? contextMenuItems,
    Color? backgroundColor,
    ChatMessage? quotedChatMessage,
    Zap? quotedZap,
    NostrEventResolver? onResolveEvent,
    NostrProfileResolver? onResolveProfile,
    NostrEmojiResolver? onResolveEmoji,
    NostrProfileSearch? onSearchProfiles,
    NostrEmojiSearch? onSearchEmojis,
    VoidCallback? onCameraTap,
    VoidCallback? onEmojiTap,
    VoidCallback? onGifTap,
    VoidCallback? onAddTap,
    Function(Profile)? onProfileTap,
    VoidCallback? onSendTap,
    VoidCallback? onDoneTap,
    VoidCallback? onChevronTap,
  }) {
    return LabShortTextField(
      placeholder: placeholder ?? this.placeholder,
      onChanged: onChanged ?? this.onChanged,
      onRawTextChanged: onRawTextChanged ?? this.onRawTextChanged,
      controller: controller ?? this.controller,
      focusNode: focusNode ?? this.focusNode,
      style: style ?? this.style,
      contextMenuItems: contextMenuItems ?? this.contextMenuItems,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      quotedChatMessage: quotedChatMessage ?? this.quotedChatMessage,
      quotedZap: quotedZap ?? this.quotedZap,
      onResolveEvent: onResolveEvent ?? this.onResolveEvent,
      onResolveProfile: onResolveProfile ?? this.onResolveProfile,
      onResolveEmoji: onResolveEmoji ?? this.onResolveEmoji,
      onSearchProfiles: onSearchProfiles ?? this.onSearchProfiles,
      onSearchEmojis: onSearchEmojis ?? this.onSearchEmojis,
      onCameraTap: onCameraTap ?? this.onCameraTap,
      onEmojiTap: onEmojiTap ?? this.onEmojiTap,
      onGifTap: onGifTap ?? this.onGifTap,
      onAddTap: onAddTap ?? this.onAddTap,
      onProfileTap: onProfileTap ?? this.onProfileTap,
      onSendTap: onSendTap ?? this.onSendTap,
      onDoneTap: onDoneTap ?? this.onDoneTap,
      onChevronTap: onChevronTap ?? this.onChevronTap,
    );
  }

  @override
  State<LabShortTextField> createState() => _LabShortTextFieldState();

  // Static method to access the editor state from parent widgets
  static LabEditableShortTextState? getEditorState(BuildContext context) {
    final state = context.findAncestorStateOfType<_LabShortTextFieldState>();
    return state?.editorState;
  }
}

class _LabShortTextFieldState extends State<LabShortTextField> {
  // Global key to access the editor state
  final GlobalKey<LabEditableShortTextState> _editorKey =
      GlobalKey<LabEditableShortTextState>();

  // Public getter to access the editor state
  LabEditableShortTextState? get editorState => _editorKey.currentState;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    final defaultTextStyle = theme.typography.reg16.copyWith(
      color: theme.colors.white,
    );

    final textStyle = widget.style?.copyWith(
          color: theme.colors.white,
        ) ??
        defaultTextStyle;

    return LabContainer(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.colors.black33,
        borderRadius: theme.radius.asBorderRadius().rad16,
        border: Border.all(
          color: theme.colors.white33,
          width: LabLineThicknessData.normal().thin,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.quotedZap != null || widget.quotedCashuZap != null)
            LabContainer(
              padding: const LabEdgeInsets.only(
                left: LabGapSize.s8,
                right: LabGapSize.s8,
                top: LabGapSize.s8,
                bottom: LabGapSize.s2,
              ),
              child: widget.quotedZap != null
                  ? LabZapCard(
                      zap: widget.quotedZap!,
                      onResolveEvent: widget.onResolveEvent,
                      onResolveProfile: widget.onResolveProfile,
                      onResolveEmoji: widget.onResolveEmoji,
                      onProfileTap: widget.onProfileTap,
                    )
                  : LabZapCard(
                      cashuZap: widget.quotedCashuZap!,
                      onResolveEvent: widget.onResolveEvent,
                      onResolveProfile: widget.onResolveProfile,
                      onResolveEmoji: widget.onResolveEmoji,
                      onProfileTap: widget.onProfileTap,
                    ),
            ),
          if (widget.quotedChatMessage != null)
            LabContainer(
              padding: const LabEdgeInsets.only(
                left: LabGapSize.s8,
                right: LabGapSize.s8,
                top: LabGapSize.s8,
                bottom: LabGapSize.s2,
              ),
              child: LabQuotedMessage(
                chatMessage: widget.quotedChatMessage!,
                onResolveEvent: widget.onResolveEvent,
                onResolveProfile: widget.onResolveProfile,
                onResolveEmoji: widget.onResolveEmoji,
              ),
            ),
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
              padding: const LabEdgeInsets.only(
                left: LabGapSize.s12,
                right: LabGapSize.s12,
                top: LabGapSize.s10,
                bottom: LabGapSize.s8,
              ),
              decoration: BoxDecoration(
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: LabEditableShortText(
                key: _editorKey,
                text: widget.controller?.text ?? '',
                style: textStyle,
                controller: widget.controller,
                focusNode: widget.focusNode,
                onChanged: widget.onChanged,
                onRawTextChanged: widget.onRawTextChanged,
                contextMenuItems: widget.contextMenuItems,
                placeholder: widget.placeholder,
                onSearchProfiles: widget.onSearchProfiles,
                onSearchEmojis: widget.onSearchEmojis,
                onResolveEvent: widget.onResolveEvent,
                onResolveProfile: widget.onResolveProfile,
                onResolveEmoji: widget.onResolveEmoji,
              ),
            ),
          ),
          LabContainer(
            padding: const LabEdgeInsets.only(
              left: LabGapSize.s12,
              right: LabGapSize.s12,
              bottom: LabGapSize.s8,
            ),
            child: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LabSmallButton(
                      square: true,
                      onTap: widget.onCameraTap,
                      color: theme.colors.white8,
                      pressedColor: theme.colors.white8,
                      children: [
                        LabIcon.s16(
                          theme.icons.characters.camera,
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const LabGap.s8(),
                    LabSmallButton(
                      square: true,
                      onTap: widget.onEmojiTap,
                      color: theme.colors.white8,
                      pressedColor: theme.colors.white8,
                      children: [
                        LabIcon.s18(
                          theme.icons.characters.emojiFill,
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const LabGap.s8(),
                    LabSmallButton(
                      square: true,
                      onTap: widget.onGifTap,
                      color: theme.colors.white8,
                      pressedColor: theme.colors.white8,
                      children: [
                        LabIcon.s12(
                          theme.icons.characters.gif,
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const LabGap.s8(),
                    LabSmallButton(
                      square: true,
                      onTap: widget.onAddTap,
                      color: theme.colors.white8,
                      pressedColor: theme.colors.white8,
                      children: [
                        LabIcon.s16(
                          theme.icons.characters.plus,
                          outlineColor: theme.colors.white33,
                          outlineThickness: LabLineThicknessData.normal().thick,
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                LabSmallButton(
                  onTap: () {
                    widget.onDoneTap?.call();
                    widget.onSendTap?.call();
                  },
                  gradient: theme.colors.blurple,
                  pressedGradient: theme.colors.blurple,
                  onChevronTap: widget.onChevronTap,
                  children: [
                    if (widget.onSendTap != null)
                      LabIcon.s16(
                        theme.icons.characters.send,
                        color: theme.colors.whiteEnforced,
                      ),
                    if (widget.onDoneTap != null)
                      LabText.med14(
                        'Done',
                        color: theme.colors.whiteEnforced,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const LabGap.s4(),
        ],
      ),
    );
  }
}
