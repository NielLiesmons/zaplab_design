import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppReplyModal extends StatefulWidget {
  final Event event;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrProfileSearch onSearchProfiles;
  final NostrEmojiSearch onSearchEmojis;
  final VoidCallback onCameraTap;
  final VoidCallback onEmojiTap;
  final VoidCallback onGifTap;
  final VoidCallback onAddTap;
  final VoidCallback onSendTap;
  final VoidCallback? onChevronTap;

  const AppReplyModal({
    super.key,
    required this.event,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onSearchProfiles,
    required this.onSearchEmojis,
    required this.onCameraTap,
    required this.onEmojiTap,
    required this.onGifTap,
    required this.onAddTap,
    required this.onSendTap,
    this.onChevronTap,
  });

  @override
  State<AppReplyModal> createState() => _AppReplyModalState();
}

class _AppReplyModalState extends State<AppReplyModal> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // Request focus after modal is built
    Future.microtask(() => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppInputModal(
      children: [
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              if (widget.event is! ChatMessage)
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppProfilePic.s40(
                          widget.event.author.value?.pictureUrl ?? '',
                        ),
                        const AppGap.s12(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AppEmojiImage(
                                    emojiUrl:
                                        'assets/emoji/${getEventContentType(widget.event)}.png',
                                    emojiName:
                                        getEventContentType(widget.event),
                                    size: 16,
                                  ),
                                  const AppGap.s10(),
                                  Expanded(
                                    child: AppCompactTextRenderer(
                                      content:
                                          getEventDisplayText(widget.event),
                                      onResolveEvent: widget.onResolveEvent,
                                      onResolveProfile: widget.onResolveProfile,
                                      onResolveEmoji: widget.onResolveEmoji,
                                      isWhite: true,
                                      isMedium: true,
                                    ),
                                  ),
                                ],
                              ),
                              const AppGap.s2(),
                              AppText.reg12(
                                widget.event.author.value?.name ??
                                    formatNpub(
                                        widget.event.author.value?.pubkey ??
                                            ''),
                                color: theme.colors.white66,
                              ),
                            ],
                          ),
                        ),
                        const AppGap.s8(),
                      ],
                    ),
                    Row(
                      children: [
                        AppContainer(
                          width: theme.sizes.s38,
                          child: Center(
                            child: AppContainer(
                              decoration:
                                  BoxDecoration(color: theme.colors.white33),
                              width: LineThicknessData.normal().medium,
                              height: theme.sizes.s16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              if (widget.event is ChatMessage)
                Row(children: [
                  AppContainer(
                    width: theme.sizes.s38,
                    child: Center(
                      child: AppContainer(
                        decoration: BoxDecoration(color: theme.colors.white33),
                        width: LineThicknessData.normal().medium,
                        height: theme.sizes.s16,
                      ),
                    ),
                  ),
                ]),
              AppShortTextField(
                controller: _controller,
                focusNode: _focusNode,
                placeholder: [
                  AppText.reg16(
                    'Your Reply',
                    color: theme.colors.white33,
                  ),
                ],
                quotedChatMessage: widget.event is ChatMessage
                    ? (widget.event as ChatMessage)
                    : null,
                onSearchProfiles: widget.onSearchProfiles,
                onSearchEmojis: widget.onSearchEmojis,
                onResolveEvent: widget.onResolveEvent,
                onResolveProfile: widget.onResolveProfile,
                onResolveEmoji: widget.onResolveEmoji,
                onCameraTap: widget.onCameraTap,
                onEmojiTap: widget.onEmojiTap,
                onGifTap: widget.onGifTap,
                onAddTap: widget.onAddTap,
                onSendTap: widget.onSendTap,
                onChevronTap: widget.onChevronTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
