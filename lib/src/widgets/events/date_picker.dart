import 'package:zaplab_design/zaplab_design.dart';

class LabDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool preventPastDates;
  final double? dateBoxHeight;

  const LabDatePicker({
    super.key,
    this.initialDate,
    this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.preventPastDates = true,
    this.dateBoxHeight,
  });

  @override
  State<LabDatePicker> createState() => _LabDatePickerState();
}

class _LabDatePickerState extends State<LabDatePicker> {
  late DateTime _selectedDate;
  late ScrollController _scrollController;
  final Map<String, GlobalKey> _buttonKeys = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = widget.initialDate ?? now;
    _scrollController = ScrollController();

    // Scroll to current selection after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelection();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelection() {
    if (!_scrollController.hasClients) return;

    final keyString = _getButtonKey(_selectedDate.year, _selectedDate.month);
    final key = _buttonKeys[keyString];
    final context = key?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        alignment: 0.0, // Align to left edge
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String _getButtonKey(int year, int month) => '${year}_$month';

  void _selectDate(int year, int month) {
    setState(() {
      _selectedDate = DateTime(year, month, _selectedDate.day);
      widget.onDateSelected?.call(_selectedDate);
    });
    _scrollToSelection();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final now = DateTime.now();
    final currentYear = now.year;
    final currentDay = now.day;
    final years = List.generate(41, (index) => currentYear - 20 + index);

    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final buttons = <Widget>[];

    // Add message button if preventPastDates is true
    if (widget.preventPastDates) {
      buttons.add(
        LabPadding(
          padding: const LabEdgeInsets.only(right: LabGapSize.s8),
          child: LabSmallButton(
            onTap: null, // Non-clickable
            rounded: true,
            inactiveColor: theme.colors.white8,
            children: [
              LabText.reg10(
                'Past dates not allowed',
                color: theme.colors.white33,
              ),
            ],
          ),
        ),
      );
    }

    for (final year in years) {
      for (int i = 0; i < monthNames.length; i++) {
        final month = i + 1;
        final monthName = monthNames[i];
        final isSelected =
            year == _selectedDate.year && month == _selectedDate.month;
        final isCurrentMonth = year == now.year && month == now.month;

        // Skip past dates if preventPastDates is true
        if (widget.preventPastDates &&
            (year < now.year || (year == now.year && month < now.month))) {
          continue;
        }

        final keyString = _getButtonKey(year, month);
        if (!_buttonKeys.containsKey(keyString)) {
          _buttonKeys[keyString] = GlobalKey();
        }

        buttons.add(
          LabPadding(
            key: _buttonKeys[keyString],
            padding: const LabEdgeInsets.only(right: LabGapSize.s8),
            child: LabSmallButton(
              onTap: () => _selectDate(year, month),
              rounded: true,
              inactiveColor: isSelected
                  ? null
                  : (isCurrentMonth
                      ? theme.colors.white16
                      : theme.colors.white8),
              children: [
                LabText.reg12(
                  monthName,
                  color: isSelected ? theme.colors.white : theme.colors.white66,
                ),
                LabText.reg12(
                  ' ',
                  color: isSelected ? theme.colors.white : theme.colors.white66,
                ),
                LabText.reg12(
                  year.toString(),
                  color:
                      isSelected ? theme.colors.white66 : theme.colors.white33,
                ),
              ],
            ),
          ),
        );
      }
    }

    return LabPanel(
      padding: const LabEdgeInsets.all(LabGapSize.none),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabContainer(
            padding: const LabEdgeInsets.only(
              left: LabGapSize.s20,
              right: LabGapSize.s12,
              top: LabGapSize.s12,
              bottom: LabGapSize.s12,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              controller: _scrollController,
              child: Row(children: buttons),
            ),
          ),
          const LabDivider(),

          const LabGap.s12(),

          // Calendar grid

          _buildCalendarGrid(theme, currentDay),
          const LabGap.s10(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(LabThemeData theme, int currentDay) {
    final firstDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // Calculate the day of week for the first day (0 = Sunday, 1 = Monday, etc.)
    final firstDayWeekday =
        firstDayOfMonth.weekday % 7; // Convert to 0-based Sunday

    // Weekday headers
    const weekdayHeaders = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    // Generate calendar weeks
    final calendarWeeks = <Widget>[];
    final dateBoxHeight = widget.dateBoxHeight ?? 32.0;

    // Calculate total weeks needed (always 6 weeks to fill the grid)
    const totalWeeks = 6;

    for (int week = 0; week < totalWeeks; week++) {
      final weekDays = <Widget>[];

      for (int dayOfWeek = 0; dayOfWeek < 7; dayOfWeek++) {
        final dayIndex = week * 7 + dayOfWeek;
        final day = dayIndex - firstDayWeekday + 1;

        if (dayIndex < firstDayWeekday) {
          // Previous month's days
          final prevMonth =
              _selectedDate.month == 1 ? 12 : _selectedDate.month - 1;
          final prevYear = _selectedDate.month == 1
              ? _selectedDate.year - 1
              : _selectedDate.year;
          final prevMonthDays = DateTime(prevYear, prevMonth + 1, 0).day;
          final prevMonthDay = prevMonthDays - firstDayWeekday + dayIndex + 1;

          weekDays.add(
            Expanded(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () =>
                      _selectSpecificDate(prevYear, prevMonth, prevMonthDay),
                  child: Container(
                    height: dateBoxHeight,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: LabText.reg12(
                        prevMonthDay.toString(),
                        color: theme.colors.white33,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (day > daysInMonth) {
          // Next month's days
          final nextMonth =
              _selectedDate.month == 12 ? 1 : _selectedDate.month + 1;
          final nextYear = _selectedDate.month == 12
              ? _selectedDate.year + 1
              : _selectedDate.year;
          final nextMonthDay = day - daysInMonth;

          weekDays.add(
            Expanded(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () =>
                      _selectSpecificDate(nextYear, nextMonth, nextMonthDay),
                  child: Container(
                    height: dateBoxHeight,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: LabText.reg12(
                        nextMonthDay.toString(),
                        color: theme.colors.white33,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          // Current month's days
          final isSelected = day == _selectedDate.day;
          final isCurrentDay = day == currentDay &&
              _selectedDate.year == DateTime.now().year &&
              _selectedDate.month == DateTime.now().month;

          weekDays.add(
            Expanded(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _selectDay(day),
                  child: Container(
                    height: dateBoxHeight,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? theme.colors.blurpleColor
                          : isCurrentDay
                              ? theme.colors.white16
                              : null,
                      border: isCurrentDay && !isSelected
                          ? Border.all(
                              color: theme.colors.white33,
                              width: LabLineThicknessData.normal().thin,
                            )
                          : null,
                    ),
                    child: Center(
                      child: LabText.reg12(
                        day.toString(),
                        color: isSelected
                            ? theme.colors.whiteEnforced
                            : theme.colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }

      calendarWeeks.add(
        Row(
          children: weekDays,
        ),
      );

      if (week < totalWeeks - 1) {
        calendarWeeks.add(const LabGap.s4());
      }
    }

    return Column(
      children: [
        // Weekday headers
        Row(
          children: weekdayHeaders
              .map(
                (header) => Expanded(
                  child: Center(
                    child: Text(
                      header,
                      style: theme.typography.reg10.copyWith(
                        color: theme.colors.white66,
                        letterSpacing: 1.6,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const LabGap.s8(),

        // Calendar weeks
        ...calendarWeeks,
      ],
    );
  }

  void _selectDay(int day) {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, day);
      widget.onDateSelected?.call(_selectedDate);
    });
  }

  void _selectSpecificDate(int year, int month, int day) {
    setState(() {
      _selectedDate = DateTime(year, month, day);
      widget.onDateSelected?.call(_selectedDate);
    });
    _scrollToSelection();
  }
}
