import 'package:flutter/gestures.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppSpinUpKeyAgainModal extends StatelessWidget {
  final String profileName;
  final String? initialNsec;
  final VoidCallback? onSecretKeyTap;

  const AppSpinUpKeyAgainModal({
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
              const AppGap.s24(),
              AppSlotMachine(initialNsec: initialNsec),
              const AppGap.s16(),
              AppContainer(
                width: 344,
                child: Column(
                  children: [
                    AppPanel(
                      child: Row(
                        children: [
                          AppProfilePic.s48("profilePicUrl"),
                          const AppGap.s8(),
                          AppText.h1("Hey $profileName!"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
