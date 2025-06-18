import 'package:zaplab_design/zaplab_design.dart';
import 'package:collection/collection.dart';
import 'package:models/models.dart';

class LabInteractionPills extends StatelessWidget {
  final List<Zap> zaps;
  final List<Reaction> reactions;
  final void Function(Zap)? onZapTap;
  final void Function(Reaction)? onReactionTap;

  const LabInteractionPills({
    super.key,
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
            return LabContainer(
              padding: isLastItem
                  ? const LabEdgeInsets.all(LabGapSize.none)
                  : const LabEdgeInsets.only(right: LabGapSize.s8),
              child: LabZapPill(
                zap: zap,
                isOutgoing: true,
                onTap: () => onZapTap?.call(zap),
              ),
            );
          }),
          ...outgoingReactions.mapIndexed((index, reaction) {
            final isLastItem = index == outgoingReactions.length - 1 &&
                incomingZaps.isEmpty &&
                incomingReactions.isEmpty;
            return LabContainer(
              padding: isLastItem
                  ? const LabEdgeInsets.all(LabGapSize.none)
                  : const LabEdgeInsets.only(right: LabGapSize.s8),
              child: LabReactionPill(
                reaction: reaction,
                isOutgoing: true,
                onTap: () => onReactionTap?.call(reaction),
              ),
            );
          }),
          ...incomingZaps.mapIndexed((index, zap) {
            final isLastItem =
                index == incomingZaps.length - 1 && incomingReactions.isEmpty;
            return LabContainer(
              padding: isLastItem
                  ? const LabEdgeInsets.all(LabGapSize.none)
                  : const LabEdgeInsets.only(right: LabGapSize.s8),
              child: LabZapPill(
                zap: zap,
                isOutgoing: false,
                onTap: () => onZapTap?.call(zap),
              ),
            );
          }),
          ...incomingReactions.mapIndexed((index, reaction) {
            final isLastItem = index == incomingReactions.length - 1;
            return LabContainer(
              padding: isLastItem
                  ? const LabEdgeInsets.all(LabGapSize.none)
                  : const LabEdgeInsets.only(right: LabGapSize.s8),
              child: LabReactionPill(
                reaction: reaction,
                isOutgoing: false,
                onTap: () => onReactionTap?.call(reaction),
              ),
            );
          }),
        ],
      ),
    );
  }
}
