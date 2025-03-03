import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppSelectorButton extends StatelessWidget {
  final List<Widget> selectedContent;
  final List<Widget> unselectedContent;
  final bool isSelected;
  final bool emphasized;
  final VoidCallback? onTap;

  const AppSelectorButton({
    super.key,
    required this.selectedContent,
    required this.unselectedContent,
    required this.isSelected,
    this.onTap,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return TapBuilder(
      onTap: onTap ?? () {},
      builder: (context, state, hasFocus) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.98;
        }

        return Transform.scale(
          scale: scaleFactor,
          child: AppContainer(
            height: theme.sizes.s38,
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
