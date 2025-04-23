import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'dart:ui';
import 'package:models/models.dart';

class AppActionsModal extends StatelessWidget {
  // Model
  final Model model;
  final Function(Model) onModelTap;
  // Reply
  final Function(Model) onReplyTap;
  // Emoji
  final List<Emoji> recentEmoji;
  final Function(Emoji) onEmojiTap;
  final VoidCallback onMoreEmojiTap;
  // Zaps
  final List<double> recentAmounts;
  final Function(double) onZapTap;
  final Function(Model) onMoreZapsTap;
  // Other actions
  final Function(Model) onReportTap;
  final Function(Model) onAddProfileTap;
  final Function(Model) onOpenWithTap;
  final Function(Model) onLabelTap;
  final Function(Model) onShareTap;
  // Compact text rendering
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;

  const AppActionsModal({
    super.key,
    required this.model,
    required this.onModelTap,
    required this.onReplyTap,
    required this.recentEmoji,
    required this.onEmojiTap,
    required this.onMoreEmojiTap,
    required this.recentAmounts,
    required this.onZapTap,
    required this.onMoreZapsTap,
    required this.onReportTap,
    required this.onAddProfileTap,
    required this.onOpenWithTap,
    required this.onLabelTap,
    required this.onShareTap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
  });

  static Future<void> show(
    BuildContext context, {
    required Model model,
    required Function(Model) onModelTap,
    required Function(Model) onReplyTap,
    required List<Emoji> recentEmoji,
    required Function(Emoji) onEmojiTap,
    required VoidCallback onMoreEmojiTap,
    required List<double> recentAmounts,
    required Function(double) onZapTap,
    required Function(Model) onMoreZapsTap,
    required Function(Model) onReportTap,
    required Function(Model) onAddProfileTap,
    required Function(Model) onOpenWithTap,
    required Function(Model) onLabelTap,
    required Function(Model) onShareTap,
    required NostrEventResolver onResolveEvent,
    required NostrProfileResolver onResolveProfile,
    required NostrEmojiResolver onResolveEmoji,
    required NostrHashtagResolver onResolveHashtag,
    required LinkTapHandler onLinkTap,
  }) {
    return AppModal.show(
      context,
      topBar: _buildTopBar(context),
      children: [
        AppActionsModal(
          model: model,
          onModelTap: onModelTap,
          onReplyTap: onReplyTap,
          recentEmoji: recentEmoji,
          onEmojiTap: onEmojiTap,
          onMoreEmojiTap: onMoreEmojiTap,
          recentAmounts: recentAmounts,
          onZapTap: onZapTap,
          onMoreZapsTap: onMoreZapsTap,
          onResolveEvent: onResolveEvent,
          onResolveProfile: onResolveProfile,
          onResolveEmoji: onResolveEmoji,
          onResolveHashtag: onResolveHashtag,
          onReportTap: onReportTap,
          onAddProfileTap: onAddProfileTap,
          onOpenWithTap: onOpenWithTap,
          onLabelTap: onLabelTap,
          onShareTap: onShareTap,
        )._buildContent(
          context,
          model: model,
          onModelTap: onModelTap,
          onReplyTap: onReplyTap,
          recentEmoji: recentEmoji,
          recentAmounts: recentAmounts,
          onEmojiTap: onEmojiTap,
          onMoreEmojiTap: onMoreEmojiTap,
          onZapTap: onZapTap,
          onMoreZapsTap: onMoreZapsTap,
          onReportTap: onReportTap,
          onAddProfileTap: onAddProfileTap,
          onOpenWithTap: onOpenWithTap,
          onLabelTap: onLabelTap,
          onShareTap: onShareTap,
          onResolveEvent: onResolveEvent,
          onResolveProfile: onResolveProfile,
          onResolveEmoji: onResolveEmoji,
          onResolveHashtag: onResolveHashtag,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppModal(
      topBar: _buildTopBar(context),
      children: [
        _buildContent(
          context,
          model: model,
          onModelTap: onModelTap,
          onReplyTap: onReplyTap,
          recentEmoji: recentEmoji,
          recentAmounts: recentAmounts,
          onEmojiTap: onEmojiTap,
          onMoreEmojiTap: onMoreEmojiTap,
          onZapTap: onZapTap,
          onMoreZapsTap: onMoreZapsTap,
          onReportTap: onReportTap,
          onAddProfileTap: onAddProfileTap,
          onOpenWithTap: onOpenWithTap,
          onLabelTap: onLabelTap,
          onShareTap: onShareTap,
          onResolveEvent: onResolveEvent,
          onResolveProfile: onResolveProfile,
          onResolveEmoji: onResolveEmoji,
          onResolveHashtag: onResolveHashtag,
        ),
      ],
    );
  }

  static Widget _buildTopBar(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppContainer(
      padding: const AppEdgeInsets.symmetric(
        horizontal: AppGapSize.s12,
        vertical: AppGapSize.s12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppContainer(
            height: 32,
            width: 32,
            padding: const AppEdgeInsets.only(
              bottom: AppGapSize.s2,
            ),
            decoration: BoxDecoration(
              color: theme.colors.black33,
              borderRadius: theme.radius.asBorderRadius().rad12,
            ),
            child: Center(
              child: AppIcon.s10(
                theme.icons.characters.chevronUp,
                outlineThickness: LineThicknessData.normal().medium,
                outlineColor: theme.colors.white66,
                color: theme.colors.white,
              ),
            ),
          ),
          const AppGap.s12(),
          AppText.med14('Actions', color: theme.colors.white),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required Model model,
    required Function(Model) onModelTap,
    required Function(Model) onReplyTap,
    required List<Emoji> recentEmoji,
    required List<double> recentAmounts,
    required Function(Emoji) onEmojiTap,
    required VoidCallback onMoreEmojiTap,
    required Function(double) onZapTap,
    required Function(Model) onMoreZapsTap,
    required Function(Model) onReportTap,
    required Function(Model) onAddProfileTap,
    required Function(Model) onOpenWithTap,
    required Function(Model) onLabelTap,
    required Function(Model) onShareTap,
    required NostrEventResolver onResolveEvent,
    required NostrProfileResolver onResolveProfile,
    required NostrEmojiResolver onResolveEmoji,
    required NostrHashtagResolver onResolveHashtag,
  }) {
    final theme = AppTheme.of(context);
    final displayedEmoji = recentEmoji.take(24).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TapBuilder(
          onTap: onModelTap(model),
          builder: (context, state, isFocused) {
            double scaleFactor = 1.0;
            if (state == TapState.pressed) {
              scaleFactor = 0.98;
            } else if (state == TapState.hover) {
              scaleFactor = 1.00;
            }

            return AnimatedScale(
              scale: scaleFactor,
              duration: AppDurationsData.normal().fast,
              curve: Curves.easeInOut,
              child: Model is ChatMessage
                  ? AppContainer(
                      decoration: BoxDecoration(
                        color: theme.colors.black33,
                        borderRadius: theme.radius.asBorderRadius().rad16,
                        border: Border.all(
                          color: theme.colors.white33,
                          width: LineThicknessData.normal().thin,
                        ),
                      ),
                      padding: const AppEdgeInsets.all(AppGapSize.s8),
                      child: Column(
                        children: [
                          AppQuotedMessage(
                            chatMessage: model as ChatMessage,
                            onResolveEvent: onResolveEvent,
                            onResolveProfile: onResolveProfile,
                            onResolveEmoji: onResolveEmoji,
                          ),
                          AppContainer(
                            padding: const AppEdgeInsets.only(
                              left: AppGapSize.s8,
                              right: AppGapSize.s8,
                              top: AppGapSize.s12,
                              bottom: AppGapSize.s4,
                            ),
                            child: Row(
                              children: [
                                AppText.med14(
                                  'Reply',
                                  color: theme.colors.white33,
                                ),
                                const Spacer(),
                                AppIcon.s16(
                                  theme.icons.characters.voice,
                                  color: theme.colors.white33,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppProfilePic.s40(
                                model.author.value?.pictureUrl ?? ''),
                            const AppGap.s12(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      AppEmojiImage(
                                        emojiUrl:
                                            'assets/emoji/${getModelContentType(model)}.png',
                                        emojiName: getModelContentType(model),
                                        size: 16,
                                      ),
                                      const AppGap.s10(),
                                      Expanded(
                                        child: AppCompactTextRenderer(
                                          content: getModelDisplayText(model),
                                          onResolveEvent: onResolveEvent,
                                          onResolveProfile: onResolveProfile,
                                          onResolveEmoji: onResolveEmoji,
                                          isWhite: true,
                                          isMedium: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const AppGap.s2(),
                                  AppText.reg12(
                                    model.author.value?.name ??
                                        formatNpub(
                                            model.author.value?.npub ?? ''),
                                    color: theme.colors.white66,
                                  ),
                                ],
                              ),
                            ),
                            const AppGap.s8(),
                          ],
                        ),
                        Row(
                          children: [
                            AppContainer(
                              width: theme.sizes.s38,
                              child: Center(
                                child: AppContainer(
                                  decoration: BoxDecoration(
                                      color: theme.colors.white33),
                                  width: LineThicknessData.normal().medium,
                                  height: theme.sizes.s16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TapBuilder(
                          onTap: () => onReplyTap(model),
                          builder: (context, state, hasFocus) {
                            double scaleFactor = 1.0;
                            if (state == TapState.pressed) {
                              scaleFactor = 0.99;
                            } else if (state == TapState.hover) {
                              scaleFactor = 1.005;
                            }

                            return Transform.scale(
                              scale: scaleFactor,
                              child: AppContainer(
                                height: theme.sizes.s40,
                                decoration: BoxDecoration(
                                  color: theme.colors.black33,
                                  borderRadius:
                                      theme.radius.asBorderRadius().rad16,
                                  border: Border.all(
                                    color: theme.colors.white33,
                                    width: LineThicknessData.normal().thin,
                                  ),
                                ),
                                padding: const AppEdgeInsets.all(AppGapSize.s8),
                                child: AppContainer(
                                  padding: const AppEdgeInsets.only(
                                    left: AppGapSize.s8,
                                    right: AppGapSize.s8,
                                  ),
                                  child: Row(
                                    children: [
                                      AppText.med14(
                                        'Reply',
                                        color: theme.colors.white33,
                                      ),
                                      const Spacer(),
                                      AppIcon.s16(
                                        theme.icons.characters.voice,
                                        color: theme.colors.white33,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            );
          },
        ),
        const AppGap.s12(),
        const AppSectionTitle('React'),
        AppContainer(
          height: 52,
          width: double.infinity,
          padding: const AppEdgeInsets.only(
            left: AppGapSize.none,
            right: AppGapSize.s8,
            top: AppGapSize.s8,
            bottom: AppGapSize.s8,
          ),
          decoration: BoxDecoration(
            color: theme.colors.black33,
            borderRadius: theme.radius.asBorderRadius().rad16,
          ),
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
                    ],
                    stops: const [0.0, 1.0],
                  ).createShader(
                      Rect.fromLTWH(bounds.width - 64, 0, 64, bounds.height));
                },
                blendMode: BlendMode.dstIn,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppGap.s14(),
                        for (final emoji in displayedEmoji) ...[
                          TapBuilder(
                            onTap: () {
                              onEmojiTap(emoji);
                            },
                            builder: (context, state, isFocused) {
                              double scaleFactor = 1.0;
                              if (state == TapState.pressed) {
                                scaleFactor = 0.98;
                              } else if (state == TapState.hover) {
                                scaleFactor = 1.20;
                              }

                              return AnimatedScale(
                                scale: scaleFactor,
                                duration: AppDurationsData.normal().fast,
                                curve: Curves.easeInOut,
                                child: AppContainer(
                                  padding: const AppEdgeInsets.only(
                                      right: AppGapSize.s14),
                                  child: Center(
                                    child: emoji.emojiUrl != null
                                        ? AppEmojiImage(
                                            emojiUrl: emoji.emojiUrl ?? '',
                                            emojiName: emoji.emojiName,
                                            size: 28,
                                          )
                                        : SizedBox(
                                            width: 28,
                                            height: 28,
                                            child: Center(
                                              child: AppText.h1(
                                                emoji.emojiName,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                        const AppGap.s32(),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: theme.radius.asBorderRadius().rad8,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: TapBuilder(
                      onTap: onMoreEmojiTap,
                      builder: (context, state, isFocused) {
                        return AppContainer(
                          height: double.infinity,
                          width: 32,
                          decoration: BoxDecoration(
                            color: theme.colors.white8,
                            borderRadius: theme.radius.asBorderRadius().rad8,
                          ),
                          child: Center(
                            child: AppIcon.s8(
                              theme.icons.characters.chevronDown,
                              outlineThickness:
                                  LineThicknessData.normal().medium,
                              outlineColor: theme.colors.white66,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const AppGap.s12(),
        const AppSectionTitle('Zap'),
        AppContainer(
          height: 52,
          width: double.infinity,
          padding: const AppEdgeInsets.only(
            left: AppGapSize.none,
            right: AppGapSize.s8,
            top: AppGapSize.s8,
            bottom: AppGapSize.s8,
          ),
          decoration: BoxDecoration(
            color: theme.colors.black33,
            borderRadius: theme.radius.asBorderRadius().rad16,
          ),
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
                    ],
                    stops: const [0.0, 1.0],
                  ).createShader(
                      Rect.fromLTWH(bounds.width - 64, 0, 64, bounds.height));
                },
                blendMode: BlendMode.dstIn,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppGap.s8(),
                        for (final amount in recentAmounts) ...[
                          TapBuilder(
                            onTap: onZapTap(amount),
                            builder: (context, state, isFocused) {
                              double scaleFactor = 1.0;
                              if (state == TapState.pressed) {
                                scaleFactor = 0.98;
                              } else if (state == TapState.hover) {
                                scaleFactor = 1.02;
                              }

                              return AnimatedScale(
                                scale: scaleFactor,
                                duration: AppDurationsData.normal().fast,
                                curve: Curves.easeInOut,
                                child: AppContainer(
                                  decoration: BoxDecoration(
                                    color: theme.colors.white8,
                                    borderRadius:
                                        theme.radius.asBorderRadius().rad8,
                                  ),
                                  padding: const AppEdgeInsets.symmetric(
                                      horizontal: AppGapSize.s12),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppIcon.s12(
                                          theme.icons.characters.zap,
                                          gradient: theme.colors.gold,
                                        ),
                                        const AppGap.s4(),
                                        AppText.bold16(
                                          amount.toStringAsFixed(0),
                                          color: theme.colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const AppGap.s8(),
                        ],
                        const AppGap.s32(),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: theme.radius.asBorderRadius().rad8,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: TapBuilder(
                      onTap: onMoreZapsTap(model),
                      builder: (context, state, isFocused) {
                        return AppContainer(
                          height: double.infinity,
                          width: 32,
                          decoration: BoxDecoration(
                            color: theme.colors.white8,
                            borderRadius: theme.radius.asBorderRadius().rad8,
                          ),
                          child: Center(
                            child: AppIcon.s8(
                              theme.icons.characters.chevronDown,
                              outlineThickness:
                                  LineThicknessData.normal().medium,
                              outlineColor: theme.colors.white66,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const AppGap.s12(),
        const AppSectionTitle('Actions'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (var i = 0; i < 3; i++) ...[
              Expanded(
                child: AppPanelButton(
                  color: theme.colors.black33,
                  padding: const AppEdgeInsets.only(
                    top: AppGapSize.s20,
                    bottom: AppGapSize.s16,
                  ),
                  onTap: i == 0
                      ? onOpenWithTap(model)
                      : i == 1
                          ? onLabelTap(model)
                          : onShareTap(model),
                  isLight: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppIcon.s24(
                        i == 0
                            ? theme.icons.characters.openWith
                            : i == 1
                                ? theme.icons.characters.label
                                : theme.icons.characters.share,
                        outlineThickness: LineThicknessData.normal().medium,
                        outlineColor: theme.colors.white66,
                      ),
                      const AppGap.s10(),
                      AppText.med14(
                        i == 0
                            ? 'Open with'
                            : i == 1
                                ? 'Label'
                                : 'Share',
                        color: theme.colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              if (i < 2) const AppGap.s12(),
            ],
          ],
        ),
        const AppGap.s12(),
        AppButton(
          onTap: onReportTap(model),
          inactiveColor: theme.colors.black33,
          children: [
            AppText.med14('Report', gradient: theme.colors.rouge),
          ],
        ),
        const AppGap.s12(),
        AppButton(
          onTap: onAddProfileTap(model),
          children: [
            AppIcon.s16(
              theme.icons.characters.plus,
              outlineThickness: LineThicknessData.normal().thick,
              outlineColor: AppColorsData.dark().white,
            ),
            const AppGap.s12(),
            AppText.reg14('Add ', color: AppColorsData.dark().white),
            AppText.bold14(
              model.author.value?.name ??
                  formatNpub(model.author.value?.pubkey ?? ''),
              color: AppColorsData.dark().white,
            ),
          ],
        ),
      ],
    );
  }
}
