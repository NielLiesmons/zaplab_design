import 'package:zaplab_design/src/utils/named.dart';
import 'package:equatable/equatable.dart';

/// Main data class for icons.
class AppIconsData extends Equatable {
  const AppIconsData({
    required this.fontFamily,
    required this.fontPackage,
    required this.characters,
    required this.sizes,
  });

  /// Initialize icons with font family, package, and characters.
  factory AppIconsData.normal() => AppIconsData(
        fontFamily: 'Icons',
        fontPackage: 'zaplab_design',
        characters: AppIconCharactersData.normal(),
        sizes: AppIconSizesData.normal(),
      );

  final String fontFamily;
  final String? fontPackage;
  final AppIconCharactersData characters;
  final AppIconSizesData sizes;

  @override
  List<Object?> get props => [
        fontFamily,
        fontPackage,
        characters,
        sizes,
      ];
}

/// Contains icon character mappings.
class AppIconCharactersData extends Equatable {
  const AppIconCharactersData({
    required this.alert,
    required this.appearance,
    required this.arrowDown,
    required this.arrowUp,
    required this.at,
    required this.backup,
    required this.bell,
    required this.camera,
    required this.check,
    required this.chevronDown,
    required this.chevronLeft,
    required this.chevronRight,
    required this.chevronUp,
    required this.clock,
    required this.code,
    required this.copy,
    required this.counter,
    required this.crown,
    required this.cross,
    required this.delete,
    required this.drag,
    required this.download,
    required this.draft,
    required this.draw,
    required this.flip,
    required this.focus,
    required this.gif,
    required this.heart,
    required this.hidden,
    required this.home,
    required this.hosting,
    required this.id,
    required this.incognito,
    required this.info,
    required this.invoice,
    required this.label,
    required this.link,
    required this.location,
    required this.magic,
    required this.mic,
    required this.mints,
    required this.music,
    required this.openBook,
    required this.openWith,
    required this.pause,
    required this.pen,
    required this.phone,
    required this.pin,
    required this.play,
    required this.plus,
    required this.pricing,
    required this.profile,
    required this.profileQR,
    required this.reply,
    required this.search,
    required this.security,
    required this.send,
    required this.share,
    required this.spinner,
    required this.split,
    required this.star,
    required this.sticker,
    required this.text,
    required this.topZap,
    required this.transfer,
    required this.video,
    required this.voice,
    required this.zap,
  });

  /// Factory constructor with alphabetically sorted icons.
  factory AppIconCharactersData.normal() => AppIconCharactersData(
        alert: String.fromCharCodes([58762, 59542, 57357]),
        appearance: String.fromCharCodes([59058, 59325, 57445]),
        arrowDown: String.fromCharCodes([57344, 58323, 60960, 57526]),
        arrowUp: String.fromCharCodes([57344, 58045, 57440, 57469]),
        at: String.fromCharCodes([60468]),
        backup: String.fromCharCodes([57344, 58676, 61323, 57407]),
        bell: String.fromCharCodes([58082, 58628]),
        camera: String.fromCharCodes([57344, 58649, 58941, 57564]),
        check: String.fromCharCodes([58788, 61009, 57353]),
        chevronDown: String.fromCharCodes([57344, 59309, 61295, 57476]),
        chevronLeft: String.fromCharCodes([57344, 59309, 60404, 57375]),
        chevronRight: String.fromCharCodes([57883, 58353, 57506]),
        chevronUp: String.fromCharCodes([58250, 60663, 57399]),
        clock: String.fromCharCodes([58790, 60865, 57359]),
        code: String.fromCharCodes([58091, 60910]),
        copy: String.fromCharCodes([58091, 61302]),
        counter: String.fromCharCodes([58258, 59222, 57597]),
        cross: String.fromCharCodes([58793, 59781, 57345]),
        crown: String.fromCharCodes([58793, 59788, 57352]),
        delete: String.fromCharCodes([57344, 58618, 59771, 57430]),
        download: String.fromCharCodes([58706, 60105, 57481]),
        draft: String.fromCharCodes([58807, 59291, 57346]),
        drag: String.fromCharCodes([58099, 60725]),
        draw: String.fromCharCodes([58099, 60741]),
        flip: String.fromCharCodes([58113, 57454]),
        focus: String.fromCharCodes([58834, 58702, 57353]),
        gif: String.fromCharCodes([57744, 57541]),
        heart: String.fromCharCodes([58857, 61189, 57351]),
        hidden: String.fromCharCodes([57344, 58506, 57699, 57431]),
        home: String.fromCharCodes([58128, 58592]),
        hosting: String.fromCharCodes([58392, 60642, 57403]),
        id: String.fromCharCodes([60700]),
        incognito: String.fromCharCodes([57344, 58702, 60236, 57429]),
        info: String.fromCharCodes([58135, 58543]),
        invoice: String.fromCharCodes([59214, 58948, 57390]),
        label: String.fromCharCodes([58912, 59376, 57349]),
        link: String.fromCharCodes([58155, 61435]),
        location: String.fromCharCodes([59157, 61344, 57526]),
        magic: String.fromCharCodes([58926, 60059, 57358]),
        mic: String.fromCharCodes([57767, 57416]),
        mints: String.fromCharCodes([58930, 59014, 57346]),
        music: String.fromCharCodes([58935, 61155, 57350]),
        openBook: String.fromCharCodes([57344, 57826, 60512, 57518]),
        openWith: String.fromCharCodes([57344, 57826, 58090, 57553]),
        pause: String.fromCharCodes([58969, 57952, 57351]),
        pen: String.fromCharCodes([57778, 57370]),
        phone: String.fromCharCodes([58972, 58327, 57359]),
        pin: String.fromCharCodes([57778, 57494]),
        play: String.fromCharCodes([58185, 60213]),
        plus: String.fromCharCodes([58185, 60827]),
        pricing: String.fromCharCodes([57344, 57645, 59233, 57403]),
        profile: String.fromCharCodes([57344, 57640, 57719, 57432]),
        profileQR: String.fromCharCodes([57344, 58303, 60723, 57463]),
        reply: String.fromCharCodes([58999, 57647, 57355]),
        search: String.fromCharCodes([57344, 58209, 58779, 57433]),
        security: String.fromCharCodes([58250, 57976, 57409]),
        send: String.fromCharCodes([58205, 61321]),
        share: String.fromCharCodes([59014, 58622, 57360]),
        spinner: String.fromCharCodes([57344, 59256, 59726, 57576]),
        split: String.fromCharCodes([59018, 57778, 57355]),
        star: String.fromCharCodes([58209, 58963]),
        sticker: String.fromCharCodes([57344, 59147, 60151, 57540]),
        text: String.fromCharCodes([58213, 58670]),
        topZap: String.fromCharCodes([57344, 58172, 60768, 57453]),
        transfer: String.fromCharCodes([58566, 59576, 57580]),
        video: String.fromCharCodes([59057, 57672, 57356]),
        voice: String.fromCharCodes([59059, 60948, 57347]),
        zap: String.fromCharCodes([57815, 57386]),
      );

  final String alert;
  final String appearance;
  final String arrowDown;
  final String arrowUp;
  final String at;
  final String backup;
  final String bell;
  final String camera;
  final String check;
  final String chevronDown;
  final String chevronLeft;
  final String chevronRight;
  final String chevronUp;
  final String clock;
  final String code;
  final String copy;
  final String counter;
  final String crown;
  final String cross;
  final String delete;
  final String drag;
  final String download;
  final String draft;
  final String draw;
  final String flip;
  final String focus;
  final String gif;
  final String heart;
  final String hidden;
  final String home;
  final String hosting;
  final String id;
  final String incognito;
  final String info;
  final String invoice;
  final String label;
  final String link;
  final String location;
  final String magic;
  final String mic;
  final String mints;
  final String music;
  final String openBook;
  final String openWith;
  final String pause;
  final String pen;
  final String phone;
  final String pin;
  final String play;
  final String plus;
  final String pricing;
  final String profile;
  final String profileQR;
  final String reply;
  final String search;
  final String security;
  final String send;
  final String share;
  final String spinner;
  final String split;
  final String star;
  final String sticker;
  final String text;
  final String topZap;
  final String transfer;
  final String video;
  final String voice;
  final String zap;

  @override
  List<Object?> get props => [
        alert.named('alert'),
        appearance.named('appearance'),
        arrowDown.named('arrowDown'),
        arrowUp.named('arrowUp'),
        at.named('at'),
        backup.named('backup'),
        bell.named('bell'),
        camera.named('camera'),
        check.named('check'),
        chevronDown.named('chevronDown'),
        chevronLeft.named('chevronLeft'),
        chevronRight.named('chevronRight'),
        chevronUp.named('chevronUp'),
        clock.named('clock'),
        code.named('code'),
        copy.named('copy'),
        counter.named('counter'),
        crown.named('crown'),
        cross.named('cross'),
        delete.named('delete'),
        drag.named('drag'),
        download.named('download'),
        draft.named('draft'),
        draw.named('draw'),
        flip.named('flip'),
        focus.named('focus'),
        gif.named('gif'),
        heart.named('heart'),
        hidden.named('hidden'),
        home.named('home'),
        hosting.named('hosting'),
        id.named('id'),
        incognito.named('incognito'),
        info.named('info'),
        invoice.named('invoice'),
        label.named('label'),
        link.named('link'),
        location.named('location'),
        magic.named('magic'),
        mic.named('mic'),
        mints.named('mints'),
        music.named('music'),
        openBook.named('openBook'),
        openWith.named('openWith'),
        pause.named('pause'),
        pen.named('pen'),
        phone.named('phone'),
        pin.named('pin'),
        play.named('play'),
        plus.named('plus'),
        pricing.named('pricing'),
        profile.named('profile'),
        profileQR.named('profileQR'),
        reply.named('reply'),
        search.named('search'),
        security.named('security'),
        send.named('send'),
        share.named('share'),
        spinner.named('spinner'),
        split.named('split'),
        star.named('star'),
        sticker.named('sticker'),
        text.named('text'),
        topZap.named('topZap'),
        transfer.named('transfer'),
        video.named('video'),
        voice.named('voice'),
        zap.named('zap'),
      ];
}

class AppIconSizesData extends Equatable {
  const AppIconSizesData({
    required this.s4,
    required this.s8,
    required this.s10,
    required this.s12,
    required this.s16,
    required this.s20,
    required this.s24,
    required this.s28,
    required this.s32,
  });

  factory AppIconSizesData.normal() => const AppIconSizesData(
        s4: 4.0,
        s8: 8.0,
        s10: 10.0,
        s12: 12.0,
        s16: 16.0,
        s20: 20.0,
        s24: 24.0,
        s28: 28.0,
        s32: 32.0,
      );

  final double s4;
  final double s8;
  final double s10;
  final double s12;
  final double s16;
  final double s20;
  final double s24;
  final double s28;
  final double s32;

  @override
  List<Object?> get props => [
        s4.named('s4'),
        s8.named('s8'),
        s10.named('s10'),
        s12.named('s12'),
        s16.named('s16'),
        s20.named('s20'),
        s24.named('s24'),
        s28.named('s28'),
        s32.named('s32'),
      ];
}
