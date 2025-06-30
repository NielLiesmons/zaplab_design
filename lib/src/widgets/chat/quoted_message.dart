import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:flutter/gestures.dart';

class LabQuotedMessage extends StatelessWidget {
  final ChatMessage? chatMessage;
  final Comment? reply;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final Function(dynamic)? onTap;

  const LabQuotedMessage({
    super.key,
    this.chatMessage,
    this.reply,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return GestureDetector(
      onTap: onTap == null
          ? null
          : () {
              print('LabQuotedMessage: GestureDetector onTap called');
              onTap!(chatMessage != null ? chatMessage! : reply!);
            },
      child: TapBuilder(
        onTap: onTap == null
            ? null
            : () {
                print('LabQuotedMessage: TapBuilder onTap called');
                onTap!(chatMessage != null ? chatMessage! : reply!);
              },
        builder: (context, state, hasFocus) => LabContainer(
          decoration: BoxDecoration(
            color: theme.colors.white8,
            borderRadius: theme.radius.asBorderRadius().rad8,
          ),
          clipBehavior: Clip.hardEdge,
          child: IntrinsicHeight(
            child: Row(
              children: [
                LabContainer(
                  width: LabLineThicknessData.normal().thick,
                  decoration: BoxDecoration(
                    color: Color(npubToColor(chatMessage != null
                        ? chatMessage!.author.value?.pubkey ?? ''
                        : reply!.author.value?.pubkey ?? '')),
                  ),
                ),
                Expanded(
                  child: LabContainer(
                    padding: const LabEdgeInsets.only(
                      left: LabGapSize.s8,
                      right: LabGapSize.s12,
                      top: LabGapSize.s6,
                      bottom: LabGapSize.s6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            LabProfilePic.s18(chatMessage != null
                                ? chatMessage!.author.value
                                : reply!.author.value),
                            const LabGap.s6(),
                            LabText.bold12(
                              chatMessage != null
                                  ? chatMessage!.author.value?.name ??
                                      formatNpub(
                                          chatMessage!.author.value?.pubkey ??
                                              '')
                                  : reply!.author.value?.name ??
                                      formatNpub(
                                          reply!.author.value?.pubkey ?? ''),
                              color: theme.colors.white66,
                            ),
                            const Spacer(),
                            LabText.reg12(
                              TimestampFormatter.format(
                                  chatMessage != null
                                      ? chatMessage!.createdAt
                                      : reply!.createdAt,
                                  format: TimestampFormat.relative),
                              color: theme.colors.white33,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        LabContainer(
                          padding: const LabEdgeInsets.only(
                            left: LabGapSize.s2,
                          ),
                          child: LabCompactTextRenderer(
                            model: chatMessage != null ? chatMessage! : reply!,
                            content: chatMessage != null
                                ? chatMessage!.content
                                : reply!.content,
                            maxLines: 1,
                            shouldTruncate: true,
                            onResolveEvent: onResolveEvent,
                            onResolveProfile: onResolveProfile,
                            onResolveEmoji: onResolveEmoji,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
