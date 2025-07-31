import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum LabProfilePicStorySize {
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

class LabProfilePicStory extends StatelessWidget {
  final String? profilePicUrl;
  final Profile? profile;
  final String? name;
  final String? pubkey;
  final LabProfilePicStorySize size;
  final VoidCallback onTap;

  LabProfilePicStory(
    this.profile, {
    super.key,
    this.size = LabProfilePicStorySize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePicStory.fromUrl(
    this.profilePicUrl, {
    super.key,
    this.size = LabProfilePicStorySize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profile = null,
        name = null,
        pubkey = null;

  LabProfilePicStory.fromPubkey(
    this.pubkey, {
    super.key,
    this.size = LabProfilePicStorySize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        name = null,
        profile = null,
        profilePicUrl = null;

  LabProfilePicStory.fromNameAndPubkey(
    this.name,
    this.pubkey, {
    super.key,
    this.size = LabProfilePicStorySize.s38,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profile = null,
        profilePicUrl = null;

  LabProfilePicStory.s38(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicStorySize.s38,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicStory.s40(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicStorySize.s40,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicStory.s48(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicStorySize.s48,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicStory.s56(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicStorySize.s56,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicStory.s64(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicStorySize.s64,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicStory.s72(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicStorySize.s72,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicStory.s80(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicStorySize.s80,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicStory.s96(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicStorySize.s96,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicStory.s104(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicStorySize.s104,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  double _resolveSize(LabProfilePicStorySize size, LabSizesData sizes) {
    switch (size) {
      case LabProfilePicStorySize.s38:
        return sizes.s38;
      case LabProfilePicStorySize.s40:
        return sizes.s40;
      case LabProfilePicStorySize.s48:
        return sizes.s48;
      case LabProfilePicStorySize.s56:
        return sizes.s56;
      case LabProfilePicStorySize.s64:
        return sizes.s64;
      case LabProfilePicStorySize.s72:
        return sizes.s72;
      case LabProfilePicStorySize.s80:
        return sizes.s80;
      case LabProfilePicStorySize.s96:
        return sizes.s96;
      case LabProfilePicStorySize.s104:
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
                  child: LabProfilePicContent(
                    profile: profile,
                    name: name,
                    pubkey: pubkey,
                    profilePicUrl: profilePicUrl,
                    size: adjustedInnerSize,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
