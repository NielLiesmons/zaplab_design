import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabThreadCard extends StatelessWidget {
  final Note thread;
  final Function(Note)? onTap;
  final Function(Profile) onProfileTap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;

  const LabThreadCard({
    super.key,
    required this.thread,
    this.onTap,
    required this.onProfileTap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabPanelButton(
      padding: const LabEdgeInsets.only(
          top: LabGapSize.s10,
          bottom: LabGapSize.s8,
          left: LabGapSize.s12,
          right: LabGapSize.s12),
      onTap: onTap == null ? null : () => onTap!(thread),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabContainer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LabProfilePic.s18(thread.author.value,
                    onTap: () => onProfileTap(thread.author.value as Profile)),
                const LabGap.s8(),
                Expanded(
                  child: LabText.bold12(
                    thread.author.value?.name ??
                        formatNpub(thread.author.value?.pubkey ?? ''),
                  ),
                ),
                LabText.reg12(
                  TimestampFormatter.format(thread.createdAt,
                      format: TimestampFormat.relative),
                  color: theme.colors.white33,
                ),
              ],
            ),
          ),
          const LabGap.s6(),
          LabContainer(
            child: LabCompactTextRenderer(
              model: thread,
              content: thread.content,
              onResolveEvent: onResolveEvent,
              onResolveProfile: onResolveProfile,
              onResolveEmoji: onResolveEmoji,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
