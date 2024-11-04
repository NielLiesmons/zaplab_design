import 'package:zapchat_design/src/utils/named.dart';
import 'package:flutter/rendering.dart';
import 'package:equatable/equatable.dart';

class AppColorsData extends Equatable {
  // Colors
  final Color White;
  final Color White66;
  final Color White33;
  final Color White16;
  final Color White8;
  final Color Black;
  final Color Black66;
  final Color Black33;
  final Color Black16;
  final Color Black8;
  final Color Grey;
  final Color Grey66;
  final Color Grey33;

  // Radial Gradients
  final Gradient Blurple;
  final Gradient Blurple66;
  final Gradient Blurple33;
  final Gradient BlurpleLight;
  final Gradient Rouge;
  final Gradient Rouge66;
  final Gradient Rouge33;
  final Gradient Gold;
  final Gradient Gold66;
  final Gradient Gold33;
  final Gradient Greydient;
  final Gradient Greydient66;
  final Gradient Greydient33;

  AppColorsData({
    required this.White,
    required this.White66,
    required this.White33,
    required this.White16,
    required this.White8,
    required this.Black,
    required this.Black66,
    required this.Black33,
    required this.Black16,
    required this.Black8,
    required this.Grey,
    required this.Grey66,
    required this.Grey33,
    required this.Blurple,
    required this.Blurple66,
    required this.Blurple33,
    required this.BlurpleLight,
    required this.Rouge,
    required this.Rouge66,
    required this.Rouge33,
    required this.Gold,
    required this.Gold66,
    required this.Gold33,
    required this.Greydient,
    required this.Greydient66,
    required this.Greydient33,
  });

// Dark mode
  factory AppColorsData.dark() => AppColorsData(
        // Colors (full or 66% / 33% transparent)
        White: Color(0xFFFFFFFF),
        White66: Color(0xFFFFFFFF).withOpacity(0.66),
        White33: Color(0xFFFFFFFF).withOpacity(0.33),
        White16: Color(0xFFFFFFFF).withOpacity(0.16),
        White8: Color(0xFFFFFFFF).withOpacity(0.08),
        Black: Color(0xFF000000),
        Black66: Color(0xFF000000).withOpacity(0.66),
        Black33: Color(0xFF000000).withOpacity(0.33),
        Black16: Color(0xFF000000).withOpacity(0.16),
        Black8: Color(0xFF000000).withOpacity(0.08),
        Grey: Color(0xFF232323),
        Grey66: Color(0xFF333333).withOpacity(0.66),
        Grey33: Color(0xFF333333).withOpacity(0.33),

        // Radial Gradients (top-left to bottom-right alignment)
        Blurple: RadialGradient(
          colors: [Color(0xFF636AFF), Color(0xFF5445FF)],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Blurple66: RadialGradient(
          colors: [
            Color(0xFF636AFF).withOpacity(0.66),
            Color(0xFF5445FF).withOpacity(0.66)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Blurple33: RadialGradient(
          colors: [
            Color(0xFF636AFF).withOpacity(0.33),
            Color(0xFF5445FF).withOpacity(0.33)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        BlurpleLight: RadialGradient(
          colors: [
            Color(0xFF888DFE).withOpacity(0.33),
            Color(0xFF7E73FF).withOpacity(0.33)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),

        Rouge: RadialGradient(
          colors: [Color(0xFFFF416E), Color(0xFFFF005C)],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Rouge66: RadialGradient(
          colors: [
            Color(0xFFFF416E).withOpacity(0.66),
            Color(0xFFFF005C).withOpacity(0.66)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Rouge33: RadialGradient(
          colors: [
            Color(0xFFFF416E).withOpacity(0.33),
            Color(0xFFFF005C).withOpacity(0.33)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),

        Gold: RadialGradient(
          colors: [Color(0xFFFFC736), Color(0xFFFFAD31)],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Gold66: RadialGradient(
          colors: [
            Color(0xFFFFC736).withOpacity(0.66),
            Color(0xFFFFAD31).withOpacity(0.66)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Gold33: RadialGradient(
          colors: [
            Color(0xFFFFC736).withOpacity(0.33),
            Color(0xFFFFAD31).withOpacity(0.33)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),

        Greydient: RadialGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFDBDBFF)],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Greydient66: RadialGradient(
          colors: [
            Color(0xFFFFFFFF).withOpacity(0.66),
            Color(0xFFDBDBFF).withOpacity(0.66)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Greydient33: RadialGradient(
          colors: [
            Color(0xFFFFFFFF).withOpacity(0.33),
            Color(0xFFDBDBFF).withOpacity(0.33)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
      );

// Light mode
  factory AppColorsData.light() => AppColorsData(
        // Colors (full or 66% / 33% transparent)
        White: Color(0xFF000000),
        White66: Color(0xFF000000).withOpacity(0.66),
        White33: Color(0xFF000000).withOpacity(0.33),
        White16: Color(0xFF000000).withOpacity(0.16),
        White8: Color(0xFF000000).withOpacity(0.08),
        Black: Color(0xFFFFFFFF),
        Black66: Color(0xFFFFFFFF).withOpacity(0.66),
        Black33: Color(0xFFFFFFFF).withOpacity(0.33),
        Black16: Color(0xFFFFFFFF).withOpacity(0.16),
        Black8: Color(0xFFFFFFFF).withOpacity(0.08),
        Grey: Color(0xFFDCDCDC),
        Grey66: Color(0xFFCCCCCC).withOpacity(0.66),
        Grey33: Color(0xFFCCCCCC).withOpacity(0.33),

        // Radial Gradients (top-left to bottom-right alignment)
        Blurple: RadialGradient(
          colors: [Color(0xFF636AFF), Color(0xFF5445FF)],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Blurple66: RadialGradient(
          colors: [
            Color(0xFF636AFF).withOpacity(0.66),
            Color(0xFF5445FF).withOpacity(0.66)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Blurple33: RadialGradient(
          colors: [
            Color(0xFF636AFF).withOpacity(0.33),
            Color(0xFF5445FF).withOpacity(0.33)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        BlurpleLight: RadialGradient(
          colors: [Color(0xFF636AFF), Color(0xFF5445FF)],
          center: Alignment.topLeft,
          radius: 1.5,
        ),

        Rouge: RadialGradient(
          colors: [Color(0xFFFF416E), Color(0xFFFF005C)],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Rouge66: RadialGradient(
          colors: [
            Color(0xFFFF416E).withOpacity(0.66),
            Color(0xFFFF005C).withOpacity(0.66)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Rouge33: RadialGradient(
          colors: [
            Color(0xFFFF416E).withOpacity(0.33),
            Color(0xFFFF005C).withOpacity(0.33)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),

        Gold: RadialGradient(
          colors: [Color(0xFFFFC736), Color(0xFFFFAD31)],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Gold66: RadialGradient(
          colors: [
            Color(0xFFFFC736).withOpacity(0.66),
            Color(0xFFFFAD31).withOpacity(0.66)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Gold33: RadialGradient(
          colors: [
            Color(0xFFFFC736).withOpacity(0.33),
            Color(0xFFFFAD31).withOpacity(0.33)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),

        Greydient: RadialGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFDBDBFF)],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Greydient66: RadialGradient(
          colors: [
            Color(0xFFFFFFFF).withOpacity(0.66),
            Color(0xFFDBDBFF).withOpacity(0.66)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Greydient33: RadialGradient(
          colors: [
            Color(0xFFFFFFFF).withOpacity(0.33),
            Color(0xFFDBDBFF).withOpacity(0.33)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
      );

// Grey mode
  factory AppColorsData.grey() => AppColorsData(
        // Colors (full or 66% / 33% transparent)
        White: Color(0xFFFFFFFF),
        White66: Color(0xFFFFFFFF).withOpacity(0.66),
        White33: Color(0xFFFFFFFF).withOpacity(0.33),
        White16: Color(0xFFFFFFFF).withOpacity(0.16),
        White8: Color(0xFFFFFFFF).withOpacity(0.08),
        Black: Color(0xFF181818),
        Black66: Color(0xFF181818).withOpacity(0.66),
        Black33: Color(0xFF000000).withOpacity(0.33),
        Black16: Color(0xFF000000).withOpacity(0.16),
        Black8: Color(0xFF000000).withOpacity(0.08),
        Grey: Color(0xFF232323),
        Grey66: Color(0xFF333333).withOpacity(0.66),
        Grey33: Color(0xFF333333).withOpacity(0.33),

        // Radial Gradients (top-left to bottom-right alignment)
        Blurple: RadialGradient(
          colors: [Color(0xFF636AFF), Color(0xFF5445FF)],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Blurple66: RadialGradient(
          colors: [
            Color(0xFF636AFF).withOpacity(0.66),
            Color(0xFF5445FF).withOpacity(0.66)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Blurple33: RadialGradient(
          colors: [
            Color(0xFF636AFF).withOpacity(0.33),
            Color(0xFF5445FF).withOpacity(0.33)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        BlurpleLight: RadialGradient(
          colors: [
            Color(0xFF888DFE).withOpacity(0.33),
            Color(0xFF7E73FF).withOpacity(0.33)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),

        Rouge: RadialGradient(
          colors: [Color(0xFFFF416E), Color(0xFFFF005C)],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Rouge66: RadialGradient(
          colors: [
            Color(0xFFFF416E).withOpacity(0.66),
            Color(0xFFFF005C).withOpacity(0.66)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Rouge33: RadialGradient(
          colors: [
            Color(0xFFFF416E).withOpacity(0.33),
            Color(0xFFFF005C).withOpacity(0.33)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),

        Gold: RadialGradient(
          colors: [Color(0xFFFFC736), Color(0xFFFFAD31)],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Gold66: RadialGradient(
          colors: [
            Color(0xFFFFC736).withOpacity(0.66),
            Color(0xFFFFAD31).withOpacity(0.66)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Gold33: RadialGradient(
          colors: [
            Color(0xFFFFC736).withOpacity(0.33),
            Color(0xFFFFAD31).withOpacity(0.33)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),

        Greydient: RadialGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFDBDBFF)],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Greydient66: RadialGradient(
          colors: [
            Color(0xFFFFFFFF).withOpacity(0.66),
            Color(0xFFDBDBFF).withOpacity(0.66)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
        Greydient33: RadialGradient(
          colors: [
            Color(0xFFFFFFFF).withOpacity(0.33),
            Color(0xFFDBDBFF).withOpacity(0.33)
          ],
          center: Alignment.topLeft,
          radius: 1.5,
        ),
      );

  @override
  List<Object?> get props => [
        White.named('White'),
        White66.named('White'),
        White33.named('White'),
        White16.named('White'),
        White8.named('White'),
        Black.named('White'),
        Black66.named('White'),
        Black33.named('White'),
        Black16.named('White'),
        Black8.named('White'),
        Grey.named('White'),
        Grey66.named('White'),
        Grey33.named('White'),
        Blurple.named('White'),
        Blurple66.named('White'),
        Blurple33.named('White'),
        Rouge.named('White'),
        Rouge66.named('White'),
        Rouge33.named('White'),
        Gold.named('White'),
        Gold66.named('White'),
        Gold33.named('White'),
        Greydient.named('White'),
        Greydient66.named('White'),
        Greydient33.named('White'),
      ];
}
