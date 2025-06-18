import 'package:zaplab_design/zaplab_design.dart';

class LabEmojiImage extends StatelessWidget {
  final String emojiUrl;
  final String emojiName;
  final double size;
  final double opacity;

  const LabEmojiImage({
    super.key,
    required this.emojiUrl,
    required this.emojiName,
    this.size = 18,
    this.opacity = 1.0,
  });

  // Find the closest available icon size that's not larger than the requested size
  LabIconSize _getClosestIconSize(double targetSize) {
    final availableSizes = [
      LabIconSize.s4,
      LabIconSize.s8,
      LabIconSize.s10,
      LabIconSize.s12,
      LabIconSize.s14,
      LabIconSize.s16,
      LabIconSize.s18,
      LabIconSize.s20,
      LabIconSize.s24,
      LabIconSize.s28,
      LabIconSize.s32,
      LabIconSize.s38,
      LabIconSize.s40,
    ];

    // Find the largest size that's not bigger than the target
    for (int i = availableSizes.length - 1; i >= 0; i--) {
      if (double.parse(availableSizes[i].name.substring(1)) <= targetSize) {
        return availableSizes[i];
      }
    }

    // If all sizes are bigger than target, return smallest size
    return LabIconSize.s4;
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

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
            return LabIcon(
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
          return const LabSkeletonLoader();
        },
        errorBuilder: (context, error, stackTrace) {
          return LabIcon(
            theme.icons.characters.emojiFill,
            size: _getClosestIconSize(size),
            color: theme.colors.white33,
          );
        },
      ),
    );
  }
}

class LabEmojiContentType extends StatelessWidget {
  const LabEmojiContentType({
    super.key,
    required this.contentType,
    this.size = 32,
    this.opacity = 1.0,
  });
  final String contentType;
  final double size;
  final double opacity;

  // Find the closest available icon size that's not larger than the requested size
  LabIconSize _getClosestIconSize(double targetSize) {
    final availableSizes = [
      LabIconSize.s4,
      LabIconSize.s8,
      LabIconSize.s10,
      LabIconSize.s12,
      LabIconSize.s14,
      LabIconSize.s16,
      LabIconSize.s18,
      LabIconSize.s20,
      LabIconSize.s24,
      LabIconSize.s28,
      LabIconSize.s32,
      LabIconSize.s38,
      LabIconSize.s40,
    ];

    // Find the largest size that's not bigger than the target
    for (int i = availableSizes.length - 1; i >= 0; i--) {
      if (double.parse(availableSizes[i].name.substring(1)) <= targetSize) {
        return availableSizes[i];
      }
    }

    // If all sizes are bigger than target, return smallest size
    return LabIconSize.s4;
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

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
          return LabIcon(
            theme.icons.characters.emojiFill,
            size: _getClosestIconSize(size),
            color: theme.colors.white33,
          );
        },
      ),
    );
  }
}
