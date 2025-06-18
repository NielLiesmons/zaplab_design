import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabAppPackCard extends StatelessWidget {
  final AppCurationSet pack;
  final List<App> apps;
  final VoidCallback onTap;
  final bool noPadding;

  const LabAppPackCard({
    super.key,
    required this.pack,
    required this.apps,
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
          // App icons container
          LabContainer(
            width: 95,
            height: 95,
            decoration: BoxDecoration(
              color: theme.colors.white8,
              borderRadius: theme.radius.asBorderRadius().rad16,
              border: Border.all(
                color: theme.colors.white16,
                width: LabLineThicknessData.normal().medium,
              ),
            ),
            padding: const LabEdgeInsets.all(LabGapSize.s10),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < 4 && i < apps.length; i++)
                  LabProfilePicSquare.fromUrl(
                    apps[i].icons.isNotEmpty ? apps[i].icons.first : '',
                    size: LabProfilePicSquareSize.s32,
                  ),
              ],
            ),
          ),
          const LabGap.s12(),
          // Content column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabText.bold14(pack.event.tags.firstWhere(
                    (tag) => tag[0] == 'name',
                    orElse: () => ['name', ''])[1]),
                const LabGap.s2(),
                LabText.reg12(
                  pack.event.content,
                  color: theme.colors.white66,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                ),
                const LabGap.s8(),
                // Author row
                Row(
                  children: [
                    LabProfilePic.s20(pack.author.value),
                    const LabGap.s8(),
                    LabText.reg12(
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
