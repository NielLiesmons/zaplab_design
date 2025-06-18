import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabAppReleaseCard extends StatelessWidget {
  final App app;
  final String releaseNumber; // TODO: get data from app via models package
  final String size; // TODO: get data from app via models package
  final String date; // TODO: get data from app via models package
  final VoidCallback onViewMore;
  final VoidCallback onInstall;
  final bool isInstalled;

  const LabAppReleaseCard({
    super.key,
    required this.app,
    required this.releaseNumber,
    required this.size,
    required this.date,
    required this.onViewMore,
    required this.onInstall,
    this.isInstalled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabContainer(
      padding: const LabEdgeInsets.all(LabGapSize.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App info header
          Row(
            children: [
              LabProfilePicSquare.fromUrl(
                app.icons.first,
                size: LabProfilePicSquareSize.s56,
              ),
              const LabGap.s16(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      LabText.h2(app.name ?? ''),
                      const LabGap.s12(),
                      LabIcon.s14(theme.icons.characters.chevronRight,
                          outlineColor: theme.colors.white33,
                          outlineThickness:
                              LabLineThicknessData.normal().medium),
                    ],
                  ),
                  LabText.reg12(
                    releaseNumber,
                    color: theme.colors.white66,
                  ),
                ],
              ),
            ],
          ),

          const LabGap.s12(),

          // Description with "View More"
          GestureDetector(
            onTap: onViewMore,
            child: LabContainer(
              child: LabText.reg14(
                app.description,
                color: theme.colors.white66,
                maxLines: 3,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          const LabGap.s12(),

          // Details panel (placeholder for now)
          LabPanel(
            isLight: true,
            padding: const LabEdgeInsets.symmetric(
                horizontal: LabGapSize.s16, vertical: LabGapSize.s10),
            child: LabContainer(
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
                                LabText.reg14('Source',
                                    color: theme.colors.white66),
                                const LabGap.s12(),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      LabEmojiImage(
                                          emojiUrl: 'emojis/folder.png',
                                          emojiName: 'folder',
                                          size: theme.sizes.s16),
                                      const LabGap.s8(),
                                      Flexible(
                                        child: LabText.med14(
                                          app.repository ?? '',
                                          textOverflow: TextOverflow.ellipsis,
                                          color: theme.colors.blurpleLightColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const LabGap.s4(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                LabText.reg14('Size',
                                    color: theme.colors.white66),
                                LabText.reg14(size),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const LabGap.s32(),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                LabText.reg14('Date',
                                    color: theme.colors.white66),
                                const LabGap.s12(),
                                LabText.reg14(date),
                              ],
                            ),
                            const LabGap.s4(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                LabText.reg14('License',
                                    color: theme.colors.white66),
                                const LabGap.s12(),
                                Flexible(
                                  child: LabText.reg14(app.license ?? '',
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

          const LabGap.s12(),

          // Publisher info
          LabPanelButton(
            isLight: true,
            padding: const LabEdgeInsets.symmetric(
                horizontal: LabGapSize.s16, vertical: LabGapSize.s10),
            onTap: () {}, // Add callback if needed
            child: Row(
              children: [
                LabText.med14(
                  'Published by',
                  color: theme.colors.white66,
                ),
                const Spacer(),
                LabProfilePic.s24(app.author.value),
                const LabGap.s8(),
                LabText.bold14(app.author.value?.name ??
                    formatNpub(app.author.value?.pubkey ?? '')),
              ],
            ),
          ),

          const LabGap.s12(),

          // Install button
          LabButton(
            onTap: onInstall,
            children: [
              LabText.med16(
                isInstalled ? 'Update' : 'Install',
                color: theme.colors.whiteEnforced,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
