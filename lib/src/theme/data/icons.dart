import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'line_thickness.dart';
import 'colors.dart';

class AppIcons {
  /// Animated icons
  static const String animSpinner = 'assets/icons/animSpinner.svg';

  /// Outline icons
  static const String lineAt = 'assets/icons/lineAt.svg';
  static const String lineCheck = 'assets/icons/lineCheck.svg';
  static const String lineChevronDown = 'assets/icons/lineChevronDown.svg';
  static const String lineChevronLeft = 'assets/icons/lineChevronLeft.svg';
  static const String lineChevronRight = 'assets/icons/lineChevronRight.svg';
  static const String lineChevronUp = 'assets/icons/lineChevronUp.svg';
  static const String lineCode = 'assets/icons/lineCode.svg';
  static const String lineCopy = 'assets/icons/lineCopy.svg';
  static const String lineCounter = 'assets/icons/lineCounter.svg';
  static const String lineCross = 'assets/icons/lineCross.svg';
  static const String lineFatCross = 'assets/icons/lineFatCross.svg';
  static const String lineFatPlus = 'assets/icons/lineFatPlus.svg';
  static const String lineFlip = 'assets/icons/lineFlip.svg';
  static const String lineID = 'assets/icons/lineID.svg';
  static const String lineInfo = 'assets/icons/lineInfo.svg';
  static const String lineInvoice = 'assets/icons/lineInvoice.svg';
  static const String lineLabel = 'assets/icons/lineLabel.svg';
  static const String lineLink = 'assets/icons/lineLink.svg';
  static const String lineOpenWith = 'assets/icons/lineOpenWith.svg';
  static const String linePin = 'assets/icons/linePin.svg';
  static const String linePlus = 'assets/icons/linePlus.svg';
  static const String lineProfileQR = 'assets/icons/lineProfileQR.svg';
  static const String lineReply = 'assets/icons/lineReply.svg';
  static const String lineShare = 'assets/icons/lineShare.svg';
  static const String lineSplit = 'assets/icons/lineSplit.svg';
  static const String lineTransfer = 'assets/icons/lineTransfer.svg';
  static const String lineZap = 'assets/icons/lineZap.svg';

  /// Filled icons
  static const String fillAlert = 'assets/icons/fillAlert.svg';
  static const String fillAppearance = 'assets/icons/fillAppearance.svg';
  static const String fillBackup = 'assets/icons/fillBackup.svg';
  static const String fillBell = 'assets/icons/fillBell.svg';
  static const String fillClock = 'assets/icons/fillClock.svg';
  static const String fillCrown = 'assets/icons/fillCrown.svg';
  static const String fillDownload = 'assets/icons/fillDownload.svg';
  static const String fillDrag = 'assets/icons/fillDrag.svg';
  static const String fillDraft = 'assets/icons/fillDraft.svg';
  static const String fillDraw = 'assets/icons/fillDraw.svg';
  static const String fillFocus = 'assets/icons/fillFocus.svg';
  static const String fillGIF = 'assets/icons/fillGIF.svg';
  static const String fillHeart = 'assets/icons/fillHeart.svg';
  static const String fillHidden = 'assets/icons/fillHidden.svg';
  static const String fillHome = 'assets/icons/fillHome.svg';
  static const String fillHosting = 'assets/icons/fillHosting.svg';
  static const String fillIncognito = 'assets/icons/fillIncognito.svg';
  static const String fillLabel = 'assets/icons/fillLabel.svg';
  static const String fillLocation = 'assets/icons/fillLocation.svg';
  static const String fillMagic = 'assets/icons/fillMagic.svg';
  static const String fillMic = 'assets/icons/fillMic.svg';
  static const String fillMints = 'assets/icons/fillMints.svg';
  static const String fillMusic = 'assets/icons/fillMusic.svg';
  static const String fillOpenBook = 'assets/icons/fillOpenBook.svg';
  static const String fillPause = 'assets/icons/fillPause.svg';
  static const String fillPen = 'assets/icons/fillPen.svg';
  static const String fillPhone = 'assets/icons/fillPhone.svg';
  static const String fillPin = 'assets/icons/fillPin.svg';
  static const String fillPlay = 'assets/icons/fillPlay.svg';
  static const String fillPricing = 'assets/icons/fillPricing.svg';
  static const String fillProfile = 'assets/icons/fillProfile.svg';
  static const String fillSecurity = 'assets/icons/fillSecurity.svg';
  static const String fillSend = 'assets/icons/fillSend.svg';
  static const String fillStar = 'assets/icons/fillStar.svg';
  static const String fillSticker = 'assets/icons/fillSticker.svg';
  static const String fillText = 'assets/icons/fillText.svg';
  static const String fillTopZap = 'assets/icons/fillTopZap.svg';
  static const String fillVideo = 'assets/icons/fillVideo.svg';
  static const String fillVoice = 'assets/icons/fillVoice.svg';
  static const String fillZap = 'assets/icons/fillZap.svg';
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
  final String icon;
  final Color? color;
  final double? width;
  final double? height;

  const AppIcon({
    required this.icon,
    this.color,
    this.width,
    this.height,
    Key? key,
  })  : assert(width != null || height != null,
            'Either width or height must be provided to scale the icon.'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SvgPicture.asset(
          icon,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
          width: width,
          height: height,
        );
      },
    );
  }
}
