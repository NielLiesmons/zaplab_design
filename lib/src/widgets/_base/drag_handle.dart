import 'package:zaplab_design/src/theme/theme.dart';
import 'package:zaplab_design/src/utils/platform.dart';
import 'package:flutter/widgets.dart';

class AppDragHandle extends StatelessWidget {
  const AppDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppPlatformUtils.isMobile
        ? SizedBox(
            width: theme.sizes.s32,
            height: theme.sizes.s4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colors.white33,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
