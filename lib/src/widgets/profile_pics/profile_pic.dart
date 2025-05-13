import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:zaplab_design/src/utils/npub_color.dart';

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
  final String? profilePicUrl;
  final Profile? profile;
  final AppProfilePicSize size;
  final VoidCallback onTap;

  AppProfilePic(
    this.profile, {
    super.key,
    this.size = AppProfilePicSize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.fromUrl(
    this.profilePicUrl, {
    super.key,
    this.size = AppProfilePicSize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profile = null;

  AppProfilePic.s12(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s12,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.s16(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s16,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.s18(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s18,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.s20(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s20,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.s24(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s24,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.s28(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s28,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.s32(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s32,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.s38(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s38,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.s40(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s40,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.s48(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s48,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.s56(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s56,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.s64(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s64,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.s72(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s72,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.s80(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s80,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.s96(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s96,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePic.s104(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicSize.s104,
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
              child: _effectiveUrl != null && _effectiveUrl!.isNotEmpty
                  ? Image.network(
                      _effectiveUrl!,
                      width: resolvedSize,
                      height: resolvedSize,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const AppSkeletonLoader();
                      },
                      errorBuilder: (context, error, stackTrace) {
                        if (profile != null) {
                          return Container(
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
