import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class LabZapAmountModal extends StatefulWidget {
  final double initialAmount;
  final void Function(double)? onAmountChanged;
  final List<double> recentAmounts;

  const LabZapAmountModal({
    super.key,
    required this.initialAmount,
    this.onAmountChanged,
    this.recentAmounts = const [],
  });

  static Future<void> show(
    BuildContext context, {
    required double initialAmount,
    void Function(double)? onAmountChanged,
    List<double> recentAmounts = const [],
  }) {
    return LabModal.show(
      context,
      children: [
        LabZapAmountModal(
          initialAmount: initialAmount,
          onAmountChanged: onAmountChanged,
          recentAmounts: recentAmounts,
        ),
      ],
    );
  }

  @override
  State<LabZapAmountModal> createState() => _LabZapAmountModalState();
}

class _LabZapAmountModalState extends State<LabZapAmountModal> {
  bool _showCursor = true;
  late Timer _cursorTimer;
  late final ValueNotifier<double> _amount;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _amount = ValueNotifier<double>(widget.initialAmount);
    _cursorTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => setState(() => _showCursor = !_showCursor),
    );
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _cursorTimer.cancel();
    _amount.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        widget.onAmountChanged?.call(_amount.value);
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
      _amount.value = (_amount.value ~/ 10).toDouble();
    } else {
      final digit = int.parse(key);
      final newValue = _amount.value * 10 + digit;

      // Only update if the new value doesn't exceed 1,000,000
      if (newValue <= 1000000) {
        _amount.value = newValue;
      }
    }
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
                  widget.onAmountChanged?.call(_amount.value);
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
                  'Amount',
                  color: theme.colors.white66,
                ),
              ],
            ),
            const LabGap.s8(),
            ValueListenableBuilder<double>(
              valueListenable: _amount,
              builder: (context, value, child) {
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
                  padding: const LabEdgeInsets.all(LabGapSize.s16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          LabIcon.s20(
                            theme.icons.characters.zap,
                            gradient: theme.colors.gold,
                          ),
                          const LabGap.s8(),
                          LabAmount(
                            value,
                            level: LabTextLevel.h1,
                            color: theme.colors.white,
                          ),
                          const LabGap.s4(),
                          _buildCursor(theme),
                          const Spacer(),
                          LabCrossButton.s32(
                            onTap: () {
                              _amount.value = 0;
                            },
                          ),
                        ],
                      ),
                      if (widget.recentAmounts.isNotEmpty) ...[
                        const LabGap.s12(),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (final amount in widget.recentAmounts)
                                LabContainer(
                                  margin: const LabEdgeInsets.only(
                                      right: LabGapSize.s8),
                                  child: LabSmallButton(
                                    onTap: () {
                                      _amount.value = amount;
                                      widget.onAmountChanged?.call(amount);
                                    },
                                    color: theme.colors.white8,
                                    children: [
                                      LabIcon.s12(
                                        theme.icons.characters.zap,
                                        color: theme.colors.white66,
                                      ),
                                      const LabGap.s4(),
                                      LabAmount(
                                        amount,
                                        level: LabTextLevel.med12,
                                        color: theme.colors.white66,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
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

    return TapBuilder(
      onTap: onTap,
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
                    color: theme.colors.white,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildCursor(LabThemeData theme) {
    return Opacity(
      opacity: _showCursor ? 1.0 : 0.0,
      child: LabContainer(
        width: theme.sizes.s2,
        height: theme.sizes.s24,
        decoration: BoxDecoration(
          color: theme.colors.white,
        ),
      ),
    );
  }
}
