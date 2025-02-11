import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class AppShortTextRenderer extends StatelessWidget {
  final String content;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;

  const AppShortTextRenderer({
    super.key,
    required this.content,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
  });

  @override
  Widget build(BuildContext context) {
    final parser = ShortTextParser();
    final elements = parser.parse(content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final element in elements)
          _buildElementWithSpacing(element, context),
      ],
    );
  }

  Widget _buildElementWithSpacing(
      ShortTextElement element, BuildContext context) {
    final theme = AppTheme.of(context);
    final AppEdgeInsets spacing = switch (element.type) {
      ShortTextElementType.heading1 => const AppEdgeInsets.only(
          top: AppGapSize.s4,
          bottom: AppGapSize.s6,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      ShortTextElementType.heading2 => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      ShortTextElementType.heading3 => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      ShortTextElementType.heading4 => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      ShortTextElementType.heading5 => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      ShortTextElementType.listItem => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      ShortTextElementType.orderedListItem => const AppEdgeInsets.only(
          bottom: AppGapSize.s6,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      ShortTextElementType.horizontalRule => const AppEdgeInsets.only(
          bottom: AppGapSize.none,
          left: AppGapSize.s16,
          right: AppGapSize.s16,
        ),
      ShortTextElementType.image => const AppEdgeInsets.only(
          bottom: AppGapSize.s8,
        ),
      _ => const AppEdgeInsets.only(
          bottom: AppGapSize.s4,
        ),
    };

    // Determine if this element should be swipeable (paragraphs and certain other content)
    final bool isSwipeable = switch (element.type) {
      ShortTextElementType.paragraph => true,
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

  Widget _buildElement(BuildContext context, ShortTextElement element) {
    final theme = AppTheme.of(context);

    switch (element.type) {
      case ShortTextElementType.heading1:
        return AppText.longformh1(element.content);
      case ShortTextElementType.heading2:
        return AppText.longformh2(element.content);
      case ShortTextElementType.heading3:
        return AppText.longformh3(element.content, color: theme.colors.white66);
      case ShortTextElementType.heading4:
        return AppText.longformh4(element.content);
      case ShortTextElementType.heading5:
        return AppText.longformh5(element.content, color: theme.colors.white66);
      case ShortTextElementType.codeBlock:
        return AppCodeBlock(
          code: element.content,
          language: element.attributes?['language'] ?? 'plain',
        );
      case ShortTextElementType.admonition:
        return AppAdmonition(
          type: element.attributes?['type'] ?? 'note',
          child: AppText.reg14(
            element.content,
            color: theme.colors.white,
          ),
        );
      case ShortTextElementType.listItem:
      case ShortTextElementType.orderedListItem:
        final String number = element.attributes?['number'] ?? '•';
        final String displayNumber =
            element.type == ShortTextElementType.orderedListItem
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
                child: AppText.reg14(
                  displayNumber,
                  color: theme.colors.white66,
                ),
              ),
              Expanded(
                child: AppText.reg14(
                  element.content,
                  color: theme.colors.white,
                ),
              ),
            ],
          ),
        );
      case ShortTextElementType.checkListItem:
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
                child: AppText.reg14(
                  element.content,
                  color: theme.colors.white,
                ),
              ),
            ],
          ),
        );
      case ShortTextElementType.descriptionListItem:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.bold14(element.content),
            if (element.attributes?['description'] != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 4,
                ),
                child: AppText.reg14(
                  element.attributes!['description']!,
                  color: theme.colors.white66,
                ),
              ),
          ],
        );
      case ShortTextElementType.horizontalRule:
        return const AppContainer(
          padding: AppEdgeInsets.symmetric(vertical: AppGapSize.s16),
          child: AppDivider(),
        );
      case ShortTextElementType.paragraph:
        if (element.children != null) {
          final List<Widget> paragraphPieces = [];
          final List<InlineSpan> currentSpans = [];

          for (var child in element.children!) {
            if (child.type == ShortTextElementType.nostrEvent) {
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
              paragraphPieces.add(const AppGap.s4());
              paragraphPieces.add(
                FutureBuilder<NostrEventData>(
                  future: onResolveEvent(child.content),
                  builder: (context, snapshot) {
                    return AppEventCard(
                      contentType: snapshot.data?.contentType ?? '',
                      title: snapshot.data?.title ?? '',
                      message: snapshot.data?.message ?? '',
                      profileName: snapshot.data?.profileName ?? '',
                      profilePicUrl: snapshot.data?.profilePicUrl ?? '',
                      timestamp: snapshot.data?.timestamp ?? DateTime.now(),
                      onTap: snapshot.data?.onTap,
                    );
                  },
                ),
              );
              paragraphPieces.add(const AppGap.s4());
            } else {
              // Handle all other elements exactly as before
              if (child.type == ShortTextElementType.nostrProfile) {
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
                      child: FutureBuilder<NostrProfileData>(
                        future: onResolveProfile(child.content),
                        builder: (context, snapshot) {
                          return AppProfileInline(
                            profileName: snapshot.data?.name ?? '',
                            profilePicUrl: snapshot.data?.imageUrl ?? '',
                            onTap: snapshot.data?.onTap,
                          );
                        },
                      ),
                    ),
                  ],
                ));
              } else if (child.type == ShortTextElementType.emoji) {
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
                              size: 16,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ));
              } else if (child.type == ShortTextElementType.hashtag) {
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
                padding: const AppEdgeInsets.symmetric(
                  horizontal: AppGapSize.s4,
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
          padding: const AppEdgeInsets.symmetric(
            horizontal: AppGapSize.s4,
          ),
          child: AppSelectableText(
            text: element.content,
            style: theme.typography.reg14.copyWith(
              color: theme.colors.white,
            ),
          ),
        );
      case ShortTextElementType.image:
        return AppFullWidthImage(
          url: element.content,
          caption: element.attributes?['title'],
        );
      case ShortTextElementType.styledText:
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
      default:
        return AppText.reg14(element.content);
    }
  }

  List<TextSpan> _buildStyledTextSpans(
      BuildContext context, List<ShortTextElement> elements) {
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
