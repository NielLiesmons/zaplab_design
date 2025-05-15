import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';

class AppModelButton extends StatelessWidget {
  final Model? model;
  final VoidCallback? onTap;

  const AppModelButton({
    super.key,
    required this.model,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final contentType = getModelContentType(model);
    final displayText = getModelDisplayText(model);

    return TapBuilder(
      onTap: onTap,
      builder: (context, state, hasFocus) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.99;
        } else if (state == TapState.hover) {
          scaleFactor = 1.01;
        }

        return Transform.scale(
          scale: scaleFactor,
          child: AppContainer(
            constraints: const BoxConstraints(
              maxWidth: 180,
            ),
            padding: const AppEdgeInsets.symmetric(
              horizontal: AppGapSize.s8,
              vertical: AppGapSize.s6,
            ),
            decoration: BoxDecoration(
              color: theme.colors.gray66,
              borderRadius: theme.radius.asBorderRadius().rad8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppEmojiContentType(
                  contentType: contentType,
                  size: 16,
                  opacity: 0.66,
                ),
                const AppGap.s8(),
                Flexible(
                  child: AppText.reg12(
                    displayText,
                    color: theme.colors.white66,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}




// AppModelButton