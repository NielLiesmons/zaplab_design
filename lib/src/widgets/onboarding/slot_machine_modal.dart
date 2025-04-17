import 'package:flutter/gestures.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppSlotMachineModal extends StatelessWidget {
  final String profileName;
  final String? initialNsec;
  final VoidCallback? onSecretKeyTap;

  const AppSlotMachineModal({
    super.key,
    required this.profileName,
    this.initialNsec,
    this.onSecretKeyTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppModal(
      children: [
        AppContainer(
          child: Column(
            children: [
              const AppGap.s12(),
              AppText.h1(
                "Hey $profileName!",
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
          ),
        ),
      ],
    );
  }
}
