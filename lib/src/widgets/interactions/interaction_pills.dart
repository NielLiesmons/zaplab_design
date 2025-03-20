import 'package:zaplab_design/zaplab_design.dart';
import 'package:collection/collection.dart';

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

    final outgoingZaps = sortedZaps.where((zap) => zap.isOutgoing == true);
    final incomingZaps = sortedZaps.where((zap) => zap.isOutgoing != true);
    final outgoingReactions =
        sortedReactions.where((reaction) => reaction.isOutgoing == true);
    final incomingReactions =
        sortedReactions.where((reaction) => reaction.isOutgoing != true);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...outgoingZaps.mapIndexed((index, zap) {
            final isLastItem = index == outgoingZaps.length - 1 &&
                outgoingReactions.isEmpty &&
                incomingZaps.isEmpty &&
                incomingReactions.isEmpty;
            return AppContainer(
              padding: isLastItem
                  ? const AppEdgeInsets.all(AppGapSize.none)
                  : const AppEdgeInsets.only(right: AppGapSize.s8),
              child: AppZapPill(
                amount: zap.amount,
                profilePicUrl: zap.profilePicUrl,
                npub: zap.npub,
                isOutgoing: true,
                onTap: () => onZapTap?.call(nevent),
              ),
            );
          }),
          ...outgoingReactions.mapIndexed((index, reaction) {
            final isLastItem = index == outgoingReactions.length - 1 &&
                incomingZaps.isEmpty &&
                incomingReactions.isEmpty;
            return AppContainer(
              padding: isLastItem
                  ? const AppEdgeInsets.all(AppGapSize.none)
                  : const AppEdgeInsets.only(right: AppGapSize.s8),
              child: AppReactionPill(
                emojiUrl: reaction.emojiUrl,
                emojiName: reaction.emojiName,
                profilePicUrl: reaction.profilePicUrl,
                npub: reaction.npub,
                isOutgoing: true,
                onTap: () => onReactionTap?.call(nevent),
              ),
            );
          }),
          ...incomingZaps.mapIndexed((index, zap) {
            final isLastItem =
                index == incomingZaps.length - 1 && incomingReactions.isEmpty;
            return AppContainer(
              padding: isLastItem
                  ? const AppEdgeInsets.all(AppGapSize.none)
                  : const AppEdgeInsets.only(right: AppGapSize.s8),
              child: AppZapPill(
                amount: zap.amount,
                profilePicUrl: zap.profilePicUrl,
                npub: zap.npub,
                isOutgoing: false,
                onTap: () => onZapTap?.call(nevent),
              ),
            );
          }),
          ...incomingReactions.mapIndexed((index, reaction) {
            final isLastItem = index == incomingReactions.length - 1;
            return AppContainer(
              padding: isLastItem
                  ? const AppEdgeInsets.all(AppGapSize.none)
                  : const AppEdgeInsets.only(right: AppGapSize.s8),
              child: AppReactionPill(
                emojiUrl: reaction.emojiUrl,
                emojiName: reaction.emojiName,
                profilePicUrl: reaction.profilePicUrl,
                npub: reaction.npub,
                isOutgoing: false,
                onTap: () => onReactionTap?.call(nevent),
              ),
            );
          }),
        ],
      ),
    );
  }
}
