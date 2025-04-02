import 'package:zaplab_design/zaplab_design.dart';

class AppCompactTextRenderer extends StatelessWidget {
  final String content;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final int? maxLines;
  final bool shouldTruncate;
  final bool isMedium;
  final bool isWhite;

  const AppCompactTextRenderer({
    super.key,
    required this.content,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    this.maxLines,
    this.shouldTruncate = true,
    this.isMedium = false,
    this.isWhite = false,
  });

  @override
  Widget build(BuildContext context) {
    final parser = AppShortTextParser();
    final elements = parser.parse(content);
    final theme = AppTheme.of(context);

    final textStyle =
        isMedium ? theme.typography.reg14 : theme.typography.reg12;
    final emojiSize = isMedium ? 18.0 : 16.0;
    final textColor = isWhite ? theme.colors.white : theme.colors.white66;

    final List<InlineSpan> spans = [];
    for (final element in elements) {
      if (element.type == AppShortTextElementType.images) {
        // Split by newlines and filter out any non-URL content
        final urls = element.content
            .split('\n')
            .where((line) => line.startsWith('http'))
            .toList();
        if (urls.isNotEmpty) {
          // Add a space before the image to ensure proper spacing
          spans.add(TextSpan(
            text: '',
            style: textStyle.copyWith(
              color: textColor,
            ),
          ));

          spans.add(WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isMedium
                    ? AppIcon.s16(
                        theme.icons.characters.camera,
                        color: theme.colors.white33,
                      )
                    : AppIcon.s14(
                        theme.icons.characters.camera,
                        color: theme.colors.white33,
                      ),
                isMedium ? const AppGap.s8() : const AppGap.s6(),
                isMedium
                    ? AppText.reg14(
                        urls.length > 1 ? '${urls.length} Images  ' : 'Image  ',
                        color: textColor,
                      )
                    : AppText.reg12(
                        urls.length > 1 ? '${urls.length} Images  ' : 'Image  ',
                        color: textColor,
                      ),
              ],
            ),
          ));
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
                  size: emojiSize,
                  opacity: 0.66,
                ),
              );
            },
          ),
        ));
      } else if (element.type == AppShortTextElementType.paragraph &&
          element.children != null) {
        for (var child in element.children!) {
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
                            size: emojiSize,
                            opacity: 0.66,
                          ),
                          isMedium ? const AppGap.s8() : const AppGap.s6(),
                          isMedium
                              ? AppText.reg14(
                                  contentType.isNotEmpty
                                      ? contentType[0].toUpperCase() +
                                          contentType.substring(1) +
                                          ("  ")
                                      : 'Nostr Publication  ',
                                  color: textColor,
                                )
                              : AppText.reg12(
                                  contentType.isNotEmpty
                                      ? contentType[0].toUpperCase() +
                                          contentType.substring(1) +
                                          ("  ")
                                      : 'Nostr Publication  ',
                                  color: textColor,
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
                      isMedium
                          ? AppIcon.s16(
                              theme.icons.characters.voice,
                              color: theme.colors.white33,
                            )
                          : AppIcon.s14(
                              theme.icons.characters.voice,
                              color: theme.colors.white33,
                            ),
                      isMedium ? const AppGap.s8() : const AppGap.s6(),
                      isMedium
                          ? AppText.reg14(
                              'Audio Message  ',
                              color: textColor,
                            )
                          : AppText.reg12(
                              'Audio Message  ',
                              color: textColor,
                            ),
                    ],
                  ),
                ),
              ],
            ));
          } else if (child.type == AppShortTextElementType.images) {
            // Split by newlines and filter out any non-URL content
            final urls = child.content
                .split('\n')
                .where((line) => line.startsWith('http'))
                .toList();
            if (urls.isNotEmpty) {
              // Add a space before the image to ensure proper spacing
              spans.add(TextSpan(
                text: '',
                style: textStyle.copyWith(
                  color: textColor,
                ),
              ));

              spans.add(WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isMedium
                        ? AppIcon.s16(
                            theme.icons.characters.camera,
                            color: theme.colors.white33,
                          )
                        : AppIcon.s14(
                            theme.icons.characters.camera,
                            color: theme.colors.white33,
                          ),
                    isMedium ? const AppGap.s8() : const AppGap.s6(),
                    isMedium
                        ? AppText.reg14(
                            urls.length > 1
                                ? '${urls.length} Images  '
                                : 'Image  ',
                            color: textColor,
                          )
                        : AppText.reg12(
                            urls.length > 1
                                ? '${urls.length} Images  '
                                : 'Image  ',
                            color: textColor,
                          ),
                  ],
                ),
              ));
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
                  child: isMedium
                      ? AppText.bold14(
                          '#${child.content}',
                          color: theme.colors.blurpleColor,
                        )
                      : AppText.bold12(
                          '#${child.content}',
                          color: theme.colors.blurpleColor,
                        ),
                ),
              ],
            ));
          } else if (child.type == AppShortTextElementType.link) {
            spans.add(TextSpan(
              text: child.content,
              style: textStyle.copyWith(
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
                      color: textColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ));
          } else if (child.type == AppShortTextElementType.utfEmoji) {
            spans.add(TextSpan(
              text: child.content,
              style: textStyle.copyWith(
                color: textColor,
              ),
            ));
          } else if (child.type == AppShortTextElementType.emoji) {
            spans.add(TextSpan(
              text: child.content,
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
                future: onResolveEmoji(child.content),
                builder: (context, snapshot) {
                  return AppContainer(
                    child: AppEmojiImage(
                      emojiUrl: snapshot.data ?? '',
                      emojiName: snapshot.data ?? '',
                      size: emojiSize,
                      opacity: 0.66,
                    ),
                  );
                },
              ),
            ));
          } else {
            spans.add(TextSpan(
              text: child.content,
              style: textStyle.copyWith(
                color: textColor,
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
      } else {
        spans.add(TextSpan(
          text: element.content,
          style: textStyle.copyWith(
            color: textColor,
          ),
        ));
      }
    }

    return RichText(
      maxLines: maxLines,
      overflow: shouldTruncate ? TextOverflow.ellipsis : TextOverflow.visible,
      text: TextSpan(children: spans),
      textDirection: TextDirection.ltr,
      softWrap: true,
      textAlign: TextAlign.left,
      locale: const Locale('en'),
      strutStyle: StrutStyle(
        fontSize: textStyle.fontSize,
        fontWeight: textStyle.fontWeight,
        fontFamily: textStyle.fontFamily,
      ),
      textWidthBasis: TextWidthBasis.parent,
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: true,
        applyHeightToLastDescent: true,
      ),
    );
  }
}
