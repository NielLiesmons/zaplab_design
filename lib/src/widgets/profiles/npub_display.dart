import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabNpubDisplay extends StatefulWidget {
  final Profile profile;
  final bool copyable;

  const LabNpubDisplay({
    super.key,
    required this.profile,
    this.copyable = true,
  });

  @override
  State<LabNpubDisplay> createState() => _LabNpubDisplayState();
}

class _LabNpubDisplayState extends State<LabNpubDisplay> {
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
    final theme = LabTheme.of(context);

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LabContainer(
          height: theme.sizes.s8,
          width: theme.sizes.s8,
          decoration: BoxDecoration(
            color: Color(profileToColor(widget.profile)),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: theme.colors.white16,
              width: LabLineThicknessData.normal().thin,
            ),
          ),
        ),
        const LabGap.s8(),
        LabText.med12(
          formatNpub(widget.profile.npub),
          color: theme.colors.white66,
        ),
        const SizedBox(width: 8),
        if (_showCheck)
          LabIcon.s8(
            theme.icons.characters.check,
            outlineColor: theme.colors.blurpleLightColor,
            outlineThickness: LabLineThicknessData.normal().medium,
          ),
        if (!_showCheck && widget.copyable)
          LabIcon.s14(
            theme.icons.characters.copy,
            outlineColor: theme.colors.white33,
            outlineThickness: LabLineThicknessData.normal().medium,
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
            LabContainer(
              height: theme.sizes.s8,
              width: theme.sizes.s8,
              decoration: BoxDecoration(
                color: Color(profileToColor(widget.profile)),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: theme.colors.white16,
                  width: LabLineThicknessData.normal().thin,
                ),
              ),
            ),
            const LabGap.s8(),
            LabText.med12(
              formatNpub(widget.profile.npub),
              color: theme.colors.white66,
            ),
            const SizedBox(width: 8),
            if (_showCheck)
              LabIcon.s8(
                theme.icons.characters.check,
                outlineColor: theme.colors.blurpleLightColor,
                outlineThickness: LabLineThicknessData.normal().medium,
              ),
            if (state == TapState.hover && !_showCheck)
              LabIcon.s14(
                theme.icons.characters.copy,
                outlineColor: theme.colors.white33,
                outlineThickness: LabLineThicknessData.normal().medium,
              ),
          ],
        );
      },
    );
  }
}
