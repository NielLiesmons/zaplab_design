import './npub_color.dart';

RGBColor extensionToColor(String extension) {
  // Convert extension to uppercase and remove dot if present
  final cleanExtension = extension.toUpperCase().replaceAll('.', '');

  // Convert string to BigInt using character codes
  BigInt number = BigInt.zero;
  for (int i = 0; i < cleanExtension.length; i++) {
    number = number +
        BigInt.from(cleanExtension.codeUnitAt(i)) * BigInt.from(256).pow(i);
  }

  // Get hue value between 0 and 355
  final hue = (number % BigInt.from(360)).toInt();

  // Convert HSV to RGB
  final h = hue / 60;

  // Adjustements to make the color readable at all times
  final s = 0.70;
  final v = (hue >= 32 && hue <= 204)
      ? 0.70
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

  return RGBColor(red, green, blue);
}

String extensionToHexColor(String extension) {
  return extensionToColor(extension).toHex();
}

int extensionToColorInt(String extension) {
  return extensionToColor(extension).toIntWithAlpha();
}

// Convenience method for common file extensions
String getFileExtensionColor(String filename) {
  final extension = filename.split('.').last;
  return extensionToHexColor(extension);
}

int getFileExtensionColorInt(String filename) {
  final extension = filename.split('.').last;
  return extensionToColorInt(extension);
}
