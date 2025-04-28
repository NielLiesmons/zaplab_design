import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppNpubDisplay extends StatefulWidget {
  final Profile profile;

  const AppNpubDisplay({
    super.key,
    required this.profile,
  });

  @override
  State<AppNpubDisplay> createState() => _AppNpubDisplayState();
}

class _AppNpubDisplayState extends State<AppNpubDisplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _showCheck = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1234),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showCheck = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await Clipboard.setData(ClipboardData(text: widget.profile.npub));
    setState(() => _showCheck = true);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
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
                color: Color(
                  int.parse(
                        profileToColor(widget.profile).substring(1),
                        radix: 16,
                      ) +
                      0xFF000000,
                ),
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
