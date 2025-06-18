import 'package:zaplab_design/zaplab_design.dart';
import 'dart:ui';

class LabBottomBarSafeArea extends StatelessWidget {
  const LabBottomBarSafeArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Column(
      children: [
        const LabDivider(),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: LabContainer(
              height: bottomPadding,
              decoration: BoxDecoration(
                color: theme.colors.black66,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
