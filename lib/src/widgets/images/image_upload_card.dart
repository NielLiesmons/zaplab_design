import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class LabImageUploadCard extends StatelessWidget {
  final String? url;
  final VoidCallback? onTap;
  final double? ratio;

  const LabImageUploadCard({
    super.key,
    this.url,
    this.onTap,
    this.ratio = 16 / 9,
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              if (maxWidth > 400) {
                return LabContainer(
                  width: double.infinity,
                  height: 400 * (1 / ratio!),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    gradient: theme.colors.blurple16,
                    borderRadius: theme.radius.asBorderRadius().rad16,
                    border: Border.all(
                      color: theme.colors.white16,
                      width: LabLineThicknessData.normal().thin,
                    ),
                  ),
                  child: url != null
                      ? Image.network(
                          url!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const LabSkeletonLoader();
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: LabText(
                                "Image not found",
                                color: theme.colors.white33,
                              ),
                            );
                          },
                        )
                      : Center(
                          child: LabIcon.s32(
                            theme.icons.characters.camera,
                            gradient: theme.colors.graydient33,
                          ),
                        ),
                );
              }
              return AspectRatio(
                aspectRatio: ratio!,
                child: LabContainer(
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    gradient: theme.colors.blurple16,
                    borderRadius: theme.radius.asBorderRadius().rad16,
                    border: Border.all(
                      color: theme.colors.white16,
                      width: LabLineThicknessData.normal().thin,
                    ),
                  ),
                  child: url != null
                      ? Image.network(
                          url!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const LabSkeletonLoader();
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: LabText(
                                "Image not found",
                                color: theme.colors.white33,
                              ),
                            );
                          },
                        )
                      : Center(
                          child: LabIcon.s32(
                            theme.icons.characters.camera,
                            gradient: theme.colors.graydient33,
                          ),
                        ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
