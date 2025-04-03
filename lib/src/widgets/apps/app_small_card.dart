import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppAppSmallCard extends StatelessWidget {
  final App app;
  final String releaseNumber; // TODO: get data from app via models package
  final VoidCallback onTap;

  const AppAppSmallCard({
    super.key,
    required this.app,
    required this.releaseNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      padding: const AppEdgeInsets.all(AppGapSize.s12),
      child: Row(
        children: [
          AppProfilePic.s38(app.icons.first),
          const AppGap.s12(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppText.bold14(app.name ?? ''),
                    AppText.reg12(
                      releaseNumber,
                      color: theme.colors.white33,
                    ),
                  ],
                ),
                const AppGap.s2(),
                AppText.reg12(
                  app.description,
                  color: theme.colors.white33,
                  maxLines: 2,
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
