import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppFeedArticle extends StatelessWidget {
  final Article article;
  final List<Reply> topReplies;
  final int totalReplies;
  final VoidCallback? onTap;
  final bool isUnread;

  const AppFeedArticle({
    super.key,
    required this.article,
    this.topReplies = const [],
    this.totalReplies = 0,
    this.onTap,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      padding: const AppEdgeInsets.all(AppGapSize.s12),
      child: Column(
        children: [
          // Image container with 16:9 aspect ratio
          if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: AppContainer(
                width: double.infinity,
                padding: const AppEdgeInsets.all(AppGapSize.s2),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: theme.colors.gray33,
                  borderRadius: theme.radius.asBorderRadius().rad16,
                  border: Border.all(
                    color: theme.colors.white16,
                    width: LineThicknessData.normal().thin,
                  ),
                ),
                child: Image.network(
                  article.imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const AppSkeletonLoader();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image: $error');
                    return const AppSkeletonLoader();
                  },
                ),
              ),
            ),
          const AppGap.s12(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        AppProfilePic.s38(
                            article.author.value?.pictureUrl ?? ''),
                        if (topReplies.isNotEmpty)
                          Expanded(
                            child: AppDivider.vertical(
                              color: theme.colors.white33,
                            ),
                          ),
                      ],
                    ),
                    const AppGap.s12(),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppText.h2(article.title ?? 'No Title'),
                              const AppGap.s4(),
                              if (isUnread)
                                AppContainer(
                                  height: theme.sizes.s8,
                                  width: theme.sizes.s8,
                                  decoration: BoxDecoration(
                                    gradient: theme.colors.blurple,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppText.med12(
                                  article.author.value?.name ??
                                      formatNpub(
                                          article.author.value?.pubkey ?? ''),
                                  color: theme.colors.white66),
                              AppText.reg12(
                                TimestampFormatter.format(article.createdAt,
                                    format: TimestampFormat.relative),
                                color: theme.colors.white33,
                              ),
                            ],
                          ),
                          const AppGap.s2(),
                          if (article.summary != null &&
                              article.summary!.isNotEmpty)
                            AppText.regArticle(
                              article.summary!,
                              fontSize: 14,
                            ),
                          // TODO: Implement Zaps and Reactions once HasMany is available
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (topReplies.isNotEmpty) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: Column(
                        children: [
                          AppProfilePic.s20(
                              topReplies[0].author.value?.pictureUrl ?? ''),
                          const AppGap.s2(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (topReplies.length > 1)
                                AppProfilePic.s16(
                                    topReplies[1].author.value?.pictureUrl ??
                                        ''),
                              const Spacer(),
                              if (topReplies.length > 2)
                                AppProfilePic.s12(
                                    topReplies[2].author.value?.pictureUrl ??
                                        ''),
                              const AppGap.s2()
                            ],
                          ),
                        ],
                      ),
                    ),
                    const AppGap.s12(),
                    Expanded(
                      child: AppText.med14(
                        '${topReplies[0].author.value?.name ?? formatNpub(topReplies[0].author.value?.npub ?? '')} & ${totalReplies - 1} others replied',
                        color: theme.colors.white33,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          AppText.reg14(article.summary ?? '')
        ],
      ),
    );
  }
}
