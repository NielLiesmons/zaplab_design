import 'package:zaplab_design/zaplab_design.dart';

class AppEmojiImage extends StatelessWidget {
  final String emojiUrl;
  final String emojiName;
  final double size;
  final double opacity;

  const AppEmojiImage({
    super.key,
    required this.emojiUrl,
    required this.emojiName,
    this.size = 18,
    this.opacity = 1.0,
  });

  // Find the closest available icon size that's not larger than the requested size
  AppIconSize _getClosestIconSize(double targetSize) {
    final availableSizes = [
      AppIconSize.s4,
      AppIconSize.s8,
      AppIconSize.s10,
      AppIconSize.s12,
      AppIconSize.s14,
      AppIconSize.s16,
      AppIconSize.s18,
      AppIconSize.s20,
      AppIconSize.s24,
      AppIconSize.s28,
      AppIconSize.s32,
      AppIconSize.s38,
      AppIconSize.s40,
    ];

    // Find the largest size that's not bigger than the target
    for (int i = availableSizes.length - 1; i >= 0; i--) {
      if (double.parse(availableSizes[i].name.substring(1)) <= targetSize) {
        return availableSizes[i];
      }
    }

    // If all sizes are bigger than target, return smallest size
    return AppIconSize.s4;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    if (emojiUrl.startsWith('assets/')) {
      return Opacity(
        opacity: opacity,
        child: Image(
          image: AssetImage(
            emojiUrl,
            package: 'zaplab_design',
          ),
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return AppIcon(
              theme.icons.characters.emojiFill,
              size: _getClosestIconSize(size),
              color: theme.colors.white33,
            );
          },
        ),
      );
    }

    return Opacity(
      opacity: opacity,
      child: Image.network(
        emojiUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const AppSkeletonLoader();
        },
        errorBuilder: (context, error, stackTrace) {
          return AppIcon(
            theme.icons.characters.emojiFill,
            size: _getClosestIconSize(size),
            color: theme.colors.white33,
          );
        },
      ),
    );
  }
}

class AppEmojiContentType extends StatelessWidget {
  const AppEmojiContentType({
    super.key,
    required this.contentType,
    this.size = 32,
    this.opacity = 1.0,
  });
  final String contentType;
  final double size;
  final double opacity;

  // Find the closest available icon size that's not larger than the requested size
  AppIconSize _getClosestIconSize(double targetSize) {
    final availableSizes = [
      AppIconSize.s4,
      AppIconSize.s8,
      AppIconSize.s10,
      AppIconSize.s12,
      AppIconSize.s14,
      AppIconSize.s16,
      AppIconSize.s18,
      AppIconSize.s20,
      AppIconSize.s24,
      AppIconSize.s28,
      AppIconSize.s32,
      AppIconSize.s38,
      AppIconSize.s40,
    ];

    // Find the largest size that's not bigger than the target
    for (int i = availableSizes.length - 1; i >= 0; i--) {
      if (double.parse(availableSizes[i].name.substring(1)) <= targetSize) {
        return availableSizes[i];
      }
    }

    // If all sizes are bigger than target, return smallest size
    return AppIconSize.s4;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Opacity(
      opacity: opacity,
      child: Image(
        image: AssetImage(
          'assets/emoji/$contentType.png',
          package: 'zaplab_design',
        ),
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return AppIcon(
            theme.icons.characters.emojiFill,
            size: _getClosestIconSize(size),
            color: theme.colors.white33,
          );
        },
      ),
    );
  }
}
