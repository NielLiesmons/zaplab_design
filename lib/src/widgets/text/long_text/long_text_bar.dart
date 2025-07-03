import 'dart:ui';
import 'package:zaplab_design/zaplab_design.dart';

List<Widget> _buildContentTypeRows(BuildContext context) {
  final contentTypes = [
    'highlight',
    'section',
    "reply",
    'wiki',
    'book',
    'thread',
    'doc',
    'article',
    'graph',
    'video',
    'product',
    'event',
  ];

  final rows = <Widget>[];
  final rowCount = (contentTypes.length / 3).ceil();

  for (var row = 0; row < rowCount; row++) {
    final rowItems = <Widget>[];
    for (var col = 0; col < 3; col++) {
      final index = row * 3 + col;
      if (index < contentTypes.length) {
        rowItems.add(
          Expanded(
            child: LabPanelButton(
              padding: const LabEdgeInsets.only(
                top: LabGapSize.s20,
                bottom: LabGapSize.s14,
              ),
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LabEmojiContentType(
                    contentType: contentTypes[index],
                    size: 32,
                  ),
                  const LabGap.s10(),
                  LabText.med14(
                    contentTypes[index][0].toUpperCase() +
                        contentTypes[index].substring(1),
                  ),
                ],
              ),
            ),
          ),
        );
        if (col < 2) {
          rowItems.add(const LabGap.s8());
        }
      } else {
        rowItems.add(const Expanded(child: SizedBox()));
        if (col < 2) {
          rowItems.add(const LabGap.s8());
        }
      }
    }
    rows.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: rowItems,
    ));
    if (row < rowCount - 1) {
      rows.add(const LabGap.s8());
    }
  }

  return rows;
}

class LabLongTextBar extends StatelessWidget {
  final void Function(LongTextElementType)? onBlockTypeSelected;

  const LabLongTextBar({
    super.key,
    this.onBlockTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return ClipRRect(
      borderRadius: theme.radius.asBorderRadius().rad16,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: LabPanelButton(
          onTap: () => LabModal.show(
            context,
            includePadding: false,
            children: [
              LabContainer(
                padding: const LabEdgeInsets.all(
                  LabGapSize.s16,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: LabPanelButton(
                            onTap: () {
                              onBlockTypeSelected
                                  ?.call(LongTextElementType.heading1);
                              Navigator.of(context).pop();
                            },
                            padding: const LabEdgeInsets.symmetric(
                              horizontal: LabGapSize.s16,
                            ),
                            height: theme.sizes.s48,
                            color: theme.colors.white8,
                            child: Row(
                              children: [
                                LabText.longformh1('Heading 1'),
                              ],
                            ),
                          ),
                        ),
                        const LabGap.s10(),
                        Expanded(
                          child: LabPanelButton(
                            onTap: () {},
                            padding: const LabEdgeInsets.symmetric(
                              horizontal: LabGapSize.s16,
                            ),
                            height: theme.sizes.s48,
                            color: theme.colors.white8,
                            child: Row(
                              children: [
                                LabText.reg14(
                                  'Paragraph',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const LabGap.s10(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: LabPanelButton(
                            onTap: () {},
                            padding: const LabEdgeInsets.symmetric(
                              horizontal: LabGapSize.s16,
                            ),
                            height: theme.sizes.s48,
                            color: theme.colors.white8,
                            child: Row(
                              children: [
                                LabText.longformh2('Heading 2',
                                    color: theme.colors.white66),
                              ],
                            ),
                          ),
                        ),
                        const LabGap.s10(),
                        Expanded(
                          child: LabPanelButton(
                            onTap: () {},
                            padding: const LabEdgeInsets.symmetric(
                              horizontal: LabGapSize.s16,
                            ),
                            height: theme.sizes.s48,
                            color: theme.colors.white8,
                            child: Row(
                              children: [
                                LabText.bold14(
                                  'Link',
                                  color: theme.colors.blurpleLightColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const LabGap.s10(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: LabPanelButton(
                            onTap: () {},
                            padding: const LabEdgeInsets.symmetric(
                              horizontal: LabGapSize.s16,
                            ),
                            height: theme.sizes.s48,
                            color: theme.colors.white8,
                            child: Row(
                              children: [
                                LabText.longformh3(
                                  'Heading 3',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const LabGap.s10(),
                        Expanded(
                          child: LabPanelButton(
                            onTap: () {},
                            padding: const LabEdgeInsets.only(
                              left: LabGapSize.s12,
                              right: LabGapSize.s16,
                            ),
                            height: theme.sizes.s48,
                            color: theme.colors.white8,
                            child: Row(
                              children: [
                                LabCheckBox(
                                  value: true,
                                ),
                                const LabGap.s12(),
                                LabText.reg14(
                                  'Check List',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const LabGap.s10(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: LabPanelButton(
                            onTap: () {},
                            padding: const LabEdgeInsets.symmetric(
                              horizontal: LabGapSize.s16,
                            ),
                            height: theme.sizes.s48,
                            color: theme.colors.white8,
                            child: Row(
                              children: [
                                LabText.longformh4(
                                  'Heading 4',
                                  color: theme.colors.white66,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const LabGap.s10(),
                        Expanded(
                          child: LabPanelButton(
                            onTap: () {},
                            padding: const LabEdgeInsets.symmetric(
                              horizontal: LabGapSize.s16,
                            ),
                            height: theme.sizes.s48,
                            color: theme.colors.white8,
                            child: Row(
                              children: [
                                LabContainer(
                                  width: theme.sizes.s12,
                                  height: theme.sizes.s12,
                                  decoration: BoxDecoration(
                                      gradient: theme.colors.blurple,
                                      shape: BoxShape.circle),
                                ),
                                const LabGap.s12(),
                                LabText.reg14(
                                  'Bullet List',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const LabGap.s10(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: LabPanelButton(
                            onTap: () {},
                            padding: const LabEdgeInsets.symmetric(
                              horizontal: LabGapSize.s16,
                            ),
                            height: theme.sizes.s48,
                            color: theme.colors.white8,
                            child: Row(
                              children: [
                                LabText.longformh5(
                                  'Heading 5',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const LabGap.s10(),
                        Expanded(
                          child: LabPanelButton(
                            onTap: () {},
                            padding: const LabEdgeInsets.symmetric(
                              horizontal: LabGapSize.s16,
                            ),
                            height: theme.sizes.s48,
                            color: theme.colors.white8,
                            child: Row(
                              children: [
                                LabText.regWiki(
                                  '1.',
                                  color: theme.colors.white66,
                                ),
                                const LabGap.s8(),
                                LabText.reg14(
                                  'Numbered List',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const LabDivider(),
              LabContainer(
                padding: const LabEdgeInsets.all(
                  LabGapSize.s16,
                ),
                child: Column(
                  children: [
                    LabImageUploadCard(
                      ratio: 5 / 1,
                    ),
                  ],
                ),
              ),
              const LabDivider(),
              LabContainer(
                padding: const LabEdgeInsets.all(
                  LabGapSize.s16,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Expanded(
                          child: LabCodeBlock(
                            code: "{}",
                            language: "CODE",
                            allowCopy: false,
                          ),
                        ),
                        const LabGap.s10(),
                        Expanded(
                          child: LabContainer(
                            width: double.infinity,
                            clipBehavior: Clip.hardEdge,
                            padding: LabEdgeInsets.symmetric(
                              horizontal: LabGapSize.s10,
                              vertical: LabGapSize.s6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colors.black33,
                              borderRadius: theme.radius.asBorderRadius().rad16,
                              border: Border.all(
                                color: theme.colors.white16,
                                width: LabLineThicknessData.normal().medium,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabText.h3('MATH', color: theme.colors.white33),
                                LabContainer(
                                  padding: const LabEdgeInsets.only(
                                    left: LabGapSize.s2,
                                    right: LabGapSize.s4,
                                    top: LabGapSize.s4,
                                    bottom: LabGapSize.s6,
                                  ),
                                  child: LabIcon.s14(
                                    theme.icons.characters.latex,
                                    outlineColor:
                                        theme.colors.blurpleLightColor,
                                    outlineThickness:
                                        LabLineThicknessData.normal().medium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const LabGap.s10(),
                    Row(
                      children: [
                        Expanded(
                          child: LabAdmonition(
                            type: "note",
                            child: LabText.reg14(
                              '...',
                              color: theme.colors.white66,
                            ),
                          ),
                        ),
                        const LabGap.s10(),
                        Expanded(
                          child: LabAdmonition(
                            type: "warning",
                            child: LabText.reg14(
                              '...',
                              color: theme.colors.white66,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          color: theme.colors.white16,
          padding: const LabEdgeInsets.only(
            top: LabGapSize.s8,
            bottom: LabGapSize.s8,
            left: LabGapSize.s16,
            right: LabGapSize.s8,
          ),
          width: 208,
          child: Row(
            children: [
              LabText.med16(
                'Heading 1',
                color: theme.colors.white66,
              ),
              const LabGap.s12(),
              LabIcon.s8(
                theme.icons.characters.chevronDown,
                outlineColor: theme.colors.white33,
                outlineThickness: LabLineThicknessData.normal().medium,
              ),
              const LabGap.s12(),
              const Spacer(),
              LabSmallButton(
                square: true,
                onTap: () => LabModal.show(
                  context,
                  title: 'Add Content',
                  description: 'Select the content type you want to insert',
                  children: [
                    const LabGap.s8(),
                    ..._buildContentTypeRows(context),
                  ],
                ),
                children: [
                  LabIcon.s14(
                    theme.icons.characters.plus,
                    outlineColor: theme.colors.whiteEnforced,
                    outlineThickness: LabLineThicknessData.normal().thick,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
