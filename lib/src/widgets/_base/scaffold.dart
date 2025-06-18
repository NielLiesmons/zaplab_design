import 'package:zaplab_design/zaplab_design.dart';

class LabScaffold extends StatelessWidget {
  const LabScaffold({
    super.key,
    required this.body,
    this.backgroundColor,
  });

  final Widget body;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabContainer(
      decoration: BoxDecoration(color: backgroundColor ?? theme.colors.black),
      child: body,
    );
  }
}
