import 'package:zaplab_design/zaplab_design.dart';

class AppWelcomeModal extends StatefulWidget {
  final String logoImageUrl;
  final String title;
  final void Function(String profileName) onStart;
  final VoidCallback onAlreadyHaveKey;

  const AppWelcomeModal({
    super.key,
    required this.logoImageUrl,
    required this.title,
    required this.onStart,
    required this.onAlreadyHaveKey,
  });

  @override
  State<AppWelcomeModal> createState() => _AppWelcomeModalState();
}

class _AppWelcomeModalState extends State<AppWelcomeModal> {
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
              const AppGap.s12(),
              Image(
                image: AssetImage(widget.logoImageUrl),
                width: 80,
                height: 80,
              ),
              const AppGap.s12(),
              AppText.h1(widget.title),
              const AppGap.s24(),
              Row(
                children: [
                  const AppGap.s16(),
                  AppText.reg14("Choose a Profile Name",
                      color: theme.colors.white),
                  const AppGap.s12(),
                ],
              ),
              const AppGap.s8(),
              AppInputTextField(
                controller: _controller,
                focusNode: _focusNode,
                placeholder: [
                  AppText.reg16(
                    'Profile Name',
                    color: theme.colors.white33,
                  ),
                ],
              ),
              const AppGap.s16(),
              AppButton(
                onTap: () {
                  if (_controller.text.isNotEmpty) {
                    widget.onStart(_controller.text);
                  }
                },
                children: [
                  AppIcon.s12(
                    theme.icons.characters.play,
                    color: AppColorsData.dark().white,
                  ),
                  const AppGap.s12(),
                  AppText.med14("Start", color: AppColorsData.dark().white),
                ],
              ),
              const AppGap.s16(),
              AppButton(
                onTap: widget.onAlreadyHaveKey,
                inactiveColor: theme.colors.black33,
                children: [
                  AppIcon.s16(
                    theme.icons.characters.nostr,
                    color: AppColorsData.dark().blurpleColor,
                  ),
                  const AppGap.s12(),
                  AppText.reg14("Already have a Nostr key?",
                      color: theme.colors.white66),
                ],
              ),
              PlatformUtils.isMobile ? const AppGap.s8() : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
