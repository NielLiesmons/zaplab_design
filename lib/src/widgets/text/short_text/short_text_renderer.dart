import 'package:zaplab_design/zaplab_design.dart';
import 'short_text_parser.dart';

class AppShortTextRenderer extends StatelessWidget {
  final String content;

  const AppShortTextRenderer({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final segments = ShortTextParser.parse(content);

    return RichText(
      text: TextSpan(
        style: theme.typography.reg14.copyWith(
          color: theme.colors.white,
        ),
        children: segments.map((segment) {
          // For now, just return plain text
          return TextSpan(text: segment.content);
        }).toList(),
      ),
    );
  }
}
