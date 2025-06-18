import 'package:zaplab_design/src/theme/theme.dart';
import 'package:zaplab_design/src/utils/platform.dart';
import 'package:flutter/widgets.dart';

class LabDragHandle extends StatelessWidget {
  const LabDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    return LabPlatformUtils.isMobile
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
