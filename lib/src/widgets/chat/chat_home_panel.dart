import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class AppChatHomePanel extends StatelessWidget {
  final String npub;
  final String profileName;
  final String profilePicUrl;
  final String lastMessage;
  final String? lastMessageProfileName;
  final DateTime lastMessageTimeStamp;
  final Map<String, int> contentCounts;
  final int? mainCount;
  final void Function(BuildContext context, String npub)? onNavigateToChat;
  final void Function(BuildContext context, String npub, String contentType)?
      onNavigateToContent;

  const AppChatHomePanel({
    super.key,
    required this.npub,
    required this.profileName,
    required this.profilePicUrl,
    required this.lastMessage,
    this.lastMessageProfileName,
    required this.lastMessageTimeStamp,
    this.contentCounts = const {},
    this.mainCount,
    this.onNavigateToChat,
    this.onNavigateToContent,
  });

  (String, double) _getCountDisplay(int count) {
    if (count > 99) return ('99+', 40);
    if (count > 9) return (count.toString(), 32);
    return (count.toString(), 24);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final (displayCount, containerWidth) = _getCountDisplay(mainCount!);

    return TapBuilder(
      onTap: onNavigateToChat == null
          ? null
          : () => onNavigateToChat!(
                context,
                npub,
              ),
      builder: (context, state, hasFocus) {
        return Column(children: [
          AppSwipeContainer(
            leftContent: AppIcon.s16(
              theme.icons.characters.plus,
              outlineColor: theme.colors.white66,
              outlineThickness: LineThicknessData.normal().medium,
            ),
            rightContent: AppIcon.s10(
              theme.icons.characters.chevronUp,
              outlineColor: theme.colors.white66,
              outlineThickness: LineThicknessData.normal().medium,
            ),
            onSwipeLeft: () {
              print('swiped left');
            },
            onSwipeRight: () {
              print('swiped right');
            },
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
                      profilePicUrl,
                      onTap: onNavigateToChat == null
                          ? null
                          : () => onNavigateToChat!(
                                context,
                                npub,
                              ),
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
                                    profileName,
                                    color: theme.colors.white,
                                  ),
                                ),
                                AppText.reg12(
                                  TimestampFormatter.format(
                                    lastMessageTimeStamp,
                                    format: TimestampFormat.relative,
                                  ),
                                  color: theme.colors.white33,
                                ),
                              ],
                            ),
                          ),
                          const AppGap.s8(),
                          AppContainer(
                            height: theme.sizes.s24,
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
                                        bounds.width - (containerWidth + 16),
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
                                                            lastMessageProfileName !=
                                                                    null
                                                                ? '$lastMessageProfileName:'
                                                                : '',
                                                            color: theme
                                                                .colors.white66,
                                                          ),
                                                          lastMessageProfileName !=
                                                                  null
                                                              ? const AppGap
                                                                  .s4()
                                                              : const SizedBox
                                                                  .shrink(),
                                                          Flexible(
                                                            child:
                                                                AppText.reg12(
                                                              lastMessage,
                                                              color: theme
                                                                  .colors
                                                                  .white66,
                                                              maxLines: 1,
                                                              textOverflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const AppGap.s8(),
                                                  ...contentCounts.entries
                                                      .where((entry) =>
                                                          entry.value > 0)
                                                      .map(
                                                        (entry) => AppContainer(
                                                          padding:
                                                              const AppEdgeInsets
                                                                  .only(
                                                            right:
                                                                AppGapSize.s8,
                                                          ),
                                                          child: AppContainer(
                                                            height:
                                                                theme.sizes.s24,
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
                                                                  .grey66,
                                                              borderRadius: theme
                                                                  .radius
                                                                  .asBorderRadius()
                                                                  .rad12,
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                AppEmojiImage(
                                                                  emojiUrl:
                                                                      'assets/emoji/${entry.key}.png',
                                                                  emojiName:
                                                                      entry.key,
                                                                  size: 16,
                                                                ),
                                                                const AppGap
                                                                    .s4(),
                                                                AppText.reg12(
                                                                  entry.value
                                                                      .toString(),
                                                                  color: theme
                                                                      .colors
                                                                      .white66,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
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
                                  child: AppContainer(
                                    height: theme.sizes.s24,
                                    width: containerWidth,
                                    padding: const AppEdgeInsets.symmetric(
                                      horizontal: AppGapSize.s8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: theme.colors.blurple,
                                      borderRadius: BorderRadius.circular(
                                        theme.sizes.s12,
                                      ),
                                    ),
                                    child: Center(
                                      child: AppText.reg12(
                                        displayCount,
                                        color: AppColorsData.dark().white,
                                      ),
                                    ),
                                  ),
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
