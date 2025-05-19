import 'package:zaplab_design/zaplab_design.dart';

class AppHistoryCard extends StatelessWidget {
  final String contentType;
  final String displayText;
  final VoidCallback? onTap;

  const AppHistoryCard({
    super.key,
    required this.contentType,
    required this.displayText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      decoration: BoxDecoration(
        color: theme.colors.white8,
        borderRadius: theme.radius.asBorderRadius().rad12,
      ),
      padding: const AppEdgeInsets.only(
        top: AppGapSize.s10,
        bottom: AppGapSize.s10,
        left: AppGapSize.s12,
        right: AppGapSize.s16,
      ),
      child: Row(
        children: [
          AppEmojiContentType(contentType: contentType, size: theme.sizes.s18),
          const AppGap.s10(),
          AppText.reg12(
            contentType,
            color: theme.colors.white66,
          ),
          const AppGap.s10(),
          Expanded(
            child: AppText.reg12(
              displayText,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}





// AppHistoryCard