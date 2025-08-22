import 'package:zaplab_design/zaplab_design.dart';

class LabBottomBarSafeArea extends StatelessWidget {
  const LabBottomBarSafeArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;

    return Column(
      children: [
        const LabDivider(),
        LabContainer(
          height: bottomPadding,
          decoration: BoxDecoration(
            color: theme.colors.black66,
          ),
        ),
      ],
    );
  }
}
