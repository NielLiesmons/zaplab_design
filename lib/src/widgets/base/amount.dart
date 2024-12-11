import 'package:zaplab_design/zaplab_design.dart';

class AppAmount extends StatelessWidget {
  final double value;
  final AppTextLevel level;
  final Color? color;
  final Gradient? gradient;

  const AppAmount(
    this.value, {
    super.key,
    this.level = AppTextLevel.med16,
    this.color,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final formattedValue = value.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');

    return AppText(
      formattedValue,
      level: level,
      color: color,
      gradient: gradient,
    );
  }
}
