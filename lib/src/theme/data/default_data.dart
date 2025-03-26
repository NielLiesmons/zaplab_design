import 'package:models/models.dart';

class DefaultData {
  static const List<double> defaultAmounts = [
    21,
    100,
    1000,
    1234,
    2100,
    5000,
    21000
  ];

  static List<PartialReaction> defaultReactions = [
    PartialReaction(
      emojiTag: (
        'https://www.pinclipart.com/picdir/big/357-3571823_free-png-download-ios-10-crying-laughing-emoji.png',
        'laughing'
      ),
    ),
    PartialReaction(
      emojiTag: (
        'http://clipart.info/images/ccovers/1516250282red-heart-emoji.png',
        'heart'
      ),
    ),
    PartialReaction(
      emojiTag: (
        'https://cdn.satellite.earth/eb0122af34cf27ba7c8248d72294c32a956209f157aa9d697c7cdd6b054f9ea9.png',
        '90'
      ),
    ),
    PartialReaction(
      emojiTag: (
        'https://cdn.satellite.earth/cbcd50ec769b65c03bc780f0b2d0967f893d10a29f7666d7df8f2d7614d493d4.png',
        'todo'
      ),
    ),
    PartialReaction(emojiTag: (
      'https://cdn.betterttv.net/emote/5eb9919eec17d81685a496b1/3x.webp',
      'todo'
    )),
    PartialReaction(
      emojiTag: (
        'https://cdn.betterttv.net/emote/5bc116eddd373363d2c76479/3x.webp',
        'todo'
      ),
    ),
    PartialReaction(
      emojiTag: ('https://nogood.studio/nostr/emotes/NoGood_Yo.gif', 'todo'),
    ),
  ];
}
