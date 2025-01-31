import 'package:zaplab_design/zaplab_design.dart';

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
      AsciiDocElementType.listItem => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
        ),
      AsciiDocElementType.orderedListItem => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
        ),
      AsciiDocElementType.horizontalRule => const AppEdgeInsets.only(
          bottom: AppGapSize.none,
        ),
      _ => const AppEdgeInsets.only(bottom: AppGapSize.s8),
    };

    return AppContainer(
      padding: spacing,
      child: _buildElement(context, element),
    );
  }

  Widget _buildElement(BuildContext context, AsciiDocElement element) {
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
      // case AsciiDocElementType.paragraph:
      //   return AppText.regArticle(
      //     element.content,
      //     color: theme.colors.white,
      //   );
      case AsciiDocElementType.admonition:
        return AppAdmonition(
          type: element.attributes?['type'] ?? 'note',
          child: AppText.reg14(
            element.content,
            color: theme.colors.white,
          ),
        );
      case AsciiDocElementType.listItem:
      case AsciiDocElementType.orderedListItem:
        final String number = element.attributes?['number'] ?? '•';
        final String displayNumber =
            element.type == AsciiDocElementType.orderedListItem
                ? '$number.'
                : number;
        return Padding(
          padding: EdgeInsets.only(
            left: element.level * 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppContainer(
                padding: const AppEdgeInsets.only(
                  right: AppGapSize.s8,
                ),
                child: AppText.regArticle(
                  displayNumber,
                  color: theme.colors.white66,
                ),
              ),
              Expanded(
                child: AppText.regArticle(
                  element.content,
                  color: theme.colors.white,
                ),
              ),
            ],
          ),
        );
      case AsciiDocElementType.checkListItem:
        return Padding(
          padding: EdgeInsets.only(
            left: element.level * 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCheckBox(
                value: element.checked ?? false,
                onChanged: null,
              ),
              const AppGap.s8(),
              Expanded(
                child: AppText.regArticle(
                  element.content,
                  color: theme.colors.white,
                ),
              ),
            ],
          ),
        );
      case AsciiDocElementType.descriptionListItem:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.boldArticle(element.content),
            if (element.attributes?['description'] != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 4,
                ),
                child: AppText.regArticle(
                  element.attributes!['description']!,
                  color: theme.colors.white66,
                ),
              ),
          ],
        );
      case AsciiDocElementType.horizontalRule:
        return const AppContainer(
          padding: AppEdgeInsets.symmetric(vertical: AppGapSize.s16),
          child: AppDivider(),
        );
      case AsciiDocElementType.paragraph when element.children != null:
        return AppContainer(
          child: RichText(
            text: TextSpan(
              style: theme.typography.regArticle.copyWith(
                color: theme.colors.white,
              ),
              children: _buildStyledTextSpans(context, element.children!),
            ),
          ),
        );
      default:
        return AppText.regArticle(element.content);
    }
  }

  List<TextSpan> _buildStyledTextSpans(
      BuildContext context, List<AsciiDocElement> elements) {
    final theme = AppTheme.of(context);
    return elements.map((element) {
      final style = element.attributes?['style'];
      return TextSpan(
        text: element.content,
        style: TextStyle(
          color: theme.colors.white,
          fontWeight: (style == 'bold' || style == 'bold-italic')
              ? FontWeight.bold
              : null,
          fontStyle: (style == 'italic' || style == 'bold-italic')
              ? FontStyle.italic
              : null,
          decoration: switch (style) {
            'underline' => TextDecoration.underline,
            'line-through' => TextDecoration.lineThrough,
            _ => null,
          },
        ),
      );
    }).toList();
  }
}
