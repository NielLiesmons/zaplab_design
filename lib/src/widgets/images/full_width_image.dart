import 'package:zaplab_design/zaplab_design.dart';
import 'dart:async';

class AppFullWidthImage extends StatefulWidget {
  final String url;
  final String? caption;

  const AppFullWidthImage({
    super.key,
    required this.url,
    this.caption,
  });

  @override
  State<AppFullWidthImage> createState() => _AppFullWidthImageState();
}

class _AppFullWidthImageState extends State<AppFullWidthImage> {
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
    final theme = AppTheme.of(context);

    return FutureBuilder<Size>(
      future: _imageSizeFuture,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppContainer(
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: theme.colors.grey66,
                border: Border.all(
                  color: theme.colors.white16,
                  width: LineThicknessData.normal().thin,
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final skeletonHeight = constraints.maxWidth / 1.618;

                  if (!snapshot.hasData) {
                    return AppContainer(
                      width: double.infinity,
                      height: skeletonHeight,
                      decoration: BoxDecoration(
                        color: theme.colors.grey33,
                      ),
                      child: const AppSkeletonLoader(),
                    );
                  }

                  final imageSize = snapshot.data!;
                  final aspectRatio = imageSize.width / imageSize.height;
                  final maxHeight = constraints.maxWidth * 1.618;
                  final height = constraints.maxWidth / aspectRatio;
                  final useMaxHeight = height > maxHeight;

                  return Container(
                    width: constraints.maxWidth,
                    height: useMaxHeight ? maxHeight : height,
                    color: theme.colors.grey66,
                    child: Center(
                      child: Image.network(
                        widget.url,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const AppSkeletonLoader();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            if (widget.caption != null)
              AppContainer(
                height: theme.sizes.s38,
                padding: const AppEdgeInsets.symmetric(
                  horizontal: AppGapSize.s12,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppText.med12(
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
