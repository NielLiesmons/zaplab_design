import 'package:zaplab_design/zaplab_design.dart';

class AppAppReleaseCard extends StatelessWidget {
  final String appName;
  final String releaseNumber;
  final String description;
  final String profilePicUrl;
  final String publisherName;
  final String publisherPicUrl;
  final String source;
  final String size;
  final String date;
  final String license;
  final VoidCallback onViewMore;
  final VoidCallback onInstall;

  const AppAppReleaseCard({
    super.key,
    required this.appName,
    required this.releaseNumber,
    required this.description,
    required this.profilePicUrl,
    required this.publisherName,
    required this.publisherPicUrl,
    required this.source,
    required this.size,
    required this.date,
    required this.license,
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
                  Row(
                    children: [
                      AppText.h2(appName),
                      const AppGap.s12(),
                      AppIcon.s14(theme.icons.characters.chevronRight,
                          outlineColor: theme.colors.white33,
                          outlineThickness: LineThicknessData.normal().medium),
                    ],
                  ),
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
                                const AppGap.s12(),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      AppEmojiImage(
                                          emojiUrl: 'emojis/folder.png',
                                          emojiName: 'folder',
                                          size: theme.sizes.s16),
                                      const AppGap.s8(),
                                      Flexible(
                                        child: AppText.med14(
                                          source,
                                          textOverflow: TextOverflow.ellipsis,
                                          color: theme.colors.blurpleColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const AppGap.s4(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText.reg14('Size',
                                    color: theme.colors.white66),
                                AppText.reg14(size),
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
                                const AppGap.s12(),
                                AppText.reg14(date),
                              ],
                            ),
                            const AppGap.s4(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText.reg14('License',
                                    color: theme.colors.white66),
                                const AppGap.s12(),
                                Flexible(
                                  child: AppText.reg14(license,
                                      textOverflow: TextOverflow.ellipsis),
                                ),
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
