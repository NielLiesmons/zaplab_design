import 'package:zaplab_design/zaplab_design.dart';
import 'dart:async';
import 'dart:math' as math;

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

  @override
  void initState() {
    super.initState();
    _imageSizeFuture = _getImageSize();
  }

  Future<Size> _getImageSize() async {
    final image = NetworkImage(widget.url);
    final completer = Completer<Size>();

    image.resolve(ImageConfiguration.empty).addListener(
      ImageStreamListener((info, _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    return completer.future;
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

                  return LabContainer(
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
                      child: Image.network(
                        widget.url,
                        fit: useMaxHeight ? BoxFit.contain : BoxFit.cover,
                        width: constraints.maxWidth,
                        height: useMaxHeight ? maxHeight : height,
                        loadingBuilder: (context, error, stackTrace) {
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
