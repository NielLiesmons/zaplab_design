import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

typedef ZapResult = ({double amount, String message});

class AppZapModal extends StatefulWidget {
  final Event event;
  final List<({double amount, String profileImageUrl})> otherZaps;
  final List<double> recentAmounts;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrProfileSearch onSearchProfiles;
  final NostrEmojiSearch onSearchEmojis;
  final VoidCallback onCameraTap;
  final VoidCallback onEmojiTap;
  final VoidCallback onGifTap;
  final VoidCallback onAddTap;

  const AppZapModal({
    super.key,
    required this.event,
    this.otherZaps = const [],
    this.recentAmounts = const [],
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onSearchProfiles,
    required this.onSearchEmojis,
    required this.onCameraTap,
    required this.onEmojiTap,
    required this.onGifTap,
    required this.onAddTap,
  });

  static Future<({double amount, String message})?> show(
    BuildContext context, {
    required Event event,
    List<({double amount, String profileImageUrl})> otherZaps = const [],
    List<double> recentAmounts = const [],
    required NostrEventResolver onResolveEvent,
    required NostrProfileResolver onResolveProfile,
    required NostrEmojiResolver onResolveEmoji,
    required NostrProfileSearch onSearchProfiles,
    required NostrEmojiSearch onSearchEmojis,
    required VoidCallback onCameraTap,
    required VoidCallback onEmojiTap,
    required VoidCallback onGifTap,
    required VoidCallback onAddTap,
  }) {
    double amount = recentAmounts.isNotEmpty ? recentAmounts.first : 100;
    String message = '';

    return AppModal.show<({double amount, String message})>(
      context,
      title: 'Zap',
      description:
          "${event.author.value?.name}'s ${getEventContentType(event) == 'chat' ? 'Message' : getEventContentType(event)[0].toUpperCase() + getEventContentType(event).substring(1)}",
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
                    profileImageUrl: event.author.value?.pictureUrl ?? '',
                    recentAmounts: recentAmounts,
                    onValueChanged: (value) {
                      setState(() => amount = value);
                    },
                    onResolveEvent: onResolveEvent,
                    onResolveProfile: onResolveProfile,
                    onResolveEmoji: onResolveEmoji,
                    onSearchProfiles: onSearchProfiles,
                    onSearchEmojis: onSearchEmojis,
                    onCameraTap: onCameraTap,
                    onEmojiTap: onEmojiTap,
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

    return AppModal(
      title: 'Zap',
      description:
          "${widget.event.author.value?.name}'s ${getEventContentType(widget.event) == 'chat' ? 'Message' : getEventContentType(widget.event)[0].toUpperCase() + getEventContentType(widget.event).substring(1)}",
      bottomBar: AppButton(
        onTap: () {
          Navigator.of(context).pop(
            (amount: amount, message: message),
          );
        },
        inactiveGradient: theme.colors.blurple,
        pressedGradient: theme.colors.blurple,
        children: [
          AppText.med16(
            'Zap',
            color: AppColorsData.dark().white,
          ),
        ],
      ),
      children: [
        AppContainer(
          child: Column(
            children: [
              const AppGap.s4(),
              AppZapSlider(
                initialValue: amount,
                otherZaps: widget.otherZaps,
                profileImageUrl: widget.event.author.value?.pictureUrl ?? '',
                recentAmounts: widget.recentAmounts,
                onValueChanged: (value) {
                  setState(() => amount = value);
                },
                onResolveEvent: widget.onResolveEvent,
                onResolveProfile: widget.onResolveProfile,
                onResolveEmoji: widget.onResolveEmoji,
                onSearchProfiles: widget.onSearchProfiles,
                onSearchEmojis: widget.onSearchEmojis,
                onCameraTap: widget.onCameraTap,
                onEmojiTap: widget.onEmojiTap,
                onGifTap: widget.onGifTap,
                onAddTap: widget.onAddTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
