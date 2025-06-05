import 'package:zaplab_design/zaplab_design.dart';

class AppModelEmptyStateCard extends StatelessWidget {
  final String contentType;
  final VoidCallback onCreateTap;

  const AppModelEmptyStateCard({
    super.key,
    required this.contentType,
    required this.onCreateTap,
  });

  final double minWidth = 280;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppPanelButton(
      color: theme.colors.gray33,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppGap.s16(),
          AppEmojiContentType(
            contentType: contentType,
            size: theme.sizes.s64,
          ),
          const AppGap.s12(),
          AppText.h2('No ${getModelNameFromContentType(contentType)}s yet',
              color: theme.colors.white33),
          const AppGap.s16(),
          AppButton(inactiveColor: theme.colors.white16, children: [
            AppIcon(
              theme.icons.characters.plus,
              outlineColor: theme.colors.white66,
              outlineThickness: AppLineThicknessData.normal().thick,
            ),
            const AppGap.s12(),
            AppText.med14(
              "Create ${getModelNameFromContentType(contentType)}",
              color: theme.colors.white66,
            )
          ])
        ],
      ),
    );
  }
}
