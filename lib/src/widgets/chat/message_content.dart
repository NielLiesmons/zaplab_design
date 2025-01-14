import 'package:zaplab_design/zaplab_design.dart';

class AppMessageContent extends StatelessWidget {
  final String content;

  const AppMessageContent({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppSelectableText(
      text: content,
      style: theme.typography.reg14.copyWith(
        color: theme.colors.white,
      ),
      editable: false,
      showContextMenu: true,
      selectionControls: AppTextSelectionControls(),
    );
  }
}
