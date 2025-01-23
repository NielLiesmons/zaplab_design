import 'package:zaplab_design/zaplab_design.dart';

class CodeBlockHighlighter extends StatelessWidget {
  final String code;

  const CodeBlockHighlighter({
    super.key,
    required this.code,
  });

  Color _getMidGradientColor(Gradient gradient) {
    final LinearGradient linearGradient = gradient as LinearGradient;
    return Color.lerp(
        linearGradient.colors.first, linearGradient.colors.last, 0.5)!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final List<TextSpan> spans = [];

    // Define all patterns with their colors
    final patterns = [
      (RegExp(r'"[^"]*"'), theme.colors.blurpleColor), // double quotes
      (RegExp(r"'[^']*'"), theme.colors.blurpleColor), // single quotes
      (RegExp(r'[\[\]]'), theme.colors.goldColor66), // square brackets
      (RegExp(r'[\(\)]'), theme.colors.white66), // parentheses
      (RegExp(r'[\{\}]'), theme.colors.goldColor), // curly braces
      (RegExp(r'[,;]'), theme.colors.white33), // comma and semicolon
    ];

    var currentPosition = 0;
    while (currentPosition < code.length) {
      var matchFound = false;

      for (final (pattern, color) in patterns) {
        final match = pattern.matchAsPrefix(code, currentPosition);
        if (match != null) {
          if (match.start > currentPosition) {
            spans.add(TextSpan(
              text: code.substring(currentPosition, match.start),
            ));
          }
          spans.add(TextSpan(
            text: match.group(0),
            style: TextStyle(color: color),
          ));
          currentPosition = match.end;
          matchFound = true;
          break;
        }
      }

      if (!matchFound) {
        // Move to next character if no pattern matches
        final nextPosition = currentPosition + 1;
        spans.add(TextSpan(
          text: code.substring(currentPosition, nextPosition),
        ));
        currentPosition = nextPosition;
      }
    }

    return RichText(
      text: TextSpan(
        style: theme.typography.code.copyWith(
          color: theme.colors.white,
        ),
        children: spans,
      ),
    );
  }
}
