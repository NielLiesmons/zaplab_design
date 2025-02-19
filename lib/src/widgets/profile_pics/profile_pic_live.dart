import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

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
  AppProfilePicLive(
    this.profilePicUrl, {
    Key? key,
    this.size = AppProfilePicLiveSize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        super(key: key);

  AppProfilePicLive.s38(this.profilePicUrl, {Key? key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s38,
        onTap = onTap ?? (() {}),
        super(key: key);
  AppProfilePicLive.s40(this.profilePicUrl, {Key? key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s40,
        onTap = onTap ?? (() {}),
        super(key: key);
  AppProfilePicLive.s48(this.profilePicUrl, {Key? key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s48,
        onTap = onTap ?? (() {}),
        super(key: key);
  AppProfilePicLive.s56(this.profilePicUrl, {Key? key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s56,
        onTap = onTap ?? (() {}),
        super(key: key);
  AppProfilePicLive.s64(this.profilePicUrl, {Key? key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s64,
        onTap = onTap ?? (() {}),
        super(key: key);
  AppProfilePicLive.s72(this.profilePicUrl, {Key? key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s72,
        onTap = onTap ?? (() {}),
        super(key: key);
  AppProfilePicLive.s80(this.profilePicUrl, {Key? key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s80,
        onTap = onTap ?? (() {}),
        super(key: key);
  AppProfilePicLive.s96(this.profilePicUrl, {Key? key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s96,
        onTap = onTap ?? (() {}),
        super(key: key);
  AppProfilePicLive.s104(this.profilePicUrl, {Key? key, VoidCallback? onTap})
      : size = AppProfilePicLiveSize.s104,
        onTap = onTap ?? (() {}),
        super(key: key);

  final String profilePicUrl;
  final AppProfilePicLiveSize size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final sizes = theme.sizes;
    final resolvedSize = _resolveSize(size, sizes);
    final outerBorderThickness = LineThicknessData.normal().medium;
    final innerBorderThickness = LineThicknessData.normal().thin;
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
                  color: theme.colors.white16,
                  border: Border.all(
                    color: theme.colors.white16,
                    width: innerBorderThickness,
                  ),
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
