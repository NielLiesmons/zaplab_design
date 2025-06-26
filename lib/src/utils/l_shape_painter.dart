import 'package:zaplab_design/zaplab_design.dart';

class LabLShapePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerRadius;

  LabLShapePainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.cornerRadius = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - cornerRadius)
      ..arcToPoint(
        Offset(cornerRadius, size.height),
        radius: Radius.circular(cornerRadius),
        clockwise: false,
      )
      ..lineTo(size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LabLShapePainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      cornerRadius != oldDelegate.cornerRadius;
}

class LabLShape extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double cornerRadius;
  final double? width;
  final double? height;
  final LabGapSize? padding;
  final Widget? child;

  const LabLShape({
    super.key,
    required this.color,
    this.strokeWidth = 1.0,
    this.cornerRadius = 8.0,
    this.width,
    this.height,
    this.padding,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LabContainer(
      width: width,
      height: height,
      padding: LabEdgeInsets.only(left: padding ?? LabGapSize.s16),
      child: CustomPaint(
        painter: LabLShapePainter(
          color: color,
          strokeWidth: strokeWidth,
          cornerRadius: cornerRadius,
        ),
      ),
    );
  }
}
