import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

typedef ZapResult = ({double amount, String message});

class LabZapModal extends StatefulWidget {
  final Model model;
  final List<({double amount, Profile profile})> otherZaps;
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
  final Function(Profile) onProfileTap;

  const LabZapModal({
    super.key,
    required this.model,
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
    required this.onProfileTap,
  });

  static Future<({double amount, String message})?> show(
    BuildContext context, {
    required Model model,
    List<({double amount, Profile profile})> otherZaps = const [],
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
    required Function(Profile) onProfileTap,
  }) {
    double amount = recentAmounts.isNotEmpty ? recentAmounts.first : 100;
    String message = '';

    return LabModal.show<({double amount, String message})>(
      context,
      title: 'Zap',
      description: "${model.author.value?.name}'s ${getModelName(model)}",
      children: [
        StatefulBuilder(
          builder: (context, setState) {
            return LabContainer(
              child: Column(
                children: [
                  const LabGap.s4(),
                  LabZapSlider(
                    initialValue: amount,
                    otherZaps: otherZaps,
                    profile: model.author.value,
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
                    onProfileTap: onProfileTap,
                  ),
                ],
              ),
            );
          },
        ),
      ],
      bottomBar: LabButton(
        children: [
          LabText.med16(
            'Zap',
            color: LabTheme.of(context).colors.whiteEnforced,
          ),
        ],
        onTap: () => Navigator.of(context).pop(
          (amount: amount, message: message),
        ),
        gradient: LabTheme.of(context).colors.blurple,
        pressedGradient: LabTheme.of(context).colors.blurple,
      ),
    );
  }

  @override
  State<LabZapModal> createState() => _LabZapModalState();
}

class _LabZapModalState extends State<LabZapModal> {
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
    final theme = LabTheme.of(context);

    return LabModal(
      title: 'Zap',
      description:
          "${widget.model.author.value?.name}'s ${getModelContentType(widget.model) == 'chat' ? 'Message' : getModelContentType(widget.model)[0].toUpperCase() + getModelContentType(widget.model).substring(1)}",
      bottomBar: LabButton(
        onTap: () {
          Navigator.of(context).pop(
            (amount: amount, message: message),
          );
        },
        gradient: theme.colors.blurple,
        pressedGradient: theme.colors.blurple,
        children: [
          LabText.med16(
            'Zap',
            color: theme.colors.whiteEnforced,
          ),
        ],
      ),
      children: [
        LabContainer(
          child: Column(
            children: [
              const LabGap.s4(),
              LabZapSlider(
                initialValue: amount,
                otherZaps: widget.otherZaps,
                profile: widget.model.author.value,
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
                onProfileTap: widget.onProfileTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
