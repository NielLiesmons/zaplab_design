import 'package:models/models.dart';

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
  // Ensure hex string is valid
  if (hex.isEmpty || !RegExp(r'^[0-9a-fA-F]+$').hasMatch(hex)) {
    // Return a default gray color if hex is invalid
    return RGBColor(128, 128, 128);
  }

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

String npubToHexColor(String npub) {
  try {
    final decodedPubkey = npub.decodeShareable();
    // Ensure we have a valid hex string
    if (decodedPubkey.isEmpty ||
        !RegExp(r'^[0-9a-fA-F]+$').hasMatch(decodedPubkey)) {
      // Fallback to a default color if decoding fails
      return '#808080'; // Gray color
    }
    return hexToColor(decodedPubkey).toHex();
  } catch (e) {
    // Fallback to a default color if any error occurs
    return '#808080'; // Gray color
  }
}

int npubToColor(String npub) {
  try {
    final decodedPubkey = npub.decodeShareable();
    // Ensure we have a valid hex string
    if (decodedPubkey.isEmpty ||
        !RegExp(r'^[0-9a-fA-F]+$').hasMatch(decodedPubkey)) {
      // Fallback to a default color if decoding fails
      return 0xFF808080; // Gray color
    }
    return hexToColor(decodedPubkey).toIntWithAlpha();
  } catch (e) {
    // Fallback to a default color if any error occurs
    return 0xFF808080; // Gray color
  }
}
