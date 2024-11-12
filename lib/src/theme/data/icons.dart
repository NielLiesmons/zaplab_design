import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcons {
  /// Outline-first icons
  static const String at = 'assets/icons/at.svg';
  static const String check = 'assets/icons/check.svg';
  static const String chevronDown = 'assets/icons/chevronDown.svg';
  static const String chevronLeft = 'assets/icons/chevronLeft.svg';
  static const String chevronRight = 'assets/icons/chevronRight.svg';
  static const String chevronUp = 'assets/icons/chevronUp.svg';
  static const String code = 'assets/icons/code.svg';
  static const String copy = 'assets/icons/copy.svg';
  static const String counter = 'assets/icons/counter.svg';
  static const String cross = 'assets/icons/cross.svg';
  static const String flip = 'assets/icons/flip.svg';
  static const String id = 'assets/icons/id.svg';
  static const String info = 'assets/icons/info.svg';
  static const String invoice = 'assets/icons/invoice.svg';
  static const String label = 'assets/icons/label.svg';
  static const String link = 'assets/icons/link.svg';
  static const String openWith = 'assets/icons/openWith.svg';
  static const String pin = 'assets/icons/pin.svg';
  static const String plus = 'assets/icons/plus.svg';
  static const String profileQR = 'assets/icons/profileQR.svg';
  static const String reply = 'assets/icons/reply.svg';
  static const String share = 'assets/icons/share.svg';
  static const String split = 'assets/icons/split.svg';
  static const String transfer = 'assets/icons/transfer.svg';

  /// Fill-first icons
  static const String alert = 'assets/icons/alert.svg';
  static const String appearance = 'assets/icons/appearance.svg';
  static const String backup = 'assets/icons/backup.svg';
  static const String bell = 'assets/icons/bell.svg';
  static const String clock = 'assets/icons/clock.svg';
  static const String crown = 'assets/icons/crown.svg';
  static const String download = 'assets/icons/download.svg';
  static const String drag = 'assets/icons/drag.svg';
  static const String draft = 'assets/icons/draft.svg';
  static const String draw = 'assets/icons/draw.svg';
  static const String focus = 'assets/icons/focus.svg';
  static const String gif = 'assets/icons/gif.svg';
  static const String heart = 'assets/icons/heart.svg';
  static const String hidden = 'assets/icons/hidden.svg';
  static const String home = 'assets/icons/home.svg';
  static const String hosting = 'assets/icons/hosting.svg';
  static const String incognito = 'assets/icons/incognito.svg';
  static const String location = 'assets/icons/location.svg';
  static const String magic = 'assets/icons/magic.svg';
  static const String mic = 'assets/icons/mic.svg';
  static const String mints = 'assets/icons/mints.svg';
  static const String music = 'assets/icons/music.svg';
  static const String openBook = 'assets/icons/openBook.svg';
  static const String pause = 'assets/icons/pause.svg';
  static const String pen = 'assets/icons/pen.svg';
  static const String phone = 'assets/icons/phone.svg';
  static const String play = 'assets/icons/play.svg';
  static const String pricing = 'assets/icons/pricing.svg';
  static const String profile = 'assets/icons/profile.svg';
  static const String security = 'assets/icons/security.svg';
  static const String send = 'assets/icons/send.svg';
  static const String star = 'assets/icons/star.svg';
  static const String sticker = 'assets/icons/sticker.svg';
  static const String text = 'assets/icons/text.svg';
  static const String topZap = 'assets/icons/topZap.svg';
  static const String video = 'assets/icons/video.svg';
  static const String voice = 'assets/icons/voice.svg';
  static const String zap = 'assets/icons/zap.svg';
}

class AppIconSizes {
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s28 = 28.0;
  static const double s32 = 32.0;
}

class AppIcon extends StatelessWidget {
  const AppIcon({
    Key? key,
    required this.icon,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  final String icon;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      width: width,
      height: height,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
