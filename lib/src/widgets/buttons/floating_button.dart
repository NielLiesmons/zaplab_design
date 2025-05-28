import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppFloatingButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;

  const AppFloatingButton({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(theme.sizes.s16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: AppButton(
          onTap: onTap,
          inactiveColor: theme.colors.white16,
          square: true,
          children: [icon],
        ),
      ),
    );
  }
}
