import 'package:zaplab_design/zaplab_design.dart';

class HostingService {
  final String name;
  final String description;
  final HostingStatus status;
  final VoidCallback onAdjust;

  const HostingService({
    required this.name,
    required this.description,
    required this.status,
    required this.onAdjust,
  });
}

class LabHostingCard extends StatelessWidget {
  final String name;
  final String type;
  final List<HostingService> services;
  final double usedStorage;
  final double totalStorage;

  const LabHostingCard({
    super.key,
    required this.name,
    required this.type,
    required this.services,
    required this.usedStorage,
    required this.totalStorage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabPanel(
      padding: const LabEdgeInsets.all(LabGapSize.none),
      radius: theme.radius.asBorderRadius().rad24,
      gradient: theme.colors.graydient66,
      child: LabContainer(
        decoration: BoxDecoration(
          color: theme.colors.black.withValues(alpha: 0.5),
          borderRadius: theme.radius.asBorderRadius().rad12,
          border: Border(
            bottom: BorderSide(
              color: theme.colors.black8,
              width: LabLineThicknessData.normal().medium,
            ),
          ),
        ),
        child: Column(
          children: [
            LabContainer(
              padding: const LabEdgeInsets.symmetric(
                horizontal: LabGapSize.s12,
                vertical: LabGapSize.s12,
              ),
              child: Row(
                children: [
                  LabProfilePicSquare.fromUrl(
                    'https://cdn.satellite.earth/413ea918cfc60bdab6a205fd7cf65bc67067a63de3c4407eb23b18ae3479f0c5.png',
                    size: LabProfilePicSquareSize.s64,
                  ),
                  const LabGap.s12(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            LabText.med16(
                              name,
                            ),
                            const LabGap.s4(),
                            LabText.reg16(type,
                                gradient: theme.colors.graydient66),
                          ],
                        ),
                        const LabGap.s2(),
                        Row(
                          children: [
                            LabText.reg12(
                              '${usedStorage.toStringAsFixed(1)} GB / ${totalStorage.toStringAsFixed(1)} GB used',
                              color: theme.colors.white66,
                            ),
                          ],
                        ),
                        const LabGap.s4(),
                        LabProgressBar(
                          progress: usedStorage / totalStorage,
                          height: theme.sizes.s6,
                        ),
                      ],
                    ),
                  ),
                  const LabGap.s20(),
                  LabIcon.s16(
                    theme.icons.characters.chevronRight,
                    outlineColor: theme.colors.white33,
                    outlineThickness: LabLineThicknessData.normal().medium,
                  ),
                  const LabGap.s10(),
                ],
              ),
            ),
            const LabDivider(),
            for (final service in services) ...[
              LabContainer(
                height: theme.sizes.s38,
                padding: const LabEdgeInsets.only(
                  left: LabGapSize.s16,
                  right: LabGapSize.s16,
                  top: LabGapSize.s4,
                  bottom: LabGapSize.s4,
                ),
                child: Row(
                  children: [
                    LabContainer(
                      height: theme.sizes.s8,
                      width: theme.sizes.s8,
                      decoration: BoxDecoration(
                        gradient: service.status.getGradient(theme),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const LabGap.s12(),
                    Expanded(
                      child: LabText.reg12(
                        service.name,
                      ),
                    ),
                    const LabGap.s12(),
                    LabText.reg12(service.description,
                        color: theme.colors.white33),
                  ],
                ),
              ),
              if (service != services.last) const LabDivider(),
            ],
          ],
        ),
      ),
    );
  }
}
