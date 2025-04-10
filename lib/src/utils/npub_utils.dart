import 'package:models/models.dart';

String profileToColor(Profile profile) {
  final hex = profile.pubkey;
  final color = '#${hex.substring(0, 6)}';
  print('NPub: $profile -> Hex: $hex -> Color: $color'); // Debug print
  return color;
}

String formatNpub(String npub) {
  if (npub.length < 8) return npub;
  return '${npub.substring(0, 5)}......${npub.substring(npub.length - 6)}';
}
