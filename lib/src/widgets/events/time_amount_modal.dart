import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class LabTimeAmountModal extends StatefulWidget {
  final LabTime initialTime;
  final void Function(LabTime)? onTimeChanged;

  const LabTimeAmountModal({
    super.key,
    required this.initialTime,
    this.onTimeChanged,
  });

  static Future<void> show(
    BuildContext context, {
    required LabTime initialTime,
    void Function(LabTime)? onTimeChanged,
  }) {
    return LabModal.show(
      context,
      children: [
        LabTimeAmountModal(
          initialTime: initialTime,
          onTimeChanged: onTimeChanged,
        ),
      ],
    );
  }

  @override
  State<LabTimeAmountModal> createState() => _LabTimeAmountModalState();
}

class _LabTimeAmountModalState extends State<LabTimeAmountModal> {
  bool _showCursor = true;
  late Timer _cursorTimer;
  late final ValueNotifier<List<int?>>
      _digits; // null = "-", 0-9 = actual digits
  late final ValueNotifier<int> _cursorPosition;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Initialize digits from initial time
    final initialTime = widget.initialTime;
    _digits = ValueNotifier<List<int?>>([
      initialTime.hour24 ~/ 10,
      initialTime.hour24 % 10,
      initialTime.minute ~/ 10,
      initialTime.minute % 10,
    ]);

    // Set cursor position to after the last non-null digit
    int cursorPos = 0;
    for (int i = 0; i < _digits.value.length; i++) {
      if (_digits.value[i] != null) {
        cursorPos = i + 1;
      }
    }
    _cursorPosition = ValueNotifier<int>(cursorPos);

    _cursorTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => setState(() => _showCursor = !_showCursor),
    );
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _cursorTimer.cancel();
    _digits.dispose();
    _cursorPosition.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _saveTime();
        Navigator.of(context).pop();
        return KeyEventResult.handled;
      }

      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        _handleKeyPress('backspace');
        return KeyEventResult.handled;
      }

      final String? digit = event.character;
      if (digit != null && RegExp(r'[0-9]').hasMatch(digit)) {
        _handleKeyPress(digit);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _handleKeyPress(String key) {
    if (key == 'backspace') {
      if (_cursorPosition.value > 0) {
        _cursorPosition.value = _cursorPosition.value - 1;
        _clearDigitAtPosition(_cursorPosition.value);
      }
    } else {
      final digit = int.parse(key);
      if (_cursorPosition.value < 4) {
        _setDigitAtPosition(_cursorPosition.value, digit);
        _cursorPosition.value = _cursorPosition.value + 1;
      }
    }
  }

  void _setDigitAtPosition(int position, int digit) {
    final currentDigits = List<int?>.from(_digits.value);
    currentDigits[position] = digit;
    _digits.value = currentDigits;
  }

  void _clearDigitAtPosition(int position) {
    final currentDigits = List<int?>.from(_digits.value);
    currentDigits[position] = null;
    _digits.value = currentDigits;
  }

  bool _isDigitValidAtPosition(int digit, int position) {
    final digits = _digits.value;

    switch (position) {
      case 0: // First hour digit
        return digit >= 0 && digit <= 2; // 0, 1, 2
      case 1: // Second hour digit
        final firstDigit = digits[0];
        if (firstDigit == null) return true; // Allow any if first digit not set
        if (firstDigit == 0) return true; // 00-09
        if (firstDigit == 1) return true; // 10-19
        if (firstDigit == 2) return digit >= 0 && digit <= 3; // 20-23
        return false;
      case 2: // First minute digit
        return digit >= 0 && digit <= 5; // 0-5
      case 3: // Second minute digit
        return digit >= 0 && digit <= 9; // 0-9
      default:
        return false;
    }
  }

  void _saveTime() {
    final digits = _digits.value;
    int hour = 0;
    int minute = 0;

    if (digits[0] != null) {
      hour += digits[0]! * 10;
    }
    if (digits[1] != null) {
      hour += digits[1]!;
    }
    if (digits[2] != null) {
      minute += digits[2]! * 10;
    }
    if (digits[3] != null) {
      minute += digits[3]!;
    }

    // Validate ranges
    hour = hour.clamp(0, 23);
    minute = minute.clamp(0, 59);

    final time = LabTime(hour, minute);
    widget.onTimeChanged?.call(time);
  }

  Widget _buildNumPad(BuildContext context) {
    final theme = LabTheme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildKey(
                context,
                '1',
                () => _handleKeyPress('1'),
              ),
            ),
            const LabGap.s8(),
            Expanded(
              child: _buildKey(
                context,
                '2',
                () => _handleKeyPress('2'),
              ),
            ),
            const LabGap.s8(),
            Expanded(
              child: _buildKey(
                context,
                '3',
                () => _handleKeyPress('3'),
              ),
            ),
          ],
        ),
        const LabGap.s8(),
        Row(
          children: [
            Expanded(
              child: _buildKey(
                context,
                '4',
                () => _handleKeyPress('4'),
              ),
            ),
            const LabGap.s8(),
            Expanded(
              child: _buildKey(
                context,
                '5',
                () => _handleKeyPress('5'),
              ),
            ),
            const LabGap.s8(),
            Expanded(
              child: _buildKey(
                context,
                '6',
                () => _handleKeyPress('6'),
              ),
            ),
          ],
        ),
        const LabGap.s8(),
        Row(
          children: [
            Expanded(
              child: _buildKey(
                context,
                '7',
                () => _handleKeyPress('7'),
              ),
            ),
            const LabGap.s8(),
            Expanded(
              child: _buildKey(
                context,
                '8',
                () => _handleKeyPress('8'),
              ),
            ),
            const LabGap.s8(),
            Expanded(
              child: _buildKey(
                context,
                '9',
                () => _handleKeyPress('9'),
              ),
            ),
          ],
        ),
        const LabGap.s8(),
        Row(
          children: [
            Expanded(
              child: _buildKey(
                context,
                'backspace',
                () => _handleKeyPress('backspace'),
                icon: theme.icons.characters.backspace,
                backgroundColor: theme.colors.white16,
              ),
            ),
            const LabGap.s8(),
            Expanded(
              child: _buildKey(
                context,
                '0',
                () => _handleKeyPress('0'),
              ),
            ),
            const LabGap.s8(),
            Expanded(
              child: _buildKey(
                context,
                'check',
                () {
                  _saveTime();
                  Navigator.of(context).pop();
                },
                icon: theme.icons.characters.check,
                gradient: theme.colors.blurple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: LabContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const LabGap.s12(),
                LabText.med14(
                  'Time',
                  color: theme.colors.white66,
                ),
              ],
            ),
            const LabGap.s8(),
            ValueListenableBuilder<List<int?>>(
              valueListenable: _digits,
              builder: (context, digits, child) {
                return ValueListenableBuilder<int>(
                  valueListenable: _cursorPosition,
                  builder: (context, cursorPos, child) {
                    return LabContainer(
                      decoration: BoxDecoration(
                        color: theme.colors.black33,
                        borderRadius: theme.radius.asBorderRadius().rad16,
                        border: Border.all(
                          color: theme.colors.white33,
                          width: LabLineThicknessData.normal().thin,
                        ),
                      ),
                      clipBehavior: Clip.hardEdge,
                      padding: const LabEdgeInsets.symmetric(
                        vertical: LabGapSize.s12,
                        horizontal: LabGapSize.s16,
                      ),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              _buildTimeDisplay(theme, digits, cursorPos),
                              const Spacer(),
                              LabCrossButton.s32(
                                onTap: () {
                                  _digits.value = [null, null, null, null];
                                  _cursorPosition.value = 0;
                                },
                              ),
                            ],
                          ),
                          Positioned(
                            left: _getCursorPosition(cursorPos),
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: _buildCursor(theme, cursorPos),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const LabGap.s16(),
            _buildNumPad(context),
          ],
        ),
      ),
    );
  }

  Widget _buildKey(
    BuildContext context,
    String value,
    VoidCallback onTap, {
    String? icon,
    Gradient? gradient,
    Color? backgroundColor,
  }) {
    final theme = LabTheme.of(context);

    // Check if this digit is valid for the current cursor position
    bool isDigitValid = true;
    if (value != 'backspace' && value != 'check') {
      final digit = int.tryParse(value);
      if (digit != null) {
        isDigitValid = _isDigitValidAtPosition(digit, _cursorPosition.value);
      }
    }

    return TapBuilder(
      onTap: isDigitValid ? onTap : null,
      builder: (context, state, hasFocus) {
        return LabContainer(
          height: theme.sizes.s48,
          decoration: BoxDecoration(
            color: backgroundColor ??
                (gradient == null ? theme.colors.black33 : null),
            gradient: gradient,
            borderRadius: theme.radius.asBorderRadius().rad16,
          ),
          child: Center(
            child: icon != null
                ? LabIcon(
                    icon,
                    size: value == 'backspace'
                        ? LabIconSize.s20
                        : LabIconSize.s14,
                    outlineColor: value == 'backspace'
                        ? theme.colors.white66
                        : theme.colors.whiteEnforced,
                    outlineThickness: value == 'backspace'
                        ? LabLineThicknessData.normal().medium
                        : LabLineThicknessData.normal().thick,
                  )
                : LabText.med16(
                    value,
                    color: isDigitValid
                        ? theme.colors.white
                        : theme.colors.white33,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildTimeDisplay(
      LabThemeData theme, List<int?> digits, int cursorPos) {
    return Row(
      children: [
        // First hour digit - fixed width
        LabContainer(
          width: theme.sizes.s20,
          child: Center(
            child: LabText.h1(
              digits[0]?.toString() ?? '-',
              color:
                  digits[0] != null ? theme.colors.white : theme.colors.white33,
            ),
          ),
        ),
        // Second hour digit - fixed width
        LabContainer(
          width: theme.sizes.s20,
          child: Center(
            child: LabText.h1(
              digits[1]?.toString() ?? '-',
              color:
                  digits[1] != null ? theme.colors.white : theme.colors.white33,
            ),
          ),
        ),
        LabContainer(
          width: theme.sizes.s20,
          padding: const LabEdgeInsets.only(bottom: LabGapSize.s4),
          child: Center(
            child: LabText.h1(
              ':',
              color: theme.colors.white66,
            ),
          ),
        ),
        // First minute digit - fixed width
        LabContainer(
          width: theme.sizes.s20,
          child: Center(
            child: LabText.h1(
              digits[2]?.toString() ?? '-',
              color:
                  digits[2] != null ? theme.colors.white : theme.colors.white33,
            ),
          ),
        ),
        // Second minute digit - fixed width
        LabContainer(
          width: theme.sizes.s20,
          child: Center(
            child: LabText.h1(
              digits[3]?.toString() ?? '-',
              color:
                  digits[3] != null ? theme.colors.white : theme.colors.white33,
            ),
          ),
        ),
      ],
    );
  }

  double _getCursorPosition(int cursorPos) {
    // Calculate cursor position based on digit position
    // Each digit is 24px wide, with 4px gap after first two digits, then colon, then 4px gap
    switch (cursorPos) {
      case 0:
        return 0; // Before first digit
      case 1:
        return 20; // Before second digit
      case 2:
        return 60; // Before colon (24 + 4 + 24)
      case 3:
        return 80; // Before third digit (24 + 4 + 24 + 4 + 4)
      case 4:
        return 100; // Before fourth digit (24 + 4 + 24 + 4 + 4 + 24)
      default:
        return 0;
    }
  }

  Widget _buildCursor(LabThemeData theme, int cursorPos) {
    // Show cursor at the current position (0-4)
    return Opacity(
      opacity: _showCursor ? 1.0 : 0.0,
      child: LabContainer(
        width: theme.sizes.s2,
        height: theme.sizes.s32,
        decoration: BoxDecoration(
          color: theme.colors.white,
        ),
      ),
    );
  }
}
