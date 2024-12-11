import 'package:zaplab_design/zaplab_design.dart';

class AppDivider extends StatelessWidget {
  final Color? color;
  final double? thickness;

  const AppDivider({
    super.key,
    this.color,
    this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: Container(
        height: 0,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: color ?? theme.colors.white16,
              width: thickness ?? LineThicknessData.normal().medium,
            ),
          ),
        ),
      ),
    );
  }
}
