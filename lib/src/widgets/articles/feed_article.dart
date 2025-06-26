import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';

class LabFeedArticle extends StatelessWidget {
  final Article article;
  final List<Profile> topThreeReplyProfiles;
  final int totalReplyProfiles;
  final Function(Model) onTap;
  final Function(Profile) onProfileTap;
  final bool isUnread;

  const LabFeedArticle({
    super.key,
    required this.article,
    this.topThreeReplyProfiles = const [],
    this.totalReplyProfiles = 0,
    required this.onTap,
    required this.onProfileTap,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return TapBuilder(
      onTap: () => onTap(article),
      builder: (context, state, hasFocus) {
        return Column(
          children: [
            LabContainer(
              padding: LabEdgeInsets.only(
                top:
                    article.imageUrl == null ? LabGapSize.none : LabGapSize.s12,
                bottom: LabGapSize.s12,
                left: LabGapSize.s12,
                right: LabGapSize.s12,
              ),
              child: Column(
                children: [
                  // Image container with 16:9 aspect ratio
                  if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final maxWidth = constraints.maxWidth;
                        if (maxWidth > 400) {
                          return LabContainer(
                            width: double.infinity,
                            height: 400 * (9 / 16),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: theme.colors.gray33,
                              borderRadius: theme.radius.asBorderRadius().rad16,
                              border: Border.all(
                                color: theme.colors.white16,
                                width: LabLineThicknessData.normal().thin,
                              ),
                            ),
                            child: Image.network(
                              article.imageUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const LabSkeletonLoader();
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: LabText(
                                    "Image not found",
                                    color: theme.colors.white33,
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return AspectRatio(
                          aspectRatio: 16 / 9,
                          child: LabContainer(
                            width: double.infinity,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: theme.colors.gray33,
                              borderRadius: theme.radius.asBorderRadius().rad16,
                              border: Border.all(
                                color: theme.colors.white16,
                                width: LabLineThicknessData.normal().thin,
                              ),
                            ),
                            child: Image.network(
                              article.imageUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const LabSkeletonLoader();
                              },
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading image: $error');
                                return const LabSkeletonLoader();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  const LabGap.s8(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const LabGap.s4(),
                                LabProfilePic.s38(article.author.value,
                                    onTap: () => onProfileTap(
                                        article.author.value as Profile)),
                                if (topThreeReplyProfiles.isNotEmpty)
                                  Expanded(
                                    child: LabDivider.vertical(
                                      color: theme.colors.white33,
                                    ),
                                  ),
                              ],
                            ),
                            const LabGap.s12(),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: LabText.bold16(
                                          article.title ?? 'No Title',
                                          maxLines: 2,
                                          textOverflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const LabGap.s4(),
                                      if (isUnread)
                                        LabContainer(
                                          margin: const LabEdgeInsets.only(
                                              top: LabGapSize.s8),
                                          height: theme.sizes.s8,
                                          width: theme.sizes.s8,
                                          decoration: BoxDecoration(
                                            gradient: theme.colors.blurple,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const LabGap.s2(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      LabText.med12(
                                          article.author.value?.name ??
                                              formatNpub(article
                                                      .author.value?.pubkey ??
                                                  ''),
                                          color: theme.colors.white66),
                                      const Spacer(),
                                      LabText.reg12(
                                        TimestampFormatter.format(
                                            article.createdAt,
                                            format: TimestampFormat.relative),
                                        color: theme.colors.white33,
                                      ),
                                    ],
                                  ),
                                  const LabGap.s2(),
                                  if (article.summary != null &&
                                      article.summary!.isNotEmpty)
                                    LabSelectableText(
                                      text: article.summary!,
                                      style:
                                          theme.typography.regArticle.copyWith(
                                        fontSize: 14,
                                        height: 1.5,
                                        color: theme.colors.white
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                  // TODO: Implement Zaps and Reactions once HasMany is available
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (topThreeReplyProfiles.isNotEmpty) ...[
                        Row(
                          children: [
                            SizedBox(
                              width: 38,
                              height: 38,
                              child: Column(
                                children: [
                                  LabProfilePic.s20(topThreeReplyProfiles[0]),
                                  const LabGap.s2(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (topThreeReplyProfiles.length > 1)
                                        LabProfilePic.s16(
                                            topThreeReplyProfiles[1]),
                                      const Spacer(),
                                      if (topThreeReplyProfiles.length > 2)
                                        LabProfilePic.s12(
                                            topThreeReplyProfiles[2]),
                                      const LabGap.s2()
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const LabGap.s12(),
                            Expanded(
                              child: LabText.med14(
                                '${topThreeReplyProfiles[0].name ?? formatNpub(topThreeReplyProfiles[0].npub ?? '')} & ${totalReplyProfiles - 1} others replied',
                                color: theme.colors.white33,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const LabDivider(),
          ],
        );
      },
    );
  }
}
