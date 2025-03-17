import 'package:zaplab_design/zaplab_design.dart';

typedef ZapResult = ({double amount, String message});

class AppZapModal extends StatefulWidget {
  const AppZapModal({super.key});

  @override
  State<AppZapModal> createState() => _AppZapModalState();

  static Future<({double amount, String message})?> show(
    BuildContext context, {
    required String profileName,
    required String contentType,
    required String profileImageUrl,
    List<({double amount, String profileImageUrl})> otherZaps = const [],
    List<double> recentAmounts = const [],
    required NostrMentionResolver onResolveMentions,
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
                    onResolveMentions: onResolveMentions,
                  ),
                ],
              ),
            );
          },
        ),
      ],
      bottomBar: AppButton(
        content: [
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
}

class _AppZapModalState extends State<AppZapModal> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
