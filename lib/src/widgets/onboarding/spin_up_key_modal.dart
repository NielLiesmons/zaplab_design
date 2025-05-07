import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter/gestures.dart';

class AppSpinUpKeyModal extends StatefulWidget {
  final String profileName;
  final VoidCallback? onSecretKeyTap;
  final int spinCompleteDelay;
  final void Function(String secretKey, String profileName) onSpinComplete;

  const AppSpinUpKeyModal({
    super.key,
    required this.profileName,
    required this.onSpinComplete,
    this.onSecretKeyTap,
    this.spinCompleteDelay = 1000,
  });

  @override
  _SpinUpKeyModalState createState() => _SpinUpKeyModalState();
}

class _SpinUpKeyModalState extends State<AppSpinUpKeyModal> {
  String? _secretKey;

  void _handleSpinComplete(String secretKey, String mode) {
    setState(() {
      _secretKey = secretKey;
    });

    Future.delayed(Duration(milliseconds: widget.spinCompleteDelay), () {
      if (mounted) {
        widget.onSpinComplete(secretKey, widget.profileName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppModal(
      children: [
        AppContainer(
          child: Column(
            children: [
              const AppGap.s12(),
              AppText.h1(
                "Hey ${widget.profileName}!",
                color: AppTheme.of(context).colors.white,
              ),
              const AppGap.s8(),
              AppContainer(
                width: 344,
                child: RichText(
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
                          ..onTap = widget.onSecretKeyTap ?? () {},
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
              ),
              const AppGap.s24(),
              AppSlotMachine(
                showSelector: false,
                onSpinComplete: _handleSpinComplete,
              ),
              const AppGap.s32(),
              AppButton(
                onTap: widget.onSecretKeyTap,
                inactiveColor: theme.colors.black33,
                children: [
                  AppIcon.s16(
                    theme.icons.characters.nostr,
                    color: AppColorsData.dark().blurpleLightColor,
                  ),
                  const AppGap.s12(),
                  AppText.reg14("Already have a Nostr key?",
                      color: theme.colors.white66),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
