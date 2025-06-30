import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabZapCard extends StatelessWidget {
  final Zap? zap;
  final CashuZap? cashuZap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final Function(Model)? onTap;
  final Function(Profile) onProfileTap;

  const LabZapCard({
    super.key,
    this.zap,
    this.cashuZap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    this.onTap,
    required this.onProfileTap,
  }) : assert(zap != null || cashuZap != null,
            'Either zap or cashuZap must be provided');

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final isCashuZap = cashuZap != null;
    final model = isCashuZap ? cashuZap! : zap!;

    return LabPanelButton(
      padding: const LabEdgeInsets.all(LabGapSize.none),
      gradient: theme.colors.graydient16,
      radius: theme.radius.asBorderRadius().rad12,
      onTap: onTap != null ? () => onTap!(model as Model) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabContainer(
            padding: const LabEdgeInsets.symmetric(
              horizontal: LabGapSize.s12,
            ),
            height: theme.sizes.s38,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LabProfilePic.s18(
                    isCashuZap ? cashuZap!.author.value : zap!.author.value,
                    onTap: () => onProfileTap(isCashuZap
                        ? cashuZap!.author.value as Profile
                        : zap!.author.value as Profile)),
                const LabGap.s10(),
                Expanded(
                  child: LabText.bold14(
                    isCashuZap
                        ? cashuZap!.author.value?.name ??
                            formatNpub(cashuZap!.author.value?.pubkey ?? '')
                        : zap!.author.value?.name ??
                            formatNpub(zap!.author.value?.pubkey ?? ''),
                  ),
                ),
                Row(
                  children: [
                    LabIcon.s12(
                      theme.icons.characters.zap,
                      gradient: theme.colors.gold,
                    ),
                    const LabGap.s4(),
                    LabAmount(
                      isCashuZap
                          ? cashuZap!.amount.toDouble()
                          : zap!.amount.toDouble(),
                      level: LabTextLevel.bold14,
                      color: theme.colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if ((isCashuZap ? cashuZap!.content : zap!.event.content)
              .isNotEmpty) ...[
            const LabDivider.horizontal(),
            LabContainer(
              padding: const LabEdgeInsets.symmetric(
                horizontal: LabGapSize.s12,
                vertical: LabGapSize.s8,
              ),
              child: LabCompactTextRenderer(
                model: zap!,
                content: isCashuZap ? cashuZap!.content : zap!.event.content,
                onResolveEvent: onResolveEvent,
                onResolveProfile: onResolveProfile,
                onResolveEmoji: onResolveEmoji,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
