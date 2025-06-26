import 'package:models/models.dart';
import 'package:bech32/bech32.dart';

class RGBColor {
  final int r;
  final int g;
  final int b;

  const RGBColor(this.r, this.g, this.b);

  int toInt() => (r << 16) | (g << 8) | b;
  int toIntWithAlpha() => 0xFF000000 | toInt();
  String toHex() =>
      '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
}

RGBColor hexToColor(String hex) {
  final number = BigInt.parse(hex, radix: 16);

  // Get hue value between 0 and 355
  final hue = (number % BigInt.from(360)).toInt();

// Convert HSV to RGB
  final h = hue / 60;

  // Adjustements to make the color readable at all times
  const s = 0.70;
  final v = (hue >= 32 && hue <= 204)
      ? 0.75
      : (hue >= 216 && hue <= 273)
          ? 0.96
          : 0.90;

  final c = v * s;
  final x = c * (1 - (h % 2 - 1).abs());
  final m = v - c;

  double r, g, b;
  if (h < 1) {
    r = c;
    g = x;
    b = 0;
  } else if (h < 2) {
    r = x;
    g = c;
    b = 0;
  } else if (h < 3) {
    r = 0;
    g = c;
    b = x;
  } else if (h < 4) {
    r = 0;
    g = x;
    b = c;
  } else if (h < 5) {
    r = x;
    g = 0;
    b = c;
  } else {
    r = c;
    g = 0;
    b = x;
  }

  // Convert RGB to integers
  final red = ((r + m) * 255).round();
  final green = ((g + m) * 255).round();
  final blue = ((b + m) * 255).round();

  final color = RGBColor(red, green, blue);

  return color;
}

String profileToHexColor(Profile profile) {
  return hexToColor(profile.pubkey).toHex();
}

int profileToColor(Profile profile) {
  return hexToColor(profile.pubkey).toIntWithAlpha();
}

String npubToHex(String npub) {
  try {
    if (npub.startsWith('npub1')) {
      // If it's already a Bech32 npub, decode it
      final decoded = const Bech32Codec().decode(npub);
      final data = decoded.data;
      final converted = convertBits(data, 5, 8, false);
      return converted
          .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
          .join('');
    } else {
      // If it's already hex, return it directly
      return npub;
    }
  } catch (e) {
    print('Error decoding npub: $e'); // Debug print
    return '000000';
  }
}

String npubToHexColor(String npub) {
  return hexToColor(npubToHex(npub)).toHex();
}

int npubToColor(String npub) {
  return hexToColor(npubToHex(npub)).toIntWithAlpha();
}
