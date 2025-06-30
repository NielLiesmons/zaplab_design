import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabNotificationCard extends StatelessWidget {
  final Model model;
  final void Function(Model) onActions;
  final void Function(Model) onReply;
  final bool isUnread;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;

  const LabNotificationCard({
    super.key,
    required this.model,
    required this.onReply,
    required this.onActions,
    this.isUnread = false,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabSwipePanel(
      padding: const LabEdgeInsets.only(
        left: LabGapSize.s12,
        right: LabGapSize.s12,
        top: LabGapSize.s10,
        bottom: LabGapSize.s12,
      ),
      isLight: true,
      leftContent: LabIcon.s16(
        theme.icons.characters.reply,
        outlineColor: theme.colors.white66,
        outlineThickness: LabLineThicknessData.normal().medium,
      ),
      rightContent: LabIcon.s10(
        theme.icons.characters.chevronUp,
        outlineColor: theme.colors.white66,
        outlineThickness: LabLineThicknessData.normal().medium,
      ),
      onSwipeLeft: () => onReply(model),
      onSwipeRight: () => onActions(model),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                LabContainer(
                  width: theme.sizes.s38,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LabGap.s2(),
                      LabProfilePic.s20(model is Comment
                          ? (model as Comment).parentModel.value!.author.value
                          : model is Zap
                              ? (model as Zap).zappedModel.value!.author.value
                              : model is Reaction
                                  ? (model as Reaction)
                                      .reactedOn
                                      .value!
                                      .author
                                      .value
                                  : null),
                      Expanded(
                        child: LabDivider.vertical(
                          color: theme.colors.white33,
                        ),
                      ),
                    ],
                  ),
                ),
                const LabGap.s4(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LabEmojiContentType(
                            contentType: getModelContentType(model is Comment
                                ? (model as Comment).parentModel.value
                                : model is Zap
                                    ? (model as Zap).zappedModel.value
                                    : model is Reaction
                                        ? (model as Reaction).reactedOn.value!
                                        : null),
                            size: theme.sizes.s16,
                          ),
                          const LabGap.s8(),
                          Expanded(
                            child: LabText.reg14(
                              getModelDisplayText(model is Comment
                                  ? (model as Comment).parentModel.value
                                  : model is Zap
                                      ? (model as Zap).zappedModel.value
                                      : model is Reaction
                                          ? (model as Reaction).reactedOn.value!
                                          : null),
                              color: theme.colors.white66,
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const LabGap.s12(),
                          if (isUnread)
                            LabContainer(
                              height: theme.sizes.s8,
                              width: theme.sizes.s8,
                              decoration: BoxDecoration(
                                gradient: theme.colors.blurple,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                        ],
                      ),
                      const LabGap.s10(),
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
                LabProfilePic.s38(null),
                const LabGap.s12(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabText.bold14("Name"), //TODO: Implement
                          const Spacer(),
                          LabText.reg12(
                            TimestampFormatter.format(DateTime.now(),
                                format: TimestampFormat.relative),
                            color: theme.colors.white33,
                          ),
                        ],
                      ),
                      LabCompactTextRenderer(
                        model: model,
                        content:
                            "This is a reply on an Article your current profile published ",
                        isMedium: true,
                        isWhite: true,
                        maxLines: 6,
                        onResolveEvent: onResolveEvent!,
                        onResolveProfile: onResolveProfile!,
                        onResolveEmoji: onResolveEmoji!,
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
