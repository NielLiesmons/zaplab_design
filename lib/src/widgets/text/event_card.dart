import 'package:zaplab_design/zaplab_design.dart';

class AppEventCard extends StatelessWidget {
  final String contentType;
  final String title;
  final String profileName;
  final String profilePicUrl;
  final String? imageUrl;

  final VoidCallback? onTap;

  const AppEventCard({
    super.key,
    required this.contentType,
    required this.title,
    required this.profileName,
    required this.profilePicUrl,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (contentType == 'article') {
      return AppArticleCard(
        title: title,
        profileName: profileName,
        profilePicUrl: profilePicUrl,
        imageUrl: imageUrl ?? '',
        onTap: onTap,
      );
    }

    final theme = AppTheme.of(context);

    return AppPanelButton(
      padding: const AppEdgeInsets.symmetric(
        horizontal: AppGapSize.s12,
        vertical: AppGapSize.s10,
      ),
      onTap: onTap,
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
                    AppEmojiImage(
                      emojiUrl: contentType.isNotEmpty
                          ? 'assets/emoji/$contentType.png'
                          : 'assets/emoji/app.png', // TODO: add fallback emoji here
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
    );
  }
}
