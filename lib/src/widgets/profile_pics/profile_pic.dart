import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

enum AppProfilePicSize {
  s12,
  s16,
  s18,
  s20,
  s24,
  s28,
  s32,
  s38,
  s40,
  s48,
  s56,
  s64,
  s72,
  s80,
  s96,
  s104,
}

class AppProfilePic extends StatelessWidget {
  AppProfilePic(
    this.profilePicUrl, {
    super.key,
    this.size = AppProfilePicSize.s38,
    VoidCallback? onTap,
  }) : onTap = onTap ?? (() {});

  AppProfilePic.s12(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s12,
        onTap = onTap ?? (() {});
  AppProfilePic.s16(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s16,
        onTap = onTap ?? (() {});
  AppProfilePic.s18(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s18,
        onTap = onTap ?? (() {});
  AppProfilePic.s20(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s20,
        onTap = onTap ?? (() {});
  AppProfilePic.s24(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s24,
        onTap = onTap ?? (() {});
  AppProfilePic.s28(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s28,
        onTap = onTap ?? (() {});
  AppProfilePic.s32(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s32,
        onTap = onTap ?? (() {});
  AppProfilePic.s38(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s38,
        onTap = onTap ?? (() {});
  AppProfilePic.s40(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s40,
        onTap = onTap ?? (() {});
  AppProfilePic.s48(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s48,
        onTap = onTap ?? (() {});
  AppProfilePic.s56(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s56,
        onTap = onTap ?? (() {});
  AppProfilePic.s64(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s64,
        onTap = onTap ?? (() {});
  AppProfilePic.s72(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s72,
        onTap = onTap ?? (() {});
  AppProfilePic.s80(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s80,
        onTap = onTap ?? (() {});
  AppProfilePic.s96(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s96,
        onTap = onTap ?? (() {});
  AppProfilePic.s104(this.profilePicUrl, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s104,
        onTap = onTap ?? (() {});

  final String profilePicUrl;
  final AppProfilePicSize size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final sizes = theme.sizes;
    final icons = theme.icons;
    final resolvedSize = _resolveSize(size, sizes);
    final thickness = AppLineThicknessData.normal().thin;

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
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colors.white16,
                width: thickness,
              ),
              color: theme.colors.gray66,
            ),
            child: ClipOval(
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

  double _resolveSize(AppProfilePicSize size, AppSizesData sizes) {
    switch (size) {
      case AppProfilePicSize.s12:
        return sizes.s12;
      case AppProfilePicSize.s16:
        return sizes.s16;
      case AppProfilePicSize.s18:
        return sizes.s18;
      case AppProfilePicSize.s20:
        return sizes.s20;
      case AppProfilePicSize.s24:
        return sizes.s24;
      case AppProfilePicSize.s28:
        return sizes.s28;
      case AppProfilePicSize.s32:
        return sizes.s32;
      case AppProfilePicSize.s38:
        return sizes.s38;
      case AppProfilePicSize.s40:
        return sizes.s40;
      case AppProfilePicSize.s48:
        return sizes.s48;
      case AppProfilePicSize.s56:
        return sizes.s56;
      case AppProfilePicSize.s64:
        return sizes.s64;
      case AppProfilePicSize.s72:
        return sizes.s72;
      case AppProfilePicSize.s80:
        return sizes.s80;
      case AppProfilePicSize.s96:
        return sizes.s96;
      case AppProfilePicSize.s104:
        return sizes.s104;
    }
  }
}
