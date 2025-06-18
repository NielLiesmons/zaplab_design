import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class LabZapPill extends StatelessWidget {
  final Zap zap;
  final VoidCallback onTap;
  final bool isOutgoing;

  const LabZapPill({
    super.key,
    required this.zap,
    required this.onTap,
    this.isOutgoing = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final isInsideModal = ModalScope.of(context);
    final isInsideScope = LabScope.of(context);
    final (isInsideMessageBubble, _) = MessageBubbleScope.of(context);

    return TapBuilder(
      onTap: onTap,
      builder: (BuildContext context, TapState state, bool isFocused) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.98;
        } else if (state == TapState.hover) {
          scaleFactor = 1.04;
        }

        return AnimatedScale(
          scale: scaleFactor,
          duration: LabDurationsData.normal().fast,
          curve: Curves.easeInOut,
          child: LabContainer(
            decoration: BoxDecoration(
              color: isOutgoing
                  ? null
                  : (isInsideModal || isInsideScope)
                      ? theme.colors.white8
                      : isInsideMessageBubble
                          ? theme.colors.white16
                          : theme.colors.gray66,
              gradient: isOutgoing ? theme.colors.gold : null,
              borderRadius: BorderRadius.all(theme.radius.rad16),
            ),
            padding: const LabEdgeInsets.only(
              left: LabGapSize.s8,
              right: LabGapSize.s4,
              top: LabGapSize.s4,
              bottom: LabGapSize.s4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LabIcon.s12(
                      theme.icons.characters.zap,
                      color: isOutgoing
                          ? LabColorsData.dark().black
                          : theme.colors.white66,
                    ),
                    const LabGap.s4(),
                    LabAmount(
                      zap.amount.toDouble(),
                      level: LabTextLevel.med12,
                      color: isOutgoing
                          ? LabColorsData.dark().black
                          : theme.colors.white66,
                    ),
                  ],
                ),
                const LabGap.s6(),
                LabProfilePic.s18(zap.author.value),
              ],
            ),
          ),
        );
      },
    );
  }
}
