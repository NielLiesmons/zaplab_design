import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabProfileHeader extends StatelessWidget {
  const LabProfileHeader({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabContainer(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: theme.colors.black,
      ),
      child: Column(
        children: [
          // Cover image
          AspectRatio(
            aspectRatio: 3 / 1.2,
            child: LabContainer(
              decoration: BoxDecoration(
                color: Color(profileToColor(profile)).withValues(alpha: 0.16),
              ),
              child: profile.banner != null && profile.banner!.isNotEmpty
                  ? Image.network(
                      profile.banner!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox.shrink();
                      },
                      loadingBuilder: (context, error, stackTrace) {
                        return const LabSkeletonLoader();
                      },
                    )
                  : null,
            ),
          ),
          // Profile section
          LabContainer(
            padding: const LabEdgeInsets.only(
              left: LabGapSize.s12,
              right: LabGapSize.s12,
              top: LabGapSize.s8,
              bottom: LabGapSize.s10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    LabContainer(
                      height: 40,
                    ),
                    Positioned(
                      top: -40,
                      child: LabProfilePic.s80(profile),
                    ),
                  ],
                ),
                const LabGap.s80(),
                const LabGap.s12(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabText.bold16(
                      profile.name ?? formatNpub(profile.npub),
                      color: theme.colors.white,
                    ),
                    LabNpubDisplay(profile: profile),
                  ],
                ),
              ],
            ),
          ),
          if (profile.about != null && profile.about!.isNotEmpty)
            Column(
              children: [
                const LabDivider(),
                LabContainer(
                  padding: const LabEdgeInsets.symmetric(
                    horizontal: LabGapSize.s12,
                    vertical: LabGapSize.s8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: LabText.reg14(
                              profile.about ?? '',
                            ),
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
    );
  }
}
