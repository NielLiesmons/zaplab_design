import 'package:zaplab_design/zaplab_design.dart';
import 'asciidoc_element.dart';

class AsciiDocRenderer extends StatelessWidget {
  final List<AsciiDocElement> elements;

  const AsciiDocRenderer({
    super.key,
    required this.elements,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final element in elements)
          _buildElementWithSpacing(element, context),
      ],
    );
  }

  Widget _buildElementWithSpacing(
      AsciiDocElement element, BuildContext context) {
    // Define spacing per element type
    final AppEdgeInsets spacing = switch (element.type) {
      AsciiDocElementType.heading1 => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
        ),
      AsciiDocElementType.heading2 => const AppEdgeInsets.only(
          bottom: AppGapSize.s8,
        ),
      AsciiDocElementType.heading3 => const AppEdgeInsets.only(
          bottom: AppGapSize.s8,
        ),
      AsciiDocElementType.heading4 => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
        ),
      AsciiDocElementType.heading5 => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
        ),
      _ => const AppEdgeInsets.only(bottom: AppGapSize.s12),
    };

    return AppContainer(
      padding: spacing,
      child: _buildElement(element, context),
    );
  }

  Widget _buildElement(AsciiDocElement element, BuildContext context) {
    final theme = AppTheme.of(context);

    switch (element.type) {
      case AsciiDocElementType.heading1:
        return AppText.longformh1(element.content);
      case AsciiDocElementType.heading2:
        return AppText.longformh2(element.content);
      case AsciiDocElementType.heading3:
        return AppText.longformh3(element.content, color: theme.colors.white66);
      case AsciiDocElementType.heading4:
        return AppText.longformh4(element.content);
      case AsciiDocElementType.heading5:
        return AppText.longformh5(element.content, color: theme.colors.white66);
      case AsciiDocElementType.codeBlock:
        return AppCodeBlock(
          code: element.content,
          language: element.attributes?['language'] ?? 'plain',
        );
      case AsciiDocElementType.paragraph:
        return AppText.regArticle(
          element.content,
          color: theme.colors.white,
        );
      default:
        return AppText.regArticle(element.content);
    }
  }
}
