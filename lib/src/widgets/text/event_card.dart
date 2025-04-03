import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppEventCard extends StatelessWidget {
  final Event? event;
  final NostrEventResolver? onResolveEvent;
  final NostrProfileResolver? onResolveProfile;
  final NostrEmojiResolver? onResolveEmoji;
  final NostrHashtagResolver? onResolveHashtag;
  final VoidCallback? onTap;

  const AppEventCard({
    super.key,
    required this.event,
    this.onTap,
    this.onResolveEvent,
    this.onResolveProfile,
    this.onResolveEmoji,
    this.onResolveHashtag,
  });

  final double minWidth = 280;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    if (event == null) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: AppPanelButton(
          padding: const AppEdgeInsets.all(AppGapSize.none),
          child: AppSkeletonLoader(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 18,
              ),
              child: Row(
                children: [
                  const AppGap.s4(),
                  AppIcon.s24(
                    theme.icons.characters.nostr,
                    color: theme.colors.white33,
                  ),
                  const AppGap.s16(),
                  AppText.med14(
                    'Nostr Publication',
                    color: theme.colors.white33,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (event is Article) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: AppArticleCard(
          article: event as Article,
          onTap: onTap,
        ),
      );
    }

    if (event is ChatMessage) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: AppQuotedMessage(
          chatMessage: event as ChatMessage,
          onResolveEvent: onResolveEvent ?? (_) => Future.value(null),
          onResolveProfile: onResolveProfile ?? (_) => Future.value(null),
          onResolveEmoji: onResolveEmoji ?? (_) => Future.value(null),
        ),
      );
    }

    if (event is Zap) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: AppZapCard(
          zap: event as CashuZap,
          onResolveEvent: onResolveEvent ?? (_) => Future.value(null),
          onResolveProfile: onResolveProfile ?? (_) => Future.value(null),
          onResolveEmoji: onResolveEmoji ?? (_) => Future.value(null),
          onTap: onTap,
        ),
      );
    }

    if (event is Note) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: AppPostCard(
          post: event as Note,
          onTap: onTap,
          onResolveEvent: onResolveEvent ?? (_) => Future.value(null),
          onResolveProfile: onResolveProfile ?? (_) => Future.value(null),
          onResolveEmoji: onResolveEmoji ?? (_) => Future.value(null),
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: AppPanelButton(
        padding: const AppEdgeInsets.symmetric(
          horizontal: AppGapSize.s12,
          vertical: AppGapSize.s10,
        ),
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppProfilePic.s40(event!.author.value?.pictureUrl ?? ''),
            const AppGap.s12(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TODO: Add abilty to detct content type to then display the correct icon and title / content
                  // Row(
                  //   children: [
                  //     AppEmojiImage(
                  //       emojiUrl: 'assets/emoji/$contentType.png',
                  //       emojiName: contentType,
                  //       size: 16,
                  //     ),
                  //     const AppGap.s10(),
                  //     Expanded(
                  //       child: AppText.reg14(
                  //         event.title,
                  //         maxLines: 1,
                  //         textOverflow: TextOverflow.ellipsis,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const AppGap.s2(),
                  AppText.reg12(
                    event!.author.value?.name ?? '',
                    color: theme.colors.white66,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
