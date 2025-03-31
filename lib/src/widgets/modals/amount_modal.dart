import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class AppAmountModal extends StatefulWidget {
  final double initialAmount;
  final void Function(double)? onAmountChanged;
  final List<double> recentAmounts;

  const AppAmountModal({
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
    return AppModal.show(
      context,
      children: [
        AppAmountModal(
          initialAmount: initialAmount,
          onAmountChanged: onAmountChanged,
          recentAmounts: recentAmounts,
        ),
      ],
    );
  }

  @override
  State<AppAmountModal> createState() => _AppAmountModalState();
}

class _AppAmountModalState extends State<AppAmountModal> {
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
    final theme = AppTheme.of(context);

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
            const AppGap.s8(),
            Expanded(
              child: _buildKey(
                context,
                '2',
                () => _handleKeyPress('2'),
              ),
            ),
            const AppGap.s8(),
            Expanded(
              child: _buildKey(
                context,
                '3',
                () => _handleKeyPress('3'),
              ),
            ),
          ],
        ),
        const AppGap.s8(),
        Row(
          children: [
            Expanded(
              child: _buildKey(
                context,
                '4',
                () => _handleKeyPress('4'),
              ),
            ),
            const AppGap.s8(),
            Expanded(
              child: _buildKey(
                context,
                '5',
                () => _handleKeyPress('5'),
              ),
            ),
            const AppGap.s8(),
            Expanded(
              child: _buildKey(
                context,
                '6',
                () => _handleKeyPress('6'),
              ),
            ),
          ],
        ),
        const AppGap.s8(),
        Row(
          children: [
            Expanded(
              child: _buildKey(
                context,
                '7',
                () => _handleKeyPress('7'),
              ),
            ),
            const AppGap.s8(),
            Expanded(
              child: _buildKey(
                context,
                '8',
                () => _handleKeyPress('8'),
              ),
            ),
            const AppGap.s8(),
            Expanded(
              child: _buildKey(
                context,
                '9',
                () => _handleKeyPress('9'),
              ),
            ),
          ],
        ),
        const AppGap.s8(),
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
            const AppGap.s8(),
            Expanded(
              child: _buildKey(
                context,
                '0',
                () => _handleKeyPress('0'),
              ),
            ),
            const AppGap.s8(),
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
    final theme = AppTheme.of(context);

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: AppContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AppGap.s12(),
                AppText.med14(
                  'Amount',
                  color: theme.colors.white66,
                ),
              ],
            ),
            const AppGap.s8(),
            ValueListenableBuilder<double>(
              valueListenable: _amount,
              builder: (context, value, child) {
                return AppContainer(
                  decoration: BoxDecoration(
                    color: theme.colors.black33,
                    borderRadius: theme.radius.asBorderRadius().rad16,
                    border: Border.all(
                      color: theme.colors.white33,
                      width: LineThicknessData.normal().thin,
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  padding: const AppEdgeInsets.all(AppGapSize.s16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          AppIcon.s20(
                            theme.icons.characters.zap,
                            gradient: theme.colors.gold,
                          ),
                          const AppGap.s8(),
                          AppAmount(
                            value,
                            level: AppTextLevel.h1,
                            color: theme.colors.white,
                          ),
                          const AppGap.s4(),
                          _buildCursor(theme),
                          const Spacer(),
                          AppCrossButton.s32(
                            onTap: () {
                              _amount.value = 0;
                            },
                          ),
                        ],
                      ),
                      if (widget.recentAmounts.isNotEmpty) ...[
                        const AppGap.s12(),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (final amount in widget.recentAmounts)
                                AppContainer(
                                  margin: const AppEdgeInsets.only(
                                      right: AppGapSize.s8),
                                  child: AppSmallButton(
                                    children: [
                                      AppIcon.s12(
                                        theme.icons.characters.zap,
                                        color: theme.colors.white66,
                                      ),
                                      const AppGap.s4(),
                                      AppAmount(
                                        amount,
                                        level: AppTextLevel.med12,
                                        color: theme.colors.white66,
                                      ),
                                    ],
                                    onTap: () {
                                      _amount.value = amount;
                                      widget.onAmountChanged?.call(amount);
                                    },
                                    inactiveColor: theme.colors.white8,
                                    pressedColor: theme.colors.white8,
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
            const AppGap.s16(),
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
    final theme = AppTheme.of(context);

    return TapBuilder(
      onTap: onTap,
      builder: (context, state, hasFocus) {
        return AppContainer(
          height: theme.sizes.s48,
          decoration: BoxDecoration(
            color: backgroundColor ??
                (gradient == null ? theme.colors.black33 : null),
            gradient: gradient,
            borderRadius: theme.radius.asBorderRadius().rad16,
          ),
          child: Center(
            child: icon != null
                ? AppIcon(
                    icon,
                    size: value == 'backspace'
                        ? AppIconSize.s20
                        : AppIconSize.s14,
                    outlineColor: value == 'backspace'
                        ? theme.colors.white66
                        : AppColorsData.dark().white,
                    outlineThickness: value == 'backspace'
                        ? LineThicknessData.normal().medium
                        : LineThicknessData.normal().thick,
                  )
                : AppText.med16(
                    value,
                    color: theme.colors.white,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildCursor(AppThemeData theme) {
    return Opacity(
      opacity: _showCursor ? 1.0 : 0.0,
      child: AppContainer(
        width: theme.sizes.s2,
        height: theme.sizes.s24,
        decoration: BoxDecoration(
          color: theme.colors.white,
        ),
      ),
    );
  }
}
