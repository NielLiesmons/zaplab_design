String formatNpub(String npub) {
  if (npub.length < 8) return npub;
  return '${npub.substring(0, 5)}......${npub.substring(npub.length - 6)}';
}
