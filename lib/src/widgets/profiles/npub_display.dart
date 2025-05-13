import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppNpubDisplay extends StatefulWidget {
  final Profile profile;
  final bool copyable;

  const AppNpubDisplay({
    super.key,
    required this.profile,
    this.copyable = true,
  });

  @override
  State<AppNpubDisplay> createState() => _AppNpubDisplayState();
}

class _AppNpubDisplayState extends State<AppNpubDisplay> {
  bool _showCheck = false;

  void _handleTap() {
    final npub = widget.profile.npub;
    if (npub != null) {
      Clipboard.setData(ClipboardData(text: npub));
      setState(() {
        _showCheck = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showCheck = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppContainer(
          height: theme.sizes.s8,
          width: theme.sizes.s8,
          decoration: BoxDecoration(
            color: Color(profileToColor(widget.profile)),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: theme.colors.white16,
              width: AppLineThicknessData.normal().thin,
            ),
          ),
        ),
        const AppGap.s8(),
        AppText.med12(
          formatNpub(widget.profile.npub),
          color: theme.colors.white66,
        ),
        const SizedBox(width: 8),
        if (_showCheck)
          AppIcon.s8(
            theme.icons.characters.check,
            outlineColor: theme.colors.blurpleLightColor,
            outlineThickness: AppLineThicknessData.normal().medium,
          ),
        if (!_showCheck && widget.copyable)
          AppIcon.s14(
            theme.icons.characters.copy,
            outlineColor: theme.colors.white33,
            outlineThickness: AppLineThicknessData.normal().medium,
          ),
      ],
    );

    if (!widget.copyable) {
      return content;
    }

    return TapBuilder(
      onTap: _handleTap,
      builder: (context, state, hasFocus) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppContainer(
              height: theme.sizes.s8,
              width: theme.sizes.s8,
              decoration: BoxDecoration(
                color: Color(profileToColor(widget.profile)),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: theme.colors.white16,
                  width: AppLineThicknessData.normal().thin,
                ),
              ),
            ),
            const AppGap.s8(),
            AppText.med12(
              formatNpub(widget.profile.npub),
              color: theme.colors.white66,
            ),
            const SizedBox(width: 8),
            if (_showCheck)
              AppIcon.s8(
                theme.icons.characters.check,
                outlineColor: theme.colors.blurpleLightColor,
                outlineThickness: AppLineThicknessData.normal().medium,
              ),
            if (state == TapState.hover && !_showCheck)
              AppIcon.s14(
                theme.icons.characters.copy,
                outlineColor: theme.colors.white33,
                outlineThickness: AppLineThicknessData.normal().medium,
              ),
          ],
        );
      },
    );
  }
}
