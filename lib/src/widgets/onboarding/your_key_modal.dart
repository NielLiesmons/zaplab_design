import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter/gestures.dart';
import 'package:zaplab_design/src/utils/key_generator.dart';
import 'package:zaplab_design/src/utils/npub_color.dart';
import 'package:zaplab_design/src/widgets/keys/key_display.dart';
import 'package:models/models.dart';

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
    final npub = AppKeyGenerator.nsecToNpub(secretKey);
    final mnemonic = AppKeyGenerator.nsecToMnemonic(secretKey) ?? '';

    return AppModal(
      topBar: AppContainer(
        padding: const AppEdgeInsets.all(AppGapSize.s12),
        child: AppText.med16("Your Key", color: theme.colors.white),
      ),
      bottomBar: Row(
        children: [
          AppButton(
            inactiveColor: theme.colors.black33,
            onTap: onUSpinAgain,
            children: [
              AppText.reg14(
                "Spin Again",
                color: theme.colors.white66,
              ),
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
      children: [
        AppContainer(
          width: double.infinity,
          child: Column(
            children: [
              const AppGap.s8(),
              AppText.h1(
                "Hooray!",
                color: theme.colors.white,
              ),
              const AppGap.s12(),
              AppContainer(
                width: 344,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "You generated an uncrackable ",
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
            ],
          ),
        ),
        const AppGap.s16(),
        AppKeyDisplay(
          secretKey: secretKey,
          mnemonic: mnemonic,
        ),
        const AppGap.s16(),
        AppContainer(
          width: 344,
          child: AppText.reg12(
            "A secret key (Nsec) can be displayed and stored in multiple ways: 12 emoji, 12 words on a piece of paper, or as a text string (Nsec) in a password manager.",
            color: theme.colors.white33,
            textAlign: TextAlign.center,
          ),
        ),
        const AppGap.s16(),
        AppContainer(
          width: 344,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "It comes with a unique ",
                  style: AppTheme.of(context).typography.reg16.copyWith(
                        color: AppTheme.of(context).colors.white66,
                      ),
                ),
                TextSpan(
                  text: "Public Identifier",
                  style: AppTheme.of(context).typography.reg16.copyWith(
                        color: AppTheme.of(context).colors.white66,
                        decoration: TextDecoration.underline,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = onSecretKeyTap ?? () {},
                ),
                TextSpan(
                  text: ":",
                  style: AppTheme.of(context).typography.reg16.copyWith(
                        color: AppTheme.of(context).colors.white66,
                      ),
                ),
              ],
            ),
          ),
        ),
        const AppGap.s16(),
        AppContainer(
          padding: AppEdgeInsets.all(AppGapSize.s12),
          width: 316,
          decoration: BoxDecoration(
            color: theme.colors.white8,
            borderRadius: theme.radius.asBorderRadius().rad24,
          ),
          child: Row(
            children: [
              AppProfilePic.s56(
                PartialProfile(
                  name: profileName,
                ).dummySign(npubToHex(npub)),
              ),
              const AppGap.s12(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.bold16(profileName),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppContainer(
                        height: theme.sizes.s12,
                        width: theme.sizes.s12,
                        margin: const AppEdgeInsets.only(top: AppGapSize.s2),
                        decoration: BoxDecoration(
                          color: Color(npubToColor(npub)),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: theme.colors.white16,
                            width: AppLineThicknessData.normal().thin,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colors.black33,
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                      const AppGap.s8(),
                      AppText.reg16(
                        formatNpub(npub),
                        color: theme.colors.white66,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const AppGap.s16(),
        AppContainer(
          width: 344,
          child: AppText.reg12(
            "Your Public identifier (Npub) is how people can identify you and is the ID that, unlike your Seceret Key (Nsec), you can share publicly.",
            color: theme.colors.white33,
            textAlign: TextAlign.center,
          ),
        ),
        const AppGap.s16(),
        AppContainer(
          width: 344,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  style: AppTheme.of(context).typography.reg16.copyWith(
                        color: AppTheme.of(context).colors.white66,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
