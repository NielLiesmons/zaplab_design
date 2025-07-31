import 'package:zaplab_design/zaplab_design.dart';

class LabConfirmationModal {
  static Future<void> show(
    BuildContext context, {
    Widget? content,
    required VoidCallback onConfirm,
    String title = 'Are you sure?',
    String? description,
  }) async {
    await LabModal.show(
      context,
      title: title,
      description: description,
      children: [content ?? const SizedBox.shrink()],
      bottomBar: Row(
        children: [
          LabButton(
            onTap: () => Navigator.of(context).pop(),
            color: LabTheme.of(context).colors.black33,
            children: [
              LabText.med14(
                'Cancel',
                color: LabTheme.of(context).colors.white66,
              ),
            ],
          ),
          const LabGap.s12(),
          Expanded(
            child: LabButton(
              onTap: () {
                onConfirm();
                Navigator.of(context).pop();
              },
              text: 'Confirm',
            ),
          ),
        ],
      ),
    );
  }
}
