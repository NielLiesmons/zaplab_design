import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class LabHistoryCard extends StatelessWidget {
  final String contentType;
  final String displayText;
  final VoidCallback? onTap;

  const LabHistoryCard({
    super.key,
    required this.contentType,
    required this.displayText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return TapBuilder(
      onTap: onTap,
      builder: (context, state, hasFocus) => LabContainer(
        decoration: BoxDecoration(
          color: theme.colors.white8,
          borderRadius: theme.radius.asBorderRadius().rad12,
        ),
        padding: const LabEdgeInsets.only(
          top: LabGapSize.s10,
          bottom: LabGapSize.s10,
          left: LabGapSize.s12,
          right: LabGapSize.s16,
        ),
        child: Row(
          children: [
            LabEmojiContentType(
                contentType: contentType, size: theme.sizes.s18),
            const LabGap.s10(),
            LabText.reg12(
              contentType,
              color: theme.colors.white66,
            ),
            const LabGap.s10(),
            Expanded(
              child: LabText.reg12(
                displayText,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}





// LabHistoryCard