import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:models/models.dart';

class LabLongTextRenderer extends StatelessWidget {
  final Model model;
  final String content;
  final String? language;
  final bool? serif;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final Function(Profile) onProfileTap;

  const LabLongTextRenderer({
    super.key,
    required this.model,
    required this.content,
    this.language,
    this.serif = true,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final dynamic parser = language == 'ndown'
        ? LabNDownParser()
        : language == 'nosciidoc'
            ? LabNosciiDocParser()
            : LabNosciiDocParser();
    final elements = parser.parse(content);

    return LabContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < elements.length; i++)
            _buildElementWithSpacing(
              elements[i],
              context,
              nextElement: i < elements.length - 1 ? elements[i + 1] : null,
            ),
        ],
      ),
    );
  }

  bool _isListItem(LongTextElement element) {
    return element.type == LongTextElementType.listItem ||
        element.type == LongTextElementType.orderedListItem ||
        element.type == LongTextElementType.checkListItem;
  }

  Widget _buildElementWithSpacing(LongTextElement element, BuildContext context,
      {LongTextElement? nextElement}) {
    final theme = LabTheme.of(context);
    final LabEdgeInsets spacing = switch (element.type) {
      LongTextElementType.heading1 => const LabEdgeInsets.only(
          top: LabGapSize.s4,
          bottom: LabGapSize.s6,
        ),
      LongTextElementType.heading2 => const LabEdgeInsets.only(
          bottom: LabGapSize.s6,
        ),
      LongTextElementType.heading3 => const LabEdgeInsets.only(
          bottom: LabGapSize.s6,
        ),
      LongTextElementType.heading4 => const LabEdgeInsets.only(
          bottom: LabGapSize.s6,
        ),
      LongTextElementType.heading5 => const LabEdgeInsets.only(
          bottom: LabGapSize.s6,
        ),
      LongTextElementType.listItem => const LabEdgeInsets.only(
          bottom: LabGapSize.s6,
        ),
      LongTextElementType.orderedListItem => const LabEdgeInsets.only(
          bottom: LabGapSize.s6,
        ),
      LongTextElementType.checkListItem => const LabEdgeInsets.only(
          bottom: LabGapSize.s6,
        ),
      LongTextElementType.horizontalRule => const LabEdgeInsets.only(
          bottom: LabGapSize.none,
        ),
      LongTextElementType.image => const LabEdgeInsets.only(
          bottom: LabGapSize.s8,
        ),
      LongTextElementType.nostrModel => const LabEdgeInsets.only(
          top: LabGapSize.s4,
          bottom: LabGapSize.s8,
        ),
      _ => const LabEdgeInsets.only(
          bottom: LabGapSize.s10,
        ),
    };

    // Determine if this element should be swipeable (paragraphs and certain other content)
    final bool isSwipeable = switch (element.type) {
      LongTextElementType.paragraph => true,
      _ => false,
    };

    final bool isLastListItem = _isListItem(element) &&
        (nextElement == null || !_isListItem(nextElement));

    final Widget content = _buildElement(context, element);

    if (!isSwipeable) {
      return LabContainer(
        padding: spacing,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            content,
            if (isLastListItem) const LabGap.s16(),
          ],
        ),
      );
    }

    return LabSwipeContainer(
      padding: spacing,
      leftContent: LabIcon.s16(
        theme.icons.characters.reply,
        outlineColor: theme.colors.white66,
        outlineThickness: LabLineThicknessData.normal().medium,
      ),
      rightContent: LabIcon.s10(
        theme.icons.characters.chevronUp,
        outlineColor: theme.colors.white66,
        outlineThickness: LabLineThicknessData.normal().medium,
      ),
      onSwipeLeft: () {}, // Add your action handlers
      onSwipeRight: () {}, // Add your reply handlers
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          content,
          if (isLastListItem) const LabGap.s16(),
        ],
      ),
    );
  }

  List<InlineSpan> _buildInlineElements(
      BuildContext context, List<LongTextElement> children) {
    final theme = LabTheme.of(context);
    return children.map((child) {
      if (child.type == LongTextElementType.nostrProfile) {
        return TextSpan(
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
              child: FutureBuilder<({Profile profile, VoidCallback? onTap})>(
                future: onResolveProfile(child.content),
                builder: (context, snapshot) {
                  return LabProfileInline(
                    profile: snapshot.data!.profile,
                    onTap: snapshot.data?.onTap,
                    isArticle: true,
                  );
                },
              ),
            ),
          ],
        );
      } else if (child.type == LongTextElementType.emoji) {
        return TextSpan(
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
                future: onResolveEmoji(child.content, model),
                builder: (context, snapshot) {
                  return LabContainer(
                    padding: const LabEdgeInsets.symmetric(
                        horizontal: LabGapSize.s2),
                    child: LabEmojiImage(
                      emojiUrl: snapshot.data ?? '',
                      emojiName: snapshot.data ?? '',
                      size: 16,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      } else if (child.type == LongTextElementType.monospace) {
        return TextSpan(
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
                  const LabGap.s2(),
                  LabContainer(
                    height: 22,
                    padding: const LabEdgeInsets.only(
                      left: LabGapSize.s4,
                      right: LabGapSize.s4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colors.white16,
                      borderRadius: theme.radius.asBorderRadius().rad4,
                    ),
                    child: LabText.code(
                      child.content,
                      color: theme.colors.white66,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      } else if (child.type == LongTextElementType.hashtag) {
        return TextSpan(
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
                          style: serif!
                              ? theme.typography.regArticle.copyWith(
                                  color: theme.colors.blurpleLightColor,
                                  fontWeight: FontWeight.bold,
                                )
                              : theme.typography.regWiki.copyWith(
                                  color: theme.colors.blurpleLightColor,
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
        );
      } else if (child.type == LongTextElementType.link) {
        return TextSpan(
          text: child.attributes?['text'] ?? child.content,
          style: serif!
              ? theme.typography.boldArticle.copyWith(
                  color: theme.colors.blurpleLightColor,
                )
              : theme.typography.boldWiki.copyWith(
                  color: theme.colors.blurpleLightColor,
                ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => onLinkTap(child.content),
        );
      } else {
        return TextSpan(
          text: child.content,
          style: serif!
              ? theme.typography.regArticle.copyWith(
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
                )
              : theme.typography.regWiki.copyWith(
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
        );
      }
    }).toList();
  }

  Widget _buildElement(BuildContext context, LongTextElement element) {
    final theme = LabTheme.of(context);

    switch (element.type) {
      case LongTextElementType.heading1:
        return LabText.longformh1(element.content);
      case LongTextElementType.heading2:
        return LabText.longformh2(element.content, color: theme.colors.white66);
      case LongTextElementType.heading3:
        return LabText.longformh3(element.content);
      case LongTextElementType.heading4:
        return LabText.longformh4(element.content, color: theme.colors.white66);
      case LongTextElementType.heading5:
        return LabText.longformh5(element.content);
      case LongTextElementType.codeBlock:
        return LabCodeBlock(
          code: element.content,
          language: element.attributes?['language'] ?? 'plain',
        );
      case LongTextElementType.admonition:
        return LabAdmonition(
          type: element.attributes?['type'] ?? 'note',
          child: LabText.reg14(
            element.content,
            color: theme.colors.white,
          ),
        );
      case LongTextElementType.listItem:
      case LongTextElementType.orderedListItem:
        final String number = element.attributes?['number'] ?? '•';
        final String displayNumber =
            element.type == LongTextElementType.orderedListItem
                ? '$number.'
                : number;
        return Padding(
          padding: EdgeInsets.only(
            left: (element.level) * 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabContainer(
                padding: const LabEdgeInsets.only(
                  right: LabGapSize.s8,
                ),
                child: serif!
                    ? LabText.regArticle(
                        displayNumber,
                        color: theme.colors.white66,
                      )
                    : LabText.regWiki(
                        displayNumber,
                        color: theme.colors.white66,
                      ),
              ),
              Expanded(
                child: element.children != null
                    ? LabSelectableText.rich(
                        TextSpan(
                          children:
                              _buildInlineElements(context, element.children!),
                        ),
                        style: serif!
                            ? theme.typography.regArticle.copyWith(
                                color: theme.colors.white,
                              )
                            : theme.typography.regWiki.copyWith(
                                color: theme.colors.white,
                              ),
                        showContextMenu: true,
                        selectionControls: LabTextSelectionControls(),
                        contextMenuItems: [
                          LabTextSelectionMenuItem(
                            label: 'Copy',
                            onTap: (state) =>
                                state.copySelection(SelectionChangedCause.tap),
                          ),
                        ],
                      )
                    : serif!
                        ? LabText.regArticle(
                            element.content,
                            color: theme.colors.white,
                          )
                        : LabText.regWiki(
                            element.content,
                            color: theme.colors.white,
                          ),
              ),
            ],
          ),
        );
      case LongTextElementType.checkListItem:
        return Padding(
          padding: EdgeInsets.only(
            left: (element.level) * 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabCheckBox(
                value: element.checked ?? false,
                onChanged: null,
              ),
              const LabGap.s12(),
              Expanded(
                child: element.children != null
                    ? LabSelectableText.rich(
                        TextSpan(
                          children:
                              _buildInlineElements(context, element.children!),
                        ),
                        style: serif!
                            ? theme.typography.regArticle.copyWith(
                                color: theme.colors.white,
                              )
                            : theme.typography.regWiki.copyWith(
                                color: theme.colors.white,
                              ),
                        showContextMenu: true,
                        selectionControls: LabTextSelectionControls(),
                        contextMenuItems: [
                          LabTextSelectionMenuItem(
                            label: 'Copy',
                            onTap: (state) =>
                                state.copySelection(SelectionChangedCause.tap),
                          ),
                        ],
                      )
                    : serif!
                        ? LabText.regArticle(
                            element.content,
                            color: theme.colors.white,
                          )
                        : LabText.regWiki(
                            element.content,
                            color: theme.colors.white,
                          ),
              ),
            ],
          ),
        );
      case LongTextElementType.descriptionListItem:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabText.boldArticle(element.content),
            if (element.attributes?['description'] != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 4,
                ),
                child: serif!
                    ? LabText.regArticle(
                        element.attributes!['description']!,
                        color: theme.colors.white66,
                      )
                    : LabText.regWiki(
                        element.attributes!['description']!,
                        color: theme.colors.white66,
                      ),
              ),
          ],
        );
      case LongTextElementType.horizontalRule:
        return const LabContainer(
          padding: LabEdgeInsets.symmetric(vertical: LabGapSize.s16),
          child: LabDivider(),
        );
      case LongTextElementType.paragraph:
        if (element.attributes?['role'] == 'lead') {
          return LabSelectableText(
            text: element.content,
            style: serif!
                ? theme.typography.regArticle.copyWith(
                    color: theme.colors.white,
                    fontSize: 17,
                    fontStyle: FontStyle.italic,
                  )
                : theme.typography.regWiki.copyWith(
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
            if (child.type == LongTextElementType.nostrModel) {
              if (currentSpans.isNotEmpty) {
                paragraphPieces.add(
                  LabSelectableText.rich(
                    TextSpan(children: List.from(currentSpans)),
                    style: serif!
                        ? theme.typography.regArticle.copyWith(
                            color: theme.colors.white,
                          )
                        : theme.typography.regWiki.copyWith(
                            color: theme.colors.white,
                          ),
                  ),
                );
                currentSpans.clear();
              }
              paragraphPieces.add(const SizedBox(height: 8));
              paragraphPieces.add(
                LabContainer(
                  child: FutureBuilder<({Model model, VoidCallback? onTap})>(
                    future: onResolveEvent(child.content),
                    builder: (context, snapshot) {
                      return ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: LabModelCard(
                          model: snapshot.data?.model,
                          onTap: snapshot.data?.onTap == null
                              ? null
                              : (model) => snapshot.data!.onTap!(),
                          onProfileTap: (profile) => onProfileTap(profile),
                        ),
                      );
                    },
                  ),
                ),
              );
              paragraphPieces.add(const SizedBox(height: 8));
            } else {
              currentSpans.addAll(_buildInlineElements(context, [child]));
            }
          }

          // Add any remaining text
          if (currentSpans.isNotEmpty) {
            paragraphPieces.add(
              LabSelectableText.rich(
                TextSpan(children: List.from(currentSpans)),
                style: serif!
                    ? theme.typography.regArticle.copyWith(
                        color: theme.colors.white,
                      )
                    : theme.typography.regWiki.copyWith(
                        color: theme.colors.white,
                      ),
                showContextMenu: true,
                selectionControls: LabTextSelectionControls(),
                contextMenuItems: [
                  LabTextSelectionMenuItem(
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
        return LabSelectableText(
          text: element.content,
          style: serif!
              ? theme.typography.regArticle.copyWith(
                  color: theme.colors.white,
                )
              : theme.typography.regWiki.copyWith(
                  color: theme.colors.white,
                ),
        );
      case LongTextElementType.image:
        return LabFullWidthImage(
          url: element.content,
          caption: element.attributes?['title'],
        );
      case LongTextElementType.styledText:
        return Text(
          element.content,
          style: serif!
              ? theme.typography.regArticle.copyWith(
                  color: theme.colors.white,
                  fontWeight: element.attributes?['style'] == 'bold'
                      ? FontWeight.bold
                      : null,
                  fontStyle: element.attributes?['style'] == 'italic'
                      ? FontStyle.italic
                      : null,
                )
              : theme.typography.regWiki.copyWith(
                  color: theme.colors.white,
                  fontWeight: element.attributes?['style'] == 'bold'
                      ? FontWeight.bold
                      : null,
                  fontStyle: element.attributes?['style'] == 'italic'
                      ? FontStyle.italic
                      : null,
                ),
        );
      case LongTextElementType.blockQuote:
        return LabContainer(
          padding: const LabEdgeInsets.only(
            bottom: LabGapSize.s8,
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabContainer(
                  width: 1.4,
                  decoration: BoxDecoration(
                    color: theme.colors.white16,
                    borderRadius: theme.radius.asBorderRadius().rad4,
                  ),
                ),
                const LabGap.s16(),
                Expanded(
                  child: element.children != null
                      ? LabSelectableText.rich(
                          TextSpan(
                            children: _buildInlineElements(
                                context, element.children!),
                          ),
                          style: serif!
                              ? theme.typography.regArticle.copyWith()
                              : theme.typography.regWiki.copyWith(),
                        )
                      : LabSelectableText.rich(
                          TextSpan(
                            children: _buildInlineElements(context, [
                              LongTextElement(
                                type: LongTextElementType.styledText,
                                content: element.content,
                              )
                            ]),
                          ),
                          style: serif!
                              ? theme.typography.regArticle.copyWith()
                              : theme.typography.regWiki.copyWith(),
                        ),
                ),
              ],
            ),
          ),
        );
      default:
        return serif!
            ? LabText.regArticle(element.content)
            : LabText.regWiki(element.content);
    }
  }

  List<TextSpan> _buildStyledTextSpans(
      BuildContext context, List<LongTextElement> elements) {
    final theme = LabTheme.of(context);
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
