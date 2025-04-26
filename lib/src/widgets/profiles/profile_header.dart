import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppProfileHeader extends StatelessWidget {
  const AppProfileHeader({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: theme.colors.black,
      ),
      child: Column(
        children: [
          // Cover image
          AspectRatio(
            aspectRatio: 3 / 1.2,
            child: AppContainer(
              decoration: BoxDecoration(
                color: theme.colors.gray33,
              ),
              child: profile.banner != null && profile.banner!.isNotEmpty
                  ? Image.network(
                      profile.banner!,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          // Profile section
          AppContainer(
            padding: const AppEdgeInsets.only(
              left: AppGapSize.s12,
              right: AppGapSize.s12,
              top: AppGapSize.s8,
              bottom: AppGapSize.s10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AppContainer(
                      height: 40,
                    ),
                    Positioned(
                      top: -40,
                      child: AppProfilePic.s80(
                        profile.pictureUrl ?? '',
                      ),
                    ),
                  ],
                ),
                const AppGap.s80(),
                const AppGap.s12(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.bold16(
                      profile.name ?? formatNpub(profile.npub),
                      color: theme.colors.white,
                    ),
                    AppNpubDisplay(profile: profile),
                  ],
                ),
              ],
            ),
          ),
          if (profile.about != null && profile.about!.isNotEmpty)
            Column(
              children: [
                const AppDivider(),
                AppContainer(
                  padding: const AppEdgeInsets.symmetric(
                    horizontal: AppGapSize.s12,
                    vertical: AppGapSize.s8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: AppText.reg14(
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
