import 'package:zaplab_design/zaplab_design.dart';

class AppToastAlert extends StatelessWidget {
  final String message;

  final VoidCallback? onTap;

  const AppToastAlert({
    super.key,
    required this.message,
    this.onTap,
  });

  static void show(
    BuildContext context, {
    required String message,
    Duration? duration,
    VoidCallback? onTap,
  }) {
    AppToast.show(
      context,
      duration: duration,
      onTap: onTap,
      children: [
        AppToastAlert(
          message: message,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppContainer(
          width: theme.sizes.s38,
          height: theme.sizes.s38,
          decoration: BoxDecoration(
            color: theme.colors.white16,
            borderRadius: BorderRadius.all(theme.radius.rad16),
          ),
          alignment: Alignment.center,
          child: AppIcon.s18(
            theme.icons.characters.alert,
            outlineColor: theme.colors.white66,
            outlineThickness: AppLineThicknessData.normal().medium,
          ),
        ),
        const AppGap.s12(),
        Expanded(
          child: AppText.reg14(
            message,
          ),
        ),
      ],
    );
  }
}
