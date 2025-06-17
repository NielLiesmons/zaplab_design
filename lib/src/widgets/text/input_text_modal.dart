import 'package:zaplab_design/zaplab_design.dart';

abstract class AppInputTextModal {
  static Future<void> show(
    BuildContext context, {
    required TextEditingController controller,
    required String placeholder,
    String? title,
    bool singleLine = false,
    required void Function(String) onDone,
    AppInputTextFieldSize size = AppInputTextFieldSize.small,
  }) async {
    final theme = AppTheme.of(context);
    final focusNode = FocusNode();
    focusNode.requestFocus();

    void handleSubmit() {
      if (controller.text.isNotEmpty) {
        onDone(controller.text);
        focusNode.dispose();
        Navigator.pop(context);
      }
    }

    await AppInputModal.show(
      context,
      children: [
        AppKeyboardSubmitHandler(
          onSubmit: handleSubmit,
          child: AppInputTextField(
            controller: controller,
            focusNode: focusNode,
            singleLine: singleLine,
            placeholder: placeholder,
            title: title,
            size: size,
          ),
        ),
        const AppGap.s12(),
        AppButton(
          onTap: handleSubmit,
          children: [
            AppText.med14("Done", color: theme.colors.whiteEnforced),
          ],
        ),
        const AppGap.s16(),
      ],
    );
  }
}
