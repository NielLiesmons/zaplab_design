import 'package:zaplab_design/zaplab_design.dart';

class AppInteractionPills extends StatelessWidget {
  final List<Zap> zaps;
  final List<Reaction> reactions;
  final String nevent;
  final void Function(String)? onZapTap;
  final void Function(String)? onReactionTap;

  const AppInteractionPills({
    super.key,
    required this.nevent,
    this.zaps = const [],
    this.reactions = const [],
    this.onZapTap,
    this.onReactionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (zaps.isEmpty && reactions.isEmpty) {
      return const SizedBox();
    }

    final sortedZaps = List.from(zaps)
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final sortedReactions = List.from(reactions)
      ..sort((a, b) => b.timestamp!.compareTo(a.timestamp!));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...sortedZaps.map((zap) => AppContainer(
                padding: const AppEdgeInsets.only(right: AppGapSize.s8),
                child: AppZapPill(
                  amount: zap.amount,
                  profilePicUrl: zap.profilePicUrl,
                  npub: zap.npub,
                  isOutgoing: zap.isOutgoing ?? false,
                  onTap: () => onZapTap?.call(nevent),
                ),
              )),
          ...sortedReactions.map((reaction) => AppContainer(
                padding: const AppEdgeInsets.only(right: AppGapSize.s8),
                child: AppReactionPill(
                  emojiUrl: reaction.emojiUrl,
                  emojiName: reaction.emojiName,
                  profilePicUrl: reaction.profilePicUrl,
                  npub: reaction.npub,
                  isOutgoing: reaction.isOutgoing ?? false,
                  onTap: () => onReactionTap?.call(nevent),
                ),
              )),
        ],
      ),
    );
  }
}
