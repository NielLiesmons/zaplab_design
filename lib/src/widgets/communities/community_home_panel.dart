import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class AppCommunityHomePanel extends StatelessWidget {
  final Community community;
  final Model? lastModel;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final Map<String, int> contentCounts;
  final int? mainCount;
  final Function(Community) onNavigateToCommunity;
  final Function(Community, String contentType)? onNavigateToContent;
  final Function(Community)? onNavigateToNotifications;
  final Function(Community)? onCreateNewPublication;
  final Function(Community)? onActions;
  final bool isPinned;
  const AppCommunityHomePanel({
    super.key,
    required this.community,
    this.lastModel,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    this.contentCounts = const {},
    this.mainCount,
    required this.onNavigateToCommunity,
    this.onNavigateToContent,
    this.onNavigateToNotifications,
    this.onCreateNewPublication,
    this.onActions,
    this.isPinned = false,
  });

  (String, double) _getCountDisplay(int count) {
    if (count > 99) return ('99+', 40);
    if (count > 9) return (count.toString(), 32);
    return (count.toString(), 26);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final (displayCount, containerWidth) = _getCountDisplay(mainCount!);

    return TapBuilder(
      onTap: () => onNavigateToCommunity(community),
      builder: (context, state, hasFocus) {
        return Column(children: [
          AppSwipeContainer(
            leftContent: AppIcon.s16(
              theme.icons.characters.plus,
              outlineColor: theme.colors.white66,
              outlineThickness: AppLineThicknessData.normal().medium,
            ),
            rightContent: AppIcon.s10(
              theme.icons.characters.chevronUp,
              outlineColor: theme.colors.white66,
              outlineThickness: AppLineThicknessData.normal().medium,
            ),
            onSwipeLeft: () => onCreateNewPublication!(community),
            onSwipeRight: () => onActions!(community),
            padding: const AppEdgeInsets.symmetric(
              horizontal: AppGapSize.s12,
              vertical: AppGapSize.s12,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppProfilePic.s48(
                      community.author.value?.pictureUrl ?? '',
                      onTap: () => onNavigateToCommunity(community),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppContainer(
                            height: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const AppGap.s12(),
                                Expanded(
                                  child: AppText.bold14(
                                    community.author.value?.name ??
                                        formatNpub(
                                            community.author.value?.pubkey ??
                                                ''),
                                    color: theme.colors.white,
                                  ),
                                ),
                                AppText.reg12(
                                  lastModel != null
                                      ? TimestampFormatter.format(
                                          lastModel!.createdAt,
                                          format: TimestampFormat.relative,
                                        )
                                      : ' ',
                                  color: theme.colors.white33,
                                ),
                                const AppGap.s8(),
                                if (isPinned)
                                  AppIcon.s12(
                                    theme.icons.characters.pin,
                                    outlineColor: theme.colors.white33,
                                    outlineThickness:
                                        AppLineThicknessData.normal().medium,
                                  ),
                              ],
                            ),
                          ),
                          const AppGap.s6(),
                          AppContainer(
                            height: 26,
                            child: Stack(
                              children: [
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        theme.colors.black.withValues(alpha: 1),
                                        theme.colors.black.withValues(alpha: 0),
                                        theme.colors.black.withValues(alpha: 0),
                                      ],
                                      stops: const [0.0, 0.6, 1.0],
                                    ).createShader(Rect.fromLTWH(
                                        bounds.width -
                                            ((mainCount ?? 0) > 0
                                                ? (containerWidth + 16)
                                                : (containerWidth - 16)),
                                        0,
                                        (containerWidth + 16),
                                        bounds.height));
                                  },
                                  blendMode: BlendMode.dstIn,
                                  child: ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          theme.colors.black
                                              .withValues(alpha: 0),
                                          theme.colors.black
                                              .withValues(alpha: 1),
                                        ],
                                        stops: const [0.0, 1.0],
                                      ).createShader(Rect.fromLTWH(
                                          0, 0, 12, bounds.height));
                                    },
                                    blendMode: BlendMode.dstIn,
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final availableWidth =
                                            constraints.maxWidth;

                                        return SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: IntrinsicWidth(
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  minWidth: availableWidth),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const AppGap.s12(),
                                                  Expanded(
                                                    child: ConstrainedBox(
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxWidth: 104),
                                                      child: Row(
                                                        children: [
                                                          AppText.bold12(
                                                            lastModel
                                                                    ?.author
                                                                    .value
                                                                    ?.name ??
                                                                formatNpub(lastModel
                                                                        ?.author
                                                                        .value
                                                                        ?.npub ??
                                                                    ''),
                                                            color: theme
                                                                .colors.white66,
                                                          ),
                                                          const AppGap.s4(),
                                                          Flexible(
                                                            child:
                                                                AppCompactTextRenderer(
                                                              content: lastModel ==
                                                                      null
                                                                  ? ''
                                                                  : lastModel
                                                                          is ChatMessage
                                                                      ? (lastModel
                                                                              as ChatMessage)
                                                                          .content
                                                                      : 'nostr:nevent1${lastModel!.id}',
                                                              onResolveEvent:
                                                                  onResolveEvent,
                                                              onResolveProfile:
                                                                  onResolveProfile,
                                                              onResolveEmoji:
                                                                  onResolveEmoji,
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const AppGap.s8(),
                                                  Builder(
                                                    builder: (context) {
                                                      final visibleEntries =
                                                          contentCounts.entries
                                                              .where((entry) =>
                                                                  entry.value >
                                                                  0)
                                                              .toList();
                                                      return Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: visibleEntries
                                                            .map(
                                                              (entry) =>
                                                                  TapBuilder(
                                                                onTap: () =>
                                                                    onNavigateToContent?.call(
                                                                        community,
                                                                        entry
                                                                            .key),
                                                                builder: (context,
                                                                    state,
                                                                    hasFocus) {
                                                                  return AppContainer(
                                                                    padding: (entry == visibleEntries.last &&
                                                                            (mainCount ?? 0) ==
                                                                                0)
                                                                        ? null
                                                                        : const AppEdgeInsets
                                                                            .only(
                                                                            right:
                                                                                AppGapSize.s8,
                                                                          ),
                                                                    child:
                                                                        AppContainer(
                                                                      height: theme
                                                                          .sizes
                                                                          .s56,
                                                                      padding:
                                                                          const AppEdgeInsets
                                                                              .symmetric(
                                                                        horizontal:
                                                                            AppGapSize.s8,
                                                                      ),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: theme
                                                                            .colors
                                                                            .gray66,
                                                                        borderRadius: theme
                                                                            .radius
                                                                            .asBorderRadius()
                                                                            .rad16,
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          AppEmojiContentType(
                                                                            contentType:
                                                                                entry.key,
                                                                            size:
                                                                                16,
                                                                          ),
                                                                          const AppGap
                                                                              .s6(),
                                                                          AppText
                                                                              .reg12(
                                                                            entry.value.toString(),
                                                                            color:
                                                                                theme.colors.white66,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                            .toList(),
                                                      );
                                                    },
                                                  ),
                                                  if (mainCount != 0)
                                                    SizedBox(
                                                      width: containerWidth,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: (mainCount ?? 0) > 0
                                      ? TapBuilder(
                                          onTap: () =>
                                              onNavigateToNotifications!(
                                                  community),
                                          builder: (context, state, hasFocus) {
                                            return AppContainer(
                                              height: 26,
                                              width: containerWidth,
                                              padding:
                                                  const AppEdgeInsets.symmetric(
                                                horizontal: AppGapSize.s8,
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: theme.colors.blurple,
                                                borderRadius: theme.radius
                                                    .asBorderRadius()
                                                    .rad16,
                                              ),
                                              child: Center(
                                                child: AppText.med12(
                                                  displayCount,
                                                  color: theme
                                                      .colors.whiteEnforced,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const AppDivider(),
        ]);
      },
    );
  }
}
