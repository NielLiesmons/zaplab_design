import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabPoll extends StatelessWidget {
  final Poll poll;
  final Profile? activeProfile;

  final List<PollResponse> allVotes;

  final Function(int optionIndex) onOptionTap;
  final Function(int optionIndex) onVotesTap;
  final Function(Profile) onProfileTap;
  final bool isUnread;
  final LinkTapHandler onLinkTap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;

  const LabPoll({
    super.key,
    required this.poll,
    this.activeProfile,
    required this.allVotes,
    required this.onOptionTap,
    required this.onVotesTap,
    required this.onProfileTap,
    this.isUnread = false,
    required this.onLinkTap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    // Get poll options from the Poll model
    final pollOptions = poll.options;

    // Group votes by option ID
    final votesByOptionId = <String, List<PollResponse>>{};
    for (final vote in allVotes) {
      for (final optionId in vote.selectedOptionIds) {
        votesByOptionId.putIfAbsent(optionId, () => []).add(vote);
      }
    }

    // Create option data with votes
    final optionsWithVotes = pollOptions
        .map((option) => (
              id: option.id,
              label: option.label,
              votes: votesByOptionId[option.id] ?? [],
            ))
        .toList();

    // Calculate total votes across all options
    final totalVotes = allVotes.length;

    // Sort options by vote count (highest first)
    final sortedOptions = List.from(optionsWithVotes)
      ..sort((a, b) => b.votes.length.compareTo(a.votes.length));

    // Find the maximum votes for fill percentage calculation
    final maxVotes =
        sortedOptions.isNotEmpty ? sortedOptions.first.votes.length : 0;

    // Count how many options have the maximum votes
    final optionsWithMaxVotes =
        sortedOptions.where((option) => option.votes.length == maxVotes).length;

    // Calculate the fill percentage per option when they share the maximum
    final fillPercentagePerMaxOption =
        optionsWithMaxVotes > 0 ? (100 / optionsWithMaxVotes).round() : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabContainer(
          padding: const LabEdgeInsets.symmetric(horizontal: LabGapSize.s8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LabLongTextRenderer(
                  model: poll,
                  content: poll.content,
                  serif: false,
                  onResolveEvent: onResolveEvent,
                  onResolveProfile: onResolveProfile,
                  onResolveEmoji: onResolveEmoji,
                  onResolveHashtag: onResolveHashtag,
                  onLinkTap: onLinkTap,
                  onProfileTap: onProfileTap,
                ),
              ),
              const LabGap.s4(),
              if (isUnread)
                LabContainer(
                  margin: const LabEdgeInsets.only(top: LabGapSize.s10),
                  height: theme.sizes.s8,
                  width: theme.sizes.s8,
                  decoration: BoxDecoration(
                    gradient: theme.colors.blurple,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
        ...sortedOptions.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final optionVotes = option.votes.length;

          // Calculate percentage of total votes
          final percentage =
              totalVotes > 0 ? ((optionVotes / totalVotes) * 100).round() : 0;

          // Calculate fill percentage - if all options have same votes, divide equally
          final fillPercentage = maxVotes > 0
              ? (optionVotes == maxVotes
                  ? fillPercentagePerMaxOption
                  : ((optionVotes / maxVotes) * fillPercentagePerMaxOption)
                      .round())
              : 0;

          // Find the original index of this option for callbacks
          final originalIndex =
              pollOptions.indexWhere((opt) => opt.id == option.id);

          return Column(
            children: [
              LabPollButton(
                model: poll,
                content: option.label,
                votes: option.votes,
                isSelected: activeProfile != null
                    ? option.votes.any((vote) =>
                        vote.author.value?.pubkey == activeProfile?.pubkey)
                    : false,
                percentage: percentage,
                fillPercentage: fillPercentage,
                onTap: () => onOptionTap(originalIndex),
                onVotesTap: () => onVotesTap(originalIndex),
                onProfileTap: onProfileTap,
                onLinkTap: onLinkTap,
                onResolveEvent: onResolveEvent,
                onResolveProfile: onResolveProfile,
                onResolveEmoji: onResolveEmoji,
                onResolveHashtag: onResolveHashtag,
              ),
              if (index < sortedOptions.length - 1) const LabGap.s8(),
            ],
          );
        }),
      ],
    );
  }
}
