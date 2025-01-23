import 'package:zaplab_design/zaplab_design.dart';

enum AppProfilePicStorySize {
  s38,
  s40,
  s48,
  s56,
  s64,
  s72,
  s80,
  s96,
}

class AppProfilePicStory extends StatelessWidget {
  const AppProfilePicStory(
    this.imageUrl, {
    Key? key,
    this.size = AppProfilePicStorySize.s38,
  }) : super(key: key);

  const AppProfilePicStory.s38(this.imageUrl, {Key? key})
      : size = AppProfilePicStorySize.s38,
        super(key: key);
  const AppProfilePicStory.s40(this.imageUrl, {Key? key})
      : size = AppProfilePicStorySize.s40,
        super(key: key);
  const AppProfilePicStory.s48(this.imageUrl, {Key? key})
      : size = AppProfilePicStorySize.s48,
        super(key: key);
  const AppProfilePicStory.s56(this.imageUrl, {Key? key})
      : size = AppProfilePicStorySize.s56,
        super(key: key);
  const AppProfilePicStory.s64(this.imageUrl, {Key? key})
      : size = AppProfilePicStorySize.s64,
        super(key: key);
  const AppProfilePicStory.s72(this.imageUrl, {Key? key})
      : size = AppProfilePicStorySize.s72,
        super(key: key);
  const AppProfilePicStory.s80(this.imageUrl, {Key? key})
      : size = AppProfilePicStorySize.s80,
        super(key: key);
  const AppProfilePicStory.s96(this.imageUrl, {Key? key})
      : size = AppProfilePicStorySize.s96,
        super(key: key);

  final String imageUrl;
  final AppProfilePicStorySize size;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final sizes = theme.sizes;
    final resolvedSize = _resolveSize(size, sizes);
    final double outerBorderThickness =
        LineThicknessData.normal().medium; // Fixed gradient border thickness
    final double innerBorderThickness = LineThicknessData.normal().thin;
    final double adjustedOuterSize = resolvedSize;
    final double adjustedInnerSize = resolvedSize - 8;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer gradient border using a CustomPainter
        CustomPaint(
          size: Size(adjustedOuterSize, adjustedOuterSize),
          painter: GradientBorderPainter(
            borderWidth: outerBorderThickness,
            gradient: theme.colors.blurple, // Your gradient color
          ),
        ),

        // Inner profile pic with border
        Container(
          width: adjustedInnerSize,
          height: adjustedInnerSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colors.white16,
            border: Border.all(
              color: theme.colors.white16, // Inner profile pic border color
              width: innerBorderThickness,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const AppSkeletonLoader();
              },
              errorBuilder: (context, error, stackTrace) {
                final fallbackIconSize = adjustedInnerSize * 0.6;
                return Center(
                  child: Text(
                    theme.icons.characters.profile,
                    style: TextStyle(
                      fontFamily: theme.icons.fontFamily,
                      package: theme.icons.fontPackage,
                      fontSize: fallbackIconSize,
                      color: theme.colors.white33,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  double _resolveSize(AppProfilePicStorySize size, AppSizesData sizes) {
    switch (size) {
      case AppProfilePicStorySize.s38:
        return sizes.s38;
      case AppProfilePicStorySize.s40:
        return sizes.s40;
      case AppProfilePicStorySize.s48:
        return sizes.s48;
      case AppProfilePicStorySize.s56:
        return sizes.s56;
      case AppProfilePicStorySize.s64:
        return sizes.s64;
      case AppProfilePicStorySize.s72:
        return sizes.s72;
      case AppProfilePicStorySize.s80:
        return sizes.s80;
      case AppProfilePicStorySize.s96:
        return sizes.s96;
    }
  }
}
