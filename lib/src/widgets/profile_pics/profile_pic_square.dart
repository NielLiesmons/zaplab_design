import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

enum AppProfilePicSquareSize {
  s32,
  s38,
  s48,
  s56,
  s64,
  s72,
  s80,
  s96,
  s104,
}

class AppProfilePicSquare extends StatelessWidget {
  final String? profilePicUrl;
  final Profile? profile;
  final AppProfilePicSquareSize size;
  final VoidCallback onTap;

  AppProfilePicSquare(
    this.profile, {
    super.key,
    this.size = AppProfilePicSquareSize.s56,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePicSquare.fromUrl(
    this.profilePicUrl, {
    super.key,
    this.size = AppProfilePicSquareSize.s56,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profile = null;

  AppProfilePicSquare.s32(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s32,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicSquare.s38(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s38,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicSquare.s48(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s48,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicSquare.s56(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s56,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicSquare.s64(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s64,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicSquare.s72(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s72,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicSquare.s80(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s80,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicSquare.s96(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s96,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicSquare.s104(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSquareSize.s104,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  String? get _effectiveUrl => profilePicUrl ?? profile?.pictureUrl;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final sizes = theme.sizes;
    final icons = theme.icons;
    final resolvedSize = _resolveSize(size, sizes);
    final thickness = AppLineThicknessData.normal().thin;
    final borderRadius = resolvedSize >= sizes.s72
        ? theme.radius.asBorderRadius().rad24
        : resolvedSize >= sizes.s48
            ? theme.radius.asBorderRadius().rad16
            : theme.radius.asBorderRadius().rad8;

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
              color: theme.colors.gray,
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: _effectiveUrl != null && _effectiveUrl!.isNotEmpty
                  ? Image.network(
                      _effectiveUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const AppSkeletonLoader();
                      },
                      errorBuilder: (context, error, stackTrace) {
                        if (profile != null) {
                          return Container(
                            color: Color(profileToColor(profile!))
                                .withValues(alpha: 0.66),
                            child: profile!.name?.isNotEmpty == true
                                ? Center(
                                    child: Text(
                                      profile!.name![0].toUpperCase(),
                                      style: TextStyle(
                                        color: theme.colors.white66,
                                        fontSize: resolvedSize * 0.56,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : null,
                          );
                        }
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
                    )
                  : profile != null
                      ? Container(
                          color: Color(profileToColor(profile!)),
                          child: profile!.name?.isNotEmpty == true
                              ? Center(
                                  child: Text(
                                    profile!.name![0].toUpperCase(),
                                    style: TextStyle(
                                      color: theme.colors.white66,
                                      fontSize: resolvedSize * 0.56,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : null,
                        )
                      : Center(
                          child: Text(
                            icons.characters.profile,
                            style: TextStyle(
                              fontFamily: icons.fontFamily,
                              package: icons.fontPackage,
                              fontSize: resolvedSize * 0.6,
                              color: theme.colors.white33,
                            ),
                          ),
                        ),
            ),
          ),
        );
      },
    );
  }

  double _resolveSize(AppProfilePicSquareSize size, AppSizesData sizes) {
    switch (size) {
      case AppProfilePicSquareSize.s32:
        return sizes.s32;
      case AppProfilePicSquareSize.s38:
        return sizes.s38;
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
