import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

enum AppProfilePicStorySize {
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

class AppProfilePicStory extends StatelessWidget {
  final String? profilePicUrl;
  final Profile? profile;
  final AppProfilePicStorySize size;
  final VoidCallback onTap;

  AppProfilePicStory(
    this.profile, {
    super.key,
    this.size = AppProfilePicStorySize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profilePicUrl = null;

  AppProfilePicStory.fromUrl(
    this.profilePicUrl, {
    super.key,
    this.size = AppProfilePicStorySize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profile = null;

  AppProfilePicStory.s38(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicStorySize.s38,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicStory.s40(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicStorySize.s40,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicStory.s48(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicStorySize.s48,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicStory.s56(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicStorySize.s56,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicStory.s64(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicStorySize.s64,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicStory.s72(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicStorySize.s72,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicStory.s80(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicStorySize.s80,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicStory.s96(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicStorySize.s96,
        onTap = onTap ?? (() {}),
        profilePicUrl = null;
  AppProfilePicStory.s104(this.profile, {super.key, VoidCallback? onTap})
      : size = AppProfilePicStorySize.s104,
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
                  gradient: theme.colors.blurple,
                ),
              ),
              Container(
                width: adjustedInnerSize,
                height: adjustedInnerSize,
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
                                            fontSize: adjustedInnerSize * 0.56,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : null,
                              );
                            }
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
                                          fontSize: adjustedInnerSize * 0.56,
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
                                  fontSize: adjustedInnerSize * 0.6,
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
      case AppProfilePicStorySize.s104:
        return sizes.s104;
    }
  }
}
