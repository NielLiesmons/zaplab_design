import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppCompactTextRenderer extends StatelessWidget {
  final String content;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final int? maxLines;
  final bool shouldTruncate;
  final bool isMedium;
  final bool isWhite;
  final Color? textColor;

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
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final parser = AppShortTextParser();
    final elements = parser.parse(content);
    final theme = AppTheme.of(context);

    final textStyle =
        isMedium ? theme.typography.reg14 : theme.typography.reg12;
    final emojiSize = isMedium ? 18.0 : 16.0;
    final derivedTextColor =
        isWhite ? theme.colors.white : (textColor ?? theme.colors.white66);

    final List<InlineSpan> spans = [];
    bool isFirstElement = true;
    for (final element in elements) {
      if (element.type == AppShortTextElementType.heading1 ||
          element.type == AppShortTextElementType.heading2 ||
          element.type == AppShortTextElementType.heading3 ||
          element.type == AppShortTextElementType.heading4 ||
          element.type == AppShortTextElementType.heading5) {
        if (!isFirstElement) {
          spans.add(TextSpan(
            text: ' ',
            style: textStyle.copyWith(
              color: derivedTextColor,
            ),
          ));
        }
        spans.add(TextSpan(
          text: '${element.content} ',
          style: textStyle.copyWith(
            color: derivedTextColor,
            fontWeight: FontWeight.bold,
          ),
        ));
        isFirstElement = false;
        continue;
      }
      isFirstElement = false;
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
              color: derivedTextColor,
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
                        color: derivedTextColor.withValues(alpha: 0.44),
                      )
                    : AppText.reg12(
                        urls.length > 1 ? '${urls.length} Images  ' : 'Image  ',
                        color: derivedTextColor.withValues(alpha: 0.44),
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
          if (child.type == AppShortTextElementType.nostrModel) {
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
                  child: FutureBuilder<({Model model, VoidCallback? onTap})>(
                    future: onResolveEvent(child.content),
                    builder: (context, snapshot) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppEmojiContentType(
                            contentType:
                                getModelContentType(snapshot.data?.model),
                            size: emojiSize,
                            opacity: 0.66,
                          ),
                          isMedium ? const AppGap.s8() : const AppGap.s6(),
                          isMedium
                              ? AppText.reg14(
                                  getModelContentType(snapshot.data?.model) ==
                                          'nostr'
                                      ? 'Nostr Publication  '
                                      : getModelContentType(
                                                  snapshot.data?.model) ==
                                              'chat'
                                          ? 'Message  '
                                          : getModelContentType(
                                                      snapshot.data?.model)[0]
                                                  .toUpperCase() +
                                              getModelContentType(
                                                      snapshot.data?.model)
                                                  .substring(1) +
                                              ("  "),
                                  color:
                                      derivedTextColor.withValues(alpha: 0.44),
                                )
                              : AppText.reg12(
                                  getModelContentType(snapshot.data?.model) ==
                                          'nostr'
                                      ? 'Nostr Publication  '
                                      : getModelContentType(
                                                  snapshot.data?.model) ==
                                              'chat'
                                          ? 'Message  '
                                          : getModelContentType(
                                                      snapshot.data?.model)[0]
                                                  .toUpperCase() +
                                              getModelContentType(
                                                      snapshot.data?.model)
                                                  .substring(1) +
                                              ("  "),
                                  color:
                                      derivedTextColor.withValues(alpha: 0.44),
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
                              color: derivedTextColor.withValues(alpha: 0.44),
                            )
                          : AppText.reg12(
                              'Audio Message  ',
                              color: derivedTextColor.withValues(alpha: 0.44),
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
                  color: derivedTextColor,
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
                            color: derivedTextColor.withValues(alpha: 0.44),
                          )
                        : AppText.reg12(
                            urls.length > 1
                                ? '${urls.length} Images  '
                                : 'Image  ',
                            color: derivedTextColor.withValues(alpha: 0.44),
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
                  child:
                      FutureBuilder<({Profile profile, VoidCallback? onTap})>(
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
                  child: isMedium
                      ? AppText.bold14(
                          '#${child.content}',
                          color: theme.colors.blurpleLightColor,
                        )
                      : AppText.bold12(
                          '#${child.content}',
                          color: theme.colors.blurpleLightColor,
                        ),
                ),
              ],
            ));
          } else if (child.type == AppShortTextElementType.link) {
            spans.add(TextSpan(
              text: child.content,
              style: textStyle.copyWith(
                color: isWhite
                    ? theme.colors.blurpleLightColor
                    : theme.colors.blurpleLightColor66,
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
                      color: derivedTextColor,
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
                color: derivedTextColor,
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
                color: derivedTextColor,
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
            color: derivedTextColor,
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
