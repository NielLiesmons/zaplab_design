import 'package:zaplab_design/zaplab_design.dart';

class AppNotificationCard extends StatelessWidget {
  const AppNotificationCard({
    super.key,
    required this.nevent,
    required this.onReply,
    required this.onActions,
    this.isUnread = false,
  });
  final String nevent;
  final void Function(String) onActions;
  final void Function(String) onReply;
  final bool isUnread;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppSwipePanel(
      padding: const AppEdgeInsets.only(
        left: AppGapSize.s12,
        right: AppGapSize.s12,
        top: AppGapSize.s10,
        bottom: AppGapSize.s12,
      ),
      isLight: true,
      leftContent: AppIcon.s16(
        theme.icons.characters.reply,
        outlineColor: theme.colors.white66,
        outlineThickness: LineThicknessData.normal().medium,
      ),
      rightContent: AppIcon.s10(
        theme.icons.characters.chevronUp,
        outlineColor: theme.colors.white66,
        outlineThickness: LineThicknessData.normal().medium,
      ),
      onSwipeLeft: () => onReply(nevent),
      onSwipeRight: () => onActions(nevent),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                AppContainer(
                  width: theme.sizes.s38,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppGap.s2(),
                      AppProfilePic.s20("dummy"),
                      Expanded(
                        child: AppDivider.vertical(
                          color: theme.colors.white33,
                        ),
                      ),
                    ],
                  ),
                ),
                const AppGap.s4(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppEmojiContentType(
                            contentType: "article",
                            size: theme.sizes.s16,
                          ),
                          const AppGap.s8(),
                          AppText.reg14(
                            "Title Of Your Article",
                            color: theme.colors.white66,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          if (isUnread)
                            AppContainer(
                              height: theme.sizes.s8,
                              width: theme.sizes.s8,
                              decoration: BoxDecoration(
                                gradient: theme.colors.blurple,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                        ],
                      ),
                      const AppGap.s10(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppProfilePic.s38("dummy"),
                const AppGap.s12(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.bold14("Name"),
                          const Spacer(),
                          AppText.reg12(
                            TimestampFormatter.format(DateTime.now(),
                                format: TimestampFormat.relative),
                            color: theme.colors.white33,
                          ),
                        ],
                      ),
                      AppCompactTextRenderer(
                        content:
                            "This is a a reply on an Article your current profile published ",
                        isMedium: true,
                        isWhite: true,
                        onResolveEvent: (event) {
                          print(event);
                          return Future.value(null);
                        },
                        onResolveProfile: (profile) {
                          print(profile);
                          return Future.value(null);
                        },
                        onResolveEmoji: (emoji) {
                          print(emoji);
                          return Future.value(null);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
