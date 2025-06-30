import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabMail extends StatelessWidget {
  final Mail mail;
  // TODO: Implement reactions, zaps, and communities once HasMany is available
  // final List<ReplaceReaction> reactions;
  // final List<ReplaceZap> zaps;
  final List<Profile> recipients;
  final Profile? activeProfile;
  final Function(Mail) onSwipeLeft;
  final Function(Mail) onSwipeRight;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final Function(Profile) onProfileTap;

  const LabMail({
    super.key,
    required this.mail,
    required this.recipients,
    required this.activeProfile,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabSwipePanel(
      leftContent: LabIcon.s16(
        theme.icons.characters.reply,
        outlineColor: theme.colors.white66,
        outlineThickness: LabLineThicknessData.normal().medium,
      ),
      rightContent: LabIcon.s10(
        theme.icons.characters.chevronUp,
        outlineColor: theme.colors.white66,
        outlineThickness: LabLineThicknessData.normal().medium,
      ),
      onSwipeLeft: () => onSwipeLeft(mail),
      onSwipeRight: () => onSwipeRight(mail),
      padding: const LabEdgeInsets.all(LabGapSize.s12),
      color: theme.colors.gray33,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabProfilePic.s48(mail.author.value),
              const LabGap.s12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LabText.bold14(mail.author.value?.name ??
                            formatNpub(mail.author.value?.pubkey ?? '')),
                        LabText.reg12(
                          TimestampFormatter.format(mail.createdAt,
                              format: TimestampFormat.relative),
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const LabGap.s6(),
                    Row(
                      children: [
                        LabText.reg12(
                          'To:',
                          color: theme.colors.white66,
                        ),
                        const LabGap.s6(),
                        LabSmallProfileStack(
                          profiles: recipients,
                          activeProfile: activeProfile,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const LabGap.s8(),
          LabContainer(
            padding: const LabEdgeInsets.symmetric(
              vertical: LabGapSize.none,
              horizontal: LabGapSize.s4,
            ),
            child: LabLongTextRenderer(
              model: mail,
              content: mail.content,
              serif: false,
              onResolveEvent: onResolveEvent,
              onResolveProfile: onResolveProfile,
              onResolveEmoji: onResolveEmoji,
              onResolveHashtag: onResolveHashtag,
              onLinkTap: onLinkTap,
              onProfileTap: onProfileTap,
            ),
          ),
        ],
      ),
    );
  }
}
