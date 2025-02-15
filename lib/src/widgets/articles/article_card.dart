import 'package:zaplab_design/zaplab_design.dart';

class AppArticleCard extends StatelessWidget {
  final String title;
  final String profileName;
  final String profilePicUrl;
  final String imageUrl;
  final VoidCallback? onTap;

  const AppArticleCard({
    super.key,
    required this.title,
    required this.profileName,
    required this.profilePicUrl,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isInsideModal = ModalScope.of(context);

    return AppPanelButton(
      padding: const AppEdgeInsets.all(AppGapSize.none),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container with 16:9 aspect ratio
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
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      )
                    : const AppSkeletonLoader(),
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
                AppProfilePic.s40(profilePicUrl),
                const AppGap.s12(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const AppEmojiImage(
                            emojiUrl: 'assets/emoji/article.png',
                            size: 16,
                          ),
                          const AppGap.s10(),
                          Expanded(
                            child: AppText.reg14(
                              title,
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const AppGap.s2(),
                      AppText.reg12(
                        profileName,
                        color: theme.colors.white66,
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
