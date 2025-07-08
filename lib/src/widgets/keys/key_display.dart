import 'package:zaplab_design/zaplab_design.dart';
import 'package:flutter/services.dart';

class LabKeyDisplay extends StatefulWidget {
  final String secretKey;
  final String mnemonic;

  const LabKeyDisplay({
    super.key,
    required this.secretKey,
    required this.mnemonic,
  });

  @override
  State<LabKeyDisplay> createState() => _LabKeyDisplayState();
}

class _LabKeyDisplayState extends State<LabKeyDisplay>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0; // 0: Emoji, 1: Words, 2: Nsec
  bool _copied = false;
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.secretKey));
    setState(() => _copied = true);
    _scaleController.forward();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copied = false);
        _scaleController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final emojis = LabKeyGenerator.nsecToEmojis(widget.secretKey) ?? [];

    Widget content;
    if (_selectedIndex == 0) {
      // Emoji view
      content = Wrap(
        spacing: theme.sizes.s10,
        runSpacing: theme.sizes.s10,
        children: [
          for (var emoji in emojis)
            LabContainer(
              width: 66,
              height: 48,
              padding: const LabEdgeInsets.only(
                top: LabGapSize.s2,
              ),
              decoration: BoxDecoration(
                color: theme.colors.black33,
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: Center(
                child: LabText.h1(emoji),
              ),
            ),
        ],
      );
    } else if (_selectedIndex == 1) {
      // Words view
      final words = widget.mnemonic.split(' ');
      content = Wrap(
        spacing: theme.sizes.s10,
        runSpacing: theme.sizes.s10,
        children: [
          for (var word in words)
            LabContainer(
              width: 66,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colors.black33,
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: Center(
                child: LabText.med12(
                  word,
                  gradient: theme.colors.graydient,
                ),
              ),
            ),
        ],
      );
    } else {
      // Nsec view
      content = LabContainer(
        width: double.infinity,
        height: 164,
        padding: const LabEdgeInsets.only(
          left: LabGapSize.s16,
          right: LabGapSize.s16,
          top: LabGapSize.s10,
          bottom: LabGapSize.s16,
        ),
        decoration: BoxDecoration(
          color: theme.colors.black33,
          borderRadius: theme.radius.asBorderRadius().rad16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            LabText.reg16(
              widget.secretKey,
              gradient: theme.colors.graydient,
            ),
            const Spacer(),
            LabSmallButton(
              color: theme.colors.white8,
              onTap: _copyToClipboard,
              children: [
                if (_copied)
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LabIcon.s10(
                          theme.icons.characters.check,
                          outlineColor: theme.colors.white66,
                          outlineThickness:
                              LabLineThicknessData.normal().medium,
                        ),
                        const LabGap.s6(),
                        LabText.reg12(
                          'Copied!',
                          color: theme.colors.white66,
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LabIcon(
                        theme.icons.characters.copy,
                        outlineColor: theme.colors.white66,
                        outlineThickness: LabLineThicknessData.normal().medium,
                      ),
                      const LabGap.s8(),
                      LabText.med12(
                        "Copy",
                        color: theme.colors.white66,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      );
    }

    return LabContainer(
      padding: LabEdgeInsets.all(LabGapSize.s12),
      width: 318,
      height: 244,
      decoration: BoxDecoration(
        color: theme.colors.white8,
        borderRadius: theme.radius.asBorderRadius().rad24,
      ),
      child: Column(
        children: [
          content,
          const Spacer(),
          LabSelector(
            initialIndex: _selectedIndex,
            small: true,
            onChanged: (index) => setState(() => _selectedIndex = index),
            children: [
              LabSelectorButton(
                selectedContent: const [
                  LabText.reg14("Emoji"),
                ],
                unselectedContent: [
                  LabText.reg14("Emoji", color: theme.colors.white66),
                ],
                isSelected: _selectedIndex == 0,
              ),
              LabSelectorButton(
                selectedContent: const [
                  LabText.reg14("Words"),
                ],
                unselectedContent: [
                  LabText.reg14("Words", color: theme.colors.white66),
                ],
                isSelected: _selectedIndex == 1,
              ),
              LabSelectorButton(
                selectedContent: const [
                  LabText.reg14("Nsec"),
                ],
                unselectedContent: [
                  LabText.reg14("Nsec", color: theme.colors.white66),
                ],
                isSelected: _selectedIndex == 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// LabKeyDisplay