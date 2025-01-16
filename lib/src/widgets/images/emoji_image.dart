import 'package:zaplab_design/zaplab_design.dart';

class AppEmojiImage extends StatelessWidget {
  final String emojiUrl;
  final double size;

  const AppEmojiImage({
    super.key,
    required this.emojiUrl,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Image.network(
      emojiUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return AppIcon.s16(
          theme.icons.characters.heart,
          color: theme.colors.white33,
        );
      },
    );
  }
}
