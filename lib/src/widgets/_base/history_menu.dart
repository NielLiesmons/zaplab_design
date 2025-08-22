import 'dart:ui';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class HistoryItem {
  const HistoryItem({
    required this.modelType,
    required this.modelId,
    required this.displayText,
    required this.timestamp,
    this.onTap,
  });

  final String modelType;
  final String modelId;
  final String displayText;
  final DateTime timestamp;
  final VoidCallback? onTap;
}

class LabHistoryMenu extends StatelessWidget {
  final List<HistoryItem> history;
  final double currentDrag;
  final double menuHeight;
  final VoidCallback onHomeTap;
  final VoidCallback onTapOutside;

  static const double _buttonHeight = 38.0;
  static const double _buttonWidthDelta = 32.0;

  const LabHistoryMenu({
    super.key,
    required this.history,
    required this.currentDrag,
    required this.menuHeight,
    required this.onHomeTap,
    required this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final progress = currentDrag / menuHeight;

    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTapOutside,
          onVerticalDragUpdate: (details) {
            // Handle drag updates if needed
          },
          child: LabContainer(
            height: menuHeight,
            padding: const LabEdgeInsets.symmetric(
              horizontal: LabGapSize.s16,
              vertical: LabGapSize.none,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Home button
                Transform.translate(
                  offset: Offset(
                    0,
                    -_buttonHeight * (1 - progress) * (0.3),
                  ),
                  child: TapBuilder(
                    onTap: onHomeTap,
                    builder: (context, state, hasFocus) {
                      double scaleFactor = 1.0;
                      if (state == TapState.pressed) {
                        scaleFactor = 0.99;
                      } else if (state == TapState.hover) {
                        scaleFactor = 1.01;
                      }

                      return Transform.scale(
                        scale: scaleFactor,
                        child: LabContainer(
                          decoration: BoxDecoration(
                            color: theme.colors.white16,
                            borderRadius: theme.radius.asBorderRadius().rad16,
                            boxShadow: [
                              BoxShadow(
                                color: theme.colors.white16,
                                blurRadius: theme.sizes.s56,
                              ),
                            ],
                          ),
                          padding: const LabEdgeInsets.all(LabGapSize.s16),
                          child: LabIcon.s20(
                            theme.icons.characters.home,
                            color: theme.colors.white66,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const LabGap.s24(),

                // "More History..." button (if there are history items)
                if (history.isNotEmpty) ...[
                  Transform.translate(
                    offset: Offset(0, -_buttonHeight * (1 - progress) * 0.8),
                    child: SizedBox(
                      height: _buttonHeight,
                      width: containerWidth - (_buttonWidthDelta * 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: theme.radius.rad16,
                          topRight: theme.radius.rad16,
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                          child: LabContainer(
                            decoration: BoxDecoration(
                              color: theme.colors.white8,
                              borderRadius: BorderRadius.only(
                                topLeft: theme.radius.rad16,
                                topRight: theme.radius.rad16,
                              ),
                              border: Border(
                                top: BorderSide(
                                  color: LabColorsData.dark().white16,
                                  width: LabLineThicknessData.normal().thin,
                                ),
                              ),
                            ),
                            padding: const LabEdgeInsets.symmetric(
                              horizontal: LabGapSize.s16,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  LabText.reg12(
                                    'More History...',
                                    color: theme.colors.white66,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                // History items
                ...List.generate(
                  history.length,
                  (index) => Transform.translate(
                    offset: Offset(
                      0,
                      -_buttonHeight * (1 - progress) * (index + 2),
                    ),
                    child: SizedBox(
                      height: _buttonHeight,
                      width: containerWidth - (_buttonWidthDelta * (3 - index)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: theme.radius.rad16,
                          topRight: theme.radius.rad16,
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                          child: TapBuilder(
                            onTap: () {
                              history[index].onTap?.call();
                            },
                            builder: (context, state, hasFocus) {
                              return LabContainer(
                                decoration: BoxDecoration(
                                  color: theme.colors.white8,
                                  borderRadius: BorderRadius.only(
                                    topLeft: theme.radius.rad16,
                                    topRight: theme.radius.rad16,
                                  ),
                                  border: Border(
                                    top: BorderSide(
                                      color: LabColorsData.dark().white16,
                                      width: LabLineThicknessData.normal().thin,
                                    ),
                                  ),
                                ),
                                padding: const LabEdgeInsets.symmetric(
                                  horizontal: LabGapSize.s16,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      LabText.reg12(
                                        history[index].modelType,
                                        color: theme.colors.white66,
                                      ),
                                      const LabGap.s8(),
                                      Expanded(
                                        child: LabText.reg12(
                                          history[index].displayText,
                                          color: theme.colors.white,
                                          maxLines: 1,
                                          textOverflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
