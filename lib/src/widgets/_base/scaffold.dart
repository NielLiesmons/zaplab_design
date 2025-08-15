import 'package:zaplab_design/zaplab_design.dart';

class LabScaffold extends StatelessWidget {
  const LabScaffold({
    super.key,
    required this.body,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = false,
  });

  final Widget body;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabContainer(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colors.black,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: resizeToAvoidBottomInset
              ? MediaQuery.viewInsetsOf(context).bottom / theme.system.scale
              : 0,
        ),
        child: body,
      ),
    );
  }
}
