import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabSelectorButton extends StatelessWidget {
  final List<Widget> selectedContent;
  final List<Widget> unselectedContent;
  final bool isSelected;
  final bool emphasized;
  final bool small;
  final VoidCallback? onTap;

  const LabSelectorButton({
    super.key,
    required this.selectedContent,
    required this.unselectedContent,
    required this.isSelected,
    this.onTap,
    this.emphasized = false,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return TapBuilder(
      onTap: onTap ?? () {},
      builder: (context, state, hasFocus) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.98;
        }

        return Transform.scale(
          scale: scaleFactor,
          child: LabContainer(
            height: small ? theme.sizes.s28 : theme.sizes.s38,
            decoration: BoxDecoration(
              gradient: isSelected && emphasized ? theme.colors.blurple : null,
              color: isSelected && !emphasized ? theme.colors.white16 : null,
              borderRadius: emphasized
                  ? theme.radius.asBorderRadius().rad16
                  : theme.radius.asBorderRadius().rad8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: isSelected ? selectedContent : unselectedContent,
            ),
          ),
        );
      },
    );
  }
}
