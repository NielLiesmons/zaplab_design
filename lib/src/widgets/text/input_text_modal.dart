import 'package:zaplab_design/zaplab_design.dart';

abstract class LabInputTextModal {
  static Future<void> show(
    BuildContext context, {
    required TextEditingController controller,
    required String placeholder,
    String? title,
    bool singleLine = false,
    required void Function(String) onDone,
    LabInputTextFieldSize size = LabInputTextFieldSize.small,
  }) async {
    final theme = LabTheme.of(context);
    final focusNode = FocusNode();
    focusNode.requestFocus();

    void handleSubmit() {
      if (controller.text.isNotEmpty) {
        onDone(controller.text);
        focusNode.dispose();
        Navigator.pop(context);
      }
    }

    await LabInputModal.show(
      context,
      children: [
        LabKeyboardSubmitHandler(
          onSubmit: handleSubmit,
          child: LabInputTextField(
            controller: controller,
            focusNode: focusNode,
            singleLine: singleLine,
            placeholder: placeholder,
            title: title,
            size: size,
          ),
        ),
        const LabGap.s12(),
        LabButton(
          onTap: handleSubmit,
          children: [
            LabText.med14("Done", color: theme.colors.whiteEnforced),
          ],
        ),
        const LabGap.s16(),
      ],
    );
  }
}
