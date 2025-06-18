import 'package:zaplab_design/zaplab_design.dart';

class LabBigSectionTitle extends StatelessWidget {
  final String title;
  final String? filter;
  final VoidCallback? onTap;

  const LabBigSectionTitle({
    super.key,
    required this.title,
    this.filter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    return Row(
      children: [
        const LabGap.s4(),
        LabText.h2(title, maxLines: 1, textOverflow: TextOverflow.ellipsis),
        const Spacer(),
        if (filter != null) ...[
          LabText.reg12(filter!, color: theme.colors.white33),
          const LabGap.s8(),
          LabIcon.s16(
            theme.icons.characters.chevronRight,
            outlineColor: theme.colors.white33,
            outlineThickness: LabLineThicknessData.normal().medium,
          ),
        ],
        const LabGap.s4(),
      ],
    );
  }
}
