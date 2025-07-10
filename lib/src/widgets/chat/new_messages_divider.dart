import 'package:zaplab_design/zaplab_design.dart';

class LabNewMessagesDivider extends StatelessWidget {
  final String text;

  const LabNewMessagesDivider({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    return LabContainer(
      padding: const LabEdgeInsets.symmetric(vertical: LabGapSize.s16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Divider that spans the full width
          const Expanded(
            child: LabDivider(),
          ),
          // Centered text container
          LabContainer(
            padding: const LabEdgeInsets.symmetric(
              horizontal: LabGapSize.s14,
              vertical: LabGapSize.s6,
            ),
            decoration: BoxDecoration(
              gradient: theme.colors.blurple33,
              borderRadius: theme.radius.asBorderRadius().rad16,
            ),
            child: LabText.reg12(
              text,
              color: theme.colors.white,
            ),
          ),
          const Expanded(
            child: LabDivider(),
          ),
        ],
      ),
    );
  }
}
