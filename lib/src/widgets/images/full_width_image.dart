import 'package:zaplab_design/zaplab_design.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'image_viewer_utils.dart';
import 'video_preview_cache.dart';
import 'package:video_player/video_player.dart';

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
  VideoPlayerController? _videoController;
  bool _isVideo = false;
  Duration? _videoDuration;

  @override
  void initState() {
    super.initState();
    _imageSizeFuture = _getImageSize();
    _checkIfVideo();
  }

  @override
  void dispose() {
    if (_isVideo && _videoController != null) {
      VideoPreviewCache.release(widget.url);
    }
    super.dispose();
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

  void _checkIfVideo() {
    _isVideo = ImageViewerUtils.isVideoUrl(widget.url);
    if (_isVideo) {
      _initializeVideoController();
    }
  }

  void _initializeVideoController() {
    VideoPreviewCache.acquire(widget.url).then((controller) {
      if (!mounted) return;
      setState(() {
        _videoController = controller;
        _videoDuration = controller?.value.duration;
      });
    });
  }

  Widget _buildPlayIcon() {
    final theme = LabTheme.of(context);
    return Center(
      child: LabIcon(
        theme.icons.characters.play,
        size: LabIconSize.s32,
        color: theme.colors.white,
      ),
    );
  }

  Widget _buildDurationBadge() {
    final theme = LabTheme.of(context);
    if (_videoDuration == null) return const SizedBox.shrink();

    final minutes = _videoDuration!.inMinutes;
    final seconds = _videoDuration!.inSeconds % 60;
    final durationText = '$minutes:${seconds.toString().padLeft(2, '0')}';

    return Positioned(
      bottom: 12,
      right: 12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: LabContainer(
            padding: const LabEdgeInsets.symmetric(
              horizontal: LabGapSize.s8,
              vertical: LabGapSize.s4,
            ),
            decoration: BoxDecoration(
              color: theme.colors.black66,
              borderRadius: BorderRadius.circular(8),
            ),
            child: LabText.med12(
              durationText,
              color: theme.colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    ImageViewerUtils.showFullScreenImage(
      context,
      widget.url,
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
                      child: Stack(
                        children: [
                          if (_isVideo)
                            (_videoController != null &&
                                    _videoController!.value.isInitialized)
                                ? ClipRect(
                                    child: FittedBox(
                                      fit: useMaxHeight
                                          ? BoxFit.contain
                                          : BoxFit.cover,
                                      child: SizedBox(
                                        width:
                                            _videoController!.value.size.width,
                                        height:
                                            _videoController!.value.size.height,
                                        child: VideoPlayer(_videoController!),
                                      ),
                                    ),
                                  )
                                : const Center(child: LabSkeletonLoader())
                          else
                            Center(
                              child: CachedNetworkImage(
                                imageUrl: widget.url,
                                fit: useMaxHeight
                                    ? BoxFit.contain
                                    : BoxFit.cover,
                                width: constraints.maxWidth,
                                height: useMaxHeight ? maxHeight : height,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        const LabSkeletonLoader(),
                                errorWidget: (context, url, error) => Center(
                                  child: LabText(
                                    _isVideo
                                        ? "Video not found"
                                        : "Image not found",
                                    color: theme.colors.white33,
                                  ),
                                ),
                              ),
                            ),
                          if (_isVideo) _buildPlayIcon(),
                          if (_isVideo && _videoDuration != null)
                            _buildDurationBadge(),
                        ],
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
