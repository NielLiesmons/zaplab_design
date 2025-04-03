import 'package:models/models.dart';

String npubToColor(String npub) {
  final hex = Profile.hexFromNpub(npub);
  final color = '#${hex.substring(0, 6)}';
  print('NPub: $npub -> Hex: $hex -> Color: $color'); // Debug print
  return color;
}

String formatNpub(String npub) {
  if (npub.length < 8) return npub;
  return '${npub.substring(0, 5)}......${npub.substring(npub.length - 6)}';
}
