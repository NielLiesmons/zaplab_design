import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppZapCard extends StatelessWidget {
  final CashuZap zap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final VoidCallback? onTap;

  const AppZapCard({
    super.key,
    required this.zap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppPanelButton(
      padding: const AppEdgeInsets.all(AppGapSize.none),
      onTap: onTap,
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
                AppProfilePic.s18(zap.author.value?.pictureUrl ?? ''),
                const AppGap.s10(),
                Expanded(
                  child: AppText.bold14(
                    zap.author.value?.name ??
                        formatNpub(zap.author.value?.pubkey ?? ''),
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
                      zap.amount.toDouble(),
                      level: AppTextLevel.bold14,
                      color: theme.colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (zap.content.isNotEmpty) ...[
            const AppDivider.horizontal(),
            AppContainer(
              padding: const AppEdgeInsets.symmetric(
                horizontal: AppGapSize.s12,
                vertical: AppGapSize.s8,
              ),
              child: AppCompactTextRenderer(
                content: zap.content,
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
