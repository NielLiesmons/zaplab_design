import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class LabBottomBarProduct extends StatelessWidget {
  final Function(Product) onAddLabelTap;
  final Function(Product) onMailTap;
  final Function(Product) onVoiceTap;
  final Function(Product) onActions;
  final Product product;

  const LabBottomBarProduct({
    super.key,
    required this.onAddLabelTap,
    required this.onMailTap,
    required this.onVoiceTap,
    required this.onActions,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabBottomBar(
      child: Row(
        children: [
          LabButton(
            color: theme.colors.white16,
            square: true,
            onTap: () => onAddLabelTap(product),
            children: [
              LabIcon.s20(
                theme.icons.characters.label,
                color: theme.colors.white33,
              ),
            ],
          ),
          const LabGap.s12(),
          Expanded(
            child: TapBuilder(
              onTap: () => onMailTap(product),
              builder: (context, state, hasFocus) {
                double scaleFactor = 1.0;
                if (state == TapState.pressed) {
                  scaleFactor = 0.99;
                } else if (state == TapState.hover) {
                  scaleFactor = 1.005;
                }

                return Transform.scale(
                  scale: scaleFactor,
                  child: LabContainer(
                    height: theme.sizes.s40,
                    decoration: BoxDecoration(
                      color: theme.colors.black33,
                      borderRadius: theme.radius.asBorderRadius().rad16,
                      border: Border.all(
                        color: theme.colors.white33,
                        width: LabLineThicknessData.normal().thin,
                      ),
                    ),
                    padding: const LabEdgeInsets.only(
                      left: LabGapSize.s16,
                      right: LabGapSize.s12,
                    ),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LabIcon.s14(
                            theme.icons.characters.plus,
                            outlineColor: theme.colors.whiteEnforced,
                            outlineThickness:
                                LabLineThicknessData.normal().thick,
                          ),
                          const LabGap.s12(),
                          LabText.med14('Add to Cart',
                              color: theme.colors.white33),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const LabGap.s12(),
          LabButton(
            square: true,
            color: theme.colors.black33,
            onTap: () => onActions(product),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LabIcon.s8(theme.icons.characters.chevronUp,
                      outlineThickness: LabLineThicknessData.normal().medium,
                      outlineColor: theme.colors.white66),
                  const LabGap.s2(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
