import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabFeedPoll extends StatelessWidget {
  final Poll poll;
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

  const LabFeedPoll({
    super.key,
    required this.poll,
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
    return Column(
      children: [
        LabContainer(
          padding: const LabEdgeInsets.all(LabGapSize.s12),
          child: LabPoll(
            poll: poll,
            allVotes: allVotes,
            onOptionTap: onOptionTap,
            onVotesTap: onVotesTap,
            onProfileTap: onProfileTap,
            isUnread: isUnread,
            onLinkTap: onLinkTap,
            onResolveEvent: onResolveEvent,
            onResolveProfile: onResolveProfile,
            onResolveEmoji: onResolveEmoji,
            onResolveHashtag: onResolveHashtag,
          ),
        ),
        const LabDivider(),
      ],
    );
  }
}
