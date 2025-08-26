import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class LabCommunityHomePanel extends StatelessWidget {
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

  const LabCommunityHomePanel({
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

  // Cache expensive shaders to avoid recreation on every build
  static final Map<String, Shader> _shaderCache = {};

  Shader _getCachedShader(
      String key, Rect bounds, List<Color> colors, List<double> stops) {
    final cacheKey =
        '${key}_${bounds.width}_${bounds.height}_${colors.length}_${stops.join('_')}';
    return _shaderCache.putIfAbsent(cacheKey, () {
      return LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: colors,
        stops: stops,
      ).createShader(bounds);
    });
  }

  (String, double) _getCountDisplay(int count) {
    if (count > 99) return ('99+', 40);
    if (count > 9) return (count.toString(), 32);
    return (count.toString(), 26);
  }

  @override
  Widget build(BuildContext context) {
    // Cache theme access to avoid multiple LabTheme.of(context) calls
    final theme = LabTheme.of(context);
    final colors = theme.colors;
    final icons = theme.icons;
    final radius = theme.radius;

    final (displayCount, containerWidth) = _getCountDisplay(mainCount!);

    return RepaintBoundary(
      child: TapBuilder(
        onTap: () => onNavigateToCommunity(community),
        builder: (context, state, hasFocus) {
          return Column(children: [
            LabContainer(
              padding: const LabEdgeInsets.symmetric(
                horizontal: LabGapSize.s12,
                vertical: LabGapSize.s12,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LabProfilePic.s48(
                        community.author.value,
                        onTap: () => onNavigateToCommunity(community),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabContainer(
                              height: 20,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const LabGap.s12(),
                                  Expanded(
                                    child: LabText.bold14(
                                      community.author.value?.name ??
                                          formatNpub(
                                              community.author.value?.pubkey ??
                                                  ''),
                                      color: colors.white,
                                    ),
                                  ),
                                  LabText.reg12(
                                    lastModel != null
                                        ? TimestampFormatter.format(
                                            lastModel!.createdAt,
                                            format: TimestampFormat.relative,
                                          )
                                        : ' ',
                                    color: colors.white33,
                                  ),
                                  const LabGap.s8(),
                                  if (isPinned)
                                    LabIcon.s12(
                                      icons.characters.pin,
                                      outlineColor: colors.white33,
                                      outlineThickness:
                                          LabLineThicknessData.normal().medium,
                                    ),
                                ],
                              ),
                            ),
                            const LabGap.s6(),
                            LabContainer(
                              height: 26,
                              child: Stack(
                                children: [
                                  ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return _getCachedShader(
                                        'fade_right',
                                        Rect.fromLTWH(
                                          bounds.width -
                                              ((mainCount ?? 0) > 0
                                                  ? (containerWidth + 16)
                                                  : (containerWidth - 16)),
                                          0,
                                          (containerWidth + 16),
                                          bounds.height,
                                        ),
                                        [
                                          colors.black.withValues(alpha: 1),
                                          colors.black.withValues(alpha: 0),
                                          colors.black.withValues(alpha: 0),
                                        ],
                                        const [0.0, 0.6, 1.0],
                                      );
                                    },
                                    blendMode: BlendMode.dstIn,
                                    child: ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return _getCachedShader(
                                          'fade_left',
                                          Rect.fromLTWH(
                                              0, 0, 12, bounds.height),
                                          [
                                            colors.black.withValues(alpha: 0),
                                            colors.black.withValues(alpha: 1),
                                          ],
                                          const [0.0, 1.0],
                                        );
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const LabGap.s12(),
                                                    Expanded(
                                                      child: ConstrainedBox(
                                                        constraints:
                                                            const BoxConstraints(
                                                                maxWidth: 104),
                                                        child: Row(
                                                          children: [
                                                            LabText.bold12(
                                                              lastModel
                                                                      ?.author
                                                                      .value
                                                                      ?.name ??
                                                                  formatNpub(lastModel
                                                                          ?.author
                                                                          .value
                                                                          ?.npub ??
                                                                      ''),
                                                              color: colors
                                                                  .white66,
                                                            ),
                                                            const LabGap.s8(),
                                                            if (lastModel !=
                                                                null)
                                                              Flexible(
                                                                child:
                                                                    LabCompactTextRenderer(
                                                                  model:
                                                                      lastModel!,
                                                                  content: lastModel
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
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const LabGap.s8(),
                                                    if (contentCounts
                                                        .isNotEmpty)
                                                      Row(
                                                        children:
                                                            contentCounts
                                                                .entries
                                                                .map(
                                                                  (entry) =>
                                                                      LabContainer(
                                                                    height: 26,
                                                                    padding:
                                                                        const LabEdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          LabGapSize
                                                                              .s8,
                                                                    ),
                                                                    margin:
                                                                        const LabEdgeInsets
                                                                            .only(
                                                                      right:
                                                                          LabGapSize
                                                                              .s4,
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: colors
                                                                          .gray66,
                                                                      borderRadius: radius
                                                                          .asBorderRadius()
                                                                          .rad16,
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        LabEmojiContentType(
                                                                          contentType:
                                                                              entry.key,
                                                                          size:
                                                                              16,
                                                                        ),
                                                                        const LabGap
                                                                            .s6(),
                                                                        LabText
                                                                            .reg12(
                                                                          entry
                                                                              .value
                                                                              .toString(),
                                                                          color:
                                                                              colors.white66,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                                .toList(),
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
                                            builder:
                                                (context, state, hasFocus) {
                                              return LabContainer(
                                                height: 26,
                                                width: containerWidth,
                                                padding: const LabEdgeInsets
                                                    .symmetric(
                                                  horizontal: LabGapSize.s8,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient: colors.blurple,
                                                  borderRadius: radius
                                                      .asBorderRadius()
                                                      .rad16,
                                                ),
                                                child: Center(
                                                  child: LabText.med12(
                                                    displayCount,
                                                    color: colors.whiteEnforced,
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
            const LabDivider(),
          ]);
        },
      ),
    );
  }
}
