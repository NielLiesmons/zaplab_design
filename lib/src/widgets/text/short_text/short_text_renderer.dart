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

class AppShortTextRenderer extends StatelessWidget {
  final String content;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;

  const AppShortTextRenderer({
    super.key,
    required this.content,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
  });

  static ShortTextContentType analyzeContent(String content) {
    final parser = AppShortTextParser();
    final elements = parser.parse(content);
    return _analyzeElements(elements);
  }

  static ShortTextContentType _analyzeElements(
      List<AppShortTextElement> elements) {
    if (elements.isEmpty) {
      return ShortTextContentType.empty;
    }

    // Single image stack
    if (elements.length == 1 &&
        elements[0].type == AppShortTextElementType.images) {
      return ShortTextContentType.singleImageStack;
    }

    // Single emoji
    if (elements.length == 1 &&
        (elements[0].type == AppShortTextElementType.emoji ||
            elements[0].type == AppShortTextElementType.utfEmoji)) {
      return ShortTextContentType.singleEmoji;
    }

    // Single paragraph with one child
    if (elements.length == 1 &&
        elements[0].type == AppShortTextElementType.paragraph &&
        elements[0].children != null &&
        elements[0].children!.length == 1) {
      final child = elements[0].children![0];

      // Single profile
      if (child.type == AppShortTextElementType.nostrProfile) {
        return ShortTextContentType.singleProfile;
      }

      // Single model
      if (child.type == AppShortTextElementType.nostrModel) {
        return ShortTextContentType.singleModel;
      }
    }

    // Check for paragraphs with only one type of content
    if (elements.length == 1 &&
        elements[0].type == AppShortTextElementType.paragraph &&
        elements[0].children != null) {
      final children = elements[0].children!;
      print('Analyzing paragraph with ${children.length} children');
      // Filter out whitespace and check if all remaining children are either emoji or utfEmoji
      final nonWhitespaceChildren = children.where((child) {
        print('Child type: ${child.type}, content: ${child.content}');
        return child.type != AppShortTextElementType.styledText ||
            child.content.trim().isNotEmpty;
      }).toList();
      print('Non-whitespace children count: ${nonWhitespaceChildren.length}');

      // Check if all non-whitespace children are either emoji or utfEmoji, and there are 1-2 of them
      if (nonWhitespaceChildren.length <= 2 &&
          nonWhitespaceChildren.every((child) =>
              child.type == AppShortTextElementType.emoji ||
              child.type == AppShortTextElementType.utfEmoji)) {
        print('Detected singleEmoji content type');
        return ShortTextContentType.singleEmoji;
      } else {
        print(
            'Not singleEmoji: ${nonWhitespaceChildren.length} children, types: ${nonWhitespaceChildren.map((c) => c.type).join(', ')}');
      }
    }

    // Mixed content
    print('Falling back to mixed content type');
    return ShortTextContentType.mixed;
  }

  @override
  Widget build(BuildContext context) {
    final parser = AppShortTextParser();
    final elements = parser.parse(content);
    final widgets = _buildElements(elements, context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  List<Widget> _buildElements(
      List<AppShortTextElement> elements, BuildContext context) {
    return [
      for (final element in elements)
        _buildElementWithSpacing(element, context),
    ];
  }

  Widget _buildElementWithSpacing(
      AppShortTextElement element, BuildContext context) {
    final (isInsideMessageBubble, _) = MessageBubbleScope.of(context);
    final contentType = ShortTextContent.of(context);

    final AppEdgeInsets spacing = switch (element.type) {
      AppShortTextElementType.listItem => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
        ),
      _ => isInsideMessageBubble && contentType.isSingleContent
          ? const AppEdgeInsets.all(AppGapSize.none)
          : const AppEdgeInsets.only(
              bottom: AppGapSize.s4,
            ),
    };

    // Determine if this element should be swipeable (paragraphs and certain other content)
    final bool isSwipeable = switch (element.type) {
      AppShortTextElementType.paragraph => true,
      _ => false,
    };

    final Widget content = _buildElement(context, element);

    if (!isSwipeable) {
      return AppContainer(
        padding: spacing,
        child: content,
      );
    }

    return AppContainer(
      padding: spacing,
      child: content,
    );
  }

  Widget _buildElement(BuildContext context, AppShortTextElement element) {
    final theme = AppTheme.of(context);
    final (isInsideMessageBubble, _) = MessageBubbleScope.of(context);

    switch (element.type) {
      case AppShortTextElementType.images:
        final urls = element.content.split('\n');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppGap.s2(),
            AppImageStack(imageUrls: urls),
            const AppGap.s2(),
          ],
        );

      case AppShortTextElementType.emoji:
        return FutureBuilder<String>(
          future: onResolveEmoji(element.content),
          builder: (context, snapshot) {
            return AppContainer(
              padding: const AppEdgeInsets.symmetric(horizontal: AppGapSize.s2),
              child: AppEmojiImage(
                emojiUrl: snapshot.data ?? '',
                emojiName: snapshot.data ?? '',
                size: ShortTextContent.of(context) ==
                        ShortTextContentType.singleEmoji
                    ? 80
                    : 17,
              ),
            );
          },
        );

      case AppShortTextElementType.utfEmoji:
        return Text(
          element.content,
          style: theme.typography.reg14.copyWith(
            color: theme.colors.white,
            fontSize:
                ShortTextContent.of(context) == ShortTextContentType.singleEmoji
                    ? 64
                    : 16,
          ),
        );

      case AppShortTextElementType.audio:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppGap.s2(),
            AppAudioMessage(audioUrl: element.content),
            const AppGap.s2(),
          ],
        );

      case AppShortTextElementType.codeBlock:
        return AppCodeBlock(
          code: element.content,
          language: element.attributes?['language'] ?? 'plain',
        );

      case AppShortTextElementType.listItem:
      case AppShortTextElementType.orderedListItem:
        final String number = element.attributes?['number'] ?? '•';
        final String displayNumber =
            element.type == AppShortTextElementType.orderedListItem
                ? '$number.'
                : number;
        return Padding(
          padding: EdgeInsets.only(
            left: (int.tryParse(element.attributes?['level'] ?? '0') ?? 0) * 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppContainer(
                padding: const AppEdgeInsets.only(
                  right: AppGapSize.s8,
                ),
                child: AppText.reg14(
                  displayNumber,
                  color: theme.colors.white66,
                ),
              ),
              Expanded(
                child: element.children != null
                    ? AppSelectableText.rich(
                        TextSpan(
                          children:
                              _buildInlineElements(context, element.children!),
                        ),
                        style: theme.typography.reg14.copyWith(
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
                      )
                    : AppText.reg14(
                        element.content,
                        color: theme.colors.white,
                      ),
              ),
            ],
          ),
        );
      case AppShortTextElementType.checkListItem:
        return Padding(
          padding: EdgeInsets.only(
            left: (int.tryParse(element.attributes?['level'] ?? '0') ?? 0) * 16,
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
                child: element.children != null
                    ? AppSelectableText.rich(
                        TextSpan(
                          children:
                              _buildInlineElements(context, element.children!),
                        ),
                        style: theme.typography.reg14.copyWith(
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
                      )
                    : AppText.reg14(
                        element.content,
                        color: theme.colors.white,
                      ),
              ),
            ],
          ),
        );

      case AppShortTextElementType.paragraph:
        if (element.children != null) {
          final List<Widget> paragraphPieces = [];
          final List<InlineSpan> currentSpans = [];

          // Check if this is a singleEmoji case
          if (ShortTextContent.of(context) ==
              ShortTextContentType.singleEmoji) {
            return AppContainer(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < element.children!.length; i++) ...[
                    if (element.children![i].type ==
                        AppShortTextElementType.emoji)
                      FutureBuilder<String>(
                        future: onResolveEmoji(element.children![i].content),
                        builder: (context, snapshot) {
                          return AppEmojiImage(
                            emojiUrl: snapshot.data ?? '',
                            emojiName: snapshot.data ?? '',
                            size: 96,
                            opacity: 1.0,
                          );
                        },
                      )
                    else if (element.children![i].type ==
                        AppShortTextElementType.utfEmoji)
                      Text(
                        element.children![i].content,
                        style: theme.typography.reg14.copyWith(
                          color: theme.colors.white,
                          fontSize: 64,
                        ),
                      ),
                    if (i == 0 && element.children!.length == 2)
                      const AppGap.s4(),
                  ],
                ],
              ),
            );
          }

          for (var child in element.children!) {
            if (child.type == AppShortTextElementType.nostrModel) {
              if (currentSpans.isNotEmpty) {
                paragraphPieces.add(
                  AppContainer(
                    padding: AppEdgeInsets.symmetric(
                      horizontal: isInsideMessageBubble
                          ? AppGapSize.s4
                          : AppGapSize.none,
                    ),
                    child: AppSelectableText.rich(
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
                  ? const AppGap.s2()
                  : const AppGap.s8());
              paragraphPieces.add(
                FutureBuilder<({Model model, VoidCallback? onTap})>(
                  future: onResolveEvent(child.content),
                  builder: (context, snapshot) {
                    return ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: AppModelCard(
                        model: snapshot.data?.model,
                        onTap: snapshot.data?.onTap,
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
                  ? const AppGap.s4()
                  : const AppGap.s8());
            } else if (child.type == AppShortTextElementType.audio) {
              if (currentSpans.isNotEmpty) {
                paragraphPieces.add(
                  AppContainer(
                    padding: AppEdgeInsets.symmetric(
                      horizontal: isInsideMessageBubble
                          ? AppGapSize.s4
                          : AppGapSize.none,
                    ),
                    child: AppSelectableText.rich(
                      TextSpan(children: List.from(currentSpans)),
                      style: theme.typography.reg14.copyWith(
                        color: theme.colors.white,
                      ),
                    ),
                  ),
                );
                currentSpans.clear();
              }
              paragraphPieces.add(const AppGap.s2());
              paragraphPieces.add(
                AppAudioMessage(audioUrl: child.content),
              );
              paragraphPieces.add(const AppGap.s2());
            } else if (child.type == AppShortTextElementType.utfEmoji) {
              final contentType = ShortTextContent.of(context);
              if (contentType == ShortTextContentType.singleEmoji) {
                // For singleEmoji, render as block
                if (currentSpans.isNotEmpty) {
                  paragraphPieces.add(
                    AppContainer(
                      padding: AppEdgeInsets.symmetric(
                        horizontal: isInsideMessageBubble
                            ? AppGapSize.s4
                            : AppGapSize.none,
                      ),
                      child: AppSelectableText.rich(
                        TextSpan(children: List.from(currentSpans)),
                        style: theme.typography.reg14.copyWith(
                          color: theme.colors.white,
                        ),
                      ),
                    ),
                  );
                  currentSpans.clear();
                }
                paragraphPieces.add(const AppGap.s2());
                paragraphPieces.add(
                  AppContainer(
                    padding: const AppEdgeInsets.symmetric(
                        horizontal: AppGapSize.s2),
                    child: Text(
                      child.content,
                      style: theme.typography.reg14.copyWith(
                        color: theme.colors.white,
                        fontSize: 64,
                      ),
                    ),
                  ),
                );
                paragraphPieces.add(const AppGap.s2());
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
            } else if (child.type == AppShortTextElementType.emoji) {
              final contentType = ShortTextContent.of(context);
              if (contentType == ShortTextContentType.singleEmoji) {
                // For singleEmoji, render as block
                if (currentSpans.isNotEmpty) {
                  paragraphPieces.add(
                    AppContainer(
                      padding: AppEdgeInsets.symmetric(
                        horizontal: isInsideMessageBubble
                            ? AppGapSize.s4
                            : AppGapSize.none,
                      ),
                      child: AppSelectableText.rich(
                        TextSpan(children: List.from(currentSpans)),
                        style: theme.typography.reg14.copyWith(
                          color: theme.colors.white,
                        ),
                      ),
                    ),
                  );
                  currentSpans.clear();
                }
                paragraphPieces.add(const AppGap.s2());
                paragraphPieces.add(
                  FutureBuilder<String>(
                    future: onResolveEmoji(child.content),
                    builder: (context, snapshot) {
                      return AppContainer(
                        padding: const AppEdgeInsets.symmetric(
                            horizontal: AppGapSize.s2),
                        child: AppEmojiImage(
                          emojiUrl: snapshot.data ?? '',
                          emojiName: snapshot.data ?? '',
                          size: 80,
                        ),
                      );
                    },
                  ),
                );
                paragraphPieces.add(const AppGap.s2());
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
                        future: onResolveEmoji(child.content),
                        builder: (context, snapshot) {
                          return AppContainer(
                            padding: const AppEdgeInsets.symmetric(
                                horizontal: AppGapSize.s2),
                            child: AppEmojiImage(
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
              if (child.type == AppShortTextElementType.nostrProfile) {
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
                            return AppText.reg12(
                              '@${child.content}',
                              color: theme.colors.blurpleLightColor,
                            );
                          }
                          return AppProfileInline(
                            profile: snapshot.data!.profile,
                            onTap: snapshot.data?.onTap,
                          );
                        },
                      ),
                    ),
                  ],
                ));
              } else if (child.type == AppShortTextElementType.hashtag) {
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
              } else if (child.type == AppShortTextElementType.link) {
                currentSpans.add(TextSpan(
                  text: child.content,
                  style: theme.typography.reg14.copyWith(
                    color: theme.colors.blurpleLightColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        onLinkTap(child.attributes?['url'] ?? child.content),
                ));
              } else if (child.type == AppShortTextElementType.monospace) {
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
                          const AppGap.s2(),
                          AppContainer(
                            height: 20,
                            padding: const AppEdgeInsets.only(
                              left: AppGapSize.s4,
                              right: AppGapSize.s4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colors.white16,
                              borderRadius: theme.radius.asBorderRadius().rad4,
                            ),
                            child: AppText.code(
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
              } else if (child.type == AppShortTextElementType.images) {
                final urls = child.content.split('\n');
                if (currentSpans.isNotEmpty) {
                  paragraphPieces.add(
                    AppContainer(
                      padding: AppEdgeInsets.symmetric(
                        horizontal: isInsideMessageBubble
                            ? AppGapSize.s4
                            : AppGapSize.none,
                      ),
                      child: AppSelectableText.rich(
                        TextSpan(children: List.from(currentSpans)),
                        style: theme.typography.reg14.copyWith(
                          color: theme.colors.white,
                        ),
                      ),
                    ),
                  );
                  currentSpans.clear();
                }
                paragraphPieces.add(const AppGap.s2());
                paragraphPieces.add(
                  AppImageStack(
                    imageUrls: urls,
                  ),
                );
                paragraphPieces.add(const AppGap.s4());
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
              AppContainer(
                padding: AppEdgeInsets.symmetric(
                  horizontal:
                      isInsideMessageBubble ? AppGapSize.s4 : AppGapSize.none,
                ),
                child: AppSelectableText.rich(
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
                  selectionControls: AppTextSelectionControls(),
                  contextMenuItems: [
                    AppTextSelectionMenuItem(
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
        return AppContainer(
          padding: AppEdgeInsets.symmetric(
            horizontal: isInsideMessageBubble ? AppGapSize.s4 : AppGapSize.none,
          ),
          child: AppSelectableText(
            text: element.content,
            style: theme.typography.reg14.copyWith(
              color: theme.colors.white,
            ),
          ),
        );

      case AppShortTextElementType.styledText:
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

      case AppShortTextElementType.heading1:
        return AppContainer(
          padding: const AppEdgeInsets.only(top: AppGapSize.s8),
          child: AppText.bold16(element.content),
        );
      case AppShortTextElementType.heading2:
        return AppText.bold16(element.content, color: theme.colors.white66);
      case AppShortTextElementType.heading3:
        return AppText.bold12(element.content);
      case AppShortTextElementType.heading4:
        return AppText.bold12(element.content, color: theme.colors.white66);
      case AppShortTextElementType.heading5:
        return AppText.bold12(element.content);

      case AppShortTextElementType.blockQuote:
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppContainer(
                width: AppLineThicknessData.normal().thick,
                decoration: BoxDecoration(
                  color: theme.colors.white33,
                  borderRadius: theme.radius.asBorderRadius().rad16,
                ),
                margin: const AppEdgeInsets.only(
                  left: AppGapSize.s4,
                  right: AppGapSize.s4,
                  top: AppGapSize.s2,
                  bottom: AppGapSize.s2,
                ),
              ),
              Expanded(
                child: element.children != null
                    ? AppContainer(
                        padding: const AppEdgeInsets.symmetric(
                          horizontal: AppGapSize.s4,
                        ),
                        child: AppSelectableText.rich(
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
        return AppText.reg14(element.content);
    }
  }

  List<InlineSpan> _buildInlineElements(
      BuildContext context, List<AppShortTextElement> children) {
    final theme = AppTheme.of(context);
    return children.map((child) {
      if (child.type == AppShortTextElementType.nostrProfile) {
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
                    return AppText.reg12(
                      '@${child.content}',
                      color: theme.colors.blurpleLightColor,
                    );
                  }
                  return AppProfileInline(
                    profile: snapshot.data!.profile,
                    onTap: snapshot.data?.onTap,
                  );
                },
              ),
            ),
          ],
        );
      } else if (child.type == AppShortTextElementType.emoji) {
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
                future: onResolveEmoji(child.content),
                builder: (context, snapshot) {
                  return AppContainer(
                    padding: const AppEdgeInsets.symmetric(
                        horizontal: AppGapSize.s2),
                    child: AppEmojiImage(
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
      } else if (child.type == AppShortTextElementType.monospace) {
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
                  const AppGap.s2(),
                  AppContainer(
                    height: 20,
                    padding: const AppEdgeInsets.only(
                      left: AppGapSize.s4,
                      right: AppGapSize.s4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colors.white16,
                      borderRadius: theme.radius.asBorderRadius().rad4,
                    ),
                    child: AppText.code(
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
      } else if (child.type == AppShortTextElementType.hashtag) {
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
      } else if (child.type == AppShortTextElementType.link) {
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
      BuildContext context, List<AppShortTextElement> elements) {
    final theme = AppTheme.of(context);
    return elements.map((element) {
      if (element.type == AppShortTextElementType.nostrProfile) {
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
                  return AppProfileInline(
                    profile: snapshot.data!.profile,
                    onTap: snapshot.data?.onTap,
                  );
                },
              ),
            ),
          ],
        );
      }

      if (element.type == AppShortTextElementType.emoji) {
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
                future: onResolveEmoji(element.content),
                builder: (context, snapshot) {
                  return AppContainer(
                    padding: const AppEdgeInsets.symmetric(
                        horizontal: AppGapSize.s2),
                    child: AppEmojiImage(
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
      } else if (element.type == AppShortTextElementType.monospace) {
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
                  const AppGap.s2(),
                  AppContainer(
                    height: 20,
                    padding: const AppEdgeInsets.only(
                      left: AppGapSize.s4,
                      right: AppGapSize.s4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colors.white16,
                      borderRadius: theme.radius.asBorderRadius().rad4,
                    ),
                    child: AppText.code(
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
      } else if (element.type == AppShortTextElementType.hashtag) {
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
