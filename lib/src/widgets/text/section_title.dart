import 'package:zaplab_design/zaplab_design.dart';

class AppSectionTitle extends StatelessWidget {
  final String text;

  const AppSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      children: [
        Row(
          children: [
            const AppGap.s12(),
            AppText.h3(text.toUpperCase(), color: theme.colors.white66),
          ],
        ),
        const AppGap.s6(),
      ],
    );
  }
}
