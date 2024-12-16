import 'package:zaplab_design/zaplab_design.dart';

enum AppDividerOrientation {
  horizontal,
  vertical,
}

class AppDivider extends StatelessWidget {
  final Color? color;
  final double? thickness;
  final AppDividerOrientation orientation;

  const AppDivider({
    super.key,
    this.color,
    this.thickness,
    this.orientation = AppDividerOrientation.horizontal,
  });

  const AppDivider.vertical({
    super.key,
    this.color,
    this.thickness,
  }) : orientation = AppDividerOrientation.vertical;

  const AppDivider.horizontal({
    super.key,
    this.color,
    this.thickness,
  }) : orientation = AppDividerOrientation.horizontal;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: Container(
        height: orientation == AppDividerOrientation.horizontal ? 0 : null,
        width: orientation == AppDividerOrientation.vertical ? 0 : null,
        decoration: BoxDecoration(
          border: orientation == AppDividerOrientation.horizontal
              ? Border(
                  bottom: BorderSide(
                    color: color ?? theme.colors.white16,
                    width: thickness ?? LineThicknessData.normal().medium,
                  ),
                )
              : Border(
                  right: BorderSide(
                    color: color ?? theme.colors.white16,
                    width: thickness ?? LineThicknessData.normal().medium,
                  ),
                ),
        ),
      ),
    );
  }
}
