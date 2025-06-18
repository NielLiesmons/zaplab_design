import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabAppSmallCard extends StatelessWidget {
  final App app;
  final VoidCallback onTap;
  final bool noPadding;

  const LabAppSmallCard({
    super.key,
    required this.app,
    required this.onTap,
    this.noPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabContainer(
      padding: noPadding
          ? const LabEdgeInsets.all(LabGapSize.none)
          : const LabEdgeInsets.all(LabGapSize.s12),
      child: Row(
        children: [
          LabProfilePicSquare.fromUrl(
            app.icons.isNotEmpty ? app.icons.first : '',
            size: LabProfilePicSquareSize.s48,
          ),
          const LabGap.s12(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabText.bold14(app.name ?? ''),
                const LabGap.s2(),
                LabText.reg12(
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
