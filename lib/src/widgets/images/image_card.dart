import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class LabImageCard extends StatelessWidget {
  final String url;
  final VoidCallback? onTap;
  final double? width;
  final double? loadingWidth;
  final double? height;
  final double? loadingHeight;

  const LabImageCard({
    super.key,
    required this.url,
    this.onTap,
    this.width,
    this.loadingWidth,
    this.height,
    this.loadingHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return TapBuilder(
      onTap: onTap,
      builder: (context, state, isFocused) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.99;
        } else if (state == TapState.hover) {
          scaleFactor = 1.01;
        }

        return Transform.scale(
          scale: scaleFactor,
          child: LabContainer(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: theme.colors.gray66,
              borderRadius: theme.radius.asBorderRadius().rad12,
              border: Border.all(
                color: theme.colors.white16,
                width: LabLineThicknessData.normal().thin,
              ),
            ),
            width: width,
            height: height ?? 180,
            child: Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return LabContainer(
                  width: width ?? loadingWidth ?? 320,
                  height: height ?? loadingHeight ?? 180,
                  child: Center(
                    child: LabText(
                      "Image not found",
                      color: theme.colors.white33,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, error, stackTrace) {
                return LabContainer(
                  width: width ?? loadingWidth ?? 320,
                  height: height ?? loadingHeight ?? 180,
                  child: const LabSkeletonLoader(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
