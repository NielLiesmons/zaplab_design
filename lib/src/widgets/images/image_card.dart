import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class AppImageCard extends StatelessWidget {
  final String url;
  final VoidCallback? onTap;
  final double? width;
  final double? loadingWidth;
  final double? height;
  final double? loadingHeight;

  const AppImageCard({
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
    final theme = AppTheme.of(context);

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
          child: AppContainer(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: theme.colors.gray66,
              borderRadius: theme.radius.asBorderRadius().rad16,
              border: Border.all(
                color: theme.colors.white16,
                width: AppLineThicknessData.normal().thin,
              ),
            ),
            width: width,
            height: height ?? 180,
            child: Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return AppContainer(
                  width: width ?? loadingWidth ?? 320,
                  height: height ?? loadingHeight ?? 180,
                  child: Center(
                    child: AppText(
                      "Image not found",
                      color: theme.colors.white33,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, error, stackTrace) {
                return AppContainer(
                  width: width ?? loadingWidth ?? 320,
                  height: height ?? loadingHeight ?? 180,
                  child: const AppSkeletonLoader(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
