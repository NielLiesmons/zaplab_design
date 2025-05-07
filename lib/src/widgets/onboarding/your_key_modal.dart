import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter/gestures.dart';

class AppYourKeyModal extends StatelessWidget {
  final String secretKey;
  final String profileName;
  final VoidCallback onUseThisKey;
  final VoidCallback onUSpinAgain;
  final VoidCallback? onSecretKeyTap;

  const AppYourKeyModal({
    super.key,
    required this.secretKey,
    required this.profileName,
    required this.onUseThisKey,
    required this.onUSpinAgain,
    this.onSecretKeyTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppModal(
      bottomBar: AppContainer(
        child: Row(
          children: [
            AppButton(
              onTap: onUSpinAgain,
              inactiveColor: theme.colors.black33,
              children: [
                AppText.med14("Spin Again", color: theme.colors.white66),
              ],
            ),
            const AppGap.s12(),
            Expanded(
              child: AppButton(
                text: "Use This Key",
                onTap: onUseThisKey,
              ),
            ),
          ],
        ),
      ),
      children: [
        AppContainer(
          child: Column(
            children: [
              const AppGap.s12(),
              AppText.h1(
                "Hooray!",
                color: theme.colors.white,
              ),
              const AppGap.s8(),
              AppContainer(
                width: 344,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "You created an uncrackable ",
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
                        text: ".",
                        style: AppTheme.of(context).typography.reg16.copyWith(
                              color: AppTheme.of(context).colors.white66,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const AppGap.s24(),
              AppContainer(
                padding: AppEdgeInsets.all(AppGapSize.s16),
                decoration: BoxDecoration(
                  color: theme.colors.black33,
                  borderRadius: theme.radius.asBorderRadius().rad16,
                ),
                child: AppText.reg14(secretKey),
              ),
              const AppGap.s32(),
            ],
          ),
        ),
      ],
    );
  }
}
