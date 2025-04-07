import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback? onTap;

  const AppArticleCard({
    super.key,
    required this.article,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    // TODO: Get image URL from article model once implemented
    final imageUrl = null;

    return AppPanelButton(
      padding: const AppEdgeInsets.all(AppGapSize.none),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container with 16:9 aspect ratio
          if (imageUrl != null && imageUrl.isNotEmpty)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: AppContainer(
                width: double.infinity,
                padding: const AppEdgeInsets.all(AppGapSize.s2),
                child: AppContainer(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: theme.colors.grey33,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14.6),
                      topRight: Radius.circular(14.6),
                    ),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const AppSkeletonLoader();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading asset: $error');
                      return const AppSkeletonLoader();
                    },
                  ),
                ),
              ),
            ),

          // Event info section
          AppContainer(
            padding: const AppEdgeInsets.only(
              left: AppGapSize.s12,
              right: AppGapSize.s12,
              top: AppGapSize.s8,
              bottom: AppGapSize.s10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppProfilePic.s40(article.author.value?.pictureUrl ?? ''),
                const AppGap.s12(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const AppEmojiImage(
                            emojiUrl: 'assets/emoji/article.png',
                            emojiName: 'article',
                            size: 16,
                          ),
                          const AppGap.s10(),
                          Expanded(
                            child: AppText.reg14(
                              article.title ?? '',
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const AppGap.s2(),
                      AppText.reg12(
                        article.author.value?.name ??
                            formatNpub(article.author.value?.pubkey ?? ''),
                        color: theme.colors.white66,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
