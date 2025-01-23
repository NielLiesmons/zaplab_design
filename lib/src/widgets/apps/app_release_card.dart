import 'package:zaplab_design/zaplab_design.dart';

class AppReleaseCard extends StatelessWidget {
  final String appName;
  final String releaseNumber;
  final String description;
  final String profilePicUrl;
  final String publisherName;
  final String publisherPicUrl;
  final VoidCallback onViewMore;
  final VoidCallback onInstall;

  const AppReleaseCard({
    super.key,
    required this.appName,
    required this.releaseNumber,
    required this.description,
    required this.profilePicUrl,
    required this.publisherName,
    required this.publisherPicUrl,
    required this.onViewMore,
    required this.onInstall,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      padding: const AppEdgeInsets.all(AppGapSize.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App info header
          Row(
            children: [
              AppProfilePicSquare.s56(profilePicUrl),
              const AppGap.s16(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.h2(appName),
                  AppText.reg12(
                    releaseNumber,
                    color: theme.colors.white66,
                  ),
                ],
              ),
            ],
          ),

          const AppGap.s12(),

          // Description with "View More"
          GestureDetector(
            onTap: onViewMore,
            child: AppContainer(
              child: AppText.reg14(
                description,
                color: theme.colors.white66,
                maxLines: 3,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          const AppGap.s12(),

          // Details panel (placeholder for now)
          AppPanel(
            isLight: true,
            padding: const AppEdgeInsets.symmetric(
                horizontal: AppGapSize.s16, vertical: AppGapSize.s10),
            child: AppContainer(
              // Temporary height
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText.reg14('Source',
                                    color: theme.colors.white66),
                                Row(
                                  children: [
                                    AppEmojiImage(
                                        emojiUrl:
                                            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.emoji.co.uk%2Ffiles%2Fapple-emojis%2Fobjects-ios%2F733-file-folder.png&f=1&nofb=1&ipt=6e2c118ca3055fd7ae84c39656c3e56bf40c968aef9beb9c06be6edb69197aeb&ipo=images',
                                        size: theme.sizes.s16),
                                    const AppGap.s8(),
                                    AppText.med14('Repo',
                                        color: theme.colors.blurpleColor),
                                  ],
                                ),
                              ],
                            ),
                            const AppGap.s4(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText.reg14('Size',
                                    color: theme.colors.white66),
                                AppText.reg14('32 MB'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const AppGap.s32(),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText.reg14('Date',
                                    color: theme.colors.white66),
                                AppText.reg14('21/04/25'),
                              ],
                            ),
                            const AppGap.s4(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText.reg14('License',
                                    color: theme.colors.white66),
                                AppText.reg14('Unlicense'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const AppGap.s12(),

          // Publisher info
          AppPanelButton(
            isLight: true,
            padding: const AppEdgeInsets.symmetric(
                horizontal: AppGapSize.s16, vertical: AppGapSize.s10),
            onTap: () {}, // Add callback if needed
            child: Row(
              children: [
                AppText.med14(
                  'Published by',
                  color: theme.colors.white66,
                ),
                const Spacer(),
                AppProfilePic.s24(publisherPicUrl),
                const AppGap.s8(),
                AppText.bold14(publisherName),
              ],
            ),
          ),

          const AppGap.s12(),

          // Install button
          AppButton(
            content: [
              AppText.med16(
                'Install Update',
                color: AppColorsData.dark().white,
              ),
            ],
            onTap: onInstall,
          ),
        ],
      ),
    );
  }
}
