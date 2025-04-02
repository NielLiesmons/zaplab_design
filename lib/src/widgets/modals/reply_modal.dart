import 'package:zaplab_design/zaplab_design.dart';

class AppReplyModal extends StatefulWidget {
  final String nevent;
  final String contentType;
  final String profileName;
  final String profilePicUrl;
  final String? message;
  final String? title;
  final String? imageUrl;
  final NostrProfileSearch onSearchProfiles;
  final NostrEmojiSearch onSearchEmojis;
  final VoidCallback onCameraTap;
  final VoidCallback onGifTap;
  final VoidCallback onAddTap;
  final VoidCallback onSendTap;
  final VoidCallback? onChevronTap;

  const AppReplyModal({
    super.key,
    required this.nevent,
    required this.contentType,
    required this.profileName,
    required this.profilePicUrl,
    this.message,
    this.title,
    this.imageUrl,
    required this.onSearchProfiles,
    required this.onSearchEmojis,
    required this.onCameraTap,
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
              if (widget.contentType != 'message')
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppProfilePic.s40(widget.profilePicUrl),
                    const AppGap.s12(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppEmojiImage(
                                emojiUrl:
                                    'assets/emoji/${widget.contentType}.png',
                                emojiName: widget.contentType,
                                size: 16,
                              ),
                              const AppGap.s10(),
                              Expanded(
                                child: AppText.reg14(
                                  widget.title ?? widget.message ?? '',
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const AppGap.s2(),
                          AppText.reg12(
                            widget.profileName,
                            color: theme.colors.white66,
                          ),
                        ],
                      ),
                    ),
                    const AppGap.s8(),
                  ],
                ),
              if (widget.contentType != 'message')
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
                quotedMessage: widget.contentType == 'message'
                    ? Message(
                        nevent: widget.nevent,
                        npub: 'npub1test', // TODO: connect this
                        timestamp: DateTime.now(), // TODO: connect this
                        profileName: widget.profileName,
                        profilePicUrl: widget.profilePicUrl,
                        message: widget.message!,
                      )
                    : null,
                onSearchProfiles: widget.onSearchProfiles,
                onSearchEmojis: widget.onSearchEmojis,
                onCameraTap: widget.onCameraTap,
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
