import 'package:zaplab_design/zaplab_design.dart';
import 'dart:convert';

class CodeBlockHighlighter extends StatelessWidget {
  final String code;
  final String? language;

  const CodeBlockHighlighter({
    super.key,
    required this.code,
    this.language,
  });

  Color _getMidGradientColor(Gradient gradient) {
    final LinearGradient linearGradient = gradient as LinearGradient;
    return Color.lerp(
        linearGradient.colors.first, linearGradient.colors.last, 0.5)!;
  }

  String _formatJson(String jsonString) {
    try {
      final json = jsonDecode(jsonString);
      final encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (e) {
      return jsonString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final List<TextSpan> spans = [];

    // Format code if it's JSON
    final formattedCode =
        language?.toLowerCase() == 'json' ? _formatJson(code) : code;

    // Define all patterns with their colors
    final patterns = [
      (RegExp(r'"[^"]*"'), theme.colors.blurpleLightColor), // double quotes
      (RegExp(r"'[^']*'"), theme.colors.blurpleLightColor), // single quotes
      (RegExp(r'[\[\]]'), theme.colors.goldColor66), // square brackets
      (RegExp(r'[\(\)]'), theme.colors.white66), // parentheses
      (RegExp(r'[\{\}]'), theme.colors.goldColor), // curly braces
      (RegExp(r'[,;]'), theme.colors.white33), // comma and semicolon
    ];

    var currentPosition = 0;
    while (currentPosition < formattedCode.length) {
      var matchFound = false;

      for (final (pattern, color) in patterns) {
        final match = pattern.matchAsPrefix(formattedCode, currentPosition);
        if (match != null) {
          if (match.start > currentPosition) {
            spans.add(TextSpan(
              text: formattedCode.substring(currentPosition, match.start),
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
          text: formattedCode.substring(currentPosition, nextPosition),
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
