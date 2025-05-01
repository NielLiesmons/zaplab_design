import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppModelCard extends StatelessWidget {
  final Model? model;
  final NostrEventResolver? onResolveEvent;
  final NostrProfileResolver? onResolveProfile;
  final NostrEmojiResolver? onResolveEmoji;
  final NostrHashtagResolver? onResolveHashtag;
  final VoidCallback? onTap;

  const AppModelCard({
    super.key,
    required this.model,
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

    if (model == null || getModelContentType(model) == 'nostr') {
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

    if (model is Article) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: AppArticleCard(
          article: model as Article,
          onTap: onTap,
        ),
      );
    }

    if (model is ChatMessage) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: AppQuotedMessage(
          chatMessage: model as ChatMessage,
          onResolveEvent: onResolveEvent ?? (_) => Future.value(null),
          onResolveProfile: onResolveProfile ?? (_) => Future.value(null),
          onResolveEmoji: onResolveEmoji ?? (_) => Future.value(null),
        ),
      );
    }

    if (model is Zap) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: AppZapCard(
          zap: model as Zap,
          onResolveEvent: onResolveEvent ?? (_) => Future.value(null),
          onResolveProfile: onResolveProfile ?? (_) => Future.value(null),
          onResolveEmoji: onResolveEmoji ?? (_) => Future.value(null),
          onTap: onTap,
        ),
      );
    }

    if (model is Note) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: AppThreadCard(
          thread: model as Note,
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
            AppProfilePic.s40(model!.author.value?.pictureUrl ?? ''),
            const AppGap.s12(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppEmojiContentType(
                        contentType: getModelContentType(model),
                        size: 16,
                      ),
                      const AppGap.s10(),
                      Expanded(
                        child: AppCompactTextRenderer(
                          content: getModelDisplayText(model),
                          onResolveEvent:
                              onResolveEvent ?? (_) => Future.value(null),
                          onResolveProfile:
                              onResolveProfile ?? (_) => Future.value(null),
                          onResolveEmoji:
                              onResolveEmoji ?? (_) => Future.value(null),
                        ),
                      ),
                    ],
                  ),
                  const AppGap.s2(),
                  AppText.reg12(
                    model!.author.value?.name ??
                        formatNpub(model!.author.value?.npub ?? ''),
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
