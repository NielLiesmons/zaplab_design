import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'dart:ui';

enum LabProfilePicSize {
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

class LabProfilePic extends StatelessWidget {
  final String? profilePicUrl;
  final Profile? profile;
  final String? name;
  final String? pubkey;
  final LabProfilePicSize size;
  final VoidCallback onTap;

  LabProfilePic(
    this.profile, {
    super.key,
    this.size = LabProfilePicSize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.fromUrl(
    this.profilePicUrl, {
    super.key,
    this.size = LabProfilePicSize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profile = null,
        name = null,
        pubkey = null;

  LabProfilePic.fromNameAndPubkey(
    this.name,
    this.pubkey, {
    super.key,
    this.size = LabProfilePicSize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profile = null,
        profilePicUrl = null;

  LabProfilePic.s12(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s12,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.s16(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s16,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.s18(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s18,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.s20(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s20,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.s24(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s24,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.s28(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s28,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.s32(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s32,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.s38(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s38,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.s40(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s40,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.s48(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s48,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.s56(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s56,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.s64(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s64,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.s72(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s72,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.s80(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s80,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.s96(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s96,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePic.s104(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSize.s104,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  String? get _effectiveUrl => profilePicUrl ?? profile?.pictureUrl;

  int _getProfileColor() {
    if (profile != null) {
      return profileToColor(profile!);
    }
    if (pubkey != null) {
      return hexToColor(pubkey!).toIntWithAlpha();
    }
    return 0xFF808080; // Default gray color
  }

  String? get _effectiveName => name ?? profile?.name;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final sizes = theme.sizes;
    final icons = theme.icons;
    final resolvedSize = _resolveSize(size, sizes);
    final thickness = LabLineThicknessData.normal().thin;

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
          child: LabContainer(
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
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: _effectiveUrl != null && _effectiveUrl!.isNotEmpty
                    ? Image.network(
                        _effectiveUrl!,
                        width: resolvedSize,
                        height: resolvedSize,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const LabSkeletonLoader();
                        },
                        errorBuilder: (context, error, stackTrace) {
                          if (profile != null ||
                              (name != null && pubkey != null)) {
                            return Container(
                              color: Color(_getProfileColor())
                                  .withValues(alpha: 0.24),
                              child: _effectiveName?.isNotEmpty == true
                                  ? Center(
                                      child: Stack(
                                        children: [
                                          Text(
                                            _effectiveName![0].toUpperCase(),
                                            style: TextStyle(
                                              color: Color(_getProfileColor()),
                                              fontSize: resolvedSize * 0.56,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            _effectiveName![0].toUpperCase(),
                                            style: TextStyle(
                                              color: theme.colors.white16,
                                              fontSize: resolvedSize * 0.56,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
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
                    : profile != null || (name != null && pubkey != null)
                        ? Container(
                            color: Color(_getProfileColor())
                                .withValues(alpha: 0.24),
                            child: _effectiveName?.isNotEmpty == true
                                ? Center(
                                    child: Stack(
                                      children: [
                                        Text(
                                          _effectiveName![0].toUpperCase(),
                                          style: TextStyle(
                                            color: Color(_getProfileColor()),
                                            fontSize: resolvedSize * 0.56,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          _effectiveName![0].toUpperCase(),
                                          style: TextStyle(
                                            color: theme.colors.white16,
                                            fontSize: resolvedSize * 0.56,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
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
          ),
        );
      },
    );
  }

  double _resolveSize(LabProfilePicSize size, LabSizesData sizes) {
    switch (size) {
      case LabProfilePicSize.s12:
        return sizes.s12;
      case LabProfilePicSize.s16:
        return sizes.s16;
      case LabProfilePicSize.s18:
        return sizes.s18;
      case LabProfilePicSize.s20:
        return sizes.s20;
      case LabProfilePicSize.s24:
        return sizes.s24;
      case LabProfilePicSize.s28:
        return sizes.s28;
      case LabProfilePicSize.s32:
        return sizes.s32;
      case LabProfilePicSize.s38:
        return sizes.s38;
      case LabProfilePicSize.s40:
        return sizes.s40;
      case LabProfilePicSize.s48:
        return sizes.s48;
      case LabProfilePicSize.s56:
        return sizes.s56;
      case LabProfilePicSize.s64:
        return sizes.s64;
      case LabProfilePicSize.s72:
        return sizes.s72;
      case LabProfilePicSize.s80:
        return sizes.s80;
      case LabProfilePicSize.s96:
        return sizes.s96;
      case LabProfilePicSize.s104:
        return sizes.s104;
    }
  }
}
