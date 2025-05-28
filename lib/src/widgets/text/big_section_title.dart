import 'package:zaplab_design/zaplab_design.dart';

class AppBigSectionTitle extends StatelessWidget {
  final String title;
  final String? filter;
  final VoidCallback? onTap;

  const AppBigSectionTitle({
    super.key,
    required this.title,
    this.filter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Row(
      children: [
        const AppGap.s4(),
        AppText.h2(title, maxLines: 1, textOverflow: TextOverflow.ellipsis),
        const Spacer(),
        if (filter != null) ...[
          AppText.reg12(filter!, color: theme.colors.white33),
          const AppGap.s8(),
          AppIcon.s16(
            theme.icons.characters.chevronRight,
            outlineColor: theme.colors.white33,
            outlineThickness: AppLineThicknessData.normal().medium,
          ),
        ],
        const AppGap.s4(),
      ],
    );
  }
}
