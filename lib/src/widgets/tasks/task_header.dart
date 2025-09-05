import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';

class LabTaskHeader extends StatefulWidget {
  final Task task;
  final List<Community> communities;
  final Function(Profile) onProfileTap;
  final NostrEventResolver onResolveEvent;
  final NostrProfileResolver onResolveProfile;
  final NostrEmojiResolver onResolveEmoji;
  final NostrHashtagResolver onResolveHashtag;
  final LinkTapHandler onLinkTap;
  final Function(Model)? onTaggedModelTap;

  const LabTaskHeader({
    super.key,
    required this.task,
    required this.communities,
    required this.onProfileTap,
    required this.onResolveEvent,
    required this.onResolveProfile,
    required this.onResolveEmoji,
    required this.onResolveHashtag,
    required this.onLinkTap,
    this.onTaggedModelTap,
  });

  @override
  State<LabTaskHeader> createState() => _LabTaskHeaderState();
}

class _LabTaskHeaderState extends State<LabTaskHeader> {
  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabContainer(
          padding: const LabEdgeInsets.only(
            top: LabGapSize.s4,
            bottom: LabGapSize.s12,
            left: LabGapSize.s12,
            right: LabGapSize.s12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabProfilePic.s48(widget.task.author.value,
                  onTap: () =>
                      widget.onProfileTap(widget.task.author.value as Profile)),
              const LabGap.s12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LabText.bold14(widget.task.author.value?.name ??
                            formatNpub(widget.task.author.value?.pubkey ?? '')),
                        LabText.reg12(
                          TimestampFormatter.format(widget.task.createdAt,
                              format: TimestampFormat.relative),
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const LabGap.s6(),
                    LabCommunityStack(
                      communities: widget.communities,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const LabDivider(),
        LabContainer(
          constraints: const BoxConstraints(
            maxHeight: 292,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabContainer(
                      padding: const LabEdgeInsets.only(
                        top: LabGapSize.s12,
                        left: LabGapSize.s12,
                        bottom: LabGapSize.s8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LabContainer(
                            padding: const LabEdgeInsets.only(
                              right: LabGapSize.s12,
                            ),
                            child: LabTaskBox(
                              state: switch (widget.task.status) {
                                'closed' => TaskBoxState.closed,
                                'open' => TaskBoxState.open,
                                'inReview' => TaskBoxState.inReview,
                                'inProgress' => TaskBoxState.inProgress,
                                _ => TaskBoxState.open,
                              },
                            ),
                          ),
                          Expanded(
                            child: LabContainer(
                              width: 37,
                              padding: const LabEdgeInsets.only(
                                left: LabGapSize.s12,
                                bottom: LabGapSize.s24,
                              ),
                              child:
                                  widget.task.targetedModels.toList().isNotEmpty
                                      ? CustomPaint(
                                          painter: LabLShapePainter(
                                            color: theme.colors.white33,
                                            strokeWidth:
                                                LabLineThicknessData.normal()
                                                    .medium,
                                          ),
                                        )
                                      : null,
                            ),
                          )
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
                                    child: LabText.h2(
                                      widget.task.title ?? '',
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const LabGap.s8(),
                            // task labels
                            if (widget.task.labels.isNotEmpty) ...[
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (final label in widget.task.labels) ...[
                                      LabSmallLabel(
                                        label,
                                        onTap: () {},
                                        isEmphasized: true,
                                      ),
                                      const LabGap.s8(),
                                    ],
                                  ],
                                ),
                              ),
                              const LabGap.s8(),
                            ],
                            if (widget.task.content.isNotEmpty)
                              _buildFixedHeightContent(theme),
                            if (widget.task.targetedModels.toList().isNotEmpty)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (final model
                                        in widget.task.targetedModels.toList())
                                      Row(
                                        children: [
                                          LabModelButton(
                                            model: model,
                                            onTap: widget.onTaggedModelTap !=
                                                    null
                                                ? () => widget
                                                    .onTaggedModelTap!(model)
                                                : null,
                                          ),
                                          const LabGap.s8(),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFixedHeightContent(LabThemeData theme) {
    // Create the text renderer widget
    final textRenderer = LabLongTextRenderer(
      model: widget.task,
      content: widget.task.content,
      serif: false,
      onResolveEvent: widget.onResolveEvent,
      onResolveProfile: widget.onResolveProfile,
      onResolveEmoji: widget.onResolveEmoji,
      onResolveHashtag: widget.onResolveHashtag,
      onLinkTap: (url) => widget.onLinkTap(url),
      onProfileTap: (profile) => widget.onProfileTap(profile),
    );

    return TapBuilder(
      onTap: () => _showFullDescriptionModal(theme),
      builder: (context, state, hasFocus) => LabContainer(
        height: 164,
        child: Stack(
          children: [
            // The actual content with tap gesture
            LabContainer(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: const Color(0x00000000),
                borderRadius: theme.radius.asBorderRadius().rad16,
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: textRenderer,
              ),
            ),

            // Gradient overlay (always visible)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: LabContainer(
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colors.black.withValues(alpha: 0),
                      theme.colors.black66,
                      theme.colors.black,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullDescriptionModal(LabThemeData theme) {
    LabModal.show(
      context,
      title: "Task Description",
      children: [
        LabContainer(
          padding: const LabEdgeInsets.only(
            top: LabGapSize.s4,
            left: LabGapSize.s8,
            right: LabGapSize.s8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabLongTextRenderer(
                model: widget.task,
                content: widget.task.content,
                serif: false,
                onResolveEvent: widget.onResolveEvent,
                onResolveProfile: widget.onResolveProfile,
                onResolveEmoji: widget.onResolveEmoji,
                onResolveHashtag: widget.onResolveHashtag,
                onLinkTap: (url) => widget.onLinkTap(url),
                onProfileTap: (profile) => widget.onProfileTap(profile),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
