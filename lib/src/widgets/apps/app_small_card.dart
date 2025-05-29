import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppAppSmallCard extends StatelessWidget {
  final App app;
  final VoidCallback onTap;
  final bool noPadding;

  const AppAppSmallCard({
    super.key,
    required this.app,
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
          AppProfilePicSquare.fromUrl(
            app.icons.isNotEmpty ? app.icons.first : '',
            size: AppProfilePicSquareSize.s48,
          ),
          const AppGap.s12(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.bold14(app.name ?? ''),
                const AppGap.s2(),
                AppText.reg12(
                  app.description,
                  color: theme.colors.white66,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
