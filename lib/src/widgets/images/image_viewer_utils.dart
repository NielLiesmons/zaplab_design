import 'package:zaplab_design/zaplab_design.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tap_builder/tap_builder.dart';

class ImageViewerUtils {
  static void showFullScreenImage(
    BuildContext context,
    String imageUrl, {
    TransformationController? transformationController,
  }) {
    final theme = LabTheme.of(context);
    final controller = transformationController ?? TransformationController();

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: LabContainer(
              decoration: BoxDecoration(
                color: theme.colors.black66,
              ),
              child: Stack(
                children: [
                  // Background tap area (next to image)
                  Positioned.fill(
                    child: TapBuilder(
                      onTap: () => Navigator.of(context).pop(),
                      builder: (context, state, hasFocus) {
                        return Container(
                          color: theme.colors.black33,
                        );
                      },
                    ),
                  ),
                  // Full screen zoomable image with swipe detection
                  Center(
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      transformationController: controller,
                      onInteractionEnd: (details) {
                        // Only exit on swipe down when at minimum scale (full width)
                        final matrix = controller.value;
                        final scale = matrix.getMaxScaleOnAxis();
                        if (scale <= 0.5 &&
                            details.velocity.pixelsPerSecond.dy > 300) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                const Center(child: LabLoadingDots()),
                        errorWidget: (context, url, error) => Center(
                          child: LabText(
                            "Image not found",
                            color: LabTheme.of(context).colors.white33,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Close button
                  Positioned(
                    top: MediaQuery.of(context).padding.top + theme.sizes.s16,
                    right: theme.sizes.s16,
                    child: LabCrossButton(
                      onTap: () => Navigator.of(context).pop(),
                      size: LabCrossButtonSize.s32,
                      isLight: false,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
