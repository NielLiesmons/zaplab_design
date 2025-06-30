import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';

class LabFeedMail extends StatelessWidget {
  final Mail mail;
  final Function(Model) onTap;
  final Function(Profile) onProfileTap;
  final bool isUnread;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final Function(Model) onSwipeLeft;
  final Function(Model) onSwipeRight;

  const LabFeedMail({
    super.key,
    required this.mail,
    required this.onTap,
    required this.onProfileTap,
    this.isUnread = false,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabSwipeContainer(
      onTap: () => onTap(mail),
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
      child: Column(
        children: [
          LabContainer(
            padding: const LabEdgeInsets.only(
              top: LabGapSize.s8,
              bottom: LabGapSize.s12,
              left: LabGapSize.s12,
              right: LabGapSize.s12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    LabContainer(
                      margin: const LabEdgeInsets.only(
                        top: LabGapSize.s4,
                      ),
                      child: LabProfilePic.s38(mail.author.value,
                          onTap: () =>
                              onProfileTap(mail.author.value as Profile)),
                    ),
                  ],
                ),
                const LabGap.s12(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: LabContainer(
                              padding: const LabEdgeInsets.only(
                                top: LabGapSize.s2,
                              ),
                              child: isUnread
                                  ? LabText.bold12(
                                      mail.author.value?.name ??
                                          formatNpub(
                                              mail.author.value?.pubkey ?? ''),
                                    )
                                  : LabText.med12(
                                      mail.author.value?.name ??
                                          formatNpub(
                                              mail.author.value?.pubkey ?? ''),
                                      color: theme.colors.white66,
                                    ),
                            ),
                          ),
                          LabContainer(
                            child: LabText.reg12(
                              TimestampFormatter.format(mail.createdAt,
                                  format: TimestampFormat.relative),
                              color: theme.colors.white33,
                            ),
                          ),
                          const LabGap.s12(),
                          if (isUnread)
                            LabContainer(
                              height: theme.sizes.s8,
                              width: theme.sizes.s8,
                              decoration: BoxDecoration(
                                gradient: theme.colors.blurple,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                        ],
                      ),
                      const LabGap.s2(),
                      isUnread
                          ? LabText.reg14(
                              mail.title ?? 'No Title',
                              color: theme.colors.white,
                              textOverflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                          : LabText.reg14(
                              mail.title ?? 'No Title',
                              color: theme.colors.white,
                              textOverflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                      const LabGap.s2(),
                      LabCompactTextRenderer(
                        model: mail,
                        content: mail.content,
                        onResolveEvent: onResolveEvent,
                        onResolveProfile: onResolveProfile,
                        onResolveEmoji: onResolveEmoji,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const LabDivider(),
        ],
      ),
    );
  }
}
