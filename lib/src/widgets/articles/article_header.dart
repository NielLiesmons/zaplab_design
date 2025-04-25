import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppArticleHeader extends StatelessWidget {
  final Article article;
  final List<Community> communities;

  const AppArticleHeader({
    super.key,
    required this.article,
    required this.communities,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Column(
      children: [
        AppContainer(
          padding: const AppEdgeInsets.all(AppGapSize.s12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppProfilePic.s48(article.author.value?.pictureUrl ?? ''),
              const AppGap.s12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText.bold14(article.author.value?.name ??
                            formatNpub(article.author.value?.pubkey ?? '')),
                        AppText.reg12(
                          TimestampFormatter.format(article.createdAt,
                              format: TimestampFormat.relative),
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const AppGap.s6(),
                    AppCommunityStack(
                      communities: communities,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (article.imageUrl != null) AppFullWidthImage(url: article.imageUrl!),
        AppContainer(
          padding: const AppEdgeInsets.all(AppGapSize.s12),
          child: Column(
            children: [
              AppText.h2(article.title ?? ''),
              const AppGap.s4(),
              if (article.summary != null) AppText.reg16(article.summary!)
            ],
          ),
        ),
      ],
    );
  }
}
