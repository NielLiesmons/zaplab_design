import 'package:zaplab_design/zaplab_design.dart';

class LabToastInfo extends StatelessWidget {
  final String message;

  final VoidCallback? onTap;

  const LabToastInfo({
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
    LabToast.show(
      context,
      duration: duration,
      onTap: onTap,
      children: [
        LabToastInfo(
          message: message,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LabContainer(
          width: theme.sizes.s38,
          height: theme.sizes.s38,
          decoration: BoxDecoration(
            color: theme.colors.white16,
            borderRadius: BorderRadius.all(theme.radius.rad16),
          ),
          alignment: Alignment.center,
          child: LabIcon.s18(
            theme.icons.characters.info,
            outlineColor: theme.colors.white66,
            outlineThickness: LabLineThicknessData.normal().medium,
          ),
        ),
        const LabGap.s12(),
        Expanded(
          child: LabText.reg14(
            message,
          ),
        ),
      ],
    );
  }
}
