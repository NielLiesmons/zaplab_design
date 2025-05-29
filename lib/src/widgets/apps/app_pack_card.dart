import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppAppPackCard extends StatelessWidget {
  final AppCurationSet pack;
  final List<App> apps;
  final VoidCallback onTap;
  final bool noPadding;

  const AppAppPackCard({
    super.key,
    required this.pack,
    required this.apps,
    required this.onTap,
    this.noPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      padding: noPadding
          ? const AppEdgeInsets.all(AppGapSize.none)
          : const AppEdgeInsets.all(AppGapSize.s12),
      child: Row(
        children: [
          // App icons container
          AppContainer(
            width: 95,
            height: 95,
            decoration: BoxDecoration(
              color: theme.colors.white8,
              borderRadius: theme.radius.asBorderRadius().rad16,
              border: Border.all(
                color: theme.colors.white16,
                width: AppLineThicknessData.normal().medium,
              ),
            ),
            padding: const AppEdgeInsets.all(AppGapSize.s10),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < 4 && i < apps.length; i++)
                  AppProfilePicSquare.fromUrl(
                    apps[i].icons.isNotEmpty ? apps[i].icons.first : '',
                    size: AppProfilePicSquareSize.s32,
                  ),
              ],
            ),
          ),
          const AppGap.s12(),
          // Content column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.bold14(pack.event.tags.firstWhere(
                    (tag) => tag[0] == 'name',
                    orElse: () => ['name', ''])[1]),
                const AppGap.s2(),
                AppText.reg12(
                  pack.event.content,
                  color: theme.colors.white66,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                ),
                const AppGap.s8(),
                // Author row
                Row(
                  children: [
                    AppProfilePic.s20(pack.author.value),
                    const AppGap.s8(),
                    AppText.reg12(
                      pack.author.value?.name ??
                          formatNpub(pack.author.value?.pubkey ?? ''),
                      color: theme.colors.white33,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
