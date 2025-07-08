import 'package:zaplab_design/zaplab_design.dart';

class LabDateInputDisplay extends StatefulWidget {
  final DateTime? selectedDate;
  final LabTime? selectedTime;
  final Function(DateTime date, LabTime? time)? onDateChanged;
  final String timezone;

  const LabDateInputDisplay({
    super.key,
    this.selectedDate,
    this.selectedTime,
    this.onDateChanged,
    this.timezone = "UTC+2",
  });

  @override
  State<LabDateInputDisplay> createState() => _LabDateInputDisplayState();
}

class _LabDateInputDisplayState extends State<LabDateInputDisplay> {
  DateTime? _currentDate;
  LabTime? _currentTime;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.selectedDate;
    _currentTime = widget.selectedTime;
  }

  @override
  void didUpdateWidget(LabDateInputDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _currentDate = widget.selectedDate;
    }
    if (widget.selectedTime != oldWidget.selectedTime) {
      _currentTime = widget.selectedTime;
    }
  }

  Future<void> _openDatePicker() async {
    final result = await LabDatePickerModal.show(
      context,
      initialDate: _currentDate ?? DateTime.now(),
      initialTime: _currentTime,
      startAndEndDate: false,
      allowAllDay: false,
    );

    if (result != null) {
      setState(() {
        _currentDate = result['date'] as DateTime?;
        _currentTime = result['time'] as LabTime?;
      });
      if (_currentDate != null) {
        widget.onDateChanged?.call(_currentDate!, _currentTime);
      }
    }
  }

  String _formatDate(DateTime date) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];
    final day = date.day;
    return '$dayName $monthName $day';
  }

  String _formatTime(LabTime? time) {
    if (time == null) return '';
    return time.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    return LabContainer(
      padding: const LabEdgeInsets.all(LabGapSize.s16),
      child: LabInputButton(
        onTap: _openDatePicker,
        minHeight: theme.sizes.s64,
        topAlignment: true,
        children: [
          _currentDate == null
              ? Row(
                  children: [
                    LabText.reg14("Select", color: theme.colors.white33),
                    const LabGap.s10(),
                    LabText.reg14("Date & Time", color: theme.colors.white16),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        LabText.med14(_formatDate(_currentDate!)),
                        const LabGap.s10(),
                        LabText.reg14(_currentDate!.year.toString(),
                            color: theme.colors.white66),
                      ],
                    ),
                    const LabGap.s4(),
                    Row(
                      children: [
                        LabText.reg14(
                          _formatTime(_currentTime),
                          color: theme.colors.blurpleLightColor,
                        ),
                        const LabGap.s10(),
                        LabText.reg14(
                          widget.timezone,
                          color: theme.colors.blurpleLightColor66,
                        ),
                      ],
                    ),
                  ],
                ),
          const Spacer(),
          const LabGap.s12(),
          LabIcon.s12(
            theme.icons.characters.pen,
            color: theme.colors.white33,
          ),
        ],
      ),
    );
  }
}
