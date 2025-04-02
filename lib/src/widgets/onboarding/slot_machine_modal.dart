import 'package:flutter/gestures.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppSlotMachineModal extends StatelessWidget {
  final String profileName;
  final VoidCallback? onSecretKeyTap;

  const AppSlotMachineModal({
    super.key,
    required this.profileName,
    this.onSecretKeyTap,
  });

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
        AppSlotMachine(),
        const AppGap.s32(),
        AppContainer(
          width: 344,
          child: AppSelector(
            children: [
              AppSelectorButton(
                selectedContent: [
                  AppText.reg14("Emoji"),
                ],
                unselectedContent: [
                  AppText.reg14("Emoji", color: theme.colors.white66),
                ],
                isSelected: false,
                onTap: () => (),
              ),
              AppSelectorButton(
                selectedContent: [
                  AppText.reg14("Nsec"),
                ],
                unselectedContent: [
                  AppText.reg14("Nsec", color: theme.colors.white66),
                ],
                isSelected: false,
                onTap: () => (),
              ),
              AppSelectorButton(
                selectedContent: [
                  AppText.reg14("Words"),
                ],
                unselectedContent: [
                  AppText.reg14("Words", color: theme.colors.white66),
                ],
                isSelected: false,
                onTap: () => (),
              ),
            ],
          ),
        ),
        const AppGap.s16(),
      ],
    );
  }
}
