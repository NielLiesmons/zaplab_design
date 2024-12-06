import 'package:zapchat_design/src/theme/theme.dart';
import 'package:flutter/widgets.dart';

class DragHandle extends StatelessWidget {
  const DragHandle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return SizedBox(
      width: theme.sizes.s32,
      height: theme.sizes.s4,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colors.white33,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
