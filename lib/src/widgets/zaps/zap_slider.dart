import 'dart:math' as math;
import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

typedef ZapRecord = ({double amount, Profile profile});

class LabZapSlider extends StatefulWidget {
  final Profile? profile;
  final double initialValue;
  final ValueChanged<double>? onValueChanged;
  final List<double>? recentAmounts;
  final List<({double amount, Profile profile})> otherZaps;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrProfileSearch onSearchProfiles;
  final NostrEmojiSearch onSearchEmojis;
  final VoidCallback onCameraTap;
  final VoidCallback onEmojiTap;
  final VoidCallback onGifTap;
  final VoidCallback onAddTap;
  final Function(Profile) onProfileTap;

  const LabZapSlider({
    super.key,
    this.profile,
    this.initialValue = 100,
    this.onValueChanged,
    this.recentAmounts,
    this.otherZaps = const [],
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onSearchProfiles,
    required this.onSearchEmojis,
    required this.onCameraTap,
    required this.onEmojiTap,
    required this.onGifTap,
    required this.onAddTap,
    required this.onProfileTap,
  });

  @override
  State<LabZapSlider> createState() => _LabZapSliderState();
}

class _LabZapSliderState extends State<LabZapSlider> {
  // Slider state and configuration
  double _value = 0.0;
  final double _startAngle = math.pi * 3 / 4; // Start at 315 degrees
  final double _totalAngle = 3 * math.pi / 2; // Sweep 270 degrees (3/4 circle)

  // Fixed range for logarithmic scale
  static const double _minValue = 0.0;
  static const double _maxValue = 1000001.0;

  // Reference for precise touch positioning
  final _customPaintKey = GlobalKey();

  // Add state variable for message
  String _message = '';

  // Add focus node for text field
  late FocusNode _focusNode;
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue.clamp(_minValue, _maxValue);
    _focusNode = FocusNode();
    _messageController = TextEditingController(text: _message);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return Column(
      children: [
        SizedBox(
          height: 296,
          child: Center(
            child: SizedBox(
              width: 320,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanStart: (details) =>
                          _handleTouch(details.localPosition),
                      onPanUpdate: (details) =>
                          _handleTouch(details.localPosition),
                      onTapDown: (details) =>
                          _handleTouch(details.localPosition),
                      onVerticalDragStart: (details) =>
                          _handleTouch(details.localPosition),
                      onVerticalDragUpdate: (details) =>
                          _handleTouch(details.localPosition),
                      child: SizedBox(
                        width: 320,
                        height: 320,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              key: _customPaintKey,
                              size: const Size(320, 320),
                              painter: LabZapSliderPainter(
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
                                markerThickness:
                                    LabLineThicknessData.normal().thin,
                                markerColor: theme.colors.white33,
                                labelStyle: theme.typography.med12,
                                labelColor: theme.colors.white33,
                                markerToLabelGap: theme.sizes.s6,
                                otherZaps: widget.otherZaps,
                              ),
                            ),
                            ...widget.otherZaps.map((zapData) {
                              final percentage = zapData.amount <= 0
                                  ? 0.0
                                  : math.log(zapData.amount + 1) /
                                      math.log(_maxValue + 1);
                              final angle =
                                  _startAngle + (percentage * _totalAngle);

                              // Calculate position for profile pic
                              const radius = 100.0;
                              const outerRadius = radius +
                                  24 +
                                  6; // Reduced from 12 to 6 to move closer to markers

                              return Positioned(
                                left: 160 +
                                    (outerRadius + 9) * math.cos(angle) -
                                    9,
                                top: 160 +
                                    (outerRadius + 9) * math.sin(angle) -
                                    9,
                                child: LabProfilePic.s18(zapData.profile),
                              );
                            }),
                            Positioned(
                              left: 108,
                              top: 108,
                              child: LabProfilePic.s104(widget.profile),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        LabContainer(
          decoration: BoxDecoration(
            color: theme.colors.black33,
            borderRadius: theme.radius.asBorderRadius().rad16,
            border: Border.all(
              color: theme.colors.white33,
              width: LabLineThicknessData.normal().thin,
            ),
          ),
          child: Column(
            children: [
              TapBuilder(
                onTap: _handleAmountTap,
                builder: (context, state, hasFocus) {
                  return LabContainer(
                    padding: const LabEdgeInsets.symmetric(
                      horizontal: LabGapSize.s16,
                      vertical: LabGapSize.s12,
                    ),
                    child: Row(
                      children: [
                        LabIcon.s16(
                          theme.icons.characters.zap,
                          gradient: theme.colors.gold,
                        ),
                        const LabGap.s8(),
                        LabAmount(
                          _value,
                          level: LabTextLevel.h2,
                          color: theme.colors.white,
                        ),
                        const LabGap.s12(),
                        const Spacer(),
                        if (widget.otherZaps.isNotEmpty &&
                            _value >
                                widget.otherZaps
                                    .map((z) => z.amount)
                                    .reduce(math.max))
                          LabContainer(
                            decoration: BoxDecoration(
                              gradient: theme.colors.gold16,
                              borderRadius: theme.radius.asBorderRadius().rad16,
                            ),
                            padding: const LabEdgeInsets.symmetric(
                              horizontal: LabGapSize.s12,
                              vertical: LabGapSize.s4,
                            ),
                            child: LabText.med12(
                              'Top Zap',
                              gradient: theme.colors.gold,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const LabDivider.horizontal(),
              TapBuilder(
                onTap: _handleMessageTap,
                builder: (context, state, hasFocus) {
                  return LabContainer(
                    padding: const LabEdgeInsets.symmetric(
                      horizontal: LabGapSize.s16,
                      vertical: LabGapSize.s16,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _message.isEmpty
                          ? LabText.med14(
                              'Your Message',
                              color: LabTheme.of(context).colors.white33,
                            )
                          : LabText.reg14(
                              _message,
                              color: LabTheme.of(context).colors.white,
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                    ),
                  );
                },
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

    // Normalize angle relative to start angle
    var adjustedAngle = angle - _startAngle;
    if (angle > math.pi / 2.75 && angle < math.pi * 3 / 4) {
      // If we're in the forbidden zone, force to minimum value
      adjustedAngle = 0;
    } else {
      // Normal angle handling for valid zones
      if (adjustedAngle < 0) {
        adjustedAngle += 2 * math.pi;
      }
      adjustedAngle = adjustedAngle.clamp(0.0, _totalAngle);
    }

    // Convert angle to logarithmic value
    final percentage = adjustedAngle / _totalAngle;
    final logValue = percentage * math.log(_maxValue + 1);
    final newValue = (math.exp(logValue) - 1).toDouble();

    setState(() {
      _value = newValue.clamp(_minValue, _maxValue);
      widget.onValueChanged?.call(_value);
    });
  }

  void _handleMessageTap() async {
    _messageController.text = _message;
    final theme = LabTheme.of(context);

    // Request focus before showing the modal
    _focusNode.requestFocus();

    await LabInputModal.show(
      context,
      children: [
        LabShortTextField(
          focusNode: _focusNode,
          controller: _messageController,
          onChanged: (value) {
            setState(() {
              _message = value;
            });
          },
          placeholder: _message.isEmpty
              ? [
                  LabText.reg16(
                    'Your Message',
                    color: theme.colors.white33,
                  ),
                ]
              : null,
          onResolveEvent: widget.onResolveEvent,
          onResolveProfile: widget.onResolveProfile,
          onResolveEmoji: widget.onResolveEmoji,
          onSearchProfiles: widget.onSearchProfiles,
          onSearchEmojis: widget.onSearchEmojis,
          onCameraTap: widget.onCameraTap,
          onEmojiTap: widget.onEmojiTap,
          onGifTap: widget.onGifTap,
          onAddTap: widget.onAddTap,
          onProfileTap: (profile) => widget.onProfileTap(profile),
          onDoneTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void _handleAmountTap() async {
    await LabZapAmountModal.show(
      context,
      initialAmount: _value,
      recentAmounts: widget.recentAmounts ?? [],
      onAmountChanged: (value) {
        setState(() {
          _value = value;
          widget.onValueChanged?.call(value);
        });
      },
    );
  }
}

class LabZapSliderPainter extends CustomPainter {
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
  final List<({double amount, Profile profile})> otherZaps;

  final double backgroundThickness;
  final double valueThickness;
  final double handleSize;
  final double markerLength;
  final double markerThickness;
  static const double _maxValue = 1000000.0;

  const LabZapSliderPainter({
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
    required this.otherZaps,
    this.backgroundThickness = 48.0,
    this.valueThickness = 32.0,
    this.handleSize = 24.0,
    this.markerLength = 12.0,
    this.markerThickness = 1.0,
    this.markerToLabelGap = 16.0,
  });

  void _drawZapMarker(Canvas canvas, Offset center,
      ({double amount, Profile profile}) zapData) {
    final percentage = zapData.amount <= 0
        ? 0.0
        : math.log(zapData.amount + 1) / math.log(_maxValue + 1);
    final angle = startAngle + (percentage * totalAngle);

    final markerPaint = Paint()
      ..shader = valueGradient.createShader(
        Rect.fromCircle(center: center, radius: 100.0),
      )
      ..strokeWidth = LabLineThicknessData.normal().medium
      ..strokeCap = StrokeCap.round;

    const radius = 100.0;
    final innerRadius = radius - (backgroundThickness / 2);
    final outerRadius = radius + (backgroundThickness / 2) + markerLength;

    final startPoint = Offset(
      center.dx + innerRadius * math.cos(angle),
      center.dy + innerRadius * math.sin(angle),
    );

    final endPoint = Offset(
      center.dx + outerRadius * math.cos(angle),
      center.dy + outerRadius * math.sin(angle),
    );

    canvas.drawLine(startPoint, endPoint, markerPaint);
  }

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

    // First draw other users' zap markers (behind everything)
    for (final zapData in otherZaps) {
      _drawZapMarker(canvas, center, zapData);
    }

    // Then draw background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = backgroundThickness
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, totalAngle, false, backgroundPaint);

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
              (i) => (i + 1) / valueGradient.colors.length),
          0.999999,
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

    final handlePaint = Paint()..color = LabColorsData.dark().whiteEnforced;

    canvas.drawCircle(handlePosition, handleSize / 2, handlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
