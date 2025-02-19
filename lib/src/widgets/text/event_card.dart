import 'package:zaplab_design/zaplab_design.dart';

class AppEventCard extends StatelessWidget {
  final String contentType;
  final String title;
  final String? imageUrl;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;
  final String? amount;
  final String? message;
  final VoidCallback? onTap;

  const AppEventCard({
    super.key,
    required this.contentType,
    required this.title,
    this.imageUrl,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
    this.amount,
    this.message,
    this.onTap,
  });

  final double minWidth = 280;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    if (contentType.isEmpty) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: AppPanelButton(
          padding: const AppEdgeInsets.all(AppGapSize.none),
          child: AppSkeletonLoader(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 18,
              ),
              child: Row(
                children: [
                  const AppGap.s4(),
                  AppIcon.s24(
                    theme.icons.characters.nostr,
                    color: theme.colors.white33,
                  ),
                  const AppGap.s16(),
                  AppText.med14(
                    'Nostr Publication',
                    color: theme.colors.white33,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (contentType == 'article') {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: AppArticleCard(
          title: title,
          profileName: profileName,
          profilePicUrl: profilePicUrl,
          imageUrl: imageUrl ?? '',
          onTap: onTap,
        ),
      );
    }

    if (contentType == 'message') {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: AppQuotedMessage(
          profileName: profileName,
          profilePicUrl: profilePicUrl,
          message: message ?? '',
          timestamp: timestamp,
          eventId: null,
        ),
      );
    }

    if (contentType == 'zap') {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: AppZapCard(
          profileName: profileName,
          profilePicUrl: profilePicUrl,
          amount: amount ?? '',
          message: message ?? '',
          onTap: onTap,
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: AppPanelButton(
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
                        emojiUrl: 'assets/emoji/$contentType.png',
                        emojiName: contentType,
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
    );
  }
}
