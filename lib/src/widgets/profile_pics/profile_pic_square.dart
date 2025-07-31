import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

enum LabProfilePicSquareSize {
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

class LabProfilePicSquare extends StatelessWidget {
  final String? profilePicUrl;
  final Profile? profile;
  final String? name;
  final String? pubkey;
  final LabProfilePicSquareSize size;
  final VoidCallback onTap;

  LabProfilePicSquare(
    this.profile, {
    super.key,
    this.size = LabProfilePicSquareSize.s56,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  LabProfilePicSquare.fromUrl(
    this.profilePicUrl, {
    super.key,
    this.size = LabProfilePicSquareSize.s56,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profile = null,
        name = null,
        pubkey = null;

  LabProfilePicSquare.fromPubkey(
    this.pubkey, {
    super.key,
    this.size = LabProfilePicSquareSize.s56,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        name = null,
        profile = null,
        profilePicUrl = null;

  LabProfilePicSquare.fromNameAndPubkey(
    this.name,
    this.pubkey, {
    super.key,
    this.size = LabProfilePicSquareSize.s56,
    VoidCallback? onTap,
  })  : onTap = onTap ?? (() {}),
        profile = null,
        profilePicUrl = null;

  LabProfilePicSquare.s32(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSquareSize.s32,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicSquare.s38(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSquareSize.s38,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicSquare.s48(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSquareSize.s48,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicSquare.s56(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSquareSize.s56,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicSquare.s64(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSquareSize.s64,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicSquare.s72(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSquareSize.s72,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicSquare.s80(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSquareSize.s80,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicSquare.s96(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSquareSize.s96,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;
  LabProfilePicSquare.s104(this.profile, {super.key, VoidCallback? onTap})
      : size = LabProfilePicSquareSize.s104,
        onTap = onTap ?? (() {}),
        profilePicUrl = null,
        name = null,
        pubkey = null;

  double _resolveSize(LabProfilePicSquareSize size, LabSizesData sizes) {
    switch (size) {
      case LabProfilePicSquareSize.s32:
        return sizes.s32;
      case LabProfilePicSquareSize.s38:
        return sizes.s38;
      case LabProfilePicSquareSize.s48:
        return sizes.s48;
      case LabProfilePicSquareSize.s56:
        return sizes.s56;
      case LabProfilePicSquareSize.s64:
        return sizes.s64;
      case LabProfilePicSquareSize.s72:
        return sizes.s72;
      case LabProfilePicSquareSize.s80:
        return sizes.s80;
      case LabProfilePicSquareSize.s96:
        return sizes.s96;
      case LabProfilePicSquareSize.s104:
        return sizes.s104;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final sizes = theme.sizes;
    final resolvedSize = _resolveSize(size, sizes);
    final thickness = LabLineThicknessData.normal().thin;
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
          child: LabContainer(
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
              child: LabProfilePicContent(
                profile: profile,
                name: name,
                pubkey: pubkey,
                profilePicUrl: profilePicUrl,
                size: resolvedSize,
              ),
            ),
          ),
        );
      },
    );
  }
}
