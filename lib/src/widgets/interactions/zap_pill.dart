import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class AppZapPill extends StatelessWidget {
  final Zap zap;
  final VoidCallback onTap;
  final bool isOutgoing;

  const AppZapPill({
    super.key,
    required this.zap,
    required this.onTap,
    this.isOutgoing = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isInsideModal = ModalScope.of(context);
    final isInsideScope = AppScope.of(context);
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
          duration: AppDurationsData.normal().fast,
          curve: Curves.easeInOut,
          child: AppContainer(
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
            padding: const AppEdgeInsets.only(
              left: AppGapSize.s8,
              right: AppGapSize.s4,
              top: AppGapSize.s4,
              bottom: AppGapSize.s4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcon.s12(
                      theme.icons.characters.zap,
                      color: isOutgoing
                          ? AppColorsData.dark().black
                          : theme.colors.white66,
                    ),
                    const AppGap.s4(),
                    AppAmount(
                      zap.amount.toDouble(),
                      level: AppTextLevel.med12,
                      color: isOutgoing
                          ? AppColorsData.dark().black
                          : theme.colors.white66,
                    ),
                  ],
                ),
                const AppGap.s6(),
                AppProfilePic.s18(zap.author.value?.pictureUrl ?? ''),
              ],
            ),
          ),
        );
      },
    );
  }
}
