import 'package:zaplab_design/zaplab_design.dart';

class LabAmount extends StatelessWidget {
  final double value;
  final LabTextLevel level;
  final Color? color;
  final Gradient? gradient;

  const LabAmount(
    this.value, {
    super.key,
    this.level = LabTextLevel.med16,
    this.color,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final formattedValue = value.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    return LabText(
      formattedValue,
      level: level,
      color: color,
      gradient: gradient,
    );
  }
}
