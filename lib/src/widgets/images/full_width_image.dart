import 'package:zaplab_design/zaplab_design.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tap_builder/tap_builder.dart';

class LabFullWidthImage extends StatefulWidget {
  final String url;
  final String? caption;

  const LabFullWidthImage({
    super.key,
    required this.url,
    this.caption,
  });

  @override
  State<LabFullWidthImage> createState() => _LabFullWidthImageState();
}

class _LabFullWidthImageState extends State<LabFullWidthImage> {
  late Future<Size> _imageSizeFuture;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _imageSizeFuture = _getImageSize();
  }

  Future<Size> _getImageSize() async {
    final image = CachedNetworkImageProvider(widget.url);
    final completer = Completer<Size>();

    image.resolve(ImageConfiguration.empty).addListener(
      ImageStreamListener((info, _) {
        if (!completer.isCompleted) {
          completer.complete(Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          ));
        }
      }),
    );

    return completer.future;
  }

  void _showFullScreenImage(BuildContext context) {
    final theme = LabTheme.of(context);

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
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
                      transformationController: _transformationController,
                      onInteractionEnd: (details) {
                        // Only exit on swipe down when at minimum scale (full width)
                        final matrix = _transformationController.value;
                        final scale = matrix.getMaxScaleOnAxis();
                        if (scale <= 0.5 &&
                            details.velocity.pixelsPerSecond.dy > 300) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: CachedNetworkImage(
                        imageUrl: widget.url,
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

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return FutureBuilder<Size>(
      future: _imageSizeFuture,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabContainer(
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: theme.colors.gray66,
                border: Border.all(
                  color: theme.colors.white16,
                  width: LabLineThicknessData.normal().thin,
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final skeletonHeight = constraints.maxWidth / 1.618;

                  if (!snapshot.hasData) {
                    return LabContainer(
                      width: double.infinity,
                      height: skeletonHeight,
                      decoration: BoxDecoration(
                        color: theme.colors.gray33,
                      ),
                      child: const LabSkeletonLoader(),
                    );
                  }

                  final imageSize = snapshot.data!;
                  final aspectRatio = imageSize.width / imageSize.height;
                  final maxHeight =
                      math.min(constraints.maxWidth * 1.618, 600.0);
                  final height = constraints.maxWidth / aspectRatio;
                  final useMaxHeight = height > maxHeight;

                  return GestureDetector(
                    onTap: () => _showFullScreenImage(context),
                    child: LabContainer(
                      width: constraints.maxWidth,
                      height: useMaxHeight ? maxHeight : height,
                      decoration: BoxDecoration(
                        color: theme.colors.gray66,
                        border: Border.all(
                          color: theme.colors.white16,
                          width: LabLineThicknessData.normal().thin,
                        ),
                      ),
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: widget.url,
                          fit: useMaxHeight ? BoxFit.contain : BoxFit.cover,
                          width: constraints.maxWidth,
                          height: useMaxHeight ? maxHeight : height,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  const LabSkeletonLoader(),
                          errorWidget: (context, url, error) => Center(
                            child: LabText(
                              "Image not found",
                              color: theme.colors.white33,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (widget.caption != null)
              LabContainer(
                height: theme.sizes.s38,
                padding: const LabEdgeInsets.symmetric(
                  horizontal: LabGapSize.s12,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: LabText.med12(
                    widget.caption!,
                    color: theme.colors.white66,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
