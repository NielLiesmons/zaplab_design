import 'package:zaplab_design/zaplab_design.dart';

class AppQuotedMessage extends StatelessWidget {
  final String profileName;
  final String profilePicUrl;
  final String message;
  final DateTime timestamp;
  final String? eventId;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;

  const AppQuotedMessage({
    super.key,
    required this.profileName,
    required this.profilePicUrl,
    required this.message,
    required this.timestamp,
    this.eventId,
    required this.onResolveEvent,
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
                        AppProfilePic.s18(profilePicUrl),
                        const AppGap.s6(),
                        AppText.bold12(
                          profileName,
                          color: theme.colors.white66,
                        ),
                        const Spacer(),
                        AppText.reg12(
                          TimestampFormatter.format(timestamp,
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
                        content: message,
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
    );
  }
}
