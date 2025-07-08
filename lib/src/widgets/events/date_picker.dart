import 'package:zaplab_design/zaplab_design.dart';

class LabDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool preventPastDates;
  final double? dateBoxHeight;
  final DateTime? startDate;

  const LabDatePicker({
    super.key,
    this.initialDate,
    this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.preventPastDates = true,
    this.dateBoxHeight,
    this.startDate,
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
  void didUpdateWidget(LabDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate &&
        widget.initialDate != null) {
      setState(() {
        _selectedDate = widget.initialDate!;
      });
      // Scroll to the new selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelection();
      });
    }
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
      final RenderBox box = context.findRenderObject() as RenderBox;
      final RenderBox? scrollBox =
          _scrollController.position.context.storageContext.findRenderObject()
              as RenderBox?;
      if (scrollBox != null) {
        final position = box.localToGlobal(Offset.zero, ancestor: scrollBox);
        final double targetOffset = _scrollController.offset + position.dx;
        _scrollController.animateTo(
          targetOffset,
          duration: LabDurationsData.normal().normal,
          curve: Curves.easeInOut,
        );
      }
    }
  }

  String _getButtonKey(int year, int month) => '${year}_$month';

  Color? _getDateBackgroundColor(
      DateTime date, bool isSelected, bool isCurrentDay) {
    final theme = LabTheme.of(context);

    if (isSelected) {
      return theme.colors.blurpleColor;
    }

    // Check if this date is in the range (including start date)
    if (widget.startDate != null && _selectedDate.isAfter(widget.startDate!)) {
      final isInRange = (date.isAfter(widget.startDate!) ||
              date.isAtSameMomentAs(widget.startDate!)) &&
          (date.isBefore(_selectedDate) ||
              date.isAtSameMomentAs(_selectedDate));
      if (isInRange) {
        return theme.colors.blurpleColor.withValues(alpha: 0.66);
      }
    }

    // Default colors
    if (isCurrentDay) {
      return theme.colors.white16;
    }

    return null;
  }

  Border? _getDateBorder(DateTime date, bool isSelected, bool isCurrentDay) {
    final theme = LabTheme.of(context);

    // Default border for current day
    if (isCurrentDay && !isSelected) {
      return Border.all(
        color: theme.colors.white33,
        width: LabLineThicknessData.normal().thin,
      );
    }

    return null;
  }

  bool _isDateInRange(DateTime date) {
    if (widget.startDate == null || !_selectedDate.isAfter(widget.startDate!)) {
      return false;
    }
    return (date.isAfter(widget.startDate!) ||
            date.isAtSameMomentAs(widget.startDate!)) &&
        (date.isBefore(_selectedDate) || date.isAtSameMomentAs(_selectedDate));
  }

  Color _getDividerColor(int dayIndex, int totalDays) {
    if (widget.startDate == null || !_selectedDate.isAfter(widget.startDate!)) {
      return const Color(0x00000000); // Transparent
    }

    final currentDate =
        DateTime(_selectedDate.year, _selectedDate.month, dayIndex);
    final nextDate =
        DateTime(_selectedDate.year, _selectedDate.month, dayIndex + 1);

    // Show divider if current date is in range and next date is also in range
    // This includes the case where current date is the start date
    if (_isDateInRange(currentDate) && _isDateInRange(nextDate)) {
      final theme = LabTheme.of(context);
      return theme.colors.blurpleColor.withValues(alpha: 0.66);
    }

    // Special case: if current date is the start date and we're in the same month
    if (widget.startDate != null &&
        currentDate.year == widget.startDate!.year &&
        currentDate.month == widget.startDate!.month &&
        currentDate.day == widget.startDate!.day &&
        _isDateInRange(nextDate)) {
      final theme = LabTheme.of(context);
      return theme.colors.blurpleColor.withValues(alpha: 0.66);
    }

    return const Color(0x00000000); // Transparent
  }

  Color _getDividerColorForDate(DateTime currentDate, int day) {
    if (widget.startDate == null || !_selectedDate.isAfter(widget.startDate!)) {
      return const Color(0x00000000); // Transparent
    }

    // Create the next date (this might be in the next month)
    final nextDate = currentDate.add(const Duration(days: 1));

    // Show divider if current date is in range and next date is also in range
    if (_isDateInRange(currentDate) && _isDateInRange(nextDate)) {
      final theme = LabTheme.of(context);
      return theme.colors.blurpleColor.withValues(alpha: 0.66);
    }

    // Special case: if current date is the start date
    if (widget.startDate != null &&
        currentDate.year == widget.startDate!.year &&
        currentDate.month == widget.startDate!.month &&
        currentDate.day == widget.startDate!.day &&
        _isDateInRange(nextDate)) {
      final theme = LabTheme.of(context);
      return theme.colors.blurpleColor.withValues(alpha: 0.66);
    }

    return const Color(0x00000000); // Transparent
  }

  bool _isDateSelectable(DateTime date) {
    // For start date selection: prevent dates before current date if preventPastDates is true
    if (widget.startDate == null && widget.preventPastDates) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (date.isBefore(today)) {
        return false;
      }
    }

    // For end date selection: prevent dates before start date
    if (widget.startDate != null && date.isBefore(widget.startDate!)) {
      return false;
    }

    return true;
  }

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
            color: theme.colors.white8,
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
              color: isSelected
                  ? null
                  : (isCurrentMonth
                      ? theme.colors.white16
                      : theme.colors.white8),
              children: [
                LabText.reg12(
                  monthName,
                  color: isSelected
                      ? theme.colors.whiteEnforced
                      : theme.colors.white,
                ),
                const LabText.reg12(
                  ' ',
                ),
                LabText.reg12(
                  year.toString(),
                  color: isSelected
                      ? theme.colors.whiteEnforced.withValues(alpha: 0.66)
                      : theme.colors.white66,
                ),
              ],
            ),
          ),
        );
      }
    }

    return LabContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LabDivider(),

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
          const LabDivider(),
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
    final dateBoxHeight = widget.dateBoxHeight ?? 30.0;

    // Calculate total weeks needed dynamically
    final totalDays = firstDayWeekday + daysInMonth;
    final totalWeeks = (totalDays / 7).ceil();
    // Use the actual calculated weeks needed (4, 5, or 6)
    final adjustedWeeks = totalWeeks;

    for (int week = 0; week < adjustedWeeks; week++) {
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
          final prevMonthDate = DateTime(prevYear, prevMonth, prevMonthDay);
          final prevMonthBackgroundColor =
              _getDateBackgroundColor(prevMonthDate, false, false);

          final isPrevMonthSelectable = _isDateSelectable(prevMonthDate);
          weekDays.add(
            Expanded(
              child: MouseRegion(
                cursor: isPrevMonthSelectable
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                child: GestureDetector(
                  onTap: isPrevMonthSelectable
                      ? () =>
                          _selectSpecificDate(prevYear, prevMonth, prevMonthDay)
                      : null,
                  child: LabContainer(
                    height: dateBoxHeight,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: prevMonthBackgroundColor,
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

          // Add connecting divider after each date (except the last one in the week)
          if (dayOfWeek < 6) {
            final prevMonthDividerColor =
                _getDividerColorForDate(prevMonthDate, prevMonthDay);
            weekDays.add(
              Expanded(
                child: LabDivider(
                  color: prevMonthDividerColor,
                  thickness: LabLineThicknessData.normal().thick,
                ),
              ),
            );
          }
        } else if (day > daysInMonth) {
          // Next month's days
          final nextMonth =
              _selectedDate.month == 12 ? 1 : _selectedDate.month + 1;
          final nextYear = _selectedDate.month == 12
              ? _selectedDate.year + 1
              : _selectedDate.year;
          final nextMonthDay = day - daysInMonth;
          final nextMonthDate = DateTime(nextYear, nextMonth, nextMonthDay);
          final nextMonthBackgroundColor =
              _getDateBackgroundColor(nextMonthDate, false, false);

          final isNextMonthSelectable = _isDateSelectable(nextMonthDate);
          weekDays.add(
            Expanded(
              child: MouseRegion(
                cursor: isNextMonthSelectable
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                child: GestureDetector(
                  onTap: isNextMonthSelectable
                      ? () =>
                          _selectSpecificDate(nextYear, nextMonth, nextMonthDay)
                      : null,
                  child: LabContainer(
                    height: dateBoxHeight,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: nextMonthBackgroundColor,
                    ),
                    child: Center(
                      child: LabText.reg12(
                        nextMonthDay.toString(),
                        color: isNextMonthSelectable
                            ? theme.colors.white33
                            : theme.colors.white66,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

          // Add connecting divider after each date (except the last one in the week)
          if (dayOfWeek < 6) {
            final nextMonthDividerColor =
                _getDividerColorForDate(nextMonthDate, nextMonthDay);
            weekDays.add(
              Expanded(
                child: LabDivider(
                  color: nextMonthDividerColor,
                  thickness: LabLineThicknessData.normal().thick,
                ),
              ),
            );
          }
        } else {
          // Current month's days
          final isSelected = day == _selectedDate.day;
          final isCurrentDay = day == currentDay &&
              _selectedDate.year == DateTime.now().year &&
              _selectedDate.month == DateTime.now().month;
          final currentDate =
              DateTime(_selectedDate.year, _selectedDate.month, day);
          final isSelectable = _isDateSelectable(currentDate);
          final backgroundColor =
              _getDateBackgroundColor(currentDate, isSelected, isCurrentDay);
          final border = _getDateBorder(currentDate, isSelected, isCurrentDay);
          final dividerColor = _getDividerColor(day, daysInMonth);

          weekDays.add(
            Expanded(
              child: MouseRegion(
                cursor: isSelectable
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                child: GestureDetector(
                  onTap: isSelectable ? () => _selectDay(day) : null,
                  child: LabContainer(
                    height: dateBoxHeight,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: backgroundColor,
                      border: border,
                    ),
                    child: Center(
                      child: LabText.reg12(
                        day.toString(),
                        color: isSelected
                            ? theme.colors.whiteEnforced
                            : isSelectable
                                ? theme.colors.white
                                : theme.colors.white66,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

          // Add connecting divider after each date (except the last one in the week)
          if (dayOfWeek < 6) {
            weekDays.add(
              Expanded(
                child: LabDivider(
                  color: dividerColor,
                  thickness: LabLineThicknessData.normal().thick,
                ),
              ),
            );
          }
        }
      }

      calendarWeeks.add(
        Row(
          children: weekDays,
        ),
      );

      if (week < adjustedWeeks - 1) {
        calendarWeeks.add(const LabGap.s4());
      }
    }

    return LabContainer(
      padding: const LabEdgeInsets.symmetric(horizontal: LabGapSize.s12),
      child: Column(
        children: [
          // Weekday headers
          Row(
            children: [
              for (int i = 0; i < weekdayHeaders.length; i++) ...[
                Expanded(
                  child: Center(
                    child: Text(
                      weekdayHeaders[i],
                      style: theme.typography.reg10.copyWith(
                        color: theme.colors.white66,
                        letterSpacing: 1.6,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
                if (i < weekdayHeaders.length - 1) const Spacer(),
              ],
            ],
          ),
          const LabGap.s8(),

          // Calendar weeks
          ...calendarWeeks,
        ],
      ),
    );
  }

  void _selectDay(int day) {
    final newDate = DateTime(_selectedDate.year, _selectedDate.month, day);
    if (_isDateSelectable(newDate)) {
      setState(() {
        _selectedDate = newDate;
        widget.onDateSelected?.call(_selectedDate);
      });
    }
  }

  void _selectSpecificDate(int year, int month, int day) {
    final newDate = DateTime(year, month, day);
    if (_isDateSelectable(newDate)) {
      setState(() {
        _selectedDate = newDate;
        widget.onDateSelected?.call(_selectedDate);
      });
      _scrollToSelection();
    }
  }
}
