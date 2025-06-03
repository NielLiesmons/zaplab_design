import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';

class AppFeedMail extends StatelessWidget {
  final Mail mail;
  final Function(Model) onTap;
  final Function(Profile) onProfileTap;
  final bool isUnread;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final Function(Model) onSwipeLeft;
  final Function(Model) onSwipeRight;

  const AppFeedMail({
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
    final theme = AppTheme.of(context);

    return AppSwipeContainer(
      onTap: () => onTap(mail),
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
      child: Column(
        children: [
          AppContainer(
            padding: const AppEdgeInsets.only(
              top: AppGapSize.s8,
              bottom: AppGapSize.s12,
              left: AppGapSize.s12,
              right: AppGapSize.s12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppContainer(
                      margin: const AppEdgeInsets.only(
                        top: AppGapSize.s4,
                      ),
                      child: AppProfilePic.s38(mail.author.value,
                          onTap: () =>
                              onProfileTap(mail.author.value as Profile)),
                    ),
                  ],
                ),
                const AppGap.s12(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AppContainer(
                              padding: const AppEdgeInsets.only(
                                top: AppGapSize.s2,
                              ),
                              child: isUnread
                                  ? AppText.bold12(
                                      mail.author.value?.name ??
                                          formatNpub(
                                              mail.author.value?.pubkey ?? ''),
                                    )
                                  : AppText.med12(
                                      mail.author.value?.name ??
                                          formatNpub(
                                              mail.author.value?.pubkey ?? ''),
                                      color: theme.colors.white66,
                                    ),
                            ),
                          ),
                          AppContainer(
                            child: AppText.reg12(
                              TimestampFormatter.format(mail.createdAt,
                                  format: TimestampFormat.relative),
                              color: theme.colors.white33,
                            ),
                          ),
                          const AppGap.s12(),
                          if (isUnread)
                            AppContainer(
                              height: theme.sizes.s8,
                              width: theme.sizes.s8,
                              decoration: BoxDecoration(
                                gradient: theme.colors.blurple,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                        ],
                      ),
                      const AppGap.s2(),
                      isUnread
                          ? AppText.reg14(
                              mail.title ?? 'No Title',
                              color: theme.colors.white,
                              textOverflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                          : AppText.reg14(
                              mail.title ?? 'No Title',
                              color: theme.colors.white,
                              textOverflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                      const AppGap.s2(),
                      AppCompactTextRenderer(
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
          const AppDivider(),
        ],
      ),
    );
  }
}
