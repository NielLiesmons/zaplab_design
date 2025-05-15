import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:flutter/material.dart';
import 'package:zaplab_design/src/widgets/tasks/task_box.dart';

class LShapePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerRadius;

  LShapePainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.cornerRadius = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - cornerRadius)
      ..arcToPoint(
        Offset(cornerRadius, size.height),
        radius: Radius.circular(cornerRadius),
        clockwise: false,
      )
      ..lineTo(size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LShapePainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      cornerRadius != oldDelegate.cornerRadius;
}

class AppFeedTask extends StatelessWidget {
  final Task task;
  final Function(Model) onTap;
  final bool isUnread;
  final List<Model>? taggedModels;
  final Function(Model)? onTaggedModelTap;
  final List<Task>? subTasks;
  final Function(Model) onSwipeLeft;
  final Function(Model) onSwipeRight;

  const AppFeedTask({
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
    final theme = AppTheme.of(context);

    return AppSwipeContainer(
      onTap: () => onTap(task),
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
      onSwipeLeft: () => onSwipeLeft(task),
      onSwipeRight: () => onSwipeRight(task),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppContainer(
                padding: const AppEdgeInsets.only(
                  top: AppGapSize.s12,
                  left: AppGapSize.s12,
                  bottom: AppGapSize.s8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppContainer(
                      padding: const AppEdgeInsets.only(
                        right: AppGapSize.s12,
                      ),
                      child: AppTaskBox(
                        state: switch (task.status) {
                          'closed' => TaskBoxState.closed,
                          'open' => TaskBoxState.open,
                          'inReview' => TaskBoxState.inReview,
                          'inProgress' => TaskBoxState.inProgress,
                          _ => TaskBoxState.open,
                        },
                      ),
                    ),
                    AppContainer(
                      width: 37,
                      height: 22,
                      padding: const AppEdgeInsets.only(
                        left: AppGapSize.s12,
                      ),
                      child: (subTasks != null || taggedModels != null)
                          ? CustomPaint(
                              painter: LShapePainter(
                                color: theme.colors.white33,
                                strokeWidth:
                                    AppLineThicknessData.normal().medium,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AppContainer(
                  padding: const AppEdgeInsets.only(
                    top: AppGapSize.s8,
                    right: AppGapSize.s12,
                    bottom: AppGapSize.s12,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AppContainer(
                              padding: const AppEdgeInsets.only(
                                top: AppGapSize.s2,
                              ),
                              child: AppText.bold16(
                                task.title ?? '',
                                textOverflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                          const AppGap.s12(),
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
                      if (taggedModels != null || subTasks != null)
                        const AppGap.s8(),
                      if (taggedModels != null || subTasks != null)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final model in taggedModels ?? [])
                                Row(
                                  children: [
                                    AppModelButton(
                                      model: model,
                                      onTap: () => onTaggedModelTap!(model),
                                    ),
                                    const AppGap.s8(),
                                  ],
                                ),
                              Row(
                                children: [
                                  AppContainer(
                                    padding: const AppEdgeInsets.symmetric(
                                      horizontal: AppGapSize.s8,
                                      vertical: AppGapSize.s6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colors.gray33,
                                      borderRadius:
                                          theme.radius.asBorderRadius().rad8,
                                    ),
                                    child: AppText.reg12(
                                      '${subTasks?.length} Subtasks',
                                      color: theme.colors.white33,
                                    ),
                                  ),
                                  const AppGap.s8(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      const AppGap.s8(),
                      Row(
                        children: [
                          AppProfilePic.s20(task.author.value),
                          const AppGap.s8(),
                          AppText.med12(
                            task.author.value?.name ??
                                formatNpub(
                                  task.author.value?.pubkey ?? '',
                                ),
                            color: theme.colors.white66,
                          ),
                          const Spacer(),
                          AppText.reg12(
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
          const AppDivider(),
        ],
      ),
    );
  }
}
