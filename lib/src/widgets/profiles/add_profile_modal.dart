import 'package:zaplab_design/zaplab_design.dart';

class AppAddProfileModal extends StatefulWidget {
  final void Function(String profileName) onStart;
  final VoidCallback onAlreadyHaveKey;

  const AppAddProfileModal({
    super.key,
    required this.onStart,
    required this.onAlreadyHaveKey,
  });

  @override
  State<AppAddProfileModal> createState() => _AppAddProfileModalState();
}

class _AppAddProfileModalState extends State<AppAddProfileModal> {
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
              const AppText.h1("Add Profile"),
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
                    color: theme.colors.whiteEnforced,
                  ),
                  const AppGap.s12(),
                  AppText.med14("Start", color: theme.colors.whiteEnforced),
                ],
              ),
              const AppGap.s16(),
              AppButton(
                onTap: widget.onAlreadyHaveKey,
                inactiveColor: theme.colors.black33,
                children: [
                  AppIcon.s16(
                    theme.icons.characters.nostr,
                    color: AppColorsData.dark().blurpleLightColor,
                  ),
                  const AppGap.s12(),
                  AppText.reg14("Already have a Nostr key?",
                      color: theme.colors.white66),
                ],
              ),
              AppPlatformUtils.isMobile ? const AppGap.s8() : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
