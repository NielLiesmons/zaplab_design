import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppLabel extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isEmphasized;
  final VoidCallback? onTap;

  const AppLabel(
    this.text, {
    super.key,
    this.isSelected = false,
    this.isEmphasized = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

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
              AppContainer(
                height: theme.sizes.s32,
                constraints: const BoxConstraints(maxWidth: 200),
                padding: const AppEdgeInsets.only(
                  left: AppGapSize.s12,
                ),
                decoration: BoxDecoration(
                  color: isSelected || isEmphasized
                      ? theme.colors.blurpleColor33
                      : theme.colors.white8,
                  borderRadius: BorderRadius.only(
                    topLeft: theme.radius.rad12,
                    bottomLeft: theme.radius.rad12,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: AppIcon.s10(
                          theme.icons.characters.check,
                          outlineColor: theme.colors.white,
                          outlineThickness: AppLineThicknessData.normal().thick,
                        ),
                      ),
                    Flexible(
                      child: AppText.reg14(
                        text,
                        color: isSelected || isEmphasized
                            ? AppColorsData.dark().white
                            : theme.colors.white66,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // House shape
              CustomPaint(
                size: const Size(24, 32),
                painter: HouseShapePainter(
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

class HouseShapePainter extends CustomPainter {
  final Color color;

  HouseShapePainter({required this.color});

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
        Offset(14, 6),
        radius: const Radius.circular(16),
      )
      ..lineTo(23, 14)
      ..arcToPoint(
        Offset(23, 18),
        radius: const Radius.circular(4),
      )
      ..lineTo(14, 26)
      ..arcToPoint(
        Offset(4, 32),
        radius: const Radius.circular(16),
      )
      // Line to last point (0,32)
      ..lineTo(0, 32)
      ..close();

    // // Draw the circular cutout
    // final cutoutPath = Path()
    //   ..addOval(Rect.fromCircle(
    //     center: Offset(size.width / 2 + 1, size.height / 2),
    //     radius: 3,
    //   ));

    // // Combine the paths using Path.combine with PathOperation.difference
    // final finalPath = Path.combine(
    //   PathOperation.difference,
    //   path,
    //   cutoutPath,
    // );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// AppLabel
