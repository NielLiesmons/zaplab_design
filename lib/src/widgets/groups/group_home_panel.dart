import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';
import 'dart:ui';

class LabGroupHomePanel extends StatelessWidget {
  final Group group;
  final Model? lastModel;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final Map<String, int> contentCounts;
  final int? mainCount;
  final Function(Group) onNavigateToGroup;
  final Function(Group, String contentType)? onNavigateToContent;
  final Function(Group)? onNavigateToNotifications;
  final Function(Group)? onCreateNewPublication;
  final Function(Group)? onActions;

  const LabGroupHomePanel({
    super.key,
    required this.group,
    this.lastModel,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    this.contentCounts = const {},
    this.mainCount,
    required this.onNavigateToGroup,
    this.onNavigateToContent,
    this.onNavigateToNotifications,
    this.onCreateNewPublication,
    this.onActions,
  });

  (String, double) _getCountDisplay(int count) {
    if (count > 99) return ('99+', 40);
    if (count > 9) return (count.toString(), 32);
    return (count.toString(), 26);
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    final (displayCount, containerWidth) = _getCountDisplay(mainCount!);

    return TapBuilder(
      onTap: () => onNavigateToGroup(group),
      builder: (context, state, hasFocus) {
        return Column(children: [
          LabSwipeContainer(
            leftContent: LabIcon.s16(
              theme.icons.characters.plus,
              outlineColor: theme.colors.white66,
              outlineThickness: LabLineThicknessData.normal().medium,
            ),
            rightContent: LabIcon.s10(
              theme.icons.characters.chevronUp,
              outlineColor: theme.colors.white66,
              outlineThickness: LabLineThicknessData.normal().medium,
            ),
            onSwipeLeft: () => onCreateNewPublication!(group),
            onSwipeRight: () => onActions!(group),
            padding: const LabEdgeInsets.symmetric(
              horizontal: LabGapSize.s12,
              vertical: LabGapSize.s12,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        LabProfilePic.s48(
                          group.author.value,
                          onTap: () => onNavigateToGroup(group),
                        ),
                        Positioned(
                          right: -4,
                          bottom: -4,
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                              child: LabContainer(
                                width: theme.sizes.s20,
                                height: theme.sizes.s20,
                                decoration: BoxDecoration(
                                  gradient: theme.colors.graydient16,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: LabIcon.s12(
                                    theme.icons.characters.star,
                                    gradient: theme.colors.gold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                                    group.author.value?.name ??
                                        formatNpub(
                                            group.author.value?.pubkey ?? ''),
                                    color: theme.colors.white,
                                  ),
                                ),
                                LabText.reg12(
                                  lastModel != null
                                      ? TimestampFormatter.format(
                                          lastModel!.createdAt,
                                          format: TimestampFormat.relative,
                                        )
                                      : ' ',
                                  color: theme.colors.white33,
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
                                                            color: theme
                                                                .colors.white66,
                                                          ),
                                                          const LabGap.s4(),
                                                          Flexible(
                                                            child:
                                                                LabCompactTextRenderer(
                                                              model: lastModel!,
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
                                                  const LabGap.s8(),
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
                                                                        group,
                                                                        entry
                                                                            .key),
                                                                builder: (context,
                                                                    state,
                                                                    hasFocus) {
                                                                  return LabContainer(
                                                                    padding: (entry == visibleEntries.last &&
                                                                            (mainCount ?? 0) ==
                                                                                0)
                                                                        ? null
                                                                        : const LabEdgeInsets
                                                                            .only(
                                                                            right:
                                                                                LabGapSize.s8,
                                                                          ),
                                                                    child:
                                                                        LabContainer(
                                                                      height: theme
                                                                          .sizes
                                                                          .s56,
                                                                      padding:
                                                                          const LabEdgeInsets
                                                                              .symmetric(
                                                                        horizontal:
                                                                            LabGapSize.s8,
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
                                              onNavigateToNotifications!(group),
                                          builder: (context, state, hasFocus) {
                                            return LabContainer(
                                              height: 26,
                                              width: containerWidth,
                                              padding:
                                                  const LabEdgeInsets.symmetric(
                                                horizontal: LabGapSize.s8,
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: theme.colors.blurple,
                                                borderRadius: theme.radius
                                                    .asBorderRadius()
                                                    .rad16,
                                              ),
                                              child: Center(
                                                child: LabText.med12(
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
          const LabDivider(),
        ]);
      },
    );
  }
}
