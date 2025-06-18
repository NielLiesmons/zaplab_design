import 'dart:math';
import 'dart:ui';
import 'package:zaplab_design/zaplab_design.dart';

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
    LabOpenedImages.show(context, images);
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

  @override
  void initState() {
    super.initState();
    _resolveImage();
  }

  @override
  void dispose() {
    if (_imageStreamListener != null && _imageStream != null) {
      _imageStream!.removeListener(_imageStreamListener!);
    }
    super.dispose();
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
    final (_, isOutgoing) = MessageBubbleScope.of(context);

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
            if (isOutgoing) SizedBox(width: theme.sizes.s80),
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
                        child: Opacity(
                          opacity: 0.6,
                          child: Image.network(
                            widget.images[2],
                            fit: BoxFit.cover,
                            width: containerSize.width - 80,
                            height: containerSize.height - 80,
                            alignment: Alignment.center,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const LabSkeletonLoader();
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const LabSkeletonLoader();
                            },
                          ),
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
                        child: Opacity(
                          opacity: 0.8,
                          child: Image.network(
                            widget.images[1],
                            fit: BoxFit.cover,
                            width: containerSize.width - 40,
                            height: containerSize.height - 40,
                            alignment: Alignment.center,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const LabSkeletonLoader();
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const LabSkeletonLoader();
                            },
                          ),
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
                        Image.network(
                          widget.images[0],
                          fit: BoxFit.cover,
                          width: containerSize.width,
                          height: containerSize.height,
                          alignment: Alignment.center,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const LabSkeletonLoader();
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const LabSkeletonLoader();
                          },
                        ),
                        // Counter for additional images
                        if (widget.images.length > 1)
                          Positioned(
                            right: isOutgoing ? null : 12,
                            left: isOutgoing ? 12 : null,
                            top: 12,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 24, sigmaY: 24),
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
            if (!isOutgoing) SizedBox(width: theme.sizes.s80),
          ],
        ),
      ),
    );
  }
}
