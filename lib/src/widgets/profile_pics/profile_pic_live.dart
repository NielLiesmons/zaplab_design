import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

enum AppProfilePicLiveSize {
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

class AppProfilePicLive extends StatelessWidget {
  final String? profilePicUrl;
  final Profile? profile;
  final AppProfilePicLiveSize size;
  final VoidCallback onTap;

  AppProfilePicLive(
    this.profile, {
    super.key,
    this.size = AppProfilePicLiveSize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePicLive.fromUrl(
    this.profilePicUrl, {
    super.key,
    this.size = AppProfilePicLiveSize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profile = null;

  AppProfilePicLive.s38(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s38,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicLive.s40(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s40,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicLive.s48(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s48,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicLive.s56(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s56,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicLive.s64(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s64,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicLive.s72(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s72,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicLive.s80(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s80,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicLive.s96(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s96,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicLive.s104(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s104,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;

  String? get _effectiveUrl => profilePicUrl ?? profile?.pictureUrl;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final sizes = theme.sizes;
    final resolvedSize = _resolveSize(size, sizes);
    final outerBorderThickness = AppLineThicknessData.normal().medium;
    final innerBorderThickness = AppLineThicknessData.normal().thin;
    final adjustedOuterSize = resolvedSize;
    final adjustedInnerSize = resolvedSize - 8;
    final adjustedInnerSize2 = resolvedSize - 14;

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
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(adjustedOuterSize, adjustedOuterSize),
                painter: GradientBorderPainter(
                  borderWidth: outerBorderThickness,
                  gradient: theme.colors.rouge,
                ),
              ),
              CustomPaint(
                size: Size(adjustedInnerSize, adjustedInnerSize),
                painter: GradientBorderPainter(
                  borderWidth: outerBorderThickness,
                  gradient: theme.colors.rouge66,
                ),
              ),
              AppContainer(
                width: adjustedInnerSize2,
                height: adjustedInnerSize2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colors.gray,
                  border: Border.all(
                    color: theme.colors.white16,
                    width: innerBorderThickness,
                  ),
                ),
                child: ClipOval(
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
                                            fontSize: adjustedInnerSize2 * 0.56,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : null,
                              );
                            }
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
                                          fontSize: adjustedInnerSize2 * 0.56,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : null,
                            )
                          : Center(
                              child: Text(
                                theme.icons.characters.profile,
                                style: TextStyle(
                                  fontFamily: theme.icons.fontFamily,
                                  package: theme.icons.fontPackage,
                                  fontSize: adjustedInnerSize2 * 0.6,
                                  color: theme.colors.white33,
                                ),
                              ),
                            ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _resolveSize(AppProfilePicLiveSize size, AppSizesData sizes) {
    switch (size) {
      case AppProfilePicLiveSize.s38:
        return sizes.s38;
      case AppProfilePicLiveSize.s40:
        return sizes.s40;
      case AppProfilePicLiveSize.s48:
        return sizes.s48;
      case AppProfilePicLiveSize.s56:
        return sizes.s56;
      case AppProfilePicLiveSize.s64:
        return sizes.s64;
      case AppProfilePicLiveSize.s72:
        return sizes.s72;
      case AppProfilePicLiveSize.s80:
        return sizes.s80;
      case AppProfilePicLiveSize.s96:
        return sizes.s96;
      case AppProfilePicLiveSize.s104:
        return sizes.s104;
    }
  }
}
