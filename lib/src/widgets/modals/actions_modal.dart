import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'dart:ui';

class AppActionsModal extends StatelessWidget {
  final String nevent;
  final String contentType;
  final String profileName;
  final String profilePicUrl;
  final List<Reaction> recentReactions;
  final List<double> recentAmounts;
  final String? message;
  final String? title;
  final String? imageUrl;

  const AppActionsModal({
    super.key,
    required this.nevent,
    required this.contentType,
    required this.profileName,
    required this.profilePicUrl,
    required this.recentReactions,
    required this.recentAmounts,
    this.message,
    this.title,
    this.imageUrl,
  });

  static Future<void> show(
    BuildContext context, {
    required String nevent,
    required String contentType,
    required String profileName,
    required String profilePicUrl,
    required List<Reaction> recentReactions,
    required List<double> recentAmounts,
    String? message,
    String? title,
    String? imageUrl,
  }) {
    return AppModal.show(
      context,
      topBar: _buildTopBar(context),
      children: [
        _buildContent(
          context,
          nevent: nevent,
          contentType: contentType,
          profileName: profileName,
          profilePicUrl: profilePicUrl,
          recentReactions: recentReactions,
          recentAmounts: recentAmounts,
          message: message,
          title: title,
          imageUrl: imageUrl,
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
          nevent: nevent,
          contentType: contentType,
          profileName: profileName,
          profilePicUrl: profilePicUrl,
          recentReactions: recentReactions,
          recentAmounts: recentAmounts,
          message: message,
          title: title,
          imageUrl: imageUrl,
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

  static Widget _buildContent(
    BuildContext context, {
    required String nevent,
    required String contentType,
    required String profileName,
    required String profilePicUrl,
    required List<Reaction> recentReactions,
    required List<double> recentAmounts,
    String? message,
    String? title,
    String? imageUrl,
  }) {
    final theme = AppTheme.of(context);
    final displayedReactions = recentReactions.take(24).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TapBuilder(
          onTap: () {
            // TODO: add onTap as a paremeter
          },
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
              child: contentType == 'message'
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
                            message: message ?? '',
                            profileName: profileName,
                            profilePicUrl: profilePicUrl,
                            timestamp: DateTime.now(),
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
                            AppProfilePic.s40(profilePicUrl),
                            const AppGap.s12(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      AppEmojiImage(
                                        emojiUrl:
                                            'assets/emoji/$contentType.png',
                                        emojiName: contentType,
                                        size: 16,
                                      ),
                                      const AppGap.s10(),
                                      Expanded(
                                        child: AppText.reg14(
                                          title ?? '',
                                          maxLines: 1,
                                          textOverflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const AppGap.s2(),
                                  AppText.reg12(
                                    profileName,
                                    color: theme.colors.white66,
                                  ),
                                ],
                              ),
                            ),
                            const AppGap.s8(),
                          ],
                        ),
                        Row(children: [
                          AppContainer(
                            width: theme.sizes.s38,
                            child: Center(
                              child: AppContainer(
                                decoration:
                                    BoxDecoration(color: theme.colors.white33),
                                width: LineThicknessData.normal().medium,
                                height: theme.sizes.s16,
                              ),
                            ),
                          ),
                        ]),
                        AppContainer(
                          height: theme.sizes.s40,
                          decoration: BoxDecoration(
                            color: theme.colors.black33,
                            borderRadius: theme.radius.asBorderRadius().rad16,
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
                      theme.colors.black.withOpacity(1),
                      theme.colors.black.withOpacity(0),
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
                        for (final reaction in displayedReactions) ...[
                          TapBuilder(
                            onTap: () {
                              Navigator.of(context).pop();
                              // Add reaction logic here
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
                                    child: AppEmojiImage(
                                      emojiUrl: reaction.emojiUrl,
                                      emojiName: reaction.emojiName,
                                      size: 28,
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
                      onTap: () {}, // TODO: Add the modal
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
                      theme.colors.black.withOpacity(1),
                      theme.colors.black.withOpacity(0),
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
                            onTap: () {
                              Navigator.of(context).pop();
                              // Add reaction logic here
                            },
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
                      onTap: () {}, // TODO: Add the modal
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
                  onTap: () {
                    // TODO: Handle action tap
                  },
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
          onTap: () {
            print('test'); // TODO: Handle report tap
          },
          inactiveColor: theme.colors.black33,
          content: [
            AppText.med14('Report', gradient: theme.colors.rouge),
          ],
        ),
        const AppGap.s12(),
        AppButton(
          onTap: () {
            print('test'); // TODO: Handle add tap
          },
          content: [
            AppIcon.s16(
              theme.icons.characters.plus,
              outlineThickness: LineThicknessData.normal().thick,
              outlineColor: AppColorsData.dark().white,
            ),
            const AppGap.s12(),
            AppText.reg14('Add ', color: AppColorsData.dark().white),
            AppText.bold14(profileName, color: AppColorsData.dark().white),
          ],
        ),
      ],
    );
  }
}
