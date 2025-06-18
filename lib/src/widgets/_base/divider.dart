import 'package:zaplab_design/zaplab_design.dart';

enum LabDividerOrientation {
  horizontal,
  vertical,
}

class LabDivider extends StatelessWidget {
  final Color? color;
  final double? thickness;
  final LabDividerOrientation orientation;

  const LabDivider({
    super.key,
    this.color,
    this.thickness,
    this.orientation = LabDividerOrientation.horizontal,
  });

  const LabDivider.vertical({
    super.key,
    this.color,
    this.thickness,
  }) : orientation = LabDividerOrientation.vertical;

  const LabDivider.horizontal({
    super.key,
    this.color,
    this.thickness,
  }) : orientation = LabDividerOrientation.horizontal;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    return Center(
      child: LabContainer(
        height: orientation == LabDividerOrientation.horizontal ? 0 : null,
        width: orientation == LabDividerOrientation.vertical ? 0 : null,
        decoration: BoxDecoration(
          border: orientation == LabDividerOrientation.horizontal
              ? Border(
                  bottom: BorderSide(
                    color: color ?? theme.colors.white16,
                    width: thickness ?? LabLineThicknessData.normal().medium,
                  ),
                )
              : Border(
                  right: BorderSide(
                    color: color ?? theme.colors.white16,
                    width: thickness ?? LabLineThicknessData.normal().medium,
                  ),
                ),
        ),
      ),
    );
  }
}
