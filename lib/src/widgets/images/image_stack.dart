import 'dart:math';
import 'dart:ui';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'image_viewer_utils.dart';
import 'video_preview_cache.dart';
import 'package:video_player/video_player.dart';

class LabImageStack extends StatefulWidget {
  final List<String> images;
  final VoidCallback? onTap;
  static const double _maxWidth = 220.0;
  static const double _maxHeight = 280.0;
  static const double _stackVerticalOffset = 10.0;
  static const double _stackHorizontalOffset = 32.0;
  static const double _stackHorizontalOffsetHover = 40.0;
  static const double _stackRotation = -5.0;

  const LabImageStack({
    super.key,
    required this.images,
    this.onTap,
  });

  static void _showFullScreen(BuildContext context, List<String> images) {
    if (images.length == 1) {
      // For single images/videos, go directly to full screen view
      ImageViewerUtils.showFullScreenImage(context, images[0]);
    } else {
      // For multiple images, use the existing LabOpenedImages.show
      LabOpenedImages.show(context, images);
    }
  }

  @override
  State<LabImageStack> createState() => _LabImageStackState();
}

class _LabImageStackState extends State<LabImageStack> {
  Size? _firstImageSize;
  double? _aspectRatio;
  bool _isHovered = false;
  ImageStreamListener? _imageStreamListener;
  ImageStream? _imageStream;
  Map<String, VideoPlayerController?> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    _resolveImage();
    _initializeVideoControllers();
  }

  @override
  void didUpdateWidget(covariant LabImageStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Release old video controllers
    for (final url in oldWidget.images) {
      if (_isVideo(url) && !widget.images.contains(url)) {
        VideoPreviewCache.release(url);
        _videoControllers.remove(url);
      }
    }

    // Initialize new video controllers
    if (oldWidget.images != widget.images) {
      _initializeVideoControllers();
    }
  }

  @override
  void dispose() {
    // Release all video controllers
    for (final url in _videoControllers.keys) {
      VideoPreviewCache.release(url);
    }
    _videoControllers.clear();

    if (_imageStreamListener != null && _imageStream != null) {
      _imageStream!.removeListener(_imageStreamListener!);
    }
    super.dispose();
  }

  void _initializeVideoControllers() {
    for (final url in widget.images) {
      if (_isVideo(url) && !_videoControllers.containsKey(url)) {
        VideoPreviewCache.acquire(url).then((controller) {
          if (!mounted) return;
          setState(() {
            _videoControllers[url] = controller;
          });
        });
      }
    }
  }

  void _resolveImage() {
    final ImageProvider imageProvider = NetworkImage(widget.images[0]);
    _imageStream = imageProvider.resolve(const ImageConfiguration());
    _imageStreamListener = ImageStreamListener((ImageInfo info, bool _) {
      if (!mounted) return;
      final Size size =
          Size(info.image.width.toDouble(), info.image.height.toDouble());
      setState(() {
        _firstImageSize = size;
        _aspectRatio = size.width / size.height;
      });
    });
    _imageStream!.addListener(_imageStreamListener!);
  }

  bool _isVideo(String url) {
    return ImageViewerUtils.isVideoUrl(url);
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

  Widget _buildImageOrVideo(String url, double width, double height,
      {double opacity = 1.0}) {
    final theme = LabTheme.of(context);

    if (_isVideo(url)) {
      final controller = _videoControllers[url];
      if (controller != null && controller.value.isInitialized) {
        return ClipRRect(
          borderRadius: theme.radius.asBorderRadius().rad16,
          child: Opacity(
            opacity: opacity,
            child: Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: VideoPlayer(controller),
                ),
              ),
            ),
          ),
        );
      } else {
        return Opacity(
          opacity: opacity,
          child: LabContainer(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: theme.colors.black,
              borderRadius: theme.radius.asBorderRadius().rad16,
            ),
            child: const Center(child: LabSkeletonLoader()),
          ),
        );
      }
    } else {
      return Opacity(
        opacity: opacity,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: width,
          height: height,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              const LabSkeletonLoader(),
          errorWidget: (context, url, error) => Center(
            child: LabText(
              "Image not found",
              color: theme.colors.white33,
            ),
          ),
        ),
      );
    }
  }

  Size _calculateContainerSize() {
    final theme = LabTheme.of(context);

    if (_aspectRatio == null) {
      return const Size(LabImageStack._maxWidth, LabImageStack._maxWidth);
    }

    final double aspectRatio = _aspectRatio!;

    // If aspect ratio is more extreme than golden ratio, constrain to golden ratio
    if (aspectRatio > theme.sizes.phi) {
      // Too wide - use max width and constrain height
      return Size(
          LabImageStack._maxWidth, LabImageStack._maxWidth / theme.sizes.phi);
    } else if (aspectRatio < 1 / theme.sizes.phi) {
      // Too tall - use max height and constrain width
      return Size(
          LabImageStack._maxHeight / theme.sizes.phi, LabImageStack._maxHeight);
    }

    // If within golden ratio bounds, maintain original aspect ratio
    if (LabImageStack._maxWidth / aspectRatio <= LabImageStack._maxHeight) {
      // Width constrained
      return Size(
          LabImageStack._maxWidth, LabImageStack._maxWidth / aspectRatio);
    } else {
      // Height constrained
      return Size(
          LabImageStack._maxHeight * aspectRatio, LabImageStack._maxHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    if (widget.images.isEmpty) return const SizedBox.shrink();

    final containerSize = _calculateContainerSize();
    final (isInsideMessageBubble, isOutgoing) = MessageBubbleScope.of(context);

    final double horizontalOffset = _isHovered
        ? LabImageStack._stackHorizontalOffsetHover
        : LabImageStack._stackHorizontalOffset;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap ??
            () => LabImageStack._showFullScreen(context, widget.images),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOutgoing && isInsideMessageBubble && widget.images.length > 1)
              SizedBox(width: theme.sizes.s48),
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Third image (behind)
                if (widget.images.length > 2)
                  Positioned(
                    right: isOutgoing ? null : 0,
                    left: isOutgoing ? 0 : null,
                    top: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      transform: Matrix4.rotationZ((isOutgoing ? 1 : -1) *
                          (LabImageStack._stackRotation * 2 * (pi / 180)))
                        ..translate(
                            (isOutgoing ? -1 : 1) * horizontalOffset * 2,
                            (isOutgoing ? 1.6 : 1) *
                                LabImageStack._stackVerticalOffset *
                                2),
                      child: LabContainer(
                        width: containerSize.width - 80,
                        height: containerSize.height - 80,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: theme.colors.black,
                          borderRadius: theme.radius.asBorderRadius().rad16,
                          border: Border.all(
                            color: theme.colors.white16,
                            width: LabLineThicknessData.normal().thin,
                          ),
                        ),
                        child: _buildImageOrVideo(
                          widget.images[2],
                          containerSize.width - 80,
                          containerSize.height - 80,
                          opacity: 0.6,
                        ),
                      ),
                    ),
                  ),
                // Second image (behind)
                if (widget.images.length > 1)
                  Positioned(
                    right: isOutgoing ? null : 0,
                    left: isOutgoing ? 0 : null,
                    top: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      transform: Matrix4.rotationZ((isOutgoing ? 1 : -1) *
                          (LabImageStack._stackRotation * (pi / 180)))
                        ..translate(
                            (isOutgoing ? -1 : 1) * horizontalOffset,
                            (isOutgoing ? 1.6 : 1) *
                                LabImageStack._stackVerticalOffset),
                      child: LabContainer(
                        width: containerSize.width - 40,
                        height: containerSize.height - 40,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: theme.colors.black,
                          borderRadius: theme.radius.asBorderRadius().rad16,
                          border: Border.all(
                            color: theme.colors.white16,
                            width: LabLineThicknessData.normal().thin,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colors.black16,
                              offset: Offset(isOutgoing ? -4 : 4, 0),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: _buildImageOrVideo(
                          widget.images[1],
                          containerSize.width - 40,
                          containerSize.height - 40,
                          opacity: 0.8,
                        ),
                      ),
                    ),
                  ),
                // First image (front)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  transform: Matrix4.identity()
                    ..scale(_isHovered ? 1.0033 : 1.0),
                  child: LabContainer(
                    width: containerSize.width,
                    height: containerSize.height,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: theme.colors.black,
                      borderRadius: theme.radius.asBorderRadius().rad16,
                      border: Border.all(
                        color: theme.colors.white16,
                        width: LabLineThicknessData.normal().thin,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colors.black16,
                          offset: Offset(isOutgoing ? -4 : 4, 0),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        _buildImageOrVideo(
                          widget.images[0],
                          containerSize.width,
                          containerSize.height,
                        ),
                        // Play icon for videos
                        if (_isVideo(widget.images[0])) _buildPlayIcon(),
                        // Counter for additional images
                        if (widget.images.length > 1)
                          Positioned(
                            right: isOutgoing ? null : 12,
                            left: isOutgoing ? 12 : null,
                            top: 12,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: LabContainer(
                                  height: theme.sizes.s28,
                                  padding: const LabEdgeInsets.symmetric(
                                      horizontal: LabGapSize.s10),
                                  decoration: BoxDecoration(
                                    color: theme.colors.gray66,
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Center(
                                    child: LabText.med14(
                                      '${widget.images.length}',
                                      color: theme.colors.white66,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (!isOutgoing &&
                isInsideMessageBubble &&
                widget.images.length > 1)
              SizedBox(width: theme.sizes.s48),
          ],
        ),
      ),
    );
  }
}
