import 'dart:async';
import 'package:zaplab_design/zaplab_design.dart';

class _DateTimePickerContent extends StatefulWidget {
  final DateTime initialDate;
  final LabTime? initialTime;
  final bool allowAllDay;
  final bool allowTime;
  final bool startAndEndDate;
  final DateTime? initialEndDate;
  final LabTime? initialEndTime;
  final bool initialEndMode;
  final bool initialAllDay;
  final bool initialEndAllDay;
  final ValueNotifier<bool>? modeNotifier;
  final ValueNotifier<bool>? bothAllDayNotifier;
  final Function(Map<String, dynamic>) onResult;
  final VoidCallback? onDone;

  const _DateTimePickerContent({
    super.key,
    required this.initialDate,
    this.initialTime,
    this.allowAllDay = true,
    this.allowTime = true,
    this.startAndEndDate = false,
    this.initialEndDate,
    this.initialEndTime,
    this.initialEndMode = false,
    this.initialAllDay = false,
    this.initialEndAllDay = false,
    this.modeNotifier,
    this.bothAllDayNotifier,
    required this.onResult,
    this.onDone,
  });

  @override
  State<_DateTimePickerContent> createState() => _DateTimePickerContentState();
}

class _DateTimePickerContentState extends State<_DateTimePickerContent> {
  late DateTime selectedDate;
  LabTime? selectedTime;
  bool isAllDay = false;

  // For start/end date functionality
  DateTime? endDate;
  LabTime? endTime;
  bool isEndAllDay = false;
  bool isSelectingEnd = false;

  @override
  void initState() {
    super.initState();
    final currentTime = LabTime.now();

    selectedDate = widget.initialDate;
    selectedTime = widget.initialTime ?? currentTime;
    endDate = widget.initialEndDate ??
        (widget.initialEndMode ? widget.initialDate : null);
    endTime =
        widget.initialEndTime ?? (widget.initialEndMode ? currentTime : null);
    isSelectingEnd = widget.initialEndMode;
    isAllDay = widget.initialAllDay;
    isEndAllDay = widget.initialEndAllDay;

    // Listen to mode changes from the notifier
    widget.modeNotifier?.addListener(_onModeChanged);

    // Listen to both all-day changes
    widget.bothAllDayNotifier?.addListener(_onBothAllDayChanged);

    // Initialize the result with current values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateResult();
      // Initialize the all-day notifier with current state
      widget.bothAllDayNotifier?.value = isAllDay;
    });
  }

  @override
  void dispose() {
    widget.modeNotifier?.removeListener(_onModeChanged);
    widget.bothAllDayNotifier?.removeListener(_onBothAllDayChanged);
    super.dispose();
  }

  void _onModeChanged() {
    if (mounted) {
      setState(() {
        isSelectingEnd = widget.modeNotifier?.value ?? false;

        // If switching to end mode and end date/time are not set, initialize them
        if (isSelectingEnd) {
          endDate ??= selectedDate;
          endTime ??= selectedTime ?? LabTime.now();
        }
      });
      // Update the result when mode changes to ensure current values are saved
      _updateResult();
    }
  }

  void _onBothAllDayChanged() {
    if (mounted) {
      setState(() {
        // Update the all-day state based on the notifier
        final allDayValue = widget.bothAllDayNotifier?.value ?? false;
        isAllDay = allDayValue;
      });
      _updateResult();
    }
  }

  void _updateResult() {
    if (widget.startAndEndDate) {
      widget.onResult({
        'startDate': selectedDate,
        'startTime': isAllDay ? null : selectedTime,
        'endDate': endDate,
        'endTime': isEndAllDay ? null : endTime,
        'isAllDay': isAllDay,
        'isEndAllDay': isEndAllDay,
      });
    } else {
      widget.onResult({
        'date': selectedDate,
        'time': isAllDay ? null : selectedTime,
        'isAllDay': isAllDay,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LabGap.s12(),
        if (widget.startAndEndDate) ...[
          LabText.h1(isSelectingEnd ? "End" : "Start"),
        ] else ...[
          const LabText.h1("Date & Time"),
        ],
        const LabGap.s12(),
        LabDatePicker(
          initialDate: isSelectingEnd ? endDate : selectedDate,
          startDate: isSelectingEnd ? selectedDate : null,
          onDateSelected: (date) {
            setState(() {
              if (isSelectingEnd) {
                endDate = date;
                // Ensure end date is not before start date
                if (endDate != null && endDate!.isBefore(selectedDate)) {
                  endDate = selectedDate;
                }
              } else {
                selectedDate = date;
                // Ensure end date is not before start date
                if (endDate != null && endDate!.isBefore(selectedDate)) {
                  endDate = selectedDate;
                }
              }
              _updateResult();
            });
          },
        ),
        if (widget.allowTime) ...[
          const LabGap.s6(),
          LabTimePicker(
            initialTime: isSelectingEnd ? endTime : selectedTime,
            initialAllDay: isSelectingEnd ? isEndAllDay : isAllDay,
            allowAllDay:
                widget.allowAllDay && !isSelectingEnd, // Disable for end mode
            onTimeSelected: (time) {
              setState(() {
                if (isSelectingEnd) {
                  endTime = time;
                } else {
                  selectedTime = time;
                }
                _updateResult();
              });
            },
            onAllDayChanged: (value) {
              setState(() {
                if (isSelectingEnd) {
                  isEndAllDay = value;
                } else {
                  isAllDay = value;
                }
                _updateResult();
              });
              // Update the all-day notifier immediately after state change
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.bothAllDayNotifier?.value = isAllDay;
              });
            },
          ),
        ],
        const LabGap.s6(),
        const LabDivider(),
        const LabGap.s16(),
      ],
    );
  }
}

class LabDatePickerModal extends StatefulWidget {
  final DateTime initialDate;
  final bool allowTime;
  final LabTime? initialTime;
  final bool startAndEndDate;
  final bool allowAllDay;
  final DateTime? initialEndDate;
  final LabTime? initialEndTime;

  const LabDatePickerModal({
    super.key,
    required this.initialDate,
    this.allowTime = true,
    this.initialTime,
    this.startAndEndDate = false,
    this.allowAllDay = true,
    this.initialEndDate,
    this.initialEndTime,
  });

  static Future<dynamic> show(
    BuildContext context, {
    required DateTime initialDate,
    LabTime? initialTime,
    bool allowAllDay = true,
    bool allowTime = true,
    bool startAndEndDate = false,
    DateTime? initialEndDate,
    LabTime? initialEndTime,
    bool initialEndMode = false,
    bool initialAllDay = false,
    bool initialEndAllDay = false,
  }) {
    final theme = LabTheme.of(context);

    Map<String, dynamic>? resultData;
    final modeNotifier = ValueNotifier<bool>(initialEndMode);
    final bothAllDayNotifier = ValueNotifier<bool>(initialAllDay);

    // Create a callback to update the result data
    void updateResult(Map<String, dynamic> data) {
      resultData = data;
    }

    return LabModal.show(
      context,
      includePadding: false,
      children: [
        _DateTimePickerContent(
          initialDate: initialDate,
          initialTime: initialTime,
          allowAllDay: allowAllDay,
          allowTime: allowTime,
          startAndEndDate: startAndEndDate,
          initialEndDate: initialEndDate,
          initialEndTime: initialEndTime,
          initialEndMode: initialEndMode,
          initialAllDay: initialAllDay,
          initialEndAllDay: initialEndAllDay,
          modeNotifier: modeNotifier,
          bothAllDayNotifier: bothAllDayNotifier,
          onResult: updateResult,
          onDone: () {
            Navigator.of(context).pop(resultData);
          },
        ),
      ],
      bottomBar: startAndEndDate
          ? ValueListenableBuilder<bool>(
              valueListenable: bothAllDayNotifier,
              builder: (context, isAllDay, child) {
                // If start is all-day, show only "Done" button
                if (isAllDay) {
                  return LabButton(
                    onTap: () {
                      Navigator.of(context).pop(resultData);
                    },
                    children: [
                      LabText.med14("Done"),
                    ],
                  );
                }

                // Otherwise show the normal start/end switching buttons
                return ValueListenableBuilder<bool>(
                  valueListenable: modeNotifier,
                  builder: (context, isEndMode, child) {
                    return Row(
                      children: [
                        LabButton(
                          onTap: () {
                            if (isEndMode) {
                              // Switch to start mode
                              modeNotifier.value = false;
                            } else {
                              Navigator.of(context).pop(resultData);
                            }
                          },
                          color: theme.colors.black33,
                          children: [
                            LabText.med14(
                              isEndMode ? "Edit Start" : "Close",
                              color: theme.colors.white66,
                            ),
                          ],
                        ),
                        const LabGap.s12(),
                        Expanded(
                          child: LabButton(
                            onTap: () {
                              if (!isEndMode) {
                                // Switch to end mode
                                modeNotifier.value = true;
                              } else {
                                Navigator.of(context).pop(resultData);
                              }
                            },
                            children: [
                              LabText.med14(
                                  isEndMode ? "Done" : "Save & Select End"),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            )
          : LabButton(
              onTap: () {
                Navigator.of(context).pop(resultData);
              },
              children: [
                LabText.med14("Done"),
              ],
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

  // For start/end date functionality
  DateTime? endDate;
  LabTime? endTime;
  bool isEndAllDay = false;
  bool isSelectingEnd = false;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    selectedTime = widget.initialTime;
    endDate = widget.initialEndDate;
    endTime = widget.initialEndTime;
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
