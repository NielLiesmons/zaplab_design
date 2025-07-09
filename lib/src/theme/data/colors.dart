import 'package:zaplab_design/src/utils/named.dart';
import 'package:flutter/rendering.dart';
import 'package:equatable/equatable.dart';

/// Allows developers to override specific colors and gradients
/// Only specify the colors you want to change, others will use defaults
class LabColorsOverride extends Equatable {
  final Color? white;
  final Color? white66;
  final Color? white33;
  final Color? white16;
  final Color? white8;
  final Color? whiteEnforced;
  final Color? black;
  final Color? black66;
  final Color? black33;
  final Color? black16;
  final Color? black8;
  final Color? gray;
  final Color? gray66;
  final Color? gray33;
  final Color? blurpleLightColor;
  final Color? blurpleLightColor66;
  final Color? blurpleColor;
  final Color? blurpleColor66;
  final Color? blurpleColor33;
  final Color? goldColor;
  final Color? goldColor66;
  final Color? greenColor;
  final Color? greenColor66;

  final Gradient? blurple;
  final Gradient? blurple66;
  final Gradient? blurple33;
  final Gradient? blurple16;
  final Gradient? rouge;
  final Gradient? rouge66;
  final Gradient? rouge33;
  final Gradient? rouge16;
  final Gradient? gold;
  final Gradient? gold66;
  final Gradient? gold33;
  final Gradient? gold16;
  final Gradient? green;
  final Gradient? green66;
  final Gradient? green33;
  final Gradient? green16;
  final Gradient? graydient;
  final Gradient? graydient66;
  final Gradient? graydient33;
  final Gradient? graydient16;

  const LabColorsOverride({
    this.white,
    this.white66,
    this.white33,
    this.white16,
    this.white8,
    this.whiteEnforced,
    this.black,
    this.black66,
    this.black33,
    this.black16,
    this.black8,
    this.gray,
    this.gray66,
    this.gray33,
    this.blurpleLightColor,
    this.blurpleLightColor66,
    this.blurpleColor,
    this.blurpleColor66,
    this.blurpleColor33,
    this.goldColor,
    this.goldColor66,
    this.greenColor,
    this.greenColor66,
    this.blurple,
    this.blurple66,
    this.blurple33,
    this.blurple16,
    this.rouge,
    this.rouge66,
    this.rouge33,
    this.rouge16,
    this.gold,
    this.gold66,
    this.gold33,
    this.gold16,
    this.green,
    this.green66,
    this.green33,
    this.green16,
    this.graydient,
    this.graydient66,
    this.graydient33,
    this.graydient16,
  });

  @override
  List<Object?> get props => [
        white,
        white66,
        white33,
        white16,
        white8,
        whiteEnforced,
        black,
        black66,
        black33,
        black16,
        black8,
        gray,
        gray66,
        gray33,
        blurpleLightColor,
        blurpleLightColor66,
        blurpleColor,
        blurpleColor66,
        blurpleColor33,
        goldColor,
        goldColor66,
        greenColor,
        greenColor66,
        blurple,
        blurple66,
        blurple33,
        blurple16,
        rouge,
        rouge66,
        rouge33,
        rouge16,
        gold,
        gold66,
        gold33,
        gold16,
        green,
        green66,
        green33,
        green16,
        graydient,
        graydient66,
        graydient33,
        graydient16,
      ];
}

class LabColorsData extends Equatable {
  /// Colors
  final Color white;
  final Color white66;
  final Color white33;
  final Color white16;
  final Color white8;
  final Color whiteEnforced;
  final Color black;
  final Color black66;
  final Color black33;
  final Color black16;
  final Color black8;
  final Color gray;
  final Color gray66;
  final Color gray33;
  final Color blurpleLightColor;
  final Color blurpleLightColor66;
  final Color blurpleColor;
  final Color blurpleColor66;
  final Color blurpleColor33;
  final Color goldColor;
  final Color goldColor66;
  final Color greenColor;
  final Color greenColor66;

  /// Linear Gradients
  final Gradient blurple;
  final Gradient blurple66;
  final Gradient blurple33;
  final Gradient blurple16;
  final Gradient rouge;
  final Gradient rouge66;
  final Gradient rouge33;
  final Gradient rouge16;
  final Gradient gold;
  final Gradient gold66;
  final Gradient gold33;
  final Gradient gold16;
  final Gradient green;
  final Gradient green66;
  final Gradient green33;
  final Gradient green16;
  final Gradient graydient;
  final Gradient graydient66;
  final Gradient graydient33;
  final Gradient graydient16;

  const LabColorsData({
    required this.white,
    required this.white66,
    required this.white33,
    required this.white16,
    required this.white8,
    required this.whiteEnforced,
    required this.black,
    required this.black66,
    required this.black33,
    required this.black16,
    required this.black8,
    required this.gray,
    required this.gray66,
    required this.gray33,
    required this.blurpleLightColor,
    required this.blurpleLightColor66,
    required this.blurpleColor,
    required this.blurpleColor66,
    required this.blurpleColor33,
    required this.goldColor,
    required this.goldColor66,
    required this.greenColor,
    required this.greenColor66,
    required this.blurple,
    required this.blurple66,
    required this.blurple33,
    required this.blurple16,
    required this.rouge,
    required this.rouge66,
    required this.rouge33,
    required this.rouge16,
    required this.gold,
    required this.gold66,
    required this.gold33,
    required this.gold16,
    required this.green,
    required this.green66,
    required this.green33,
    required this.green16,
    required this.graydient,
    required this.graydient66,
    required this.graydient33,
    required this.graydient16,
  });

  /// Dark mode
  factory LabColorsData.dark([LabColorsOverride? override]) => LabColorsData(
        /// Colors (full or 66% / 33% transparent)
        white: override?.white ?? const Color(0xFFFFFFFF),
        white66: override?.white66 ??
            const Color(0xFFFFFFFF).withValues(alpha: 0.66),
        white33: override?.white33 ??
            const Color(0xFFFFFFFF).withValues(alpha: 0.33),
        white16: override?.white16 ??
            const Color(0xFFFFFFFF).withValues(alpha: 0.16),
        white8:
            override?.white8 ?? const Color(0xFFFFFFFF).withValues(alpha: 0.08),
        whiteEnforced: override?.whiteEnforced ?? const Color(0xFFFFFFFF),
        black: override?.black ?? const Color(0xFF000000),
        black66: override?.black66 ??
            const Color(0xFF000000).withValues(alpha: 0.66),
        black33: override?.black33 ??
            const Color(0xFF000000).withValues(alpha: 0.33),
        black16: override?.black16 ??
            const Color(0xFF000000).withValues(alpha: 0.16),
        black8:
            override?.black8 ?? const Color(0xFF000000).withValues(alpha: 0.08),
        gray: override?.gray ?? const Color(0xFF232323),
        gray66:
            override?.gray66 ?? const Color(0xFF333333).withValues(alpha: 0.66),
        gray33:
            override?.gray33 ?? const Color(0xFF333333).withValues(alpha: 0.33),
        blurpleLightColor:
            override?.blurpleLightColor ?? const Color(0xFF8483FE),
        blurpleLightColor66: override?.blurpleLightColor66 ??
            const Color(0xFF8483FE).withValues(alpha: 0.66),
        blurpleColor: override?.blurpleColor ?? const Color(0xFF5C5AFE),
        blurpleColor66: override?.blurpleColor66 ??
            const Color(0xFF5C5AFE).withValues(alpha: 0.66),
        blurpleColor33: override?.blurpleColor33 ??
            const Color(0xFF5C5AFE).withValues(alpha: 0.33),
        goldColor: override?.goldColor ?? const Color(0xFFF5C763),
        goldColor66: override?.goldColor66 ??
            const Color(0xFFF5C763).withValues(alpha: 0.66),
        greenColor: override?.greenColor ?? const Color(0xFF45E076),
        greenColor66: override?.greenColor66 ??
            const Color(0xFF45E076).withValues(alpha: 0.66),

        /// Linear Gradients (top-left to bottom-right alignment)
        blurple: override?.blurple ??
            const LinearGradient(
              colors: [Color(0xFF636AFF), Color(0xFF5445FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        blurple66: override?.blurple66 ??
            LinearGradient(
              colors: [
                const Color(0xFF636AFF).withValues(alpha: 0.66),
                const Color(0xFF5445FF).withValues(alpha: 0.66)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        blurple33: override?.blurple33 ??
            LinearGradient(
              colors: [
                const Color(0xFF636AFF).withValues(alpha: 0.33),
                const Color(0xFF5445FF).withValues(alpha: 0.33)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        blurple16: override?.blurple16 ??
            LinearGradient(
              colors: [
                const Color(0xFF636AFF).withValues(alpha: 0.16),
                const Color(0xFF5445FF).withValues(alpha: 0.16)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

        rouge: override?.rouge ??
            const LinearGradient(
              colors: [Color(0xFFFF416E), Color(0xFFFF005C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        rouge66: override?.rouge66 ??
            LinearGradient(
              colors: [
                const Color(0xFFFF416E).withValues(alpha: 0.66),
                const Color(0xFFFF005C).withValues(alpha: 0.66)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        rouge33: override?.rouge33 ??
            LinearGradient(
              colors: [
                const Color(0xFFFF416E).withValues(alpha: 0.33),
                const Color(0xFFFF005C).withValues(alpha: 0.33)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        rouge16: override?.rouge16 ??
            LinearGradient(
              colors: [
                const Color(0xFFFF416E).withValues(alpha: 0.16),
                const Color(0xFFFF005C).withValues(alpha: 0.16)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

        gold: override?.gold ??
            const LinearGradient(
              colors: [Color(0xFFFFC736), Color(0xFFFFAD31)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        gold66: override?.gold66 ??
            LinearGradient(
              colors: [
                const Color(0xFFFFC736).withValues(alpha: 0.66),
                const Color(0xFFFFAD31).withValues(alpha: 0.66)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        gold33: override?.gold33 ??
            LinearGradient(
              colors: [
                const Color(0xFFFFC736).withValues(alpha: 0.33),
                const Color(0xFFFFAD31).withValues(alpha: 0.33)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        gold16: override?.gold16 ??
            LinearGradient(
              colors: [
                const Color(0xFFFFC736).withValues(alpha: 0.20),
                const Color(0xFFFFAD31).withValues(alpha: 0.20)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

        green: override?.green ??
            const LinearGradient(
              colors: [Color(0xFF59F372), Color(0xFF30CB78)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        green66: override?.green66 ??
            LinearGradient(
              colors: [
                const Color(0xFF59F372).withValues(alpha: 0.66),
                const Color(0xFF30CB78).withValues(alpha: 0.66)
              ],
            ),
        green33: override?.green33 ??
            LinearGradient(
              colors: [
                const Color(0xFF59F372).withValues(alpha: 0.33),
                const Color(0xFF30CB78).withValues(alpha: 0.33)
              ],
            ),
        green16: override?.green16 ??
            LinearGradient(
              colors: [
                const Color(0xFF59F372).withValues(alpha: 0.16),
                const Color(0xFF30CB78).withValues(alpha: 0.16)
              ],
            ),

        graydient: override?.graydient ??
            const LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFDBDBFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        graydient66: override?.graydient66 ??
            LinearGradient(
              colors: [
                const Color(0xFFFFFFFF).withValues(alpha: 0.66),
                const Color(0xFFDBDBFF).withValues(alpha: 0.66)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        graydient33: override?.graydient33 ??
            LinearGradient(
              colors: [
                const Color(0xFFFFFFFF).withValues(alpha: 0.33),
                const Color(0xFFDBDBFF).withValues(alpha: 0.33)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        graydient16: override?.graydient16 ??
            LinearGradient(
              colors: [
                const Color(0xFFFFFFFF).withValues(alpha: 0.20),
                const Color(0xFFDBDBFF).withValues(alpha: 0.20)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
      );

  /// Light mode
  factory LabColorsData.light([LabColorsOverride? override]) => LabColorsData(
        /// Colors (full or 66% / 33% transparent)
        white: override?.white ?? const Color(0xFF332300),
        white66: override?.white66 ??
            const Color(0xFF332300).withValues(alpha: 0.60),
        white33: override?.white33 ??
            const Color(0xFF332300).withValues(alpha: 0.31),
        white16: override?.white16 ??
            const Color(0xFF332300).withValues(alpha: 0.18),
        white8:
            override?.white8 ?? const Color(0xFF332300).withValues(alpha: 0.10),
        whiteEnforced: override?.whiteEnforced ?? const Color(0xFFEDE4D7),
        black: override?.black ?? const Color(0xFFEDE4D7),
        black66: override?.black66 ??
            const Color(0xFFE9E9E9).withValues(alpha: 0.58),
        black33: override?.black33 ??
            const Color(0xFFE9E9E9).withValues(alpha: 0.31),
        black16: override?.black16 ??
            const Color(0xFFE9E9E9).withValues(alpha: 0.16),
        black8:
            override?.black8 ?? const Color(0xFFE9E9E9).withValues(alpha: 0.08),
        gray: override?.gray ?? const Color(0xFFBBB5A8),
        gray66:
            override?.gray66 ?? const Color(0xFFAEA798).withValues(alpha: 0.60),
        gray33:
            override?.gray33 ?? const Color(0xFFAEA798).withValues(alpha: 0.30),
        blurpleLightColor:
            override?.blurpleLightColor ?? const Color.fromRGBO(75, 75, 205, 1),
        blurpleLightColor66: override?.blurpleLightColor66 ??
            const Color.fromARGB(255, 75, 75, 205).withValues(alpha: 0.66),
        blurpleColor: override?.blurpleColor ?? const Color(0xFF5C5AFE),
        blurpleColor66: override?.blurpleColor66 ??
            const Color(0xFF5C5AFE).withValues(alpha: 0.66),
        blurpleColor33: override?.blurpleColor33 ??
            const Color(0xFF5C5AFE).withValues(alpha: 0.33),
        goldColor: override?.goldColor ?? const Color(0xFFE99C0A),
        goldColor66: override?.goldColor66 ??
            const Color(0xFFE99C0A).withValues(alpha: 0.66),
        greenColor:
            override?.greenColor ?? const Color.fromARGB(255, 11, 186, 66),
        greenColor66: override?.greenColor66 ??
            const Color.fromARGB(255, 11, 186, 66).withValues(alpha: 0.66),

        /// Linear Gradients (top-left to bottom-right alignment)
        blurple: override?.blurple ??
            const LinearGradient(
              colors: [Color(0xFF636AFF), Color(0xFF5445FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        blurple66: override?.blurple66 ??
            LinearGradient(
              colors: [
                const Color(0xFF636AFF).withValues(alpha: 0.66),
                const Color(0xFF5445FF).withValues(alpha: 0.66)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        blurple33: override?.blurple33 ??
            LinearGradient(
              colors: [
                const Color(0xFF636AFF).withValues(alpha: 0.33),
                const Color(0xFF5445FF).withValues(alpha: 0.33)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        blurple16: override?.blurple16 ??
            LinearGradient(
              colors: [
                const Color(0xFF636AFF).withValues(alpha: 0.16),
                const Color(0xFF5445FF).withValues(alpha: 0.16)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

        rouge: override?.rouge ??
            const LinearGradient(
              colors: [Color(0xFFFF416E), Color(0xFFFF005C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        rouge66: override?.rouge66 ??
            LinearGradient(
              colors: [
                const Color(0xFFFF416E).withValues(alpha: 0.66),
                const Color(0xFFFF005C).withValues(alpha: 0.66)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        rouge33: override?.rouge33 ??
            LinearGradient(
              colors: [
                const Color(0xFFFF416E).withValues(alpha: 0.33),
                const Color(0xFFFF005C).withValues(alpha: 0.33)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        rouge16: override?.rouge16 ??
            LinearGradient(
              colors: [
                const Color(0xFFFF416E).withValues(alpha: 0.16),
                const Color(0xFFFF005C).withValues(alpha: 0.16)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

        gold: override?.gold ??
            const LinearGradient(
              colors: [Color(0xFFE3A915), Color(0xFFEF8F00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        gold66: override?.gold66 ??
            LinearGradient(
              colors: [
                const Color(0xFFE3A915).withValues(alpha: 0.66),
                const Color(0xFFEF8F00).withValues(alpha: 0.66)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        gold33: override?.gold33 ??
            LinearGradient(
              colors: [
                const Color(0xFFE3A915).withValues(alpha: 0.33),
                const Color(0xFFEF8F00).withValues(alpha: 0.33)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        gold16: override?.gold16 ??
            LinearGradient(
              colors: [
                const Color(0xFFE3A915).withValues(alpha: 0.16),
                const Color(0xFFEF8F00).withValues(alpha: 0.16)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

        green: override?.green ??
            const LinearGradient(
              colors: [
                Color.fromARGB(255, 12, 196, 43),
                Color.fromARGB(255, 13, 190, 95)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        green66: override?.green66 ??
            LinearGradient(
              colors: [
                const Color.fromARGB(255, 12, 196, 43).withValues(alpha: 0.66),
                const Color.fromARGB(255, 13, 190, 95).withValues(alpha: 0.66)
              ],
            ),
        green33: override?.green33 ??
            LinearGradient(
              colors: [
                const Color.fromARGB(255, 12, 196, 43).withValues(alpha: 0.33),
                const Color.fromARGB(255, 13, 190, 95).withValues(alpha: 0.33)
              ],
            ),
        green16: override?.green16 ??
            LinearGradient(
              colors: [
                const Color.fromARGB(255, 12, 196, 43).withValues(alpha: 0.16),
                const Color.fromARGB(255, 13, 190, 95).withValues(alpha: 0.16)
              ],
            ),

        graydient: override?.graydient ??
            const LinearGradient(
              colors: [Color(0xFF535367), Color(0xFF232323)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        graydient66: override?.graydient66 ??
            LinearGradient(
              colors: [
                const Color(0xFF535367).withValues(alpha: 0.66),
                const Color(0xFF232323).withValues(alpha: 0.66)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        graydient33: override?.graydient33 ??
            LinearGradient(
              colors: [
                const Color(0xFF535367).withValues(alpha: 0.33),
                const Color(0xFF232323).withValues(alpha: 0.33)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        graydient16: override?.graydient16 ??
            LinearGradient(
              colors: [
                const Color(0xFF535367).withValues(alpha: 0.20),
                const Color(0xFF232323).withValues(alpha: 0.20)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
      );

  /// Grey mode
  factory LabColorsData.gray([LabColorsOverride? override]) => LabColorsData(
        /// Colors (full or 66% / 33% transparent)
        white: override?.white ?? const Color(0xFFFFFFFF),
        white66: override?.white66 ??
            const Color(0xFFFFFFFF).withValues(alpha: 0.66),
        white33: override?.white33 ??
            const Color(0xFFFFFFFF).withValues(alpha: 0.33),
        white16: override?.white16 ??
            const Color(0xFFFFFFFF).withValues(alpha: 0.16),
        white8:
            override?.white8 ?? const Color(0xFFFFFFFF).withValues(alpha: 0.08),
        whiteEnforced: override?.whiteEnforced ?? const Color(0xFFFFFFFF),
        black: override?.black ?? const Color(0xFF181818),
        black66: override?.black66 ??
            const Color(0xFF181818).withValues(alpha: 0.66),
        black33: override?.black33 ??
            const Color(0xFF000000).withValues(alpha: 0.33),
        black16: override?.black16 ??
            const Color(0xFF000000).withValues(alpha: 0.16),
        black8:
            override?.black8 ?? const Color(0xFF000000).withValues(alpha: 0.08),
        gray: override?.gray ?? const Color(0xFF232323),
        gray66:
            override?.gray66 ?? const Color(0xFF333333).withValues(alpha: 0.66),
        gray33:
            override?.gray33 ?? const Color(0xFF333333).withValues(alpha: 0.33),
        blurpleLightColor:
            override?.blurpleLightColor ?? const Color(0xFF8483FE),
        blurpleLightColor66: override?.blurpleLightColor66 ??
            const Color(0xFF8483FE).withValues(alpha: 0.66),
        blurpleColor: override?.blurpleColor ?? const Color(0xFF5C5AFE),
        blurpleColor66: override?.blurpleColor66 ??
            const Color(0xFF5C5AFE).withValues(alpha: 0.66),
        blurpleColor33: override?.blurpleColor33 ??
            const Color(0xFF5C5AFE).withValues(alpha: 0.33),
        goldColor: override?.goldColor ?? const Color(0xFFF5C763),
        goldColor66: override?.goldColor66 ??
            const Color(0xFFF5C763).withValues(alpha: 0.66),
        greenColor: override?.greenColor ?? const Color(0xFF45E076),
        greenColor66: override?.greenColor66 ??
            const Color(0xFF45E076).withValues(alpha: 0.66),

        /// Linear Gradients (top-left to bottom-right alignment)
        blurple: override?.blurple ??
            const LinearGradient(
              colors: [Color(0xFF636AFF), Color(0xFF5445FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        blurple66: override?.blurple66 ??
            LinearGradient(
              colors: [
                const Color(0xFF636AFF).withValues(alpha: 0.66),
                const Color(0xFF5445FF).withValues(alpha: 0.66)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        blurple33: override?.blurple33 ??
            LinearGradient(
              colors: [
                const Color(0xFF636AFF).withValues(alpha: 0.33),
                const Color(0xFF5445FF).withValues(alpha: 0.33)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        blurple16: override?.blurple16 ??
            LinearGradient(
              colors: [
                const Color(0xFF636AFF).withValues(alpha: 0.16),
                const Color(0xFF5445FF).withValues(alpha: 0.16)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

        rouge: override?.rouge ??
            const LinearGradient(
              colors: [Color(0xFFFF416E), Color(0xFFFF005C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        rouge66: override?.rouge66 ??
            LinearGradient(
              colors: [
                const Color(0xFFFF416E).withValues(alpha: 0.66),
                const Color(0xFFFF005C).withValues(alpha: 0.66)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        rouge33: override?.rouge33 ??
            LinearGradient(
              colors: [
                const Color(0xFFFF416E).withValues(alpha: 0.33),
                const Color(0xFFFF005C).withValues(alpha: 0.33)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        rouge16: override?.rouge16 ??
            LinearGradient(
              colors: [
                const Color(0xFFFF416E).withValues(alpha: 0.16),
                const Color(0xFFFF005C).withValues(alpha: 0.16)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

        gold: override?.gold ??
            const LinearGradient(
              colors: [Color(0xFFFFC736), Color(0xFFFFAD31)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        gold66: override?.gold66 ??
            LinearGradient(
              colors: [
                const Color(0xFFFFC736).withValues(alpha: 0.66),
                const Color(0xFFFFAD31).withValues(alpha: 0.66)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        gold33: override?.gold33 ??
            LinearGradient(
              colors: [
                const Color(0xFFFFC736).withValues(alpha: 0.33),
                const Color(0xFFFFAD31).withValues(alpha: 0.33)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        gold16: override?.gold16 ??
            LinearGradient(
              colors: [
                const Color(0xFFFFC736).withValues(alpha: 0.16),
                const Color(0xFFFFAD31).withValues(alpha: 0.16)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

        green: override?.green ??
            const LinearGradient(
              colors: [Color(0xFF59F372), Color(0xFF30CB78)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        green66: override?.green66 ??
            LinearGradient(
              colors: [
                const Color(0xFF59F372).withValues(alpha: 0.66),
                const Color(0xFF30CB78).withValues(alpha: 0.66)
              ],
            ),
        green33: override?.green33 ??
            LinearGradient(
              colors: [
                const Color(0xFF59F372).withValues(alpha: 0.33),
                const Color(0xFF30CB78).withValues(alpha: 0.33)
              ],
            ),
        green16: override?.green16 ??
            LinearGradient(
              colors: [
                const Color(0xFF59F372).withValues(alpha: 0.16),
                const Color(0xFF30CB78).withValues(alpha: 0.16)
              ],
            ),

        graydient: override?.graydient ??
            const LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFDBDBFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        graydient66: override?.graydient66 ??
            LinearGradient(
              colors: [
                const Color(0xFFFFFFFF).withValues(alpha: 0.66),
                const Color(0xFFDBDBFF).withValues(alpha: 0.66)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        graydient33: override?.graydient33 ??
            LinearGradient(
              colors: [
                const Color(0xFFFFFFFF).withValues(alpha: 0.33),
                const Color(0xFFDBDBFF).withValues(alpha: 0.33)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        graydient16: override?.graydient16 ??
            LinearGradient(
              colors: [
                const Color(0xFFFFFFFF).withValues(alpha: 0.16),
                const Color(0xFFDBDBFF).withValues(alpha: 0.16)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
      );

  @override
  List<Object?> get props => [
        white.named('white'),
        white66.named('white66'),
        white33.named('white33'),
        white16.named('white16'),
        white8.named('white8'),
        whiteEnforced.named('whiteEnforced'),
        black.named('black'),
        black66.named('black66'),
        black33.named('black33'),
        black16.named('black16'),
        black8.named('black8'),
        gray.named('gray'),
        gray66.named('gray66'),
        gray33.named('gray33'),
        blurpleLightColor.named('blurpleLightColor'),
        blurpleLightColor66.named('blurpleLightColor66'),
        goldColor.named('goldColor'),
        goldColor66.named('goldColor66'),
        greenColor.named('greenColor'),
        greenColor66.named('greenColor66'),
        blurple.named('blurple'),
        blurple66.named('blurple66'),
        blurple33.named('blurple33'),
        blurple16.named('blurple16'),
        rouge.named('rouge'),
        rouge66.named('rouge66'),
        rouge33.named('rouge33'),
        rouge16.named('rouge16'),
        gold.named('gold'),
        gold66.named('gold66'),
        gold33.named('gold33'),
        gold16.named('gold16'),
        green.named('green'),
        green66.named('green66'),
        green33.named('green33'),
        green16.named('green16'),
        graydient.named('graydient'),
        graydient66.named('graydient66'),
        graydient33.named('graydient33'),
        graydient16.named('graydient16'),
      ];
}
