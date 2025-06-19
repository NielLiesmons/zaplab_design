import 'package:zaplab_design/zaplab_design.dart';

class _DateTimePickerContent extends StatefulWidget {
  final DateTime initialDate;
  final LabTime? initialTime;
  final bool allowAllDay;
  final Function(DateTime, LabTime?, bool) onChanged;

  const _DateTimePickerContent({
    required this.initialDate,
    this.initialTime,
    this.allowAllDay = true,
    required this.onChanged,
  });

  @override
  State<_DateTimePickerContent> createState() => _DateTimePickerContentState();
}

class _DateTimePickerContentState extends State<_DateTimePickerContent> {
  late DateTime selectedDate;
  LabTime? selectedTime;
  bool isAllDay = false;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LabGap.s12(),
        const LabText.h1("Date & Time"),
        const LabGap.s12(),
        LabDatePicker(
          initialDate: selectedDate,
          onDateSelected: (date) {
            setState(() {
              selectedDate = date;
              widget.onChanged(selectedDate, selectedTime, isAllDay);
            });
          },
        ),
        const LabGap.s6(),
        LabTimePicker(
          initialTime: selectedTime,
          allowAllDay: widget.allowAllDay,
          onTimeSelected: (time) {
            setState(() {
              selectedTime = time;
              widget.onChanged(selectedDate, selectedTime, isAllDay);
            });
          },
          onAllDayChanged: (value) {
            setState(() {
              isAllDay = value;
              widget.onChanged(selectedDate, selectedTime, isAllDay);
            });
          },
        ),
        const LabGap.s6(),
        const LabDivider(),
        const LabGap.s16(),
      ],
    );
  }
}

class LabDatePickerModal extends StatefulWidget {
  final DateTime initialDate;
  final LabTime? initialTime;
  final bool allowAllDay;

  const LabDatePickerModal({
    super.key,
    required this.initialDate,
    this.initialTime,
    this.allowAllDay = true,
  });

  static Future<(DateTime, LabTime?)?> show(
    BuildContext context, {
    required DateTime initialDate,
    LabTime? initialTime,
    bool allowAllDay = true,
  }) {
    DateTime selectedDate = initialDate;
    LabTime? selectedTime = initialTime;
    bool isAllDay = false;

    String getDisplayText() {
      final dateStr = selectedDate.toString().split(' ')[0];
      if (isAllDay) return dateStr;
      return '$dateStr${selectedTime != null ? ' at ${selectedTime.toString()}' : ''}';
    }

    return LabModal.show(
      context,
      includePadding: false,
      children: [
        _DateTimePickerContent(
          initialDate: initialDate,
          initialTime: initialTime,
          allowAllDay: allowAllDay,
          onChanged: (date, time, allDay) {
            selectedDate = date;
            selectedTime = time;
            isAllDay = allDay;
          },
        ),
      ],
      bottomBar: LabButton(
        onTap: () {
          Navigator.of(context)
              .pop((selectedDate, isAllDay ? null : selectedTime));
        },
        text: "Done",
      ),
    );
  }

  @override
  State<LabDatePickerModal> createState() => _LabDatePickerModalState();
}

class _LabDatePickerModalState extends State<LabDatePickerModal> {
  late DateTime selectedDate;
  LabTime? selectedTime;
  bool isAllDay = false;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    selectedTime = widget.initialTime;
  }

  String getDisplayText() {
    final dateStr = selectedDate.toString().split(' ')[0];
    if (isAllDay) return dateStr;
    return '$dateStr${selectedTime != null ? ' at ${selectedTime.toString()}' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    return LabModal(
      includePadding: false,
      title: 'Select Date & Time',
      bottomBar: LabButton(
        onTap: () {
          Navigator.of(context)
              .pop((selectedDate, isAllDay ? null : selectedTime));
        },
        children: [
          LabText.med14(getDisplayText()),
        ],
      ),
      children: [
        _DateTimePickerContent(
          initialDate: widget.initialDate,
          initialTime: widget.initialTime,
          allowAllDay: widget.allowAllDay,
          onChanged: (date, time, allDay) {
            setState(() {
              selectedDate = date;
              selectedTime = time;
              isAllDay = allDay;
            });
          },
        ),
      ],
    );
  }
}
