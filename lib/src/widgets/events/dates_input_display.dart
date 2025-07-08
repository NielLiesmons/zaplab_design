import 'package:zaplab_design/zaplab_design.dart';

class LabDatesInputDisplay extends StatefulWidget {
  final Map<String, dynamic>?
      startEndData; // {'startDate': DateTime, 'startTime': LabTime?, 'endDate': DateTime, 'endTime': LabTime?, 'isAllDay': bool, 'isEndAllDay': bool}
  final Function(Map<String, dynamic>)? onDateChanged;
  final String
      timezone; // e.g., "UTC+2", "America/New_York", "Europe/London", etc.
  // Best practice: Use IANA timezone identifiers (e.g., "America/New_York")
  // or UTC offsets (e.g., "UTC+2") depending on your app's requirements

  const LabDatesInputDisplay({
    super.key,
    this.startEndData,
    this.onDateChanged,
    this.timezone = "UTC+2",
  });

  @override
  State<LabDatesInputDisplay> createState() => _LabDatesInputDisplayState();
}

class _LabDatesInputDisplayState extends State<LabDatesInputDisplay> {
  Map<String, dynamic>? _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.startEndData;
  }

  @override
  void didUpdateWidget(LabDatesInputDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startEndData != oldWidget.startEndData) {
      _currentData = widget.startEndData;
    }
  }

  Future<void> _openDatePicker(bool isEndDate) async {
    final result = await LabDatePickerModal.show(
      context,
      initialDate: (_currentData?['startDate'] as DateTime?) ?? DateTime.now(),
      initialTime: (_currentData?['startTime'] as LabTime?),
      startAndEndDate: true,
      initialEndDate: (_currentData?['endDate'] as DateTime?),
      initialEndTime: (_currentData?['endTime'] as LabTime?),
      initialEndMode: isEndDate,
      initialAllDay: _currentData?['isAllDay'] as bool? ?? false,
      initialEndAllDay: _currentData?['isEndAllDay'] as bool? ?? false,
    );

    if (result != null) {
      setState(() {
        _currentData = result;
      });
      widget.onDateChanged?.call(result);
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

  bool _isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    final startDate = _currentData?['startDate'] as DateTime?;
    final startTime = _currentData?['startTime'] as LabTime?;
    final endDate = _currentData?['endDate'] as DateTime?;
    final endTime = _currentData?['endTime'] as LabTime?;
    final isAllDay = _currentData?['isAllDay'] as bool? ?? false;
    final isEndAllDay = _currentData?['isEndAllDay'] as bool? ?? false;

    return LabContainer(
      padding: const LabEdgeInsets.all(
        LabGapSize.s16,
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                LabContainer(
                  width: theme.sizes.s16,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const LabGap.s2(),
                      LabContainer(
                        width: theme.sizes.s16,
                        height: theme.sizes.s16,
                        decoration: BoxDecoration(
                          color: theme.colors.white33,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: LabContainer(
                          width: LabLineThicknessData.normal().thick,
                          decoration: BoxDecoration(
                            color: theme.colors.white33,
                          ),
                        ),
                      ),
                      if (isAllDay)
                        LabContainer(
                          width: theme.sizes.s16,
                          height: theme.sizes.s16,
                          decoration: BoxDecoration(
                            color: theme.colors.white33,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
                const LabGap.s16(),
                Expanded(
                  child: Column(
                    children: [
                      LabInputButton(
                        onTap: () => _openDatePicker(false),
                        minHeight: theme.sizes.s64,
                        topAlignment: true,
                        children: [
                          startDate == null
                              ? Row(
                                  children: [
                                    LabText.reg14("Start",
                                        color: theme.colors.white33),
                                    const LabGap.s10(),
                                    LabText.reg14("Date & Time",
                                        color: theme.colors.white16),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        LabText.med14(_formatDate(startDate)),
                                        const LabGap.s10(),
                                        LabText.reg14(startDate.year.toString(),
                                            color: theme.colors.white66),
                                      ],
                                    ),
                                    const LabGap.s4(),
                                    Row(
                                      children: [
                                        LabText.reg14(
                                          isAllDay
                                              ? "All Day"
                                              : _formatTime(startTime),
                                          color: theme.colors.blurpleLightColor,
                                        ),
                                        if (!isAllDay) ...[
                                          const LabGap.s10(),
                                          LabText.reg14(
                                            widget.timezone,
                                            color: theme
                                                .colors.blurpleLightColor66,
                                          ),
                                        ],
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
                      if (!isAllDay) const LabGap.s16(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isAllDay)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LabContainer(
                    width: theme.sizes.s16,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LabContainer(
                          height: theme.sizes.s2,
                          width: LabLineThicknessData.normal().thick,
                          decoration: BoxDecoration(
                            color: theme.colors.white33,
                          ),
                        ),
                        LabContainer(
                          width: theme.sizes.s16,
                          height: theme.sizes.s16,
                          decoration: BoxDecoration(
                            color: theme.colors.white33,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const LabGap.s16(),
                  // Only show end input if not all-day

                  Expanded(
                    child: LabInputButton(
                      onTap: () => _openDatePicker(true),
                      minHeight: _isSameDay(startDate, endDate)
                          ? theme.sizes.s38
                          : theme.sizes.s64,
                      topAlignment:
                          _isSameDay(startDate, endDate) ? false : true,
                      children: [
                        endDate == null
                            ? Row(
                                children: [
                                  LabText.reg14("End",
                                      color: theme.colors.white33),
                                  const LabGap.s10(),
                                  LabText.reg14("Date & Time",
                                      color: theme.colors.white16),
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!_isSameDay(startDate, endDate))
                                    Row(
                                      children: [
                                        LabText.med14(
                                          _formatDate(endDate),
                                          color: _isSameDay(startDate, endDate)
                                              ? theme.colors.white33
                                              : theme.colors.white,
                                        ),
                                        if (!_isSameDay(
                                            startDate, endDate)) ...[
                                          const LabGap.s10(),
                                          LabText.reg14(endDate.year.toString(),
                                              color: theme.colors.white66),
                                        ],
                                      ],
                                    ),
                                  const LabGap.s4(),
                                  Row(
                                    children: [
                                      LabText.reg14(
                                        _formatTime(endTime),
                                        color: theme.colors.blurpleLightColor,
                                      ),
                                      if (!isEndAllDay) ...[
                                        const LabGap.s10(),
                                        LabText.reg14(
                                          widget.timezone,
                                          color:
                                              theme.colors.blurpleLightColor66,
                                        ),
                                      ],
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
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
