import 'package:zaplab_design/zaplab_design.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    Key? key,
    required this.body,
    this.backgroundColor,
  }) : super(key: key);

  final Widget body;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      color: backgroundColor ?? theme.colors.black,
      child: body,
    );
  }
}
