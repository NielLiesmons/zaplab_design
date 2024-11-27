import 'package:flutter/widgets.dart';
import 'package:zapchat_design/src/theme/theme.dart';

enum AppProfilePicSize {
  s2,
  s4,
  s6,
  s8,
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
}

class AppProfilePic extends StatelessWidget {
  const AppProfilePic(
    this.imageUrl, {
    Key? key,
    this.size = AppProfilePicSize.s38,
  }) : super(key: key);

  const AppProfilePic.s2(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s2,
        super(key: key);
  const AppProfilePic.s4(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s4,
        super(key: key);
  const AppProfilePic.s6(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s6,
        super(key: key);
  const AppProfilePic.s8(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s8,
        super(key: key);
  const AppProfilePic.s12(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s12,
        super(key: key);
  const AppProfilePic.s16(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s16,
        super(key: key);
  const AppProfilePic.s18(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s18,
        super(key: key);
  const AppProfilePic.s20(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s20,
        super(key: key);
  const AppProfilePic.s24(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s24,
        super(key: key);
  const AppProfilePic.s28(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s28,
        super(key: key);
  const AppProfilePic.s32(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s32,
        super(key: key);
  const AppProfilePic.s38(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s38,
        super(key: key);
  const AppProfilePic.s40(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s40,
        super(key: key);
  const AppProfilePic.s48(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s48,
        super(key: key);
  const AppProfilePic.s56(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s56,
        super(key: key);
  const AppProfilePic.s64(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s64,
        super(key: key);
  const AppProfilePic.s72(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s72,
        super(key: key);
  const AppProfilePic.s80(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s80,
        super(key: key);
  const AppProfilePic.s96(this.imageUrl, {Key? key})
      : size = AppProfilePicSize.s96,
        super(key: key);

  final String imageUrl;
  final AppProfilePicSize size;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final sizes = theme.sizes;
    final resolvedSize = _resolveSize(size, sizes);
    final thickness = LineThicknessData.normal().thin;

    return Container(
      width: resolvedSize,
      height: resolvedSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colors.white16,
          width: thickness,
        ),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        color: theme.colors.grey66,
      ),
    );
  }

  double _resolveSize(AppProfilePicSize size, AppSizesData sizes) {
    switch (size) {
      case AppProfilePicSize.s2:
        return sizes.s2;
      case AppProfilePicSize.s4:
        return sizes.s4;
      case AppProfilePicSize.s6:
        return sizes.s6;
      case AppProfilePicSize.s8:
        return sizes.s8;
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
    }
  }
}
