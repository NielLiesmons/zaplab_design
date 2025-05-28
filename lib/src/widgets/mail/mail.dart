import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppMail extends StatelessWidget {
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

  const AppMail({
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
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppSwipePanel(
      leftContent: AppIcon.s16(
        theme.icons.characters.reply,
        outlineColor: theme.colors.white66,
        outlineThickness: AppLineThicknessData.normal().medium,
      ),
      rightContent: AppIcon.s10(
        theme.icons.characters.chevronUp,
        outlineColor: theme.colors.white66,
        outlineThickness: AppLineThicknessData.normal().medium,
      ),
      onSwipeLeft: () => onSwipeLeft(mail),
      onSwipeRight: () => onSwipeRight(mail),
      padding: const AppEdgeInsets.all(AppGapSize.s12),
      color: theme.colors.gray33,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppProfilePic.s48(mail.author.value),
              const AppGap.s12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText.bold14(mail.author.value?.name ??
                            formatNpub(mail.author.value?.pubkey ?? '')),
                        AppText.reg12(
                          TimestampFormatter.format(mail.createdAt,
                              format: TimestampFormat.relative),
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const AppGap.s6(),
                    Row(
                      children: [
                        AppText.reg12(
                          'To:',
                          color: theme.colors.white66,
                        ),
                        const AppGap.s6(),
                        AppSmallProfileStack(
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
          const AppGap.s8(),
          AppContainer(
            padding: const AppEdgeInsets.symmetric(
              vertical: AppGapSize.none,
              horizontal: AppGapSize.s4,
            ),
            child: AppShortTextRenderer(
              content: mail.content,
              onResolveEvent: onResolveEvent,
              onResolveProfile: onResolveProfile,
              onResolveEmoji: onResolveEmoji,
              onResolveHashtag: onResolveHashtag,
              onLinkTap: onLinkTap,
            ),
          ),
        ],
      ),
    );
  }
}
