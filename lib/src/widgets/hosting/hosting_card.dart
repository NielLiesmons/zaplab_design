import 'package:zaplab_design/zaplab_design.dart';

class HostingService {
  final String name;
  final HostingStatus status;
  final VoidCallback onAdjust;

  const HostingService({
    required this.name,
    required this.status,
    required this.onAdjust,
  });
}

class AppHostingCard extends StatelessWidget {
  final String name;
  final List<HostingService> services;
  final double usedStorage;
  final double totalStorage;

  const AppHostingCard({
    super.key,
    required this.name,
    required this.services,
    required this.usedStorage,
    required this.totalStorage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppPanel(
      padding: const AppEdgeInsets.all(AppGapSize.none),
      radius: theme.radius.asBorderRadius().rad24,
      gradient: theme.colors.graydient66,
      child: AppContainer(
        decoration: BoxDecoration(
          color: theme.colors.black.withValues(alpha: 0.5),
          borderRadius: theme.radius.asBorderRadius().rad12,
          border: Border(
            bottom: BorderSide(
              color: theme.colors.black8,
              width: AppLineThicknessData.normal().medium,
            ),
          ),
        ),
        child: Column(
          children: [
            AppContainer(
              padding: const AppEdgeInsets.symmetric(
                horizontal: AppGapSize.s12,
                vertical: AppGapSize.s12,
              ),
              child: Row(
                children: [
                  AppProfilePicSquare.fromUrl(
                    'https://cdn.satellite.earth/413ea918cfc60bdab6a205fd7cf65bc67067a63de3c4407eb23b18ae3479f0c5.png',
                    size: AppProfilePicSquareSize.s56,
                  ),
                  const AppGap.s12(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.med14(
                          name,
                        ),
                        Row(
                          children: [
                            AppText.reg12(
                              '${usedStorage.toStringAsFixed(1)} GB / ${totalStorage.toStringAsFixed(1)} GB used',
                              color: theme.colors.white66,
                            ),
                          ],
                        ),
                        const AppGap.s4(),
                        AppProgressBar(
                          progress: usedStorage / totalStorage,
                          height: theme.sizes.s6,
                        ),
                      ],
                    ),
                  ),
                  const AppGap.s20(),
                  AppIcon.s16(
                    theme.icons.characters.chevronRight,
                    outlineColor: theme.colors.white33,
                    outlineThickness: AppLineThicknessData.normal().medium,
                  ),
                  const AppGap.s10(),
                ],
              ),
            ),
            const AppDivider(),
            for (final service in services) ...[
              AppContainer(
                padding: const AppEdgeInsets.only(
                  left: AppGapSize.s16,
                  right: AppGapSize.s6,
                  top: AppGapSize.s4,
                  bottom: AppGapSize.s4,
                ),
                child: Row(
                  children: [
                    AppContainer(
                      height: theme.sizes.s8,
                      width: theme.sizes.s8,
                      decoration: BoxDecoration(
                        gradient: service.status.getGradient(theme),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const AppGap.s12(),
                    Expanded(
                      child: AppText.reg12(
                        service.name,
                      ),
                    ),
                    const AppGap.s12(),
                    AppSmallButton(
                      inactiveColor: Color(0x00000000),
                      onTap: service.onAdjust,
                      children: [
                        AppIcon.s16(
                          theme.icons.characters.adjust,
                          outlineColor: theme.colors.white33,
                          outlineThickness:
                              AppLineThicknessData.normal().medium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (service != services.last) const AppDivider(),
            ],
          ],
        ),
      ),
    );
  }
}
