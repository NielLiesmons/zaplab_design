import 'package:zaplab_design/zaplab_design.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:tap_builder/tap_builder.dart';
import 'time_amount_modal.dart';

class LabTime {
  final int hour24; // 0-23
  final int minute; // 0-59
  final bool isAM; // true for hours 0-11, false for 12-23

  const LabTime(this.hour24, this.minute, {bool? isAM})
      : isAM = isAM ?? (hour24 < 12);

  factory LabTime.now() {
    final now = DateTime.now();
    final currentMinute = now.minute;
    final nextInterval = ((currentMinute + 4) ~/ 5) * 5;
    final minuteOverflow = nextInterval >= 60;
    final adjustedHour = minuteOverflow ? now.hour + 1 : now.hour;
    final adjustedMinute = minuteOverflow ? 0 : nextInterval;

    return LabTime(
      adjustedHour,
      adjustedMinute,
    );
  }

  // For display in the clock face - shows 13-24 in PM mode
  int get displayHour => isAM ? hour12 : hour24;

  // For 12-hour display format
  int get hour12 => hour24 > 12
      ? hour24 - 12
      : hour24 == 0
          ? 12
          : hour24 == 12
              ? 12
              : hour24;

  // For 24-hour display format, showing 0 for 12 AM
  int get displayHour24 => isAM && hour24 == 12 ? 0 : hour24;

  LabTime copyWith({int? hour24, int? minute, bool? isAM}) {
    return LabTime(
      hour24 ?? this.hour24,
      minute ?? this.minute,
      isAM: isAM,
    );
  }

  @override
  String toString() =>
      '${hour24.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

class LabTimePicker extends StatefulWidget {
  final LabTime? initialTime;
  final Function(LabTime)? onTimeSelected;
  final double? size;
  final bool allowAllDay;
  final Function(bool)? onAllDayChanged;
  final bool initialAllDay;

  const LabTimePicker({
    super.key,
    this.initialTime,
    this.onTimeSelected,
    this.size,
    this.allowAllDay = true,
    this.onAllDayChanged,
    this.initialAllDay = false,
  });

  @override
  State<LabTimePicker> createState() => _LabTimePickerState();
}

class _LabTimePickerState extends State<LabTimePicker> {
  late LabTime _selectedTime;
  late double _clockSize;
  bool _isAllDay = false;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime ?? LabTime.now();
    _clockSize = widget.size ?? 180.0;
    _isAllDay = widget.initialAllDay;
  }

  void _selectHour(int hour) {
    setState(() {
      _selectedTime = _selectedTime.copyWith(hour24: hour);
      widget.onTimeSelected?.call(_selectedTime);
    });
  }

  void _selectMinute(int minute) {
    setState(() {
      _selectedTime = _selectedTime.copyWith(minute: minute);
      widget.onTimeSelected?.call(_selectedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabContainer(
      padding: const LabEdgeInsets.all(LabGapSize.s12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Clock interface
          ImageFiltered(
            enabled: _isAllDay,
            imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: SizedBox(
              width: _clockSize,
              height: _clockSize,
              child: Stack(
                children: [
                  // Clock background circle
                  Center(
                    child: LabContainer(
                      width: _clockSize,
                      height: _clockSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colors.white8,
                      ),
                    ),
                  ),

                  // Hour buttons (outer ring)
                  ..._buildHourButtons(theme),

                  // Minute buttons (inner ring)
                  ..._buildMinuteButtons(theme),

                  // Selection lines on top but ignoring pointer events
                  IgnorePointer(
                    child: Stack(
                      children: _buildSelectionLines(theme),
                    ),
                  ),

                  // Center dot
                  Center(
                    child: LabContainer(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const LabGap.s20(),

          // AM/PM selector
          SizedBox(
            width: 128,
            child: Column(
              children: [
                ImageFiltered(
                  enabled: _isAllDay,
                  imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: TapBuilder(
                    onTap: _isAllDay
                        ? null
                        : () async {
                            await LabTimeAmountModal.show(
                              context,
                              initialTime: _selectedTime,
                              onTimeChanged: (time) {
                                setState(() {
                                  _selectedTime = time;
                                  widget.onTimeSelected?.call(time);
                                });
                              },
                            );
                          },
                    builder: (context, state, hasFocus) {
                      return LabContainer(
                        width: 128,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: theme.radius.asBorderRadius().rad16,
                          border: Border.all(
                            color: theme.colors.white16,
                            width: LabLineThicknessData.normal().medium,
                          ),
                        ),
                        padding: const LabEdgeInsets.all(LabGapSize.s8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LabText.h1(
                              _selectedTime.displayHour24
                                  .toString()
                                  .padLeft(2, '0'),
                              color: theme.colors.white,
                            ),
                            const LabGap.s4(),
                            LabText.h1(
                              ":",
                              color: theme.colors.white66,
                            ),
                            const LabGap.s4(),
                            LabText.h1(
                              _selectedTime.minute.toString().padLeft(2, '0'),
                              color: theme.colors.white,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const LabGap.s16(),
                ImageFiltered(
                  enabled: _isAllDay,
                  imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: LabSelector(
                    small: true,
                    isLight: true,
                    initialIndex: _selectedTime.isAM ? 0 : 1,
                    onChanged: (index) {
                      setState(() {
                        final newIsAM = index == 0;
                        final currentHour = _selectedTime.hour24;

                        // Convert between AM/PM by adding/subtracting 12
                        final newHour = newIsAM
                            ? (currentHour >= 12
                                ? currentHour - 12
                                : currentHour)
                            : (currentHour < 12
                                ? currentHour + 12
                                : currentHour);

                        _selectedTime = _selectedTime.copyWith(
                          hour24: newHour,
                          isAM: newIsAM,
                        );
                        widget.onTimeSelected?.call(_selectedTime);
                      });
                    },
                    children: [
                      LabSelectorButton(
                        selectedContent: const [
                          LabText.med12('AM'),
                        ],
                        unselectedContent: [
                          LabText.med12('AM', color: theme.colors.white66),
                        ],
                        isSelected: _selectedTime.isAM,
                      ),
                      LabSelectorButton(
                        selectedContent: const [
                          LabText.med12('PM'),
                        ],
                        unselectedContent: [
                          LabText.med12('PM', color: theme.colors.white66),
                        ],
                        isSelected: !_selectedTime.isAM,
                      ),
                    ],
                  ),
                ),
                if (widget.allowAllDay) const LabGap.s16(),
                if (widget.allowAllDay)
                  LabPanel(
                    padding: const LabEdgeInsets.all(LabGapSize.s12),
                    color: theme.colors.white8,
                    child: Row(
                      children: [
                        Opacity(
                          opacity: widget.allowAllDay ? 1 : 0.66,
                          child: LabSwitch(
                            value: _isAllDay,
                            onChanged: widget.allowAllDay
                                ? (value) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      setState(() => _isAllDay = value);
                                      widget.onAllDayChanged?.call(value);
                                    });
                                  }
                                : null,
                          ),
                        ),
                        const LabGap.s12(),
                        LabText.reg14(
                          'All Day',
                          color: widget.allowAllDay
                              ? theme.colors.white
                              : theme.colors.white33,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHourButtons(LabThemeData theme) {
    final buttons = <Widget>[];
    final radius = _clockSize / 2;
    const buttonRadius = 14.0;
    final outerRadius = radius - buttonRadius - 4;

    for (int clockPosition = 1; clockPosition <= 12; clockPosition++) {
      final angle = (clockPosition - 3) * (2 * math.pi / 12);
      final x = radius + outerRadius * math.cos(angle);
      final y = radius + outerRadius * math.sin(angle);

      // Convert clock position to hour24 value
      final hour24 = _selectedTime.isAM
          ? (clockPosition == 12 ? 0 : clockPosition) // AM: 12 shows as 0
          : (clockPosition == 12
              ? 12
              : clockPosition + 12); // PM: 12 stays 12, rest are +12

      final isSelected = hour24 == _selectedTime.hour24;

      buttons.add(
        Positioned(
          left: x - buttonRadius,
          top: y - buttonRadius,
          child: TapBuilder(
            onTap: () => _selectHour(hour24),
            builder: (context, state, isFocused) {
              return LabContainer(
                width: buttonRadius * 2,
                height: buttonRadius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? theme.colors.blurpleColor
                      : theme.colors.black16,
                ),
                child: Center(
                  child: LabText.reg12(
                    hour24.toString(),
                    color: isSelected
                        ? theme.colors.whiteEnforced
                        : theme.colors.white,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return buttons;
  }

  List<Widget> _buildMinuteButtons(LabThemeData theme) {
    final buttons = <Widget>[];
    final radius = _clockSize / 2;
    const buttonRadius = 10.5;
    final innerRadius = radius - buttonRadius - 34;

    for (int i = 0; i < 12; i++) {
      final minute = i * 5;
      final angle = (i - 3) * (2 * math.pi / 12);
      final x = radius + innerRadius * math.cos(angle);
      final y = radius + innerRadius * math.sin(angle);
      final isSelected = minute == _selectedTime.minute;

      buttons.add(
        Positioned(
          left: x - buttonRadius,
          top: y - buttonRadius,
          child: TapBuilder(
            onTap: () => _selectMinute(minute),
            builder: (context, state, isFocused) {
              return LabContainer(
                width: buttonRadius * 2,
                height: buttonRadius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? theme.colors.blurpleColor
                      : theme.colors.black33,
                ),
                child: Center(
                  child: LabText.reg10(
                    minute.toString(),
                    color: isSelected
                        ? theme.colors.whiteEnforced
                        : theme.colors.white66,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return buttons;
  }

  List<Widget> _buildSelectionLines(LabThemeData theme) {
    final lines = <Widget>[];
    final radius = _clockSize / 2;

    final hourAngle = (_selectedTime.hour12 - 3) * (2 * math.pi / 12);
    final hourRadius = radius - 62; // Longer line
    final hourEndX = radius + hourRadius * math.cos(hourAngle);
    final hourEndY = radius + hourRadius * math.sin(hourAngle);
    final hourOverlayRadius = radius - 32;
    final hourOverlayEndX = radius + hourOverlayRadius * math.cos(hourAngle);
    final hourOverlayEndY = radius + hourOverlayRadius * math.sin(hourAngle);

    lines.add(
      CustomPaint(
        size: Size(_clockSize, _clockSize),
        painter: LinePainter(
          startX: radius,
          startY: radius,
          endX: hourOverlayEndX,
          endY: hourOverlayEndY,
          color: theme.colors.blurpleColor33,
          width: LabLineThicknessData.normal().thick,
        ),
      ),
    );

    lines.add(
      CustomPaint(
        size: Size(_clockSize, _clockSize),
        painter: LinePainter(
          startX: radius,
          startY: radius,
          endX: hourEndX,
          endY: hourEndY,
          color: theme.colors.blurpleColor,
          width: LabLineThicknessData.normal().thick,
        ),
      ),
    );

    final minuteAngle = (_selectedTime.minute / 5) * (2 * math.pi / 12) -
        (3 * 2 * math.pi / 12);
    final minuteRadius = radius - 54; // Longer line
    final minuteEndX = radius + minuteRadius * math.cos(minuteAngle);
    final minuteEndY = radius + minuteRadius * math.sin(minuteAngle);

    lines.add(
      CustomPaint(
        size: Size(_clockSize, _clockSize),
        painter: LinePainter(
          startX: radius,
          startY: radius,
          endX: minuteEndX,
          endY: minuteEndY,
          color: theme.colors.blurpleColor,
          width: LabLineThicknessData.normal().thick,
        ),
      ),
    );

    return lines;
  }
}

class LinePainter extends CustomPainter {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final Color color;
  final double width;

  LinePainter({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.color,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
