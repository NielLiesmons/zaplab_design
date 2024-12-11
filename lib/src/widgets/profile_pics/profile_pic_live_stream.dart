import 'package:zaplab_design/zaplab_design.dart';

enum AppProfilePicStreamSize {
  s38,
  s40,
  s48,
  s56,
  s64,
  s72,
  s80,
  s96,
}

class AppProfilePicStream extends StatelessWidget {
  const AppProfilePicStream(
    this.imageUrl, {
    Key? key,
    this.size = AppProfilePicStreamSize.s38,
  }) : super(key: key);

  const AppProfilePicStream.s38(this.imageUrl, {Key? key})
      : size = AppProfilePicStreamSize.s38,
        super(key: key);
  const AppProfilePicStream.s40(this.imageUrl, {Key? key})
      : size = AppProfilePicStreamSize.s40,
        super(key: key);
  const AppProfilePicStream.s48(this.imageUrl, {Key? key})
      : size = AppProfilePicStreamSize.s48,
        super(key: key);
  const AppProfilePicStream.s56(this.imageUrl, {Key? key})
      : size = AppProfilePicStreamSize.s56,
        super(key: key);
  const AppProfilePicStream.s64(this.imageUrl, {Key? key})
      : size = AppProfilePicStreamSize.s64,
        super(key: key);
  const AppProfilePicStream.s72(this.imageUrl, {Key? key})
      : size = AppProfilePicStreamSize.s72,
        super(key: key);
  const AppProfilePicStream.s80(this.imageUrl, {Key? key})
      : size = AppProfilePicStreamSize.s80,
        super(key: key);
  const AppProfilePicStream.s96(this.imageUrl, {Key? key})
      : size = AppProfilePicStreamSize.s96,
        super(key: key);

  final String imageUrl;
  final AppProfilePicStreamSize size;

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
    final double adjustedInnerSize2 = resolvedSize - 14;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer gradient border using a CustomPainter
        CustomPaint(
          size: Size(adjustedOuterSize, adjustedOuterSize),
          painter: GradientBorderPainter(
            borderWidth: outerBorderThickness,
            gradient: theme.colors.rouge, // Your gradient color
          ),
        ),

        CustomPaint(
          size: Size(adjustedInnerSize, adjustedInnerSize),
          painter: GradientBorderPainter(
            borderWidth: outerBorderThickness,
            gradient: theme.colors.rouge66, // Your gradient color
          ),
        ),

        // Inner profile pic with border
        Container(
          width: adjustedInnerSize2,
          height: adjustedInnerSize2,
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
              errorBuilder: (context, error, stackTrace) {
                final fallbackIconSize = adjustedInnerSize2 * 0.6;
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

  double _resolveSize(AppProfilePicStreamSize size, AppSizesData sizes) {
    switch (size) {
      case AppProfilePicStreamSize.s38:
        return sizes.s38;
      case AppProfilePicStreamSize.s40:
        return sizes.s40;
      case AppProfilePicStreamSize.s48:
        return sizes.s48;
      case AppProfilePicStreamSize.s56:
        return sizes.s56;
      case AppProfilePicStreamSize.s64:
        return sizes.s64;
      case AppProfilePicStreamSize.s72:
        return sizes.s72;
      case AppProfilePicStreamSize.s80:
        return sizes.s80;
      case AppProfilePicStreamSize.s96:
        return sizes.s96;
    }
  }
}
