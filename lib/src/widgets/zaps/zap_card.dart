import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppZapCard extends StatelessWidget {
  final Zap? zap;
  final CashuZap? cashuZap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final Function(Model)? onTap;

  const AppZapCard({
    super.key,
    this.zap,
    this.cashuZap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    this.onTap,
  }) : assert(zap != null || cashuZap != null,
            'Either zap or cashuZap must be provided');

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isCashuZap = cashuZap != null;
    final model = isCashuZap ? cashuZap! : zap!;

    return AppPanelButton(
      padding: const AppEdgeInsets.all(AppGapSize.none),
      gradient: theme.colors.graydient16,
      radius: theme.radius.asBorderRadius().rad12,
      onTap: onTap != null ? () => onTap!(model as Model) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppContainer(
            padding: const AppEdgeInsets.symmetric(
              horizontal: AppGapSize.s12,
            ),
            height: theme.sizes.s38,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppProfilePic.s18(
                    isCashuZap ? cashuZap!.author.value : zap!.author.value),
                const AppGap.s10(),
                Expanded(
                  child: AppText.bold14(
                    isCashuZap
                        ? cashuZap!.author.value?.name ??
                            formatNpub(cashuZap!.author.value?.pubkey ?? '')
                        : zap!.author.value?.name ??
                            formatNpub(zap!.author.value?.pubkey ?? ''),
                  ),
                ),
                Row(
                  children: [
                    AppIcon.s12(
                      theme.icons.characters.zap,
                      gradient: theme.colors.gold,
                    ),
                    const AppGap.s4(),
                    AppAmount(
                      isCashuZap
                          ? cashuZap!.amount.toDouble()
                          : zap!.amount.toDouble(),
                      level: AppTextLevel.bold14,
                      color: theme.colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if ((isCashuZap ? cashuZap!.content : zap!.event.content)
              .isNotEmpty) ...[
            const AppDivider.horizontal(),
            AppContainer(
              padding: const AppEdgeInsets.symmetric(
                horizontal: AppGapSize.s12,
                vertical: AppGapSize.s8,
              ),
              child: AppCompactTextRenderer(
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
