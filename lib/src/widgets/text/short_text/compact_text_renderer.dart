import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class AppCompactTextRenderer extends StatelessWidget {
  final String content;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final int? maxLines;
  final bool shouldTruncate;

  const AppCompactTextRenderer({
    super.key,
    required this.content,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    this.maxLines,
    this.shouldTruncate = false,
  });

  @override
  Widget build(BuildContext context) {
    final parser = AppShortTextParser();
    final elements = parser.parse(content);
    final theme = AppTheme.of(context);

    print('Parsed elements: ${elements.length}');
    final List<InlineSpan> spans = [];
    for (final element in elements) {
      print('Element type: ${element.type}');
      if (element.type == AppShortTextElementType.images) {
        print(
            'Found standalone image element with content: ${element.content}');
        // Split by newlines and filter out any non-URL content
        final urls = element.content
            .split('\n')
            .where((line) => line.startsWith('http'))
            .toList();
        print('Split URLs: $urls');
        if (urls.isNotEmpty) {
          // Add a space before the image to ensure proper spacing
          spans.add(TextSpan(
            text: '',
            style: theme.typography.reg12.copyWith(
              color: theme.colors.white66,
            ),
          ));

          spans.add(WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon.s14(
                  theme.icons.characters.camera,
                  color: theme.colors.white33,
                ),
                const AppGap.s6(),
                AppText.reg12(
                  urls.length > 1 ? '${urls.length} Images' : 'Image',
                  color: theme.colors.white66,
                ),
              ],
            ),
          ));
          print('Added image span with ${urls.length} URLs');
        }
      } else if (element.type == AppShortTextElementType.emoji) {
        spans.add(TextSpan(
          text: element.content,
          style: const TextStyle(
            color: Color(0xFF000000),
            fontSize: 0,
            height: 0,
            letterSpacing: 0,
            wordSpacing: 0,
          ),
        ));
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: FutureBuilder<String>(
            future: onResolveEmoji(element.content),
            builder: (context, snapshot) {
              return AppContainer(
                child: AppEmojiImage(
                  emojiUrl: snapshot.data ?? '',
                  emojiName: snapshot.data ?? '',
                  size: 16,
                  opacity: 0.66,
                ),
              );
            },
          ),
        ));
      } else if (element.type == AppShortTextElementType.paragraph &&
          element.children != null) {
        print('Children count: ${element.children!.length}');
        for (var child in element.children!) {
          print('Child type: ${child.type}, content: ${child.content}');
          if (child.type == AppShortTextElementType.nostrEvent) {
            spans.add(TextSpan(
              children: [
                TextSpan(
                  text: child.content,
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
                  child: FutureBuilder<NostrEvent>(
                    future: onResolveEvent(child.content),
                    builder: (context, snapshot) {
                      final contentType = snapshot.data?.contentType ?? '';
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppEmojiContentType(
                            contentType: contentType,
                            size: 16,
                            opacity: 0.66,
                          ),
                          const AppGap.s6(),
                          AppText.reg12(
                            contentType.isNotEmpty
                                ? contentType[0].toUpperCase() +
                                    contentType.substring(1)
                                : 'Nostr Publication',
                            color: theme.colors.white66,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ));
          } else if (child.type == AppShortTextElementType.audio) {
            spans.add(TextSpan(
              children: [
                TextSpan(
                  text: child.content,
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppIcon.s14(
                        theme.icons.characters.voice,
                        color: theme.colors.white33,
                      ),
                      const AppGap.s6(),
                      AppText.reg12(
                        'Audio Message',
                        color: theme.colors.white66,
                      ),
                    ],
                  ),
                ),
              ],
            ));
          } else if (child.type == AppShortTextElementType.images) {
            print('Found image element with content: ${child.content}');
            // Split by newlines and filter out any non-URL content
            final urls = child.content
                .split('\n')
                .where((line) => line.startsWith('http'))
                .toList();
            print('Split URLs: $urls');
            if (urls.isNotEmpty) {
              // Add a space before the image to ensure proper spacing
              spans.add(TextSpan(
                text: '',
                style: theme.typography.reg12.copyWith(
                  color: theme.colors.white66,
                ),
              ));

              spans.add(WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcon.s14(
                      theme.icons.characters.camera,
                      color: theme.colors.white33,
                    ),
                    const AppGap.s6(),
                    AppText.reg12(
                      urls.length > 1 ? '${urls.length} Images' : 'Image',
                      color: theme.colors.white66,
                    ),
                  ],
                ),
              ));
              print('Added image span with ${urls.length} URLs');
            }
          } else if (child.type == AppShortTextElementType.nostrProfile) {
            spans.add(TextSpan(
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
                        profileName: snapshot.data?.profileName ?? '',
                        profilePicUrl: snapshot.data?.profilePicUrl ?? '',
                        onTap: snapshot.data?.onTap,
                        isCompact: true,
                      );
                    },
                  ),
                ),
              ],
            ));
          } else if (child.type == AppShortTextElementType.hashtag) {
            spans.add(TextSpan(
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
                              style: theme.typography.reg12.copyWith(
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
            spans.add(TextSpan(
              text: child.content,
              style: theme.typography.reg12.copyWith(
                color: theme.colors.blurpleColor,
              ),
            ));
          } else if (child.type == AppShortTextElementType.monospace) {
            spans.add(TextSpan(
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
                  child: AppContainer(
                    height: 16,
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
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ));
          } else if (child.type == AppShortTextElementType.utfEmoji) {
            spans.add(TextSpan(
              text: child.content,
              style: theme.typography.reg14.copyWith(
                color: theme.colors.white66,
                fontSize: 12,
              ),
            ));
          } else if (child.type == AppShortTextElementType.emoji) {
            spans.add(TextSpan(
              children: [
                TextSpan(
                  text: child.content,
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
                        child: AppEmojiImage(
                          emojiUrl: snapshot.data ?? '',
                          emojiName: snapshot.data ?? '',
                          size: 16,
                          opacity: 0.66,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ));
          } else {
            spans.add(TextSpan(
              text: child.content,
              style: theme.typography.reg12.copyWith(
                color: theme.colors.white66,
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
                  'url' => TextDecoration.underline,
                  _ => null,
                },
              ),
            ));
          }
        }
      }
    }

    return Text.rich(
      TextSpan(children: spans),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: theme.typography.reg12.copyWith(
        color: theme.colors.white66,
      ),
    );
  }
}
