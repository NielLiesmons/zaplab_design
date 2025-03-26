import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:flutter/gestures.dart';

enum ShortTextContentType {
  empty,
  singleImageStack,
  singleEmoji,
  singleProfile,
  singleEvent,
  mixed;

  bool get isSingleContent => switch (this) {
        ShortTextContentType.singleImageStack ||
        ShortTextContentType.singleEmoji ||
        ShortTextContentType.singleProfile ||
        ShortTextContentType.singleEvent =>
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

    // Single paragraph with one child
    if (elements.length == 1 &&
        elements[0].type == AppShortTextElementType.paragraph &&
        elements[0].children != null &&
        elements[0].children!.length == 1) {
      final child = elements[0].children![0];

      // Single emoji
      if (child.type == AppShortTextElementType.emoji) {
        return ShortTextContentType.singleEmoji;
      }

      // Single profile
      if (child.type == AppShortTextElementType.nostrProfile) {
        return ShortTextContentType.singleProfile;
      }

      // Single event
      if (child.type == AppShortTextElementType.nostrEvent) {
        return ShortTextContentType.singleEvent;
      }
    }

    // Check for paragraphs with only one type of content
    if (elements.length == 1 &&
        elements[0].type == AppShortTextElementType.paragraph &&
        elements[0].children != null) {
      final children = elements[0].children!;
    }

    // Mixed content
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

    debugPrint(
        'Building element of type: ${element.type} with content: ${element.content}');

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
      case AppShortTextElementType.paragraph:
        if (element.children != null) {
          final List<Widget> paragraphPieces = [];
          final List<InlineSpan> currentSpans = [];

          for (var child in element.children!) {
            if (child.type == AppShortTextElementType.nostrEvent) {
              if (currentSpans.isNotEmpty) {
                paragraphPieces.add(
                  AppSelectableText.rich(
                    TextSpan(children: List.from(currentSpans)),
                    style: theme.typography.reg14.copyWith(
                      color: theme.colors.white,
                    ),
                  ),
                );
                currentSpans.clear();
              }
              paragraphPieces.add(const AppGap.s2());
              paragraphPieces.add(
                FutureBuilder<Event>(
                  future: onResolveEvent(child.content),
                  builder: (context, snapshot) {
                    return AppEventCard(
                        // contentType: snapshot.data?.contentType ?? '',
                        // title: snapshot.data?.title ?? '',
                        // message: snapshot.data?.message ?? '',
                        // content: snapshot.data?.content ?? '',
                        // imageUrl: snapshot.data?.imageUrl ?? '',
                        // profileName: snapshot.data?.profileName ?? '',
                        // profilePicUrl: snapshot.data?.profilePicUrl ?? '',
                        // timestamp: snapshot.data?.timestamp ?? DateTime.now(),
                        // amount: snapshot.data?.amount ?? '',
                        // onTap: snapshot.data?.onTap,
                        );
                  },
                ),
              );
              paragraphPieces.add(const AppGap.s2());
            } else if (child.type == AppShortTextElementType.emoji &&
                ShortTextContent.of(context) ==
                    ShortTextContentType.singleEmoji) {
              if (currentSpans.isNotEmpty) {
                paragraphPieces.add(
                  AppSelectableText.rich(
                    TextSpan(children: List.from(currentSpans)),
                    style: theme.typography.reg14.copyWith(
                      color: theme.colors.white,
                    ),
                  ),
                );
                currentSpans.clear();
              }
              paragraphPieces.add(
                FutureBuilder<String>(
                  future: onResolveEmoji(child.content),
                  builder: (context, snapshot) {
                    return AppContainer(
                      child: AppEmojiImage(
                        emojiUrl: snapshot.data ?? '',
                        emojiName: snapshot.data ?? '',
                        size: 96,
                      ),
                    );
                  },
                ),
              );
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
                      child: FutureBuilder<Profile>(
                        future: onResolveProfile(child.content),
                        builder: (context, snapshot) {
                          return AppProfileInline(
                            profileName: snapshot.data?.nameOrNpub ?? '',
                            profilePicUrl: snapshot.data?.pictureUrl ?? '',
                            // TODO: onTap
                            // onTap: snapshot.data?.onTap,
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
              } else if (child.type == AppShortTextElementType.link) {
                currentSpans.add(TextSpan(
                  text: child.content,
                  style: theme.typography.reg14.copyWith(
                    color: theme.colors.blurpleColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => onLinkTap(child.content),
                ));
              } else if (child.type == AppShortTextElementType.images) {
                final urls = child.content.split('\n');
                if (currentSpans.isNotEmpty) {
                  paragraphPieces.add(
                    AppSelectableText.rich(
                      TextSpan(children: List.from(currentSpans)),
                      style: theme.typography.reg14.copyWith(
                        color: theme.colors.white,
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
                paragraphPieces.add(const AppGap.s2());
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
                  TextSpan(children: List.from(currentSpans)),
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

      case AppShortTextElementType.blockQuote:
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppContainer(
                width: LineThicknessData.normal().thick,
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
              child: FutureBuilder<Profile>(
                future: onResolveProfile(element.content),
                builder: (context, snapshot) {
                  return AppProfileInline(
                    profileName: snapshot.data?.nameOrNpub ?? '',
                    profilePicUrl: snapshot.data?.pictureUrl ?? '',
                    // TODO: onTap
                    // onTap: snapshot.data?.onTap,
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
                          ? 96
                          : 16,
                    ),
                  );
                },
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
        );
      }

      final style = element.attributes?['style'];
      return TextSpan(
        text: element.content,
        style: TextStyle(
          color:
              style == 'url' ? theme.colors.blurpleColor : theme.colors.white,
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
