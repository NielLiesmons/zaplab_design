import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppNotificationCard extends StatelessWidget {
  final Model model;
  final void Function(Model) onActions;
  final void Function(Model) onReply;
  final bool isUnread;

  const AppNotificationCard({
    super.key,
    required this.model,
    required this.onReply,
    required this.onActions,
    this.isUnread = false,
  });

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
        outlineThickness: AppLineThicknessData.normal().medium,
      ),
      rightContent: AppIcon.s10(
        theme.icons.characters.chevronUp,
        outlineColor: theme.colors.white66,
        outlineThickness: AppLineThicknessData.normal().medium,
      ),
      onSwipeLeft: () => onReply(model),
      onSwipeRight: () => onActions(model),
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
                      AppProfilePic.s20(null), //TODO: Implement
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
                AppProfilePic.s38(null),
                const AppGap.s12(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.bold14("Name"), //TODO: Implement
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
                            "This is a reply on an Article your current profile published ",
                        isMedium: true,
                        isWhite: true,
                        maxLines: 6,
                        onResolveEvent: (model) {
                          print(model);
                          return Future.value(null); //TODO: Implement
                        },
                        onResolveProfile: (profile) {
                          print(profile);
                          return Future.value(null); //TODO: Implement
                        },
                        onResolveEmoji: (emoji) {
                          print(emoji);
                          return Future.value(null); //TODO: Implement
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
