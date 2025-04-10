import 'package:flutter/gestures.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppSlotMachineModal extends StatelessWidget {
  final String profileName;
  final VoidCallback? onSecretKeyTap;
  final String? initialNsec;

  const AppSlotMachineModal({
    super.key,
    required this.profileName,
    this.onSecretKeyTap,
    this.initialNsec,
  });

  static Future<void> show(
    BuildContext context, {
    required String profileName,
    String? initialNsec,
    VoidCallback? onSecretKeyTap,
  }) {
    return AppModal.show(
      context,
      children: [
        const AppGap.s12(),
        AppText.h1(
          "GM $profileName!",
          color: AppTheme.of(context).colors.white,
        ),
        const AppGap.s8(),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "Spin up a ",
                style: AppTheme.of(context).typography.reg16.copyWith(
                      color: AppTheme.of(context).colors.white66,
                    ),
              ),
              TextSpan(
                text: "secret key",
                style: AppTheme.of(context).typography.reg16.copyWith(
                      color: AppTheme.of(context).colors.white66,
                      decoration: TextDecoration.underline,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap = onSecretKeyTap ?? () {},
              ),
              TextSpan(
                text: " to secure your profile, publications and money",
                style: AppTheme.of(context).typography.reg16.copyWith(
                      color: AppTheme.of(context).colors.white66,
                    ),
              ),
            ],
          ),
        ),
        const AppGap.s32(),
        AppSlotMachine(initialNsec: initialNsec),
        const AppGap.s16(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppModal(
      children: [
        const AppGap.s12(),
        AppText.h1(
          "Hey $profileName!",
          color: theme.colors.white,
        ),
        const AppGap.s8(),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "Spin up a ",
                style: theme.typography.reg16.copyWith(
                  color: theme.colors.white66,
                ),
              ),
              TextSpan(
                text: "secret key",
                style: theme.typography.reg16.copyWith(
                  color: theme.colors.white66,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = onSecretKeyTap ?? () {},
              ),
              TextSpan(
                text: " to secure your profile, publications and money",
                style: theme.typography.reg16.copyWith(
                  color: theme.colors.white66,
                ),
              ),
            ],
          ),
        ),
        const AppGap.s32(),
        AppSlotMachine(initialNsec: initialNsec),
        const AppGap.s16(),
      ],
    );
  }
}
