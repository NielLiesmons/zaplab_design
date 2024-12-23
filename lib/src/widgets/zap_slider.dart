import 'dart:math' as math;
import 'package:zaplab_design/zaplab_design.dart';

class AppZapSlider extends StatefulWidget {
  final void Function(double)? onValueChanged;
  final double initialValue;

  const AppZapSlider({
    super.key,
    this.onValueChanged,
    this.initialValue = 100.0,
  });

  @override
  State<AppZapSlider> createState() => _AppZapSliderState();
}

class _AppZapSliderState extends State<AppZapSlider> {
  // Slider state and configuration
  double _value = 0.0;
  final double _startAngle = math.pi * 3 / 4; // Start at 315 degrees
  final double _totalAngle = 3 * math.pi / 2; // Sweep 270 degrees (3/4 circle)

  // Fixed range for logarithmic scale
  static const double _minValue = 0.0;
  static const double _maxValue = 1000001.0;

  // Reference for precise touch positioning
  final _customPaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue.clamp(_minValue, _maxValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Column(
      children: [
        // Gesture handler prevents modal scroll while allowing slider interaction
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) => _handleTouch(details.localPosition),
          onPanUpdate: (details) => _handleTouch(details.localPosition),
          onTapDown: (details) => _handleTouch(details.localPosition),
          onVerticalDragStart: (details) => _handleTouch(details.localPosition),
          onVerticalDragUpdate: (details) =>
              _handleTouch(details.localPosition),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                key: _customPaintKey,
                size: const Size(256, 256),
                painter: AppZapSliderPainter(
                  value: _value,
                  min: _minValue,
                  max: _maxValue,
                  backgroundColor: theme.colors.black33,
                  valueGradient: theme.colors.gold,
                  startAngle: _startAngle,
                  totalAngle: _totalAngle,
                  backgroundThickness: theme.sizes.s48,
                  valueThickness: theme.sizes.s32,
                  handleSize: theme.sizes.s24,
                  markerLength: theme.sizes.s8,
                  markerThickness: LineThicknessData.normal().thin,
                  markerColor: theme.colors.white33,
                  labelStyle: theme.typography.med12,
                  labelColor: theme.colors.white33,
                  markerToLabelGap: theme.sizes.s6,
                ),
              ),
              const AppProfilePic.s104('no url yet'),
            ],
          ),
        ),
        const AppGap.s8(),
        AppContainer(
          decoration: BoxDecoration(
            color: theme.colors.black33,
            borderRadius: theme.radius.asBorderRadius().rad16,
            border: Border.all(
              color: theme.colors.white33,
              width: LineThicknessData.normal().thin,
            ),
          ),
          child: Column(
            children: [
              AppContainer(
                padding: const AppEdgeInsets.symmetric(
                  horizontal: AppGapSize.s16,
                  vertical: AppGapSize.s12,
                ),
                child: Row(
                  children: [
                    AppIcon.s16(
                      theme.icons.characters.zap,
                      gradient: theme.colors.gold,
                    ),
                    AppGap.s12(),
                    AppAmount(
                      _value,
                      level: AppTextLevel.h2,
                      color: theme.colors.white,
                    ),
                    AppGap.s12(),
                  ],
                ),
              ),
              const AppDivider.horizontal(),
              AppContainer(
                padding: const AppEdgeInsets.symmetric(
                  horizontal: AppGapSize.s16,
                  vertical: AppGapSize.s12,
                ),
                child: AppTextField(
                  placeholder: [
                    AppText.med16(
                      'Your Message',
                      color: theme.colors.white33,
                    ),
                  ],
                  onChanged: (value) {
                    // Handle message input
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Converts touch position to slider value using logarithmic scale
  void _handleTouch(Offset position) {
    final RenderBox? renderBox =
        _customPaintKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final center = Offset(size.width / 2, size.height / 2);
    final touchPoint = position;

    final angle = math.atan2(
      touchPoint.dy - center.dy,
      touchPoint.dx - center.dx,
    );

    // Normalize angle to our 3/4 circle range
    var adjustedAngle = angle - _startAngle;
    if (adjustedAngle < 0) {
      adjustedAngle += 2 * math.pi;
    }
    adjustedAngle = adjustedAngle.clamp(0.0, _totalAngle);

    // Convert angle to logarithmic value
    final percentage = adjustedAngle / _totalAngle;
    final logValue = percentage * math.log(_maxValue + 1);
    final newValue = (math.exp(logValue) - 1).toDouble();

    setState(() {
      _value = newValue.clamp(_minValue, _maxValue);
      widget.onValueChanged?.call(_value);
    });
  }
}

class AppZapSliderPainter extends CustomPainter {
  final double value;
  final double min;
  final double max;
  final Color backgroundColor;
  final Gradient valueGradient;
  final double startAngle;
  final double totalAngle;
  final Color markerColor;
  final TextStyle labelStyle;
  final Color labelColor;
  final double markerToLabelGap;

  // Remove static modifiers and move to constructor
  final double backgroundThickness;
  final double valueThickness;
  final double handleSize;
  final double markerLength;
  final double markerThickness;
  static const double _maxValue = 1000000.0;

  const AppZapSliderPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.backgroundColor,
    required this.valueGradient,
    required this.startAngle,
    required this.totalAngle,
    required this.markerColor,
    required this.labelStyle,
    required this.labelColor,
    this.backgroundThickness =
        48.0, // Default values for when theme isn't available
    this.valueThickness = 32.0,
    this.handleSize = 24.0,
    this.markerLength = 12.0,
    this.markerThickness = 1.0,
    this.markerToLabelGap = 16.0,
  });

  void _drawMarkerLine(Canvas canvas, Offset center, double value) {
    // Convert value to angle using logarithmic scale
    final percentage =
        value <= 0 ? 0.0 : math.log(value + 1) / math.log(_maxValue + 1);
    final angle = startAngle + (percentage * totalAngle);

    final markerPaint = Paint()
      ..color = markerColor
      ..strokeWidth = markerThickness
      ..strokeCap = StrokeCap.round;

    // Calculate start point (inner edge of arc)
    const radius = 100.0;
    final innerRadius = radius - (backgroundThickness / 2);
    final startPoint = Offset(
      center.dx + innerRadius * math.cos(angle),
      center.dy + innerRadius * math.sin(angle),
    );

    // Calculate end point (outer edge of arc + extra length)
    final outerRadius = radius + (backgroundThickness / 2) + markerLength;
    final endPoint = Offset(
      center.dx + outerRadius * math.cos(angle),
      center.dy + outerRadius * math.sin(angle),
    );

    canvas.drawLine(startPoint, endPoint, markerPaint);

    // Draw the label
    _drawMarkerLabel(canvas, center, value, angle, outerRadius + 8);
  }

  void _drawMarkerLabel(
      Canvas canvas, Offset center, double value, double angle, double radius) {
    final labelText = value >= 1000000
        ? '${(value / 1000000).toInt()}M'
        : value >= 1000
            ? '${(value / 1000).toInt()}K'
            : value.toInt().toString();

    final textPainter = TextPainter(
      text: TextSpan(
        text: labelText,
        style: labelStyle.copyWith(color: labelColor),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Calculate position for the text with increased gap
    final labelPosition = Offset(
      center.dx +
          (radius + markerToLabelGap) * math.cos(angle) -
          textPainter.width / 2,
      center.dy +
          (radius + markerToLabelGap) * math.sin(angle) -
          textPainter.height / 2,
    );

    textPainter.paint(canvas, labelPosition);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 100.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Draw background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = backgroundThickness
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      startAngle,
      totalAngle,
      false,
      backgroundPaint,
    );

    // Draw markers at specific values
    final markerValues = [0, 10, 100, 1000, 10000, 100000, 1000000];
    for (final markerValue in markerValues) {
      _drawMarkerLine(canvas, center, markerValue.toDouble());
    }

    final valuePaint = Paint()
      ..shader = SweepGradient(
        colors: [...valueGradient.colors, valueGradient.colors.first],
        stops: [
          0.0,
          ...List.generate(valueGradient.colors.length - 1,
                  (i) => (i + 1) / (valueGradient.colors.length - 1))
              .map((v) => v * 0.9999),
          1.0
        ],
        startAngle: 0,
        endAngle: 2 * math.pi,
        transform: GradientRotation(startAngle - math.pi / 2),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = valueThickness
      ..strokeCap = StrokeCap.round;

    // Convert value to angle using logarithmic scale
    final percentage =
        value <= 0 ? 0.0 : math.log(value + 1) / math.log(_maxValue + 1);
    final sweepAngle = percentage * totalAngle;
    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      valuePaint,
    );

    final handleAngle = startAngle + sweepAngle;
    final handlePosition = Offset(
      center.dx + radius * math.cos(handleAngle),
      center.dy + radius * math.sin(handleAngle),
    );

    final handlePaint = Paint()..color = AppColorsData.dark().white;

    canvas.drawCircle(handlePosition, handleSize / 2, handlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
