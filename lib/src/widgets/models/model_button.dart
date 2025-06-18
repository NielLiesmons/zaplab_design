import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';

class LabModelButton extends StatelessWidget {
  final Model? model;
  final VoidCallback? onTap;

  const LabModelButton({
    super.key,
    required this.model,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
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
          child: LabContainer(
            constraints: const BoxConstraints(
              maxWidth: 180,
            ),
            padding: const LabEdgeInsets.symmetric(
              horizontal: LabGapSize.s8,
              vertical: LabGapSize.s6,
            ),
            decoration: BoxDecoration(
              color: theme.colors.gray66,
              borderRadius: theme.radius.asBorderRadius().rad8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LabEmojiContentType(
                  contentType: contentType,
                  size: 16,
                  opacity: 0.66,
                ),
                const LabGap.s8(),
                Flexible(
                  child: LabText.reg12(
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




// LabModelButton