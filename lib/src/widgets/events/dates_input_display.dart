import 'package:zaplab_design/zaplab_design.dart';

class LabDatesInputDisplay extends StatelessWidget {
  final String? date1;
  final String? date2;
  const LabDatesInputDisplay({super.key, this.date1, this.date2});

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabContainer(
      padding: const LabEdgeInsets.all(
        LabGapSize.s16,
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                LabContainer(
                  width: theme.sizes.s16,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LabGap.s2(),
                      LabContainer(
                        width: theme.sizes.s16,
                        height: theme.sizes.s16,
                        decoration: BoxDecoration(
                          color: theme.colors.white33,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: LabContainer(
                          width: LabLineThicknessData.normal().thick,
                          decoration: BoxDecoration(
                            color: theme.colors.white33,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const LabGap.s16(),
                Expanded(
                  child: Column(
                    children: [
                      LabInputButton(
                        minHeight: theme.sizes.s64,
                        topAlignment: true,
                        children: [
                          date1 == null
                              ? Row(
                                  children: [
                                    LabText.reg14("Start",
                                        color: theme.colors.white33),
                                    const LabGap.s10(),
                                    LabText.reg14("Date & Time",
                                        color: theme.colors.white16),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        LabText.med14("Friday April 6"),
                                        const LabGap.s10(),
                                        LabText.reg14("2025",
                                            color: theme.colors.white66),
                                      ],
                                    ),
                                    const LabGap.s4(),
                                    Row(
                                      children: [
                                        LabText.reg14("10:00",
                                            color:
                                                theme.colors.blurpleLightColor),
                                        const LabGap.s10(),
                                        LabText.reg14("UCT+2",
                                            color: theme
                                                .colors.blurpleLightColor66),
                                      ],
                                    ),
                                  ],
                                ),
                          const Spacer(),
                          const LabGap.s12(),
                          LabIcon.s12(
                            theme.icons.characters.pen,
                            color: theme.colors.white33,
                          ),
                        ],
                      ),
                      const LabGap.s16(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LabContainer(
                  width: theme.sizes.s16,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LabContainer(
                        height: theme.sizes.s2,
                        width: LabLineThicknessData.normal().thick,
                        decoration: BoxDecoration(
                          color: theme.colors.white33,
                        ),
                      ),
                      LabContainer(
                        width: theme.sizes.s16,
                        height: theme.sizes.s16,
                        decoration: BoxDecoration(
                          color: theme.colors.white33,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                const LabGap.s16(),
                Expanded(
                  child: LabInputButton(
                    minHeight: theme.sizes.s64,
                    topAlignment: true,
                    children: [
                      date2 == null
                          ? Row(
                              children: [
                                LabText.reg14("End",
                                    color: theme.colors.white33),
                                const LabGap.s10(),
                                LabText.reg14("Date & Time",
                                    color: theme.colors.white16),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    LabText.med14("Friday April 6"),
                                    const LabGap.s10(),
                                    LabText.reg14("2025",
                                        color: theme.colors.white66),
                                  ],
                                ),
                                const LabGap.s4(),
                                Row(
                                  children: [
                                    LabText.reg14("10:00",
                                        color: theme.colors.blurpleLightColor),
                                    const LabGap.s10(),
                                    LabText.reg14("UCT+2",
                                        color:
                                            theme.colors.blurpleLightColor66),
                                  ],
                                ),
                              ],
                            ),
                      const Spacer(),
                      const LabGap.s12(),
                      LabIcon.s12(
                        theme.icons.characters.pen,
                        color: theme.colors.white33,
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
