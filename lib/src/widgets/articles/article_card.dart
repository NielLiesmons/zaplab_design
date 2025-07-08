import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabArticleCard extends StatelessWidget {
  final Article article;
  final Function(Article)? onTap;
  final Function(Profile) onProfileTap;

  const LabArticleCard({
    super.key,
    required this.article,
    this.onTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabPanelButton(
      padding: const LabEdgeInsets.all(LabGapSize.none),
      isLight: true,
      onTap: () => onTap?.call(article),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container with 16:9 aspect ratio
          if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: LabContainer(
                width: double.infinity,
                padding: const LabEdgeInsets.all(LabGapSize.s2),
                child: LabContainer(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: theme.colors.gray33,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14.6),
                      topRight: Radius.circular(14.6),
                    ),
                  ),
                  child: Image.network(
                    article.imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const LabSkeletonLoader();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return Center(
                        child: LabText(
                          "Image not found",
                          color: theme.colors.white33,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

          // Model info section
          LabContainer(
            padding: const LabEdgeInsets.only(
              left: LabGapSize.s12,
              right: LabGapSize.s12,
              top: LabGapSize.s8,
              bottom: LabGapSize.s10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LabProfilePic.s40(article.author.value,
                    onTap: () => onProfileTap(article.author.value as Profile)),
                const LabGap.s12(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const LabEmojiImage(
                            emojiUrl: 'assets/emoji/article.png',
                            emojiName: 'article',
                            size: 16,
                          ),
                          const LabGap.s10(),
                          Expanded(
                            child: LabText.reg14(
                              article.title ?? '',
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const LabGap.s2(),
                      LabText.reg12(
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
