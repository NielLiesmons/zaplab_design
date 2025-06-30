import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:models/models.dart';

enum ShortTextContentType {
  empty,
  singleImageStack,
  singleEmoji,
  singleProfile,
  singleModel,
  mixed;

  bool get isSingleContent => switch (this) {
        ShortTextContentType.singleImageStack ||
        ShortTextContentType.singleEmoji ||
        ShortTextContentType.singleProfile ||
        ShortTextContentType.singleModel =>
          true,
        _ => false,
      };
}

class ShortTextContent extends InheritedWidget {
  final ShortTextContentType contentType;

  const ShortTextContent({
    super.key,
    required this.contentType,
    required super.child,
  });

  static ShortTextContentType of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<ShortTextContent>();
    return widget?.contentType ?? ShortTextContentType.mixed;
  }

  @override
  bool updateShouldNotify(ShortTextContent oldWidget) {
    return contentType != oldWidget.contentType;
  }
}

class LabShortTextRenderer extends StatelessWidget {
  final String content;
  final Model model;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final Function(Profile) onProfileTap;

  const LabShortTextRenderer({
    super.key,
    required this.content,
    required this.model,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    required this.onProfileTap,
  });

  static ShortTextContentType analyzeContent(String content) {
    final parser = LabShortTextParser();
    final elements = parser.parse(content);
    return _analyzeElements(elements);
  }

  static ShortTextContentType _analyzeElements(
      List<LabShortTextElement> elements) {
    if (elements.isEmpty) {
      return ShortTextContentType.empty;
    }

    // Single image stack
    if (elements.length == 1 &&
        elements[0].type == LabShortTextElementType.images) {
      return ShortTextContentType.singleImageStack;
    }

    // Single emoji
    if (elements.length == 1 &&
        (elements[0].type == LabShortTextElementType.emoji ||
            elements[0].type == LabShortTextElementType.utfEmoji)) {
      return ShortTextContentType.singleEmoji;
    }

    // Single paragraph with one child
    if (elements.length == 1 &&
        elements[0].type == LabShortTextElementType.paragraph &&
        elements[0].children != null &&
        elements[0].children!.length == 1) {
      final child = elements[0].children![0];

      // Single profile
      if (child.type == LabShortTextElementType.nostrProfile) {
        return ShortTextContentType.singleProfile;
      }

      // Single model
      if (child.type == LabShortTextElementType.nostrModel) {
        return ShortTextContentType.singleModel;
      }
    }

    // Check for paragraphs with only one type of content
    if (elements.length == 1 &&
        elements[0].type == LabShortTextElementType.paragraph &&
        elements[0].children != null) {
      final children = elements[0].children!;
      // Filter out whitespace and check if all remaining children are either emoji or utfEmoji
      final nonWhitespaceChildren = children.where((child) {
        return child.type != LabShortTextElementType.styledText ||
            child.content.trim().isNotEmpty;
      }).toList();

      // Check if all non-whitespace children are either emoji or utfEmoji, and there are 1-2 of them
      if (nonWhitespaceChildren.length <= 2 &&
          nonWhitespaceChildren.every((child) =>
              child.type == LabShortTextElementType.emoji ||
              child.type == LabShortTextElementType.utfEmoji)) {
        return ShortTextContentType.singleEmoji;
      } else {}
    }

    // Mixed content
    return ShortTextContentType.mixed;
  }

  @override
  Widget build(BuildContext context) {
    final parser = LabShortTextParser();
    final elements = parser.parse(content);
    final widgets = _buildElements(elements, context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  List<Widget> _buildElements(
      List<LabShortTextElement> elements, BuildContext context) {
    return [
      for (final element in elements)
        _buildElementWithSpacing(element, context),
    ];
  }

  Widget _buildElementWithSpacing(
      LabShortTextElement element, BuildContext context) {
    final (isInsideMessageBubble, _) = MessageBubbleScope.of(context);

    final contentType = ShortTextContent.of(context);

    final LabEdgeInsets spacing = switch (element.type) {
      LabShortTextElementType.listItem => const LabEdgeInsets.only(
          bottom: LabGapSize.s6,
        ),
      _ => isInsideMessageBubble && contentType.isSingleContent
          ? const LabEdgeInsets.all(LabGapSize.none)
          : const LabEdgeInsets.only(
              bottom: LabGapSize.s4,
            ),
    };

    // Determine if this element should be swipeable (paragraphs and certain other content)
    final bool isSwipeable = switch (element.type) {
      LabShortTextElementType.paragraph => true,
      _ => false,
    };

    final Widget content = _buildElement(context, element);

    if (!isSwipeable) {
      return LabContainer(
        padding: spacing,
        child: content,
      );
    }

    return LabContainer(
      padding: spacing,
      child: content,
    );
  }

  Widget _buildElement(BuildContext context, LabShortTextElement element) {
    final theme = LabTheme.of(context);
    final (isInsideMessageBubble, _) = MessageBubbleScope.of(context);

    switch (element.type) {
      case LabShortTextElementType.images:
        final urls = element.content.split('\n');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LabGap.s2(),
            LabImageStack(images: urls),
            const LabGap.s2(),
          ],
        );

      case LabShortTextElementType.emoji:
        return FutureBuilder<String>(
          future: onResolveEmoji(element.content, model),
          builder: (context, snapshot) {
            return LabContainer(
              padding: const LabEdgeInsets.symmetric(horizontal: LabGapSize.s2),
              child: LabEmojiImage(
                emojiUrl: snapshot.data ?? '',
                emojiName: element.content,
                size: ShortTextContent.of(context) ==
                        ShortTextContentType.singleEmoji
                    ? 80
                    : 17,
              ),
            );
          },
        );

      case LabShortTextElementType.utfEmoji:
        return Text(
          element.content,
          style: theme.typography.reg14.copyWith(
            color: theme.colors.white,
            height: 1.0,
            fontSize:
                ShortTextContent.of(context) == ShortTextContentType.singleEmoji
                    ? 64
                    : 16,
          ),
        );

      case LabShortTextElementType.audio:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LabGap.s2(),
            LabAudioMessage(audioUrl: element.content),
            const LabGap.s2(),
          ],
        );

      case LabShortTextElementType.codeBlock:
        return LabCodeBlock(
          code: element.content,
          language: element.attributes?['language'] ?? 'plain',
        );

      case LabShortTextElementType.listItem:
      case LabShortTextElementType.orderedListItem:
        final String number = element.attributes?['number'] ?? '•';
        final String displayNumber =
            element.type == LabShortTextElementType.orderedListItem
                ? '$number.'
                : number;
        return Padding(
          padding: EdgeInsets.only(
            left: (int.tryParse(element.attributes?['level'] ?? '0') ?? 0) * 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabContainer(
                padding: const LabEdgeInsets.only(
                  right: LabGapSize.s8,
                ),
                child: LabText.reg14(
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
                        style: theme.typography.reg14.copyWith(
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
                    : LabText.reg14(
                        element.content,
                        color: theme.colors.white,
                      ),
              ),
            ],
          ),
        );
      case LabShortTextElementType.checkListItem:
        return Padding(
          padding: EdgeInsets.only(
            left: (int.tryParse(element.attributes?['level'] ?? '0') ?? 0) * 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabCheckBox(
                value: element.checked ?? false,
                onChanged: null,
              ),
              const LabGap.s8(),
              Expanded(
                child: element.children != null
                    ? LabSelectableText.rich(
                        TextSpan(
                          children:
                              _buildInlineElements(context, element.children!),
                        ),
                        style: theme.typography.reg14.copyWith(
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
                    : LabText.reg14(
                        element.content,
                        color: theme.colors.white,
                      ),
              ),
            ],
          ),
        );

      case LabShortTextElementType.paragraph:
        if (element.children != null) {
          final List<Widget> paragraphPieces = [];
          final List<InlineSpan> currentSpans = [];

          // Check if this is a singleEmoji case
          if (ShortTextContent.of(context) ==
              ShortTextContentType.singleEmoji) {
            return LabContainer(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < element.children!.length; i++) ...[
                    if (element.children![i].type ==
                        LabShortTextElementType.emoji)
                      FutureBuilder<String>(
                        future:
                            onResolveEmoji(element.children![i].content, model),
                        builder: (context, snapshot) {
                          return LabEmojiImage(
                            emojiUrl: snapshot.data ?? '',
                            emojiName: snapshot.data ?? '',
                            size: 80,
                            opacity: 1.0,
                          );
                        },
                      )
                    else if (element.children![i].type ==
                        LabShortTextElementType.utfEmoji)
                      Text(
                        element.children![i].content,
                        style: theme.typography.reg14.copyWith(
                          color: theme.colors.white,
                          height: 1.0,
                          fontSize: 72,
                        ),
                      ),
                    if (i == 0 && element.children!.length > 1)
                      const LabGap.s12(),
                  ],
                ],
              ),
            );
          }

          for (var child in element.children!) {
            if (child.type == LabShortTextElementType.nostrModel) {
              if (currentSpans.isNotEmpty) {
                paragraphPieces.add(
                  LabContainer(
                    padding: LabEdgeInsets.symmetric(
                      horizontal: isInsideMessageBubble
                          ? LabGapSize.s4
                          : LabGapSize.none,
                    ),
                    child: LabSelectableText.rich(
                      TextSpan(children: List.from(currentSpans)),
                      style: theme.typography.reg14.copyWith(
                        color: theme.colors.white,
                      ),
                    ),
                  ),
                );
                currentSpans.clear();
              }
              paragraphPieces.add(isInsideMessageBubble
                  ? const LabGap.s2()
                  : const LabGap.s8());
              paragraphPieces.add(
                FutureBuilder<({Model model, VoidCallback? onTap})>(
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
                        onResolveEvent: onResolveEvent,
                        onResolveProfile: onResolveProfile,
                        onResolveEmoji: onResolveEmoji,
                        onResolveHashtag: onResolveHashtag,
                      ),
                    );
                  },
                ),
              );
              paragraphPieces.add(isInsideMessageBubble
                  ? const LabGap.s4()
                  : const LabGap.s8());
            } else if (child.type == LabShortTextElementType.audio) {
              if (currentSpans.isNotEmpty) {
                paragraphPieces.add(
                  LabContainer(
                    padding: LabEdgeInsets.symmetric(
                      horizontal: isInsideMessageBubble
                          ? LabGapSize.s4
                          : LabGapSize.none,
                    ),
                    child: LabSelectableText.rich(
                      TextSpan(children: List.from(currentSpans)),
                      style: theme.typography.reg14.copyWith(
                        color: theme.colors.white,
                      ),
                    ),
                  ),
                );
                currentSpans.clear();
              }
              paragraphPieces.add(const LabGap.s2());
              paragraphPieces.add(
                LabAudioMessage(audioUrl: child.content),
              );
              paragraphPieces.add(const LabGap.s2());
            } else if (child.type == LabShortTextElementType.utfEmoji) {
              final contentType = ShortTextContent.of(context);
              if (contentType == ShortTextContentType.singleEmoji) {
                // For singleEmoji, render as block
                if (currentSpans.isNotEmpty) {
                  paragraphPieces.add(
                    LabContainer(
                      padding: LabEdgeInsets.symmetric(
                        horizontal: isInsideMessageBubble
                            ? LabGapSize.s4
                            : LabGapSize.none,
                      ),
                      child: LabSelectableText.rich(
                        TextSpan(children: List.from(currentSpans)),
                        style: theme.typography.reg14.copyWith(
                          color: theme.colors.white,
                        ),
                      ),
                    ),
                  );
                  currentSpans.clear();
                }
                paragraphPieces.add(const LabGap.s2());
                paragraphPieces.add(
                  LabContainer(
                    padding: const LabEdgeInsets.symmetric(
                        horizontal: LabGapSize.s2),
                    child: Text(
                      child.content,
                      style: theme.typography.reg14.copyWith(
                        color: theme.colors.white,
                        fontSize: 72,
                      ),
                    ),
                  ),
                );
                paragraphPieces.add(const LabGap.s2());
              } else {
                // For inline rendering
                currentSpans.add(TextSpan(
                  text: child.content,
                  style: theme.typography.reg14.copyWith(
                    color: theme.colors.white,
                    fontSize: 16,
                  ),
                ));
              }
            } else if (child.type == LabShortTextElementType.emoji) {
              final contentType = ShortTextContent.of(context);
              if (contentType == ShortTextContentType.singleEmoji) {
                // For singleEmoji, render as block
                if (currentSpans.isNotEmpty) {
                  paragraphPieces.add(
                    LabContainer(
                      padding: LabEdgeInsets.symmetric(
                        horizontal: isInsideMessageBubble
                            ? LabGapSize.s4
                            : LabGapSize.none,
                      ),
                      child: LabSelectableText.rich(
                        TextSpan(children: List.from(currentSpans)),
                        style: theme.typography.reg14.copyWith(
                          color: theme.colors.white,
                        ),
                      ),
                    ),
                  );
                  currentSpans.clear();
                }
                paragraphPieces.add(const LabGap.s2());
                paragraphPieces.add(
                  FutureBuilder<String>(
                    future: onResolveEmoji(child.content, model),
                    builder: (context, snapshot) {
                      return LabContainer(
                        padding: const LabEdgeInsets.symmetric(
                            horizontal: LabGapSize.s2),
                        child: LabEmojiImage(
                          emojiUrl: snapshot.data ?? '',
                          emojiName: snapshot.data ?? '',
                          size: 80,
                        ),
                      );
                    },
                  ),
                );
                paragraphPieces.add(const LabGap.s2());
              } else {
                // For inline rendering
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
                        future: onResolveEmoji(child.content, model),
                        builder: (context, snapshot) {
                          return LabContainer(
                            padding: const LabEdgeInsets.symmetric(
                                horizontal: LabGapSize.s2),
                            child: LabEmojiImage(
                              emojiUrl: snapshot.data ?? '',
                              emojiName: snapshot.data ?? '',
                              size: 17,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ));
              }
            } else {
              // Handle all other elements exactly as before
              if (child.type == LabShortTextElementType.nostrProfile) {
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
                          if (!snapshot.hasData) {
                            return LabText.reg12(
                              '@${child.content}',
                              color: theme.colors.blurpleLightColor,
                            );
                          }
                          return LabProfileInline(
                            profile: snapshot.data!.profile,
                            onTap: snapshot.data?.onTap,
                          );
                        },
                      ),
                    ),
                  ],
                ));
              } else if (child.type == LabShortTextElementType.hashtag) {
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
                                  style: theme.typography.reg14.copyWith(
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
                ));
              } else if (child.type == LabShortTextElementType.link) {
                currentSpans.add(TextSpan(
                  text: child.content,
                  style: theme.typography.reg14.copyWith(
                    color: theme.colors.blurpleLightColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        onLinkTap(child.attributes?['url'] ?? child.content),
                ));
              } else if (child.type == LabShortTextElementType.monospace) {
                currentSpans.add(TextSpan(
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
                            height: 20,
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
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
              } else if (child.type == LabShortTextElementType.images) {
                final urls = child.content.split('\n');
                if (currentSpans.isNotEmpty) {
                  paragraphPieces.add(
                    LabContainer(
                      padding: LabEdgeInsets.symmetric(
                        horizontal: isInsideMessageBubble
                            ? LabGapSize.s4
                            : LabGapSize.none,
                      ),
                      child: LabSelectableText.rich(
                        TextSpan(children: List.from(currentSpans)),
                        style: theme.typography.reg14.copyWith(
                          color: theme.colors.white,
                        ),
                      ),
                    ),
                  );
                  currentSpans.clear();
                }
                paragraphPieces.add(const LabGap.s2());
                paragraphPieces.add(
                  LabImageStack(
                    images: urls,
                  ),
                );
                paragraphPieces.add(const LabGap.s4());
              } else {
                currentSpans.add(TextSpan(
                  text: child.content,
                  style: theme.typography.reg14.copyWith(
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
              LabContainer(
                padding: LabEdgeInsets.symmetric(
                  horizontal:
                      isInsideMessageBubble ? LabGapSize.s4 : LabGapSize.none,
                ),
                child: LabSelectableText.rich(
                  TextSpan(
                    children: currentSpans,
                    style: theme.typography.reg14.copyWith(
                      color: theme.colors.white,
                    ),
                  ),
                  style: theme.typography.reg14.copyWith(
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
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: paragraphPieces,
          );
        }
        return LabContainer(
          padding: LabEdgeInsets.symmetric(
            horizontal: isInsideMessageBubble ? LabGapSize.s4 : LabGapSize.none,
          ),
          child: LabSelectableText(
            text: element.content,
            style: theme.typography.reg14.copyWith(
              color: theme.colors.white,
            ),
          ),
        );

      case LabShortTextElementType.styledText:
        return Text(
          element.content,
          style: theme.typography.reg14.copyWith(
            color: theme.colors.white,
            fontWeight:
                element.attributes?['style'] == 'bold' ? FontWeight.bold : null,
            fontStyle: element.attributes?['style'] == 'italic'
                ? FontStyle.italic
                : null,
          ),
        );

      case LabShortTextElementType.heading1:
        return LabContainer(
          padding: const LabEdgeInsets.only(top: LabGapSize.s8),
          child: LabText.bold16(element.content),
        );
      case LabShortTextElementType.heading2:
        return LabText.bold16(element.content, color: theme.colors.white66);
      case LabShortTextElementType.heading3:
        return LabText.bold12(element.content);
      case LabShortTextElementType.heading4:
        return LabText.bold12(element.content, color: theme.colors.white66);
      case LabShortTextElementType.heading5:
        return LabText.bold12(element.content);

      case LabShortTextElementType.blockQuote:
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabContainer(
                width: LabLineThicknessData.normal().thick,
                decoration: BoxDecoration(
                  color: theme.colors.white33,
                  borderRadius: theme.radius.asBorderRadius().rad16,
                ),
                margin: const LabEdgeInsets.only(
                  left: LabGapSize.s4,
                  right: LabGapSize.s4,
                  top: LabGapSize.s2,
                  bottom: LabGapSize.s2,
                ),
              ),
              Expanded(
                child: element.children != null
                    ? LabContainer(
                        padding: const LabEdgeInsets.symmetric(
                          horizontal: LabGapSize.s4,
                        ),
                        child: LabSelectableText.rich(
                          TextSpan(
                            children: _buildStyledTextSpans(
                                context, element.children!),
                          ),
                          style: theme.typography.reg14.copyWith(
                            color: theme.colors.white,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        );

      default:
        return LabText.reg14(element.content);
    }
  }

  List<InlineSpan> _buildInlineElements(
      BuildContext context, List<LabShortTextElement> children) {
    final theme = LabTheme.of(context);
    return children.map((child) {
      if (child.type == LabShortTextElementType.nostrProfile) {
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
                  if (!snapshot.hasData) {
                    return LabText.reg12(
                      '@${child.content}',
                      color: theme.colors.blurpleLightColor,
                    );
                  }
                  return LabProfileInline(
                    profile: snapshot.data!.profile,
                    onTap: snapshot.data?.onTap,
                  );
                },
              ),
            ),
          ],
        );
      } else if (child.type == LabShortTextElementType.emoji) {
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
                      size: 17,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      } else if (child.type == LabShortTextElementType.monospace) {
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
                    height: 20,
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
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      } else if (child.type == LabShortTextElementType.hashtag) {
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
                          style: theme.typography.reg14.copyWith(
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
      } else if (child.type == LabShortTextElementType.link) {
        return TextSpan(
          text: child.attributes?['text'] ?? child.content,
          style: theme.typography.reg14.copyWith(
            color: theme.colors.blurpleLightColor,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap =
                () => onLinkTap(child.attributes?['url'] ?? child.content),
        );
      } else {
        return TextSpan(
          text: child.content,
          style: theme.typography.reg14.copyWith(
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

  List<InlineSpan> _buildStyledTextSpans(
      BuildContext context, List<LabShortTextElement> elements) {
    final theme = LabTheme.of(context);
    return elements.map((element) {
      if (element.type == LabShortTextElementType.nostrProfile) {
        return TextSpan(
          children: [
            TextSpan(
              text: '@${element.content}',
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
                future: onResolveProfile(element.content),
                builder: (context, snapshot) {
                  return LabProfileInline(
                    profile: snapshot.data!.profile,
                    onTap: snapshot.data?.onTap,
                  );
                },
              ),
            ),
          ],
        );
      }

      if (element.type == LabShortTextElementType.emoji) {
        return TextSpan(
          children: [
            TextSpan(
              text: ':${element.content}:',
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
                future: onResolveEmoji(element.content, model),
                builder: (context, snapshot) {
                  return LabContainer(
                    padding: const LabEdgeInsets.symmetric(
                        horizontal: LabGapSize.s2),
                    child: LabEmojiImage(
                      emojiUrl: snapshot.data ?? '',
                      emojiName: snapshot.data ?? '',
                      size: ShortTextContent.of(context) ==
                              ShortTextContentType.singleEmoji
                          ? 80
                          : 17,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      } else if (element.type == LabShortTextElementType.monospace) {
        return TextSpan(
          children: [
            TextSpan(
              text: '`${element.content}`',
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
                    height: 20,
                    padding: const LabEdgeInsets.only(
                      left: LabGapSize.s4,
                      right: LabGapSize.s4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colors.white16,
                      borderRadius: theme.radius.asBorderRadius().rad4,
                    ),
                    child: LabText.code(
                      element.content,
                      color: theme.colors.white66,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      } else if (element.type == LabShortTextElementType.hashtag) {
        return TextSpan(
          children: [
            TextSpan(
              text: '#${element.content}',
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
                future: onResolveHashtag(element.content),
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
                          '#${element.content}',
                          style: theme.typography.reg14.copyWith(
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
      }

      final style = element.attributes?['style'];
      return TextSpan(
        text: element.content,
        style: TextStyle(
          color: style == 'url'
              ? theme.colors.blurpleLightColor
              : theme.colors.white,
          fontWeight: (style == 'bold' || style == 'bold-italic')
              ? FontWeight.bold
              : null,
          fontStyle: (style == 'italic' || style == 'bold-italic')
              ? FontStyle.italic
              : null,
          decoration: switch (style) {
            'underline' => TextDecoration.underline,
            'line-through' => TextDecoration.lineThrough,
            'url' => TextDecoration.underline,
            _ => null,
          },
        ),
      );
    }).toList();
  }
}
