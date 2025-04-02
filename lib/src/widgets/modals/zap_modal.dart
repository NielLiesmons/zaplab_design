import 'package:zaplab_design/zaplab_design.dart';

typedef ZapResult = ({double amount, String message});

class AppZapModal extends StatefulWidget {
  final String profileName;
  final String contentType;
  final String profileImageUrl;
  final List<({double amount, String profileImageUrl})> otherZaps;
  final List<double> recentAmounts;
  final NostrProfileSearch onSearchProfiles;
  final NostrEmojiSearch onSearchEmojis;
  final VoidCallback onCameraTap;
  final VoidCallback onGifTap;
  final VoidCallback onAddTap;

  const AppZapModal({
    super.key,
    required this.profileName,
    required this.contentType,
    required this.profileImageUrl,
    this.otherZaps = const [],
    this.recentAmounts = const [],
    required this.onSearchProfiles,
    required this.onSearchEmojis,
    required this.onCameraTap,
    required this.onGifTap,
    required this.onAddTap,
  });

  static Future<({double amount, String message})?> show(
    BuildContext context, {
    required String profileName,
    required String contentType,
    required String profileImageUrl,
    List<({double amount, String profileImageUrl})> otherZaps = const [],
    List<double> recentAmounts = const [],
    required NostrProfileSearch onSearchProfiles,
    required NostrEmojiSearch onSearchEmojis,
    required VoidCallback onCameraTap,
    required VoidCallback onGifTap,
    required VoidCallback onAddTap,
  }) {
    double amount = recentAmounts.isNotEmpty ? recentAmounts.first : 100;
    String message = '';

    return AppModal.show<({double amount, String message})>(
      context,
      title: 'Zap',
      description: "$profileName's $contentType",
      children: [
        StatefulBuilder(
          builder: (context, setState) {
            return AppContainer(
              child: Column(
                children: [
                  const AppGap.s4(),
                  AppZapSlider(
                    initialValue: amount,
                    otherZaps: otherZaps,
                    profileImageUrl: profileImageUrl,
                    recentAmounts: recentAmounts,
                    onValueChanged: (value) {
                      setState(() => amount = value);
                    },
                    onSearchProfiles: onSearchProfiles,
                    onSearchEmojis: onSearchEmojis,
                    onCameraTap: onCameraTap,
                    onGifTap: onGifTap,
                    onAddTap: onAddTap,
                  ),
                ],
              ),
            );
          },
        ),
      ],
      bottomBar: AppButton(
        children: [
          AppText.med16(
            'Zap',
            color: AppColorsData.dark().white,
          ),
        ],
        onTap: () => Navigator.of(context).pop(
          (amount: amount, message: message),
        ),
        inactiveGradient: AppTheme.of(context).colors.blurple,
        pressedGradient: AppTheme.of(context).colors.blurple,
      ),
    );
  }

  @override
  State<AppZapModal> createState() => _AppZapModalState();
}

class _AppZapModalState extends State<AppZapModal> {
  late double amount;
  late String message;

  @override
  void initState() {
    super.initState();
    amount = widget.recentAmounts.isNotEmpty ? widget.recentAmounts.first : 100;
    message = '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      child: Column(
        children: [
          const AppGap.s4(),
          AppZapSlider(
            initialValue: amount,
            otherZaps: widget.otherZaps,
            profileImageUrl: widget.profileImageUrl,
            recentAmounts: widget.recentAmounts,
            onValueChanged: (value) {
              setState(() => amount = value);
            },
            onSearchProfiles: widget.onSearchProfiles,
            onSearchEmojis: widget.onSearchEmojis,
            onCameraTap: widget.onCameraTap,
            onGifTap: widget.onGifTap,
            onAddTap: widget.onAddTap,
          ),
          const AppGap.s16(),
          AppButton(
            children: [
              AppText.med16(
                'Zap',
                color: AppColorsData.dark().white,
              ),
            ],
            onTap: () {
              Navigator.of(context).pop(
                (amount: amount, message: message),
              );
            },
            inactiveGradient: theme.colors.blurple,
            pressedGradient: theme.colors.blurple,
          ),
        ],
      ),
    );
  }
}
