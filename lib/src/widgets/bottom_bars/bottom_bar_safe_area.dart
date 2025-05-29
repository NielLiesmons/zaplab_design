import 'package:zaplab_design/zaplab_design.dart';
import 'dart:ui';

class AppBottomBarSafeArea extends StatelessWidget {
  const AppBottomBarSafeArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Column(
      children: [
        const AppDivider(),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: AppContainer(
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
