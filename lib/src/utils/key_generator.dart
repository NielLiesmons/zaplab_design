import 'package:bip39/bip39.dart' as bip39;
import 'package:bip39/src/wordlists/english.dart' as bip39_words;
import 'package:hex/hex.dart' show HEX;
import 'package:crypto/crypto.dart';
import 'package:collection/collection.dart';
import 'emoji_list.dart';
import 'dart:math';

class KeyGeneratorResult {
  final String nsec;
  final String npub;
  final String mnemonic;
  final List<String> emojis;

  const KeyGeneratorResult({
    required this.nsec,
    required this.npub,
    required this.mnemonic,
    required this.emojis,
  });
}

class KeyGenerator {
  /// Converts a Nostr private key (nsec) to a BIP39 mnemonic
  /// Only works for nsecs generated by our method
  static String? nsecToMnemonic(String nsec) {
    if (!isOurKey(nsec)) return null;

    // Convert nsec to bytes
    final privateKeyBytes = HEX.decode(nsec);

    // Use first 16 bytes (128 bits) for the mnemonic
    final entropy = privateKeyBytes.sublist(0, 16);
    final entropyHex = HEX.encode(entropy);

    // Generate 12-word mnemonic
    return bip39.entropyToMnemonic(entropyHex);
  }

  /// Converts a BIP39 mnemonic to a Nostr private key (nsec)
  /// Always generates a valid nsec using our method
  static String mnemonicToNsec(String mnemonic) {
    // Get the entropy directly from the mnemonic
    final entropyHex = bip39.mnemonicToEntropy(mnemonic);
    final firstHalf = HEX.decode(entropyHex);

    // Second 16 bytes are derived from the first half
    final secondHalf = sha256.convert(firstHalf).bytes.sublist(0, 16);

    // Combine the halves
    final privateKeyBytes = [...firstHalf, ...secondHalf];

    // Ensure the key is valid (first byte must be less than 0x80)
    if (privateKeyBytes[0] >= 0x80) {
      privateKeyBytes[0] = privateKeyBytes[0] & 0x7F;
    }

    return 'nsec1${HEX.encode(privateKeyBytes)}';
  }

  /// Checks if a Nostr private key was generated using our method
  static bool isOurKey(String nsec) {
    final privateKeyBytes = HEX.decode(nsec);
    final firstHalf = privateKeyBytes.sublist(0, 16);
    final secondHalf = privateKeyBytes.sublist(16, 32);
    final expectedSecondHalf = sha256.convert(firstHalf).bytes.sublist(0, 16);

    return const ListEquality().equals(secondHalf, expectedSecondHalf);
  }

  /// Converts a Nostr private key to emojis
  /// Only works for nsecs generated by our method
  static List<String>? nsecToEmojis(String nsec) {
    final mnemonic = nsecToMnemonic(nsec);
    if (mnemonic == null) return null;

    final words = mnemonic.split(' ');
    return words.map((word) {
      // Find the index of the word in the BIP39 word list
      final wordIndex = bip39_words.WORDLIST.indexOf(word);
      if (wordIndex == -1) {
        throw Exception('Word not found in BIP39 word list: $word');
      }
      // Use the same index to get the corresponding emoji
      return emojis[wordIndex];
    }).toList();
  }

  /// Converts emojis back to a Nostr private key
  static String emojisToNsec(List<String> emojis) {
    // Convert each emoji back to its corresponding word
    final words = emojis.map((emoji) {
      final emojiIndex = emojis.indexOf(emoji);
      if (emojiIndex == -1) {
        throw Exception('Emoji not found in emoji list: $emoji');
      }
      return bip39_words.WORDLIST[emojiIndex];
    }).toList();

    // Join words into mnemonic
    final mnemonic = words.join(' ');

    // Convert mnemonic to nsec
    return mnemonicToNsec(mnemonic);
  }

  /// Converts a Nostr private key (nsec) to a public key (npub)
  static String nsecToNpub(String nsec) {
    final privateKeyBytes = HEX.decode(nsec);
    final publicKeyBytes = sha256.convert(privateKeyBytes).bytes;
    return HEX.encode(publicKeyBytes);
  }

  /// Generates a new random key pair with mnemonic and emojis
  static KeyGeneratorResult generateNewKeys() {
    // Generate random 16 bytes (128 bits) for the first half
    final random = Random.secure();
    final firstHalf = List<int>.generate(16, (_) => random.nextInt(256));
    final entropyHex = HEX.encode(firstHalf);

    // Generate mnemonic from entropy
    final mnemonic = bip39.entropyToMnemonic(entropyHex);

    // Convert mnemonic to nsec
    final nsec = mnemonicToNsec(mnemonic);

    // Get npub from nsec
    final npub = nsecToNpub(nsec);

    // Convert nsec to emojis
    final emojis = nsecToEmojis(nsec);
    if (emojis == null) {
      throw Exception('Failed to generate emojis from nsec');
    }

    return KeyGeneratorResult(
      nsec: nsec,
      npub: npub,
      mnemonic: mnemonic,
      emojis: emojis,
    );
  }

  /// Simple hash function to convert a word to a number
  static int _hashString(String input) {
    var hash = 0;
    for (var i = 0; i < input.length; i++) {
      hash = (hash * 31 + input.codeUnitAt(i)) & 0xFFFFFFFF;
    }
    return hash;
  }

  static String generateMnemonic() {
    final random = Random.secure();
    final entropy = List<int>.generate(16, (_) => random.nextInt(256));
    final hexString =
        entropy.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return bip39.entropyToMnemonic(hexString);
  }

  static List<int> nsecToEmojiIndices(String nsec) {
    // Remove the 'nsec1' prefix
    final hexString = nsec.substring(5);

    // Convert hex string to bytes
    final bytes = HEX.decode(hexString);

    // Use all 32 bytes to generate 12 indices
    // Each index will use 2-3 bytes to get a better distribution
    final indices = <int>[];
    for (var i = 0; i < 12; i++) {
      // Use 2-3 bytes for each index to get a better distribution
      final start = (i * 2) % bytes.length;
      final end = start + 2;
      final value = bytes
          .sublist(start, end)
          .fold<int>(0, (acc, byte) => (acc << 8) | byte);
      indices.add(value % emojis.length);
    }

    return indices;
  }

  static bool verifyNsecChecksum(String nsec) {
    try {
      // Remove the 'nsec1' prefix
      final hexString = nsec.substring(5);

      // Convert hex string to bytes
      final bytes = HEX.decode(hexString);

      // Split into first half (16 bytes) and second half (16 bytes)
      final firstHalf = bytes.sublist(0, 16);
      final secondHalf = bytes.sublist(16);

      // Hash the first half
      final hash = sha256.convert(firstHalf).bytes.sublist(0, 16);

      // Compare with second half
      return const ListEquality().equals(hash, secondHalf);
    } catch (e) {
      print('Error verifying checksum: $e');
      return false;
    }
  }
}
