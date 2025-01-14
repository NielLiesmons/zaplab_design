import 'package:zaplab_design/zaplab_design.dart';

class AppMessageBubble extends StatelessWidget {
  final String message;
  final String? profileName;
  final DateTime? timestamp;
  final bool showHeader;
  final bool isLastInStack;
  final String eventId;
  final void Function(String) onActions;
  final void Function(String) onReply;

  const AppMessageBubble({
    super.key,
    required this.message,
    required this.eventId,
    this.profileName,
    this.timestamp,
    this.showHeader = false,
    this.isLastInStack = false,
    required this.onActions,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isInsideModal = ModalScope.of(context);

    return AppSwipeContainer(
      decoration: BoxDecoration(
        color: isInsideModal ? theme.colors.white16 : theme.colors.grey66,
        borderRadius: BorderRadius.only(
          topLeft: theme.radius.rad16,
          topRight: theme.radius.rad16,
          bottomRight: theme.radius.rad16,
          bottomLeft: isLastInStack ? theme.radius.rad4 : theme.radius.rad16,
        ),
      ),
      leftContent: AppIcon.s20(
        theme.icons.characters.reply,
        outlineColor: theme.colors.white,
        outlineThickness: LineThicknessData.normal().medium,
      ),
      rightContent: AppIcon.s12(
        theme.icons.characters.chevronUp,
        outlineColor: theme.colors.white,
        outlineThickness: LineThicknessData.normal().medium,
      ),
      onSwipeLeft: () {
        onActions(eventId);
      },
      onSwipeRight: () {
        onReply(eventId);
      },
      child: IntrinsicWidth(
        child: AppContainer(
          padding: const AppEdgeInsets.symmetric(
            horizontal: AppGapSize.s12,
            vertical: AppGapSize.s8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showHeader) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (profileName != null)
                      AppText.bold12(
                        profileName!,
                        color: theme.colors.white66,
                      ),
                    if (timestamp != null) ...[
                      const AppGap.s8(),
                      AppText.reg12(
                        _formatTimestamp(timestamp!),
                        color: theme.colors.white33,
                      ),
                    ],
                  ],
                ),
              ],
              AppMessageContent(content: message),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
