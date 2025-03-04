import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

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
  AppProfilePicSquare(
    this.profilePicUrl, {
    super.key,
    this.size = AppProfilePicSquareSize.s56,
    VoidCallback? onTap,
  }) : onTap = onTap ?? (() {});

  AppProfilePicSquare.s48(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s48,
        onTap = onTap ?? (() {});
  AppProfilePicSquare.s56(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s56,
        onTap = onTap ?? (() {});
  AppProfilePicSquare.s64(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s64,
        onTap = onTap ?? (() {});
  AppProfilePicSquare.s72(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s72,
        onTap = onTap ?? (() {});
  AppProfilePicSquare.s80(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s80,
        onTap = onTap ?? (() {});
  AppProfilePicSquare.s96(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s96,
        onTap = onTap ?? (() {});
  AppProfilePicSquare.s104(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s104,
        onTap = onTap ?? (() {});

  final String profilePicUrl;
  final AppProfilePicSquareSize size;
  final VoidCallback onTap;

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

    return TapBuilder(
      onTap: onTap,
      builder: (context, state, isFocused) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.98;
        } else if (state == TapState.hover) {
          scaleFactor = 1.02;
        }

        return Transform.scale(
          scale: scaleFactor,
          child: AppContainer(
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
                profilePicUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const AppSkeletonLoader();
                },
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
          ),
        );
      },
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
