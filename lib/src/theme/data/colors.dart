import 'package:zaplab_design/src/utils/named.dart';
import 'package:flutter/rendering.dart';
import 'package:equatable/equatable.dart';

class AppColorsData extends Equatable {
  /// Colors
  final Color white;
  final Color white66;
  final Color white33;
  final Color white16;
  final Color white8;
  final Color black;
  final Color black66;
  final Color black33;
  final Color black16;
  final Color black8;
  final Color grey;
  final Color grey66;
  final Color grey33;
  final Color blurpleColor;
  final Color blurpleColor66;
  final Color goldColor;
  final Color goldColor66;

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
  final Gradient greydient;
  final Gradient greydient66;
  final Gradient greydient33;
  final Gradient greydient16;

  const AppColorsData({
    required this.white,
    required this.white66,
    required this.white33,
    required this.white16,
    required this.white8,
    required this.black,
    required this.black66,
    required this.black33,
    required this.black16,
    required this.black8,
    required this.grey,
    required this.grey66,
    required this.grey33,
    required this.blurpleColor,
    required this.blurpleColor66,
    required this.goldColor,
    required this.goldColor66,
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
    required this.greydient,
    required this.greydient66,
    required this.greydient33,
    required this.greydient16,
  });

  /// Dark mode
  factory AppColorsData.dark() => AppColorsData(
        /// Colors (full or 66% / 33% transparent)
        white: const Color(0xFFFFFFFF),
        white66: const Color(0xFFFFFFFF).withValues(alpha: 0.66),
        white33: const Color(0xFFFFFFFF).withValues(alpha: 0.33),
        white16: const Color(0xFFFFFFFF).withValues(alpha: 0.16),
        white8: const Color(0xFFFFFFFF).withValues(alpha: 0.08),
        black: const Color(0xFF000000),
        black66: const Color(0xFF000000).withValues(alpha: 0.66),
        black33: const Color(0xFF000000).withValues(alpha: 0.33),
        black16: const Color(0xFF000000).withValues(alpha: 0.16),
        black8: const Color(0xFF000000).withValues(alpha: 0.08),
        grey: const Color(0xFF232323),
        grey66: const Color(0xFF333333).withValues(alpha: 0.66),
        grey33: const Color(0xFF333333).withValues(alpha: 0.33),
        blurpleColor: const Color(0xFF8483FE),
        blurpleColor66: const Color(0xFF8483FE).withValues(alpha: 0.66),
        goldColor: const Color(0xFFF5C763),
        goldColor66: const Color(0xFFF5C763).withValues(alpha: 0.66),

        /// Linear Gradients (top-left to bottom-right alignment)
        blurple: const LinearGradient(
          colors: [Color(0xFF636AFF), Color(0xFF5445FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        blurple66: LinearGradient(
          colors: [
            const Color(0xFF636AFF).withValues(alpha: 0.66),
            const Color(0xFF5445FF).withValues(alpha: 0.66)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        blurple33: LinearGradient(
          colors: [
            const Color(0xFF636AFF).withValues(alpha: 0.33),
            const Color(0xFF5445FF).withValues(alpha: 0.33)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        blurple16: LinearGradient(
          colors: [
            const Color(0xFF636AFF).withValues(alpha: 0.16),
            const Color(0xFF5445FF).withValues(alpha: 0.16)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        rouge: const LinearGradient(
          colors: [Color(0xFFFF416E), Color(0xFFFF005C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        rouge66: LinearGradient(
          colors: [
            const Color(0xFFFF416E).withValues(alpha: 0.66),
            const Color(0xFFFF005C).withValues(alpha: 0.66)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        rouge33: LinearGradient(
          colors: [
            const Color(0xFFFF416E).withValues(alpha: 0.33),
            const Color(0xFFFF005C).withValues(alpha: 0.33)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        rouge16: LinearGradient(
          colors: [
            const Color(0xFFFF416E).withValues(alpha: 0.16),
            const Color(0xFFFF005C).withValues(alpha: 0.16)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        gold: const LinearGradient(
          colors: [Color(0xFFFFC736), Color(0xFFFFAD31)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        gold66: LinearGradient(
          colors: [
            const Color(0xFFFFC736).withValues(alpha: 0.66),
            const Color(0xFFFFAD31).withValues(alpha: 0.66)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        gold33: LinearGradient(
          colors: [
            const Color(0xFFFFC736).withValues(alpha: 0.33),
            const Color(0xFFFFAD31).withValues(alpha: 0.33)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        gold16: LinearGradient(
          colors: [
            const Color(0xFFFFC736).withValues(alpha: 0.16),
            const Color(0xFFFFAD31).withValues(alpha: 0.16)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        greydient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFDBDBFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        greydient66: LinearGradient(
          colors: [
            const Color(0xFFFFFFFF).withValues(alpha: 0.66),
            const Color(0xFFDBDBFF).withValues(alpha: 0.66)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        greydient33: LinearGradient(
          colors: [
            const Color(0xFFFFFFFF).withValues(alpha: 0.33),
            const Color(0xFFDBDBFF).withValues(alpha: 0.33)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        greydient16: LinearGradient(
          colors: [
            const Color(0xFFFFFFFF).withValues(alpha: 0.16),
            const Color(0xFFDBDBFF).withValues(alpha: 0.16)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );

  /// Light mode
  factory AppColorsData.light() => AppColorsData(
        /// Colors (full or 66% / 33% transparent)
        white: const Color(0xFF000000),
        white66: const Color(0xFF000000).withValues(alpha: 0.55),
        white33: const Color(0xFF000000).withValues(alpha: 0.29),
        white16: const Color(0xFF000000).withValues(alpha: 0.16),
        white8: const Color(0xFF000000).withValues(alpha: 0.08),
        black: const Color(0xFFFFFFFF),
        black66: const Color(0xFFFFFFFF).withValues(alpha: 0.66),
        black33: const Color(0xFFFFFFFF).withValues(alpha: 0.33),
        black16: const Color(0xFFFFFFFF).withValues(alpha: 0.16),
        black8: const Color(0xFFFFFFFF).withValues(alpha: 0.08),
        grey: const Color(0xFFDCDCDC),
        grey66: const Color(0xFFCCCCCC).withValues(alpha: 0.66),
        grey33: const Color(0xFFCCCCCC).withValues(alpha: 0.33),
        blurpleColor: const Color.fromRGBO(75, 75, 205, 1),
        blurpleColor66:
            const Color.fromARGB(255, 75, 75, 205).withValues(alpha: 0.66),
        goldColor: const Color.fromARGB(255, 233, 173, 44),
        goldColor66:
            const Color.fromARGB(255, 233, 173, 44).withValues(alpha: 0.66),

        /// Linear Gradients (top-left to bottom-right alignment)
        blurple: const LinearGradient(
          colors: [Color(0xFF636AFF), Color(0xFF5445FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        blurple66: LinearGradient(
          colors: [
            const Color(0xFF636AFF).withValues(alpha: 0.66),
            const Color(0xFF5445FF).withValues(alpha: 0.66)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        blurple33: LinearGradient(
          colors: [
            const Color(0xFF636AFF).withValues(alpha: 0.33),
            const Color(0xFF5445FF).withValues(alpha: 0.33)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        blurple16: LinearGradient(
          colors: [
            const Color(0xFF636AFF).withValues(alpha: 0.16),
            const Color(0xFF5445FF).withValues(alpha: 0.16)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        rouge: const LinearGradient(
          colors: [Color(0xFFFF416E), Color(0xFFFF005C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        rouge66: LinearGradient(
          colors: [
            const Color(0xFFFF416E).withValues(alpha: 0.66),
            const Color(0xFFFF005C).withValues(alpha: 0.66)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        rouge33: LinearGradient(
          colors: [
            const Color(0xFFFF416E).withValues(alpha: 0.33),
            const Color(0xFFFF005C).withValues(alpha: 0.33)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        rouge16: LinearGradient(
          colors: [
            const Color(0xFFFF416E).withValues(alpha: 0.16),
            const Color(0xFFFF005C).withValues(alpha: 0.16)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        gold: const LinearGradient(
          colors: [Color(0xFFFFC736), Color(0xFFFFAD31)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        gold66: LinearGradient(
          colors: [
            const Color(0xFFFFC736).withValues(alpha: 0.66),
            const Color(0xFFFFAD31).withValues(alpha: 0.66)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        gold33: LinearGradient(
          colors: [
            const Color(0xFFFFC736).withValues(alpha: 0.33),
            const Color(0xFFFFAD31).withValues(alpha: 0.33)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        gold16: LinearGradient(
          colors: [
            const Color(0xFFFFC736).withValues(alpha: 0.16),
            const Color(0xFFFFAD31).withValues(alpha: 0.16)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        greydient: const LinearGradient(
          colors: [Color(0xFF535367), Color(0xFF232323)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        greydient66: LinearGradient(
          colors: [
            const Color(0xFF535367).withValues(alpha: 0.66),
            const Color(0xFF232323).withValues(alpha: 0.66)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        greydient33: LinearGradient(
          colors: [
            const Color(0xFF535367).withValues(alpha: 0.33),
            const Color(0xFF232323).withValues(alpha: 0.33)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        greydient16: LinearGradient(
          colors: [
            const Color(0xFFFFFFFF).withValues(alpha: 0.16),
            const Color(0xFFDBDBFF).withValues(alpha: 0.16)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );

  /// Grey mode
  factory AppColorsData.grey() => AppColorsData(
        /// Colors (full or 66% / 33% transparent)
        white: const Color(0xFFFFFFFF),
        white66: const Color(0xFFFFFFFF).withValues(alpha: 0.66),
        white33: const Color(0xFFFFFFFF).withValues(alpha: 0.33),
        white16: const Color(0xFFFFFFFF).withValues(alpha: 0.16),
        white8: const Color(0xFFFFFFFF).withValues(alpha: 0.08),
        black: const Color(0xFF181818),
        black66: const Color(0xFF181818).withValues(alpha: 0.66),
        black33: const Color(0xFF000000).withValues(alpha: 0.33),
        black16: const Color(0xFF000000).withValues(alpha: 0.16),
        black8: const Color(0xFF000000).withValues(alpha: 0.08),
        grey: const Color(0xFF232323),
        grey66: const Color(0xFF333333).withValues(alpha: 0.66),
        grey33: const Color(0xFF333333).withValues(alpha: 0.33),
        blurpleColor: const Color(0xFF8483FE),
        blurpleColor66: const Color(0xFF8483FE).withValues(alpha: 0.66),
        goldColor: const Color(0xFFF5C763),
        goldColor66: const Color(0xFFF5C763).withValues(alpha: 0.66),

        /// Linear Gradients (top-left to bottom-right alignment)
        blurple: const LinearGradient(
          colors: [Color(0xFF636AFF), Color(0xFF5445FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        blurple66: LinearGradient(
          colors: [
            const Color(0xFF636AFF).withValues(alpha: 0.66),
            const Color(0xFF5445FF).withValues(alpha: 0.66)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        blurple33: LinearGradient(
          colors: [
            const Color(0xFF636AFF).withValues(alpha: 0.33),
            const Color(0xFF5445FF).withValues(alpha: 0.33)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        blurple16: LinearGradient(
          colors: [
            const Color(0xFF636AFF).withValues(alpha: 0.16),
            const Color(0xFF5445FF).withValues(alpha: 0.16)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        rouge: const LinearGradient(
          colors: [Color(0xFFFF416E), Color(0xFFFF005C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        rouge66: LinearGradient(
          colors: [
            const Color(0xFFFF416E).withValues(alpha: 0.66),
            const Color(0xFFFF005C).withValues(alpha: 0.66)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        rouge33: LinearGradient(
          colors: [
            const Color(0xFFFF416E).withValues(alpha: 0.33),
            const Color(0xFFFF005C).withValues(alpha: 0.33)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        rouge16: LinearGradient(
          colors: [
            const Color(0xFFFF416E).withValues(alpha: 0.16),
            const Color(0xFFFF005C).withValues(alpha: 0.16)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        gold: const LinearGradient(
          colors: [Color(0xFFFFC736), Color(0xFFFFAD31)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        gold66: LinearGradient(
          colors: [
            const Color(0xFFFFC736).withValues(alpha: 0.66),
            const Color(0xFFFFAD31).withValues(alpha: 0.66)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        gold33: LinearGradient(
          colors: [
            const Color(0xFFFFC736).withValues(alpha: 0.33),
            const Color(0xFFFFAD31).withValues(alpha: 0.33)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        gold16: LinearGradient(
          colors: [
            const Color(0xFFFFC736).withValues(alpha: 0.16),
            const Color(0xFFFFAD31).withValues(alpha: 0.16)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        greydient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFDBDBFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        greydient66: LinearGradient(
          colors: [
            const Color(0xFFFFFFFF).withValues(alpha: 0.66),
            const Color(0xFFDBDBFF).withValues(alpha: 0.66)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        greydient33: LinearGradient(
          colors: [
            const Color(0xFFFFFFFF).withValues(alpha: 0.33),
            const Color(0xFFDBDBFF).withValues(alpha: 0.33)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        greydient16: LinearGradient(
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
        black.named('black'),
        black66.named('black66'),
        black33.named('black33'),
        black16.named('black16'),
        black8.named('black8'),
        grey.named('grey'),
        grey66.named('grey66'),
        grey33.named('grey33'),
        blurpleColor.named('blurpleColor'),
        blurpleColor66.named('blurpleColor66'),
        goldColor.named('goldColor'),
        goldColor66.named('goldColor66'),
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
        greydient.named('greydient'),
        greydient66.named('greydient66'),
        greydient33.named('greydient33'),
        greydient16.named('greydient16'),
      ];
}
