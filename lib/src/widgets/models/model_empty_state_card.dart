import 'package:zaplab_design/zaplab_design.dart';

class LabModelEmptyStateCard extends StatelessWidget {
  final String contentType;
  final VoidCallback onCreateTap;

  const LabModelEmptyStateCard({
    super.key,
    required this.contentType,
    required this.onCreateTap,
  });

  final double minWidth = 280;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    return LabPanelButton(
      onTap: onCreateTap,
      color: theme.colors.gray33,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LabGap.s16(),
          LabEmojiContentType(
            contentType: contentType,
            size: theme.sizes.s64,
          ),
          const LabGap.s12(),
          LabText.h2('No ${getModelNameFromContentType(contentType)}s yet',
              color: theme.colors.white33),
          const LabGap.s16(),
          LabButton(onTap: onCreateTap, color: theme.colors.white16, children: [
            LabIcon(
              theme.icons.characters.plus,
              outlineColor: theme.colors.white66,
              outlineThickness: LabLineThicknessData.normal().thick,
            ),
            const LabGap.s12(),
            LabText.med14(
              "Create ${getModelNameFromContentType(contentType)}",
              color: theme.colors.white66,
            )
          ])
        ],
      ),
    );
  }
}
