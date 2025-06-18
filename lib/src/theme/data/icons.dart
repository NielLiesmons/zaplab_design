import 'package:zaplab_design/src/utils/named.dart';
import 'package:equatable/equatable.dart';

/// Main data class for icons.
class LabIconsData extends Equatable {
  const LabIconsData({
    required this.fontFamily,
    required this.fontPackage,
    required this.characters,
    required this.sizes,
  });

  /// Initialize icons with font family, package, and characters.
  factory LabIconsData.normal() => LabIconsData(
        fontFamily: 'Zaplab-Icons',
        fontPackage: 'zaplab_design',
        characters: LabIconCharactersData.normal(),
        sizes: LabIconSizesData.normal(),
      );

  final String fontFamily;
  final String? fontPackage;
  final LabIconCharactersData characters;
  final LabIconSizesData sizes;

  @override
  List<Object?> get props => [
        fontFamily,
        fontPackage,
        characters,
        sizes,
      ];
}

/// Contains icon character mappings.
class LabIconCharactersData extends Equatable {
  const LabIconCharactersData({
    required this.adjust,
    required this.alert,
    required this.appearance,
    required this.arrowDown,
    required this.arrowUp,
    required this.at,
    required this.attachment,
    required this.backup,
    required this.backspace,
    required this.bell,
    required this.bold,
    required this.camera,
    required this.check,
    required this.chevronDown,
    required this.chevronLeft,
    required this.chevronRight,
    required this.chevronUp,
    required this.circle50,
    required this.circle75,
    required this.clock,
    required this.code,
    required this.copy,
    required this.counter,
    required this.crown,
    required this.cross,
    required this.details,
    required this.devices,
    required this.drag,
    required this.download,
    required this.draft,
    required this.draw,
    required this.emojiFill,
    required this.emojiLine,
    required this.expand,
    required this.filter,
    required this.flip,
    required this.focus,
    required this.footnote,
    required this.gif,
    required this.heart,
    required this.hidden,
    required this.home,
    required this.hosting,
    required this.id,
    required this.incognito,
    required this.info,
    required this.invoice,
    required this.italic,
    required this.label,
    required this.latex,
    required this.link,
    required this.list,
    required this.location,
    required this.magic,
    required this.mail,
    required this.mic,
    required this.mints,
    required this.music,
    required this.nostr,
    required this.numberedList,
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
    required this.strikeThrough,
    required this.subscript,
    required this.superscript,
    required this.table,
    required this.text,
    required this.tilda,
    required this.tools,
    required this.transfer,
    required this.underline,
    required this.video,
    required this.voice,
    required this.wifi,
    required this.zap,
  });

  /// Factory constructor with alphabetically sorted icons.
  factory LabIconCharactersData.normal() => LabIconCharactersData(
        adjust: String.fromCharCodes([57344, 58701, 59081, 57458]),
        alert: String.fromCharCodes([58762, 59542, 57357]),
        appearance: String.fromCharCodes([59058, 59325, 57445]),
        arrowDown: String.fromCharCodes([57344, 58323, 60960, 57526]),
        arrowUp: String.fromCharCodes([57344, 58045, 57440, 57469]),
        at: String.fromCharCodes([60468]),
        attachment: String.fromCharCodes([57344, 59217, 59559, 57566]),
        backspace: String.fromCharCodes([58635, 60645, 57472]),
        backup: String.fromCharCodes([57344, 58676, 61323, 57407]),
        bold: String.fromCharCodes([58084, 60038]),
        bell: String.fromCharCodes([58082, 58628]),
        camera: String.fromCharCodes([57344, 58649, 58941, 57564]),
        check: String.fromCharCodes([58788, 61009, 57353]),
        chevronDown: String.fromCharCodes([57344, 59309, 61295, 57476]),
        chevronLeft: String.fromCharCodes([57344, 59309, 60404, 57375]),
        chevronRight: String.fromCharCodes([57883, 58353, 57506]),
        chevronUp: String.fromCharCodes([58250, 60663, 57399]),
        circle50: String.fromCharCodes([57344, 58773, 61233, 57494]),
        circle75: String.fromCharCodes([57344, 58773, 61233, 57427]),
        clock: String.fromCharCodes([58790, 60865, 57359]),
        code: String.fromCharCodes([58091, 60910]),
        copy: String.fromCharCodes([58091, 61302]),
        counter: String.fromCharCodes([58258, 59222, 57597]),
        cross: String.fromCharCodes([58793, 59781, 57345]),
        crown: String.fromCharCodes([58793, 59788, 57352]),
        details: String.fromCharCodes([58830, 59635, 57411]),
        devices: String.fromCharCodes([58832, 59565, 57566]),
        download: String.fromCharCodes([58706, 60105, 57481]),
        draft: String.fromCharCodes([58807, 59291, 57346]),
        drag: String.fromCharCodes([58099, 60725]),
        draw: String.fromCharCodes([58099, 60741]),
        expand: String.fromCharCodes([57344, 58574, 59170, 57447]),
        emojiFill: String.fromCharCodes([58952, 61015, 57578]),
        emojiLine: String.fromCharCodes([58953, 57618, 57435]),
        filter: String.fromCharCodes([57344, 58560, 59189, 57481]),
        flip: String.fromCharCodes([58113, 57454]),
        focus: String.fromCharCodes([58834, 58702, 57353]),
        footnote: String.fromCharCodes([57721, 60374, 57441]),
        gif: String.fromCharCodes([57744, 57541]),
        heart: String.fromCharCodes([58857, 61189, 57351]),
        hidden: String.fromCharCodes([57344, 58506, 57699, 57431]),
        home: String.fromCharCodes([58128, 58592]),
        hosting: String.fromCharCodes([58392, 60642, 57403]),
        id: String.fromCharCodes([60700]),
        incognito: String.fromCharCodes([57344, 58702, 60236, 57429]),
        info: String.fromCharCodes([58135, 58543]),
        invoice: String.fromCharCodes([59214, 58948, 57390]),
        italic: String.fromCharCodes([57344, 58469, 58054, 57553]),
        label: String.fromCharCodes([58912, 59376, 57349]),
        latex: String.fromCharCodes([58912, 60458, 57347]),
        link: String.fromCharCodes([58155, 61435]),
        list: String.fromCharCodes([58156, 57503]),
        location: String.fromCharCodes([59157, 61344, 57526]),
        magic: String.fromCharCodes([58926, 60059, 57358]),
        mail: String.fromCharCodes([58161, 58808]),
        mic: String.fromCharCodes([57767, 57416]),
        mints: String.fromCharCodes([58930, 59014, 57346]),
        music: String.fromCharCodes([58935, 61155, 57350]),
        nostr: String.fromCharCodes([58947, 58574, 57345]),
        numberedList: String.fromCharCodes([58827, 61003, 57447]),
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
        strikeThrough: String.fromCharCodes([58005, 57623, 57524]),
        subscript: String.fromCharCodes([57835, 61408, 57356]),
        superscript: String.fromCharCodes([57344, 58456, 61320, 57595]),
        table: String.fromCharCodes([59025, 58301, 57359]),
        tilda: String.fromCharCodes([59029, 57398, 57349]),
        text: String.fromCharCodes([58213, 58670]),
        tools: String.fromCharCodes([59031, 60574, 57356]),
        transfer: String.fromCharCodes([58566, 59576, 57580]),
        underline: String.fromCharCodes([57344, 58324, 58938, 57397]),
        video: String.fromCharCodes([59057, 57672, 57356]),
        voice: String.fromCharCodes([59059, 60948, 57347]),
        wifi: String.fromCharCodes([58235, 61206]),
        zap: String.fromCharCodes([57815, 57386]),
      );

  final String adjust;
  final String alert;
  final String appearance;
  final String arrowDown;
  final String arrowUp;
  final String at;
  final String attachment;
  final String backspace;
  final String backup;
  final String bell;
  final String bold;
  final String camera;
  final String check;
  final String chevronDown;
  final String chevronLeft;
  final String chevronRight;
  final String chevronUp;
  final String circle50;
  final String circle75;
  final String clock;
  final String code;
  final String copy;
  final String counter;
  final String crown;
  final String cross;
  final String details;
  final String devices;
  final String drag;
  final String download;
  final String draft;
  final String draw;
  final String expand;
  final String emojiFill;
  final String emojiLine;
  final String filter;
  final String flip;
  final String focus;
  final String footnote;
  final String gif;
  final String heart;
  final String hidden;
  final String home;
  final String hosting;
  final String id;
  final String incognito;
  final String info;
  final String invoice;
  final String italic;
  final String label;
  final String latex;
  final String link;
  final String list;
  final String location;
  final String magic;
  final String mail;
  final String mic;
  final String mints;
  final String music;
  final String nostr;
  final String numberedList;
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
  final String strikeThrough;
  final String subscript;
  final String superscript;
  final String table;
  final String text;
  final String tilda;
  final String tools;
  final String transfer;
  final String underline;
  final String video;
  final String voice;
  final String wifi;
  final String zap;

  @override
  List<Object?> get props => [
        adjust.named('adjust'),
        alert.named('alert'),
        appearance.named('appearance'),
        arrowDown.named('arrowDown'),
        arrowUp.named('arrowUp'),
        at.named('at'),
        attachment.named('attachment'),
        backspace.named('backspace'),
        backup.named('backup'),
        bold.named('bold'),
        bell.named('bell'),
        camera.named('camera'),
        check.named('check'),
        chevronDown.named('chevronDown'),
        chevronLeft.named('chevronLeft'),
        chevronRight.named('chevronRight'),
        chevronUp.named('chevronUp'),
        circle50.named('circle50'),
        circle75.named('circle75'),
        clock.named('clock'),
        code.named('code'),
        copy.named('copy'),
        counter.named('counter'),
        crown.named('crown'),
        cross.named('cross'),
        details.named('details'),
        devices.named('devices'),
        drag.named('drag'),
        download.named('download'),
        draft.named('draft'),
        draw.named('draw'),
        expand.named('expand'),
        emojiFill.named('emojiFill'),
        emojiLine.named('emojiLine'),
        filter.named('filter'),
        flip.named('flip'),
        focus.named('focus'),
        footnote.named('footnote'),
        gif.named('gif'),
        heart.named('heart'),
        hidden.named('hidden'),
        home.named('home'),
        hosting.named('hosting'),
        id.named('id'),
        incognito.named('incognito'),
        info.named('info'),
        invoice.named('invoice'),
        italic.named('italic'),
        label.named('label'),
        latex.named('latex'),
        link.named('link'),
        list.named('list'),
        location.named('location'),
        magic.named('magic'),
        mail.named('mail'),
        mic.named('mic'),
        mints.named('mints'),
        music.named('music'),
        nostr.named('nostr'),
        numberedList.named('numberedList'),
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
        strikeThrough.named('strikeThrough'),
        subscript.named('subscript'),
        superscript.named('superscript'),
        table.named('table'),
        text.named('text'),
        tilda.named('tilda'),
        tools.named('tools'),
        transfer.named('transfer'),
        underline.named('underline'),
        video.named('video'),
        voice.named('voice'),
        wifi.named('wifi'),
        zap.named('zap'),
      ];
}

class LabIconSizesData extends Equatable {
  const LabIconSizesData({
    required this.s4,
    required this.s8,
    required this.s10,
    required this.s12,
    required this.s14,
    required this.s16,
    required this.s18,
    required this.s20,
    required this.s24,
    required this.s28,
    required this.s32,
    required this.s38,
    required this.s40,
    required this.s48,
    required this.s56,
    required this.s64,
    required this.s72,
    required this.s80,
    required this.s96,
  });

  factory LabIconSizesData.normal() => const LabIconSizesData(
        s4: 4.0,
        s8: 8.0,
        s10: 10.0,
        s12: 12.0,
        s14: 14.0,
        s16: 16.0,
        s18: 18.0,
        s20: 20.0,
        s24: 24.0,
        s28: 28.0,
        s32: 32.0,
        s38: 38.0,
        s40: 40.0,
        s48: 48.0,
        s56: 56.0,
        s64: 64.0,
        s72: 72.0,
        s80: 80.0,
        s96: 96.0,
      );

  final double s4;
  final double s8;
  final double s10;
  final double s12;
  final double s14;
  final double s16;
  final double s18;
  final double s20;
  final double s24;
  final double s28;
  final double s32;
  final double s38;
  final double s40;
  final double s48;
  final double s56;
  final double s64;
  final double s72;
  final double s80;
  final double s96;

  @override
  List<Object?> get props => [
        s4.named('s4'),
        s8.named('s8'),
        s10.named('s10'),
        s12.named('s12'),
        s14.named('s14'),
        s16.named('s16'),
        s18.named('s18'),
        s20.named('s20'),
        s24.named('s24'),
        s28.named('s28'),
        s32.named('s32'),
        s38.named('s38'),
        s40.named('s40'),
        s48.named('s48'),
        s56.named('s56'),
        s64.named('s64'),
        s72.named('s72'),
        s80.named('s80'),
        s96.named('s96'),
      ];
}
