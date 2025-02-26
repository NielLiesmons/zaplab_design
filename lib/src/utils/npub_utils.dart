import 'package:bech32/bech32.dart';

String npubToHex(String npub) {
  try {
    final decoded = Bech32Codec().decode(npub);
    final data = decoded.data;
    final converted = convertBits(data, 5, 8, false);
    return converted
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join('');
  } catch (e) {
    print('Error decoding npub: $e'); // Debug print
    return '000000';
  }
}

String npubToColor(String npub) {
  final hex = npubToHex(npub);
  final color = '#${hex.substring(0, 6)}';
  print('NPub: $npub -> Hex: $hex -> Color: $color'); // Debug print
  return color;
}

List<int> convertBits(List<int> data, int fromBits, int toBits, bool pad) {
  var acc = 0;
  var bits = 0;
  final result = <int>[];
  final maxv = (1 << toBits) - 1;

  for (var value in data) {
    if (value < 0 || (value >> fromBits) != 0) {
      throw Exception('Invalid value: $value');
    }
    acc = (acc << fromBits) | value;
    bits += fromBits;
    while (bits >= toBits) {
      bits -= toBits;
      result.add((acc >> bits) & maxv);
    }
  }

  if (pad) {
    if (bits > 0) {
      result.add((acc << (toBits - bits)) & maxv);
    }
  }

  return result;
}

String formatNpub(String npub) {
  if (npub.length < 8) return npub;
  return '${npub.substring(0, 5)}......${npub.substring(npub.length - 6)}';
}
