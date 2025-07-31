import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'profile_pic.dart';

enum LabProfilePicLiveSize {
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

class LabProfilePicLive extends StatelessWidget {
  final String? profilePicUrl;
  final Profile? profile;
  final String? name;
  final String? pubkey;
  final LabProfilePicLiveSize size;
  final VoidCallback onTap;

  LabProfilePicLive(
    this.profile, {
    super.key,
    this.size = LabProfilePicLiveSize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePicLive.fromUrl(
    this.profilePicUrl, {
    super.key,
    this.size = LabProfilePicLiveSize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profile = null,
        name = null,
        pubkey = null;

  LabProfilePicLive.fromPubkey(
    this.pubkey, {
    super.key,
    this.size = LabProfilePicLiveSize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        name = null,
        profile = null,
        profilePicUrl = null;

  LabProfilePicLive.fromNameAndPubkey(
    this.name,
    this.pubkey, {
    super.key,
    this.size = LabProfilePicLiveSize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profile = null,
        profilePicUrl = null;

  LabProfilePicLive.s38(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicLiveSize.s38,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicLive.s40(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicLiveSize.s40,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicLive.s48(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicLiveSize.s48,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicLive.s56(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicLiveSize.s56,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicLive.s64(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicLiveSize.s64,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicLive.s72(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicLiveSize.s72,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicLive.s80(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicLiveSize.s80,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicLive.s96(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicLiveSize.s96,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicLive.s104(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicLiveSize.s104,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  double _resolveSize(LabProfilePicLiveSize size, LabSizesData sizes) {
    switch (size) {
      case LabProfilePicLiveSize.s38:
        return sizes.s38;
      case LabProfilePicLiveSize.s40:
        return sizes.s40;
      case LabProfilePicLiveSize.s48:
        return sizes.s48;
      case LabProfilePicLiveSize.s56:
        return sizes.s56;
      case LabProfilePicLiveSize.s64:
        return sizes.s64;
      case LabProfilePicLiveSize.s72:
        return sizes.s72;
      case LabProfilePicLiveSize.s80:
        return sizes.s80;
      case LabProfilePicLiveSize.s96:
        return sizes.s96;
      case LabProfilePicLiveSize.s104:
        return sizes.s104;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final sizes = theme.sizes;
    final resolvedSize = _resolveSize(size, sizes);
    final outerBorderThickness = LabLineThicknessData.normal().medium;
    final innerBorderThickness = LabLineThicknessData.normal().thin;
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
              LabContainer(
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
                child: LabProfilePicContent(
                  profile: profile,
                  name: name,
                  pubkey: pubkey,
                  profilePicUrl: profilePicUrl,
                  size: adjustedInnerSize2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
