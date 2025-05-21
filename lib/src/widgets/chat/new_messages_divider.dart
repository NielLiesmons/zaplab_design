import 'package:zaplab_design/zaplab_design.dart';

class AppNewMessagesDivider extends StatelessWidget {
  final String text;

  const AppNewMessagesDivider({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppContainer(
      padding: const AppEdgeInsets.symmetric(vertical: AppGapSize.s16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Divider that spans the full width
          Expanded(
            child: const AppDivider(),
          ),
          // Centered text container
          AppContainer(
            padding: const AppEdgeInsets.symmetric(
              horizontal: AppGapSize.s14,
              vertical: AppGapSize.s6,
            ),
            decoration: BoxDecoration(
              gradient: theme.colors.blurple33,
              borderRadius: theme.radius.asBorderRadius().rad16,
            ),
            child: AppText.reg12(
              text,
              color: theme.colors.white,
            ),
          ),
          Expanded(
            child: const AppDivider(),
          ),
        ],
      ),
    );
  }
}
