import 'package:zaplab_design/zaplab_design.dart';

enum AppProfilePicSquareSize {
  s48,
  s56,
  s64,
  s72,
  s80,
  s96,
  s104,
}

class AppProfilePicSquare extends StatelessWidget {
  const AppProfilePicSquare(
    this.imageUrl, {
    Key? key,
    this.size = AppProfilePicSquareSize.s56,
  }) : super(key: key);

  const AppProfilePicSquare.s48(this.imageUrl, {Key? key})
      : size = AppProfilePicSquareSize.s48,
        super(key: key);
  const AppProfilePicSquare.s56(this.imageUrl, {Key? key})
      : size = AppProfilePicSquareSize.s56,
        super(key: key);
  const AppProfilePicSquare.s64(this.imageUrl, {Key? key})
      : size = AppProfilePicSquareSize.s64,
        super(key: key);
  const AppProfilePicSquare.s72(this.imageUrl, {Key? key})
      : size = AppProfilePicSquareSize.s72,
        super(key: key);
  const AppProfilePicSquare.s80(this.imageUrl, {Key? key})
      : size = AppProfilePicSquareSize.s80,
        super(key: key);
  const AppProfilePicSquare.s96(this.imageUrl, {Key? key})
      : size = AppProfilePicSquareSize.s96,
        super(key: key);
  const AppProfilePicSquare.s104(this.imageUrl, {Key? key})
      : size = AppProfilePicSquareSize.s104,
        super(key: key);

  final String imageUrl;
  final AppProfilePicSquareSize size;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final sizes = theme.sizes;
    final icons = theme.icons;
    final resolvedSize = _resolveSize(size, sizes);
    final thickness = LineThicknessData.normal().thin;

    final borderRadius = resolvedSize >= sizes.s72
        ? theme.radius.asBorderRadius().rad24
        : theme.radius.asBorderRadius().rad16;

    return AppContainer(
      width: resolvedSize,
      height: resolvedSize,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(
          color: theme.colors.white16,
          width: thickness,
        ),
        color: theme.colors.grey66,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            final fallbackIconSize = resolvedSize * 0.6;
            return Center(
              child: Text(
                icons.characters.profile,
                style: TextStyle(
                  fontFamily: icons.fontFamily,
                  package: icons.fontPackage,
                  fontSize: fallbackIconSize,
                  color: theme.colors.white33,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double _resolveSize(AppProfilePicSquareSize size, AppSizesData sizes) {
    switch (size) {
      case AppProfilePicSquareSize.s48:
        return sizes.s48;
      case AppProfilePicSquareSize.s56:
        return sizes.s56;
      case AppProfilePicSquareSize.s64:
        return sizes.s64;
      case AppProfilePicSquareSize.s72:
        return sizes.s72;
      case AppProfilePicSquareSize.s80:
        return sizes.s80;
      case AppProfilePicSquareSize.s96:
        return sizes.s96;
      case AppProfilePicSquareSize.s104:
        return sizes.s104;
    }
  }
}
