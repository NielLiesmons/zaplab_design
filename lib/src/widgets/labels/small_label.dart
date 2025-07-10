import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabSmallLabel extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isEmphasized;
  final VoidCallback? onTap;

  const LabSmallLabel(
    this.text, {
    super.key,
    this.isSelected = false,
    this.isEmphasized = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return TapBuilder(
      onTap: onTap,
      builder: (context, state, hasFocus) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.99;
        } else if (state == TapState.hover) {
          scaleFactor = 1.01;
        }

        return Transform.scale(
          scale: scaleFactor,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main label container
              LabContainer(
                height: theme.sizes.s24,
                constraints: const BoxConstraints(maxWidth: 200),
                padding: const LabEdgeInsets.only(
                  left: LabGapSize.s8,
                ),
                decoration: BoxDecoration(
                  color: isSelected || isEmphasized
                      ? theme.colors.blurpleColor33
                      : theme.colors.white8,
                  borderRadius: BorderRadius.only(
                    topLeft: theme.radius.rad8,
                    bottomLeft: theme.radius.rad8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: LabIcon.s10(
                          theme.icons.characters.check,
                          outlineColor: theme.colors.white,
                          outlineThickness: LabLineThicknessData.normal().thick,
                        ),
                      ),
                    Flexible(
                      child: LabText.reg12(
                        text,
                        color: isSelected || isEmphasized
                            ? theme.colors.white
                            : theme.colors.white66,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // House shape
              CustomPaint(
                size: const Size(20, 24),
                painter: HouseShapePainter2(
                  color: isSelected || isEmphasized
                      ? theme.colors.blurpleColor33
                      : theme.colors.white8,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HouseShapePainter2 extends CustomPainter {
  final Color color;

  HouseShapePainter2({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw the main house shape
    final path = Path()
      // Start at top-right of container (0,0)
      ..moveTo(0, 0)
      ..lineTo(4, 0)
      ..arcToPoint(
        const Offset(12, 4),
        radius: const Radius.circular(16),
      )
      ..lineTo(18, 10)
      ..arcToPoint(
        const Offset(18, 14),
        radius: const Radius.circular(4),
      )
      ..lineTo(12, 20)
      ..arcToPoint(
        const Offset(4, 24),
        radius: const Radius.circular(16),
      )
      // Line to last point (0,32)
      ..lineTo(0, 24)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// LabLabel
