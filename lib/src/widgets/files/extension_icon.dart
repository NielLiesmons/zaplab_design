import 'package:zaplab_design/zaplab_design.dart';

class LabExtensionIcon extends StatelessWidget {
  final String extension;

  const LabExtensionIcon({
    super.key,
    required this.extension,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    // Get the extension color
    final extensionColor = extensionToColor(extension);
    final color = Color(extensionColor.toIntWithAlpha());

    // Get first three letters of extension (uppercase, no dot)
    final cleanExtension = extension.toUpperCase().replaceAll('.', '');
    final displayText = cleanExtension.length > 4
        ? cleanExtension.substring(0, 4)
        : cleanExtension;

    return Stack(
      children: [
        // Bottom container with gray66 background
        LabContainer(
          width: theme.sizes.s38,
          height: theme.sizes.s38,
          decoration: BoxDecoration(
            color: theme.colors.white8,
            borderRadius: theme.radius.asBorderRadius().rad12,
          ),
          child: Center(
            child: LabText.bold10(displayText, color: theme.colors.white),
          ),
        ),
        LabContainer(
            width: theme.sizes.s38,
            height: theme.sizes.s38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: theme.radius.asBorderRadius().rad12,
            ),
            child: Center(
                child: LabText.bold10(displayText,
                    color: color.withValues(alpha: 0.90)))),
      ],
    );
  }
}
