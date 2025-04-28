import 'package:zaplab_design/zaplab_design.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.backgroundColor,
  });

  final Widget body;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      decoration: BoxDecoration(color: backgroundColor ?? theme.colors.black),
      child: body,
    );
  }
}
