import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppQuotedMessage extends StatelessWidget {
  final ChatMessage chatMessage;
  final NostrModelResolver onResolveModel;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;

  const AppQuotedMessage({
    super.key,
    required this.chatMessage,
    required this.onResolveModel,
    required this.onResolveProfile,
    required this.onResolveEmoji,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      decoration: BoxDecoration(
        color: theme.colors.white8,
        borderRadius: theme.radius.asBorderRadius().rad8,
      ),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          children: [
            AppContainer(
              width: LineThicknessData.normal().thick,
              decoration: BoxDecoration(
                color: theme.colors.white66,
              ),
            ),
            Expanded(
              child: AppContainer(
                padding: const AppEdgeInsets.only(
                  left: AppGapSize.s8,
                  right: AppGapSize.s12,
                  top: AppGapSize.s6,
                  bottom: AppGapSize.s6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppProfilePic.s18(
                            chatMessage.author.value?.pictureUrl ?? ''),
                        const AppGap.s6(),
                        AppText.bold12(
                          chatMessage.author.value?.name ??
                              formatNpub(
                                  chatMessage.author.value?.pubkey ?? ''),
                          color: theme.colors.white66,
                        ),
                        const Spacer(),
                        AppText.reg12(
                          TimestampFormatter.format(chatMessage.createdAt,
                              format: TimestampFormat.relative),
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    AppContainer(
                      padding: const AppEdgeInsets.only(
                        left: AppGapSize.s2,
                      ),
                      child: AppCompactTextRenderer(
                        content: chatMessage.content,
                        maxLines: 1,
                        shouldTruncate: true,
                        onResolveModel: onResolveModel,
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
    );
  }
}
