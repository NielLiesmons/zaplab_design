import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabModelCard extends StatelessWidget {
  final Model? model;
  final NostrEventResolver? onResolveEvent;
  final NostrProfileResolver? onResolveProfile;
  final NostrEmojiResolver? onResolveEmoji;
  final NostrHashtagResolver? onResolveHashtag;
  final Function(Model)? onTap;
  final Function(Profile) onProfileTap;

  const LabModelCard({
    super.key,
    required this.model,
    this.onTap,
    required this.onProfileTap,
    this.onResolveEvent,
    this.onResolveProfile,
    this.onResolveEmoji,
    this.onResolveHashtag,
  });

  final double minWidth = 280;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    if (model == null || getModelContentType(model) == 'nostr') {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: LabPanelButton(
          padding: const LabEdgeInsets.all(LabGapSize.none),
          child: LabSkeletonLoader(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 18,
              ),
              child: Row(
                children: [
                  const LabGap.s4(),
                  LabIcon.s24(
                    theme.icons.characters.nostr,
                    color: theme.colors.white33,
                  ),
                  const LabGap.s16(),
                  LabText.med14(
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
        child: LabArticleCard(
          article: model as Article,
          onTap: onTap,
          onProfileTap: onProfileTap,
        ),
      );
    }

    if (model is ChatMessage) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: LabQuotedMessage(
          chatMessage: model as ChatMessage,
          onResolveEvent: onResolveEvent!,
          onResolveProfile: onResolveProfile!,
          onResolveEmoji: onResolveEmoji!,
          onTap: onTap == null
              ? null
              : (message) {
                  print(
                      'LabModelCard: onTap called with message: ${message.id}');
                  onTap!(message);
                },
        ),
      );
    }

    if (model is Zap) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: LabZapCard(
          zap: model as Zap,
          onResolveEvent: onResolveEvent!,
          onResolveProfile: onResolveProfile!,
          onResolveEmoji: onResolveEmoji!,
          onTap: onTap,
          onProfileTap: onProfileTap,
        ),
      );
    }

    if (model is Note) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: LabThreadCard(
          thread: model as Note,
          onTap: onTap,
          onProfileTap: onProfileTap,
          onResolveEvent: onResolveEvent!,
          onResolveProfile: onResolveProfile!,
          onResolveEmoji: onResolveEmoji!,
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: LabPanelButton(
        padding: const LabEdgeInsets.symmetric(
          horizontal: LabGapSize.s12,
          vertical: LabGapSize.s10,
        ),
        onTap: onTap!(model!),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LabProfilePic.s40(model!.author.value,
                onTap: () => onProfileTap(model!.author.value as Profile)),
            const LabGap.s12(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      LabEmojiContentType(
                        contentType: getModelContentType(model),
                        size: 16,
                      ),
                      const LabGap.s10(),
                      Expanded(
                        child: LabCompactTextRenderer(
                          model: model!,
                          content: getModelDisplayText(model),
                          onResolveEvent: onResolveEvent!,
                          onResolveProfile: onResolveProfile!,
                          onResolveEmoji: onResolveEmoji!,
                        ),
                      ),
                    ],
                  ),
                  const LabGap.s2(),
                  LabText.reg12(
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
