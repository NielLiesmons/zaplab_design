import 'package:zaplab_design/zaplab_design.dart';

class LabSectionTitle extends StatelessWidget {
  final String text;

  const LabSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    return Column(
      children: [
        Row(
          children: [
            const LabGap.s12(),
            LabText.h3(text.toUpperCase(), color: theme.colors.white66),
          ],
        ),
        const LabGap.s6(),
      ],
    );
  }
}
