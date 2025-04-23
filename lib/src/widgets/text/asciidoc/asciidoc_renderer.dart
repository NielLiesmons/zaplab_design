import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:models/models.dart';

class AppAsciiDocRenderer extends StatelessWidget {
  final String content;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;

  const AppAsciiDocRenderer({
    super.key,
    required this.content,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final parser = AsciiDocParser();
    final elements = parser.parse(content);

    return AppContainer(
      padding: const AppEdgeInsets.symmetric(vertical: AppGapSize.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final element in elements)
            _buildElementWithSpacing(element, context),
        ],
      ),
    );
  }

  Widget _buildElementWithSpacing(
      AsciiDocElement element, BuildContext context) {
    final theme = AppTheme.of(context);
    final AppEdgeInsets spacing = switch (element.type) {
      AsciiDocElementType.heading1 => const AppEdgeInsets.only(
          top: AppGapSize.s4,
          bottom: AppGapSize.s6,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      AsciiDocElementType.heading2 => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      AsciiDocElementType.heading3 => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      AsciiDocElementType.heading4 => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      AsciiDocElementType.heading5 => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      AsciiDocElementType.listItem => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      AsciiDocElementType.orderedListItem => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      AsciiDocElementType.horizontalRule => const AppEdgeInsets.only(
          bottom: AppGapSize.none,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      AsciiDocElementType.image => const AppEdgeInsets.only(
          bottom: AppGapSize.s8,
        ),
      AsciiDocElementType.nostrModel => const AppEdgeInsets.only(
          top: AppGapSize.s4,
          bottom: AppGapSize.s8,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      _ => const AppEdgeInsets.only(
          bottom: AppGapSize.s10,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
    };

    // Determine if this element should be swipeable (paragraphs and certain other content)
    final bool isSwipeable = switch (element.type) {
      AsciiDocElementType.paragraph => true,
      _ => false,
    };

    final Widget content = _buildElement(context, element);

    if (!isSwipeable) {
      return AppContainer(
        padding: spacing,
        child: content,
      );
    }

    return AppSwipeContainer(
      padding: spacing,
      leftContent: AppIcon.s16(
        theme.icons.characters.reply,
        outlineColor: theme.colors.white66,
        outlineThickness: LineThicknessData.normal().medium,
      ),
      rightContent: AppIcon.s10(
        theme.icons.characters.chevronUp,
        outlineColor: theme.colors.white66,
        outlineThickness: LineThicknessData.normal().medium,
      ),
      onSwipeLeft: () {}, // Add your action handlers
      onSwipeRight: () {}, // Add your reply handlers
      child: content,
    );
  }

  Widget _buildElement(BuildContext context, AsciiDocElement element) {
    final theme = AppTheme.of(context);

    switch (element.type) {
      case AsciiDocElementType.heading1:
        return AppText.longformh1(element.content);
      case AsciiDocElementType.heading2:
        return AppText.longformh2(element.content, color: theme.colors.white66);
      case AsciiDocElementType.heading3:
        return AppText.longformh3(element.content);
      case AsciiDocElementType.heading4:
        return AppText.longformh4(element.content, color: theme.colors.white66);
      case AsciiDocElementType.heading5:
        return AppText.longformh5(element.content);
      case AsciiDocElementType.codeBlock:
        return AppCodeBlock(
          code: element.content,
          language: element.attributes?['language'] ?? 'plain',
        );
      case AsciiDocElementType.admonition:
        return AppAdmonition(
          type: element.attributes?['type'] ?? 'note',
          child: AppText.reg14(
            element.content,
            color: theme.colors.white,
          ),
        );
      case AsciiDocElementType.listItem:
      case AsciiDocElementType.orderedListItem:
        final String number = element.attributes?['number'] ?? '•';
        final String displayNumber =
            element.type == AsciiDocElementType.orderedListItem
                ? '$number.'
                : number;
        return Padding(
          padding: EdgeInsets.only(
            left: element.level * 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppContainer(
                padding: const AppEdgeInsets.only(
                  right: AppGapSize.s8,
                ),
                child: AppText.regArticle(
                  displayNumber,
                  color: theme.colors.white66,
                ),
              ),
              Expanded(
                child: AppText.regArticle(
                  element.content,
                  color: theme.colors.white,
                ),
              ),
            ],
          ),
        );
      case AsciiDocElementType.checkListItem:
        return Padding(
          padding: EdgeInsets.only(
            left: element.level * 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCheckBox(
                value: element.checked ?? false,
                onChanged: null,
              ),
              const AppGap.s8(),
              Expanded(
                child: AppText.regArticle(
                  element.content,
                  color: theme.colors.white,
                ),
              ),
            ],
          ),
        );
      case AsciiDocElementType.descriptionListItem:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.boldArticle(element.content),
            if (element.attributes?['description'] != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 4,
                ),
                child: AppText.regArticle(
                  element.attributes!['description']!,
                  color: theme.colors.white66,
                ),
              ),
          ],
        );
      case AsciiDocElementType.horizontalRule:
        return const AppContainer(
          padding: AppEdgeInsets.symmetric(vertical: AppGapSize.s16),
          child: AppDivider(),
        );
      case AsciiDocElementType.paragraph:
        if (element.attributes?['role'] == 'lead') {
          return AppSelectableText(
            text: element.content,
            style: theme.typography.regArticle.copyWith(
              color: theme.colors.white,
              fontSize: 17,
              fontStyle: FontStyle.italic,
            ),
          );
        }
        if (element.children != null) {
          final List<Widget> paragraphPieces = [];
          final List<InlineSpan> currentSpans = [];

          for (var child in element.children!) {
            if (child.type == AsciiDocElementType.nostrModel) {
              if (currentSpans.isNotEmpty) {
                paragraphPieces.add(
                  AppSelectableText.rich(
                    TextSpan(children: List.from(currentSpans)),
                    style: theme.typography.regArticle.copyWith(
                      color: theme.colors.white,
                    ),
                  ),
                );
                currentSpans.clear();
              }
              paragraphPieces.add(const SizedBox(height: 8));
              paragraphPieces.add(
                AppContainer(
                  child: FutureBuilder<({Model model, VoidCallback? onTap})>(
                    future: onResolveEvent(child.content),
                    builder: (context, snapshot) {
                      return ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: AppModelCard(
                          model: snapshot.data?.model,
                          onTap: snapshot.data?.onTap,
                        ),
                      );
                    },
                  ),
                ),
              );
              paragraphPieces.add(const SizedBox(height: 8));
            } else {
              // Handle all other elements exactly as before
              if (child.type == AsciiDocElementType.nostrProfile) {
                currentSpans.add(TextSpan(
                  children: [
                    TextSpan(
                      text: '@${child.content}',
                      style: const TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 0,
                        height: 0,
                        letterSpacing: 0,
                        wordSpacing: 0,
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: FutureBuilder<
                          ({Profile profile, VoidCallback? onTap})>(
                        future: onResolveProfile(child.content),
                        builder: (context, snapshot) {
                          return AppProfileInline(
                            profile: snapshot.data!.profile,
                            onTap: snapshot.data?.onTap,
                            isArticle: true,
                          );
                        },
                      ),
                    ),
                  ],
                ));
              } else if (child.type == AsciiDocElementType.emoji) {
                currentSpans.add(TextSpan(
                  children: [
                    TextSpan(
                      text: ':${child.content}:',
                      style: const TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 0,
                        height: 0,
                        letterSpacing: 0,
                        wordSpacing: 0,
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: FutureBuilder<String>(
                        future: onResolveEmoji(child.content),
                        builder: (context, snapshot) {
                          return AppContainer(
                            padding: const AppEdgeInsets.symmetric(
                                horizontal: AppGapSize.s2),
                            child: AppEmojiImage(
                              emojiUrl: snapshot.data ?? '',
                              emojiName: snapshot.data ?? '',
                              size: 16,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ));
              } else if (child.type == AsciiDocElementType.monospace) {
                currentSpans.add(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '`${child.content}`',
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 0,
                          height: 0,
                          letterSpacing: 0,
                          wordSpacing: 0,
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const AppGap.s2(),
                            AppContainer(
                              height: 22,
                              padding: const AppEdgeInsets.only(
                                left: AppGapSize.s4,
                                right: AppGapSize.s4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colors.white16,
                                borderRadius:
                                    theme.radius.asBorderRadius().rad4,
                              ),
                              child: AppText.code(
                                child.content,
                                color: theme.colors.white66,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (child.type == AsciiDocElementType.hashtag) {
                currentSpans.add(TextSpan(
                  children: [
                    TextSpan(
                      text: '#${child.content}',
                      style: const TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 0,
                        height: 0,
                        letterSpacing: 0,
                        wordSpacing: 0,
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: FutureBuilder<void Function()?>(
                        future: onResolveHashtag(child.content),
                        builder: (context, snapshot) {
                          return TapBuilder(
                            onTap: snapshot.data,
                            builder: (context, state, hasFocus) {
                              double scaleFactor = 1.0;
                              if (state == TapState.pressed) {
                                scaleFactor = 0.99;
                              } else if (state == TapState.hover) {
                                scaleFactor = 1.01;
                              }

                              return Transform.scale(
                                scale: scaleFactor,
                                child: Text(
                                  '#${child.content}',
                                  style: theme.typography.regArticle.copyWith(
                                    color: theme.colors.blurpleColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ));
              } else if (child.type == AsciiDocElementType.link) {
                currentSpans.add(TextSpan(
                  text: child.content,
                  style: theme.typography.regArticle.copyWith(
                    color: theme.colors.blurpleColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => onLinkTap(child.content),
                ));
              } else {
                currentSpans.add(TextSpan(
                  text: child.content,
                  style: theme.typography.regArticle.copyWith(
                    color: theme.colors.white,
                    fontWeight: (child.attributes?['style'] == 'bold' ||
                            child.attributes?['style'] == 'bold-italic')
                        ? FontWeight.bold
                        : null,
                    fontStyle: (child.attributes?['style'] == 'italic' ||
                            child.attributes?['style'] == 'bold-italic')
                        ? FontStyle.italic
                        : null,
                    decoration: switch (child.attributes?['style']) {
                      'underline' => TextDecoration.underline,
                      'line-through' => TextDecoration.lineThrough,
                      _ => null,
                    },
                  ),
                ));
              }
            }
          }

          // Add any remaining text
          if (currentSpans.isNotEmpty) {
            paragraphPieces.add(
              AppSelectableText.rich(
                TextSpan(children: List.from(currentSpans)),
                style: theme.typography.regArticle.copyWith(
                  color: theme.colors.white,
                ),
                showContextMenu: true,
                selectionControls: AppTextSelectionControls(),
                contextMenuItems: [
                  AppTextSelectionMenuItem(
                    label: 'Copy',
                    onTap: (state) =>
                        state.copySelection(SelectionChangedCause.tap),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: paragraphPieces,
          );
        }
        return AppSelectableText(
          text: element.content,
          style: theme.typography.regArticle.copyWith(
            color: theme.colors.white,
          ),
        );
      case AsciiDocElementType.image:
        return AppFullWidthImage(
          url: element.content,
          caption: element.attributes?['title'],
        );
      case AsciiDocElementType.styledText:
        return Text(
          element.content,
          style: theme.typography.regArticle.copyWith(
            color: theme.colors.white,
            fontWeight:
                element.attributes?['style'] == 'bold' ? FontWeight.bold : null,
            fontStyle: element.attributes?['style'] == 'italic'
                ? FontStyle.italic
                : null,
          ),
        );
      default:
        return AppText.regArticle(element.content);
    }
  }

  List<TextSpan> _buildStyledTextSpans(
      BuildContext context, List<AsciiDocElement> elements) {
    final theme = AppTheme.of(context);
    return elements.map((element) {
      final style = element.attributes?['style'];
      return TextSpan(
        text: element.content,
        style: TextStyle(
          color: theme.colors.white,
          fontWeight: (style == 'bold' || style == 'bold-italic')
              ? FontWeight.bold
              : null,
          fontStyle: (style == 'italic' || style == 'bold-italic')
              ? FontStyle.italic
              : null,
          decoration: switch (style) {
            'underline' => TextDecoration.underline,
            'line-through' => TextDecoration.lineThrough,
            _ => null,
          },
        ),
      );
    }).toList();
  }
}
