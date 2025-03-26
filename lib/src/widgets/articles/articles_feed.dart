import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppArticlesFeed extends StatelessWidget {
  final List<Article> articles;

  final Future<void> Function(String url)? onTap;

  const AppArticlesFeed({
    super.key,
    required this.articles,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const AppEdgeInsets.all(AppGapSize.s12),
      child: Column(
        children: [
          for (final article in articles)
            Column(
              children: [
                AppArticleCard(
                  title: article.title,
                  profileName: article.author.value,
                  profilePicUrl: article.author.value.pictureUrl,
                  imageUrl: article.imageUrl,
                  onTap: () {
                    // TODO Handle article tap
                  },
                ),
                const AppGap.s12(),
              ],
            ),
        ],
      ),
    );
  }
}
