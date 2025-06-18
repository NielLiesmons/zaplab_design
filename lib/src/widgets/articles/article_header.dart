import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabArticleHeader extends StatelessWidget {
  final Article article;
  final List<Community> communities;
  final Function(Profile) onProfileTap;

  const LabArticleHeader({
    super.key,
    required this.article,
    required this.communities,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabContainer(
          padding: const LabEdgeInsets.only(
            top: LabGapSize.s4,
            bottom: LabGapSize.s12,
            left: LabGapSize.s12,
            right: LabGapSize.s12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabProfilePic.s48(article.author.value,
                  onTap: () => onProfileTap(article.author.value as Profile)),
              const LabGap.s12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LabText.bold14(article.author.value?.name ??
                            formatNpub(article.author.value?.pubkey ?? '')),
                        LabText.reg12(
                          TimestampFormatter.format(article.createdAt,
                              format: TimestampFormat.relative),
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const LabGap.s6(),
                    LabCommunityStack(
                      communities: communities,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (article.imageUrl != null) LabFullWidthImage(url: article.imageUrl!),
        LabContainer(
          padding: LabEdgeInsets.only(
            top: article.imageUrl == null ? LabGapSize.none : LabGapSize.s8,
            bottom: LabGapSize.s8,
            left: LabGapSize.s12,
            right: LabGapSize.s12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabText.h2(article.title ?? ''),
              const LabGap.s4(),
              if (article.summary != null)
                LabText.regArticle(article.summary!,
                    color: theme.colors.white66, fontSize: 14),
            ],
          ),
        ),
      ],
    );
  }
}
