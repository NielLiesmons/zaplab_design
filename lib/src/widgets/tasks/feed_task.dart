import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabFeedTask extends StatelessWidget {
  final Task task;
  final Function(Model) onTap;
  final bool isUnread;
  final List<Model>? taggedModels;
  final Function(Model)? onTaggedModelTap;
  final List<Task>? subTasks;
  final Function(Model) onSwipeLeft;
  final Function(Model) onSwipeRight;

  const LabFeedTask({
    super.key,
    required this.task,
    required this.onTap,
    this.isUnread = false,
    this.taggedModels,
    this.onTaggedModelTap,
    this.subTasks,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabSwipeContainer(
      onTap: () => onTap(task),
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
      onSwipeLeft: () => onSwipeLeft(task),
      onSwipeRight: () => onSwipeRight(task),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabContainer(
                padding: const LabEdgeInsets.only(
                  top: LabGapSize.s12,
                  left: LabGapSize.s12,
                  bottom: LabGapSize.s8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    LabContainer(
                      padding: const LabEdgeInsets.only(
                        right: LabGapSize.s12,
                      ),
                      child: LabTaskBox(
                        state: switch (task.status) {
                          'closed' => TaskBoxState.closed,
                          'open' => TaskBoxState.open,
                          'inReview' => TaskBoxState.inReview,
                          'inProgress' => TaskBoxState.inProgress,
                          _ => TaskBoxState.open,
                        },
                      ),
                    ),
                    LabContainer(
                      width: 37,
                      height: 22,
                      padding: const LabEdgeInsets.only(
                        left: LabGapSize.s12,
                      ),
                      child: (subTasks != null || taggedModels != null)
                          ? CustomPaint(
                              painter: LabLShapePainter(
                                color: theme.colors.white33,
                                strokeWidth:
                                    LabLineThicknessData.normal().medium,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LabContainer(
                  padding: const LabEdgeInsets.only(
                    top: LabGapSize.s8,
                    right: LabGapSize.s12,
                    bottom: LabGapSize.s12,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: LabContainer(
                              padding: const LabEdgeInsets.only(
                                top: LabGapSize.s2,
                              ),
                              child: LabText.bold16(
                                task.title ?? '',
                                textOverflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
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
                      if (taggedModels != null || subTasks != null)
                        const LabGap.s8(),
                      if (taggedModels != null || subTasks != null)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final model in taggedModels ?? [])
                                Row(
                                  children: [
                                    LabModelButton(
                                      model: model,
                                      onTap: () => onTaggedModelTap!(model),
                                    ),
                                    const LabGap.s8(),
                                  ],
                                ),
                              // Row(
                              //   children: [
                              //     LabContainer(
                              //       padding: const LabEdgeInsets.symmetric(
                              //         horizontal: LabGapSize.s8,
                              //         vertical: LabGapSize.s6,
                              //       ),
                              //       decoration: BoxDecoration(
                              //         color: theme.colors.gray33,
                              //         borderRadius:
                              //             theme.radius.asBorderRadius().rad8,
                              //       ),
                              //       child: LabText.reg12(
                              //         '${subTasks?.length} Subtasks',
                              //         color: theme.colors.white33,
                              //       ),
                              //     ),
                              //     const LabGap.s8(),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      const LabGap.s8(),
                      Row(
                        children: [
                          LabProfilePic.s20(task.author.value),
                          const LabGap.s8(),
                          LabText.med12(
                            task.author.value?.name ??
                                formatNpub(
                                  task.author.value?.pubkey ?? '',
                                ),
                            color: theme.colors.white66,
                          ),
                          const Spacer(),
                          LabText.reg12(
                            TimestampFormatter.format(task.createdAt,
                                format: TimestampFormat.relative),
                            color: theme.colors.white33,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const LabDivider(),
        ],
      ),
    );
  }
}
