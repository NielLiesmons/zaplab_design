import 'dart:math';
import 'dart:ui';
import 'package:zaplab_design/zaplab_design.dart';

class AppImageStack extends StatefulWidget {
  final List<String> imageUrls;
  final VoidCallback? onTap;
  static const double _maxWidth = 220.0;
  static const double _maxHeight = 280.0;
  static const double _stackVerticalOffset = 10.0;
  static const double _stackHorizontalOffset = 32.0;
  static const double _stackHorizontalOffsetHover = 40.0;
  static const double _stackRotation = -5.0;

  const AppImageStack({
    super.key,
    required this.imageUrls,
    this.onTap,
  });

  static void _showFullScreen(BuildContext context, List<String> imageUrls) {
    final theme = AppTheme.of(context);

    AppSlideInScreen(
      child: AppScreen(
        onHomeTap: () => Navigator.of(context).pop(),
        alwaysShowTopBar: true,
        topBarContent: AppContainer(
          height: theme.sizes.s28,
          padding: const AppEdgeInsets.only(
            top: AppGapSize.s8,
          ),
          child: AppText.med14('${imageUrls.length} Images',
              color: theme.colors.white66),
        ),
        child: Column(
          children: [
            const AppGap.s40(),
            for (final url in imageUrls) ...[
              AppFullWidthImage(
                url: url,
              ),
              const AppGap.s16(),
            ],
          ],
        ),
      ),
    );
  }

  @override
  State<AppImageStack> createState() => _AppImageStackState();
}

class _AppImageStackState extends State<AppImageStack> {
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
    final ImageProvider imageProvider = NetworkImage(widget.imageUrls[0]);
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
    final theme = AppTheme.of(context);

    if (_aspectRatio == null) {
      return const Size(AppImageStack._maxWidth, AppImageStack._maxWidth);
    }

    final double aspectRatio = _aspectRatio!;

    // If aspect ratio is more extreme than golden ratio, constrain to golden ratio
    if (aspectRatio > theme.sizes.phi) {
      // Too wide - use max width and constrain height
      return Size(
          AppImageStack._maxWidth, AppImageStack._maxWidth / theme.sizes.phi);
    } else if (aspectRatio < 1 / theme.sizes.phi) {
      // Too tall - use max height and constrain width
      return Size(
          AppImageStack._maxHeight / theme.sizes.phi, AppImageStack._maxHeight);
    }

    // If within golden ratio bounds, maintain original aspect ratio
    if (AppImageStack._maxWidth / aspectRatio <= AppImageStack._maxHeight) {
      // Width constrained
      return Size(
          AppImageStack._maxWidth, AppImageStack._maxWidth / aspectRatio);
    } else {
      // Height constrained
      return Size(
          AppImageStack._maxHeight * aspectRatio, AppImageStack._maxHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    if (widget.imageUrls.isEmpty) return const SizedBox.shrink();

    final containerSize = _calculateContainerSize();
    final (_, isOutgoing) = MessageBubbleScope.of(context);

    final double horizontalOffset = _isHovered
        ? AppImageStack._stackHorizontalOffsetHover
        : AppImageStack._stackHorizontalOffset;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap ??
            () => AppImageStack._showFullScreen(context, widget.imageUrls),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOutgoing) SizedBox(width: theme.sizes.s80),
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Third image (behind)
                if (widget.imageUrls.length > 2)
                  Positioned(
                    right: isOutgoing ? null : 0,
                    left: isOutgoing ? 0 : null,
                    top: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      transform: Matrix4.rotationZ((isOutgoing ? 1 : -1) *
                          (AppImageStack._stackRotation * 2 * (pi / 180)))
                        ..translate(
                            (isOutgoing ? -1 : 1) * horizontalOffset * 2,
                            (isOutgoing ? 1.6 : 1) *
                                AppImageStack._stackVerticalOffset *
                                2),
                      child: AppContainer(
                        width: containerSize.width - 80,
                        height: containerSize.height - 80,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: theme.colors.black,
                          borderRadius: theme.radius.asBorderRadius().rad16,
                          border: Border.all(
                            color: theme.colors.white16,
                            width: AppLineThicknessData.normal().thin,
                          ),
                        ),
                        child: Opacity(
                          opacity: 0.6,
                          child: Image.network(
                            widget.imageUrls[2],
                            fit: BoxFit.cover,
                            width: containerSize.width - 80,
                            height: containerSize.height - 80,
                            alignment: Alignment.center,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const AppSkeletonLoader();
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const AppSkeletonLoader();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                // Second image (behind)
                if (widget.imageUrls.length > 1)
                  Positioned(
                    right: isOutgoing ? null : 0,
                    left: isOutgoing ? 0 : null,
                    top: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      transform: Matrix4.rotationZ((isOutgoing ? 1 : -1) *
                          (AppImageStack._stackRotation * (pi / 180)))
                        ..translate(
                            (isOutgoing ? -1 : 1) * horizontalOffset,
                            (isOutgoing ? 1.6 : 1) *
                                AppImageStack._stackVerticalOffset),
                      child: AppContainer(
                        width: containerSize.width - 40,
                        height: containerSize.height - 40,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: theme.colors.black,
                          borderRadius: theme.radius.asBorderRadius().rad16,
                          border: Border.all(
                            color: theme.colors.white16,
                            width: AppLineThicknessData.normal().thin,
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
                            widget.imageUrls[1],
                            fit: BoxFit.cover,
                            width: containerSize.width - 40,
                            height: containerSize.height - 40,
                            alignment: Alignment.center,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const AppSkeletonLoader();
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const AppSkeletonLoader();
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
                  child: AppContainer(
                    width: containerSize.width,
                    height: containerSize.height,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: theme.colors.black,
                      borderRadius: theme.radius.asBorderRadius().rad16,
                      border: Border.all(
                        color: theme.colors.white16,
                        width: AppLineThicknessData.normal().thin,
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
                          widget.imageUrls[0],
                          fit: BoxFit.cover,
                          width: containerSize.width,
                          height: containerSize.height,
                          alignment: Alignment.center,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const AppSkeletonLoader();
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const AppSkeletonLoader();
                          },
                        ),
                        // Counter for additional images
                        if (widget.imageUrls.length > 1)
                          Positioned(
                            right: isOutgoing ? null : 12,
                            left: isOutgoing ? 12 : null,
                            top: 12,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                                child: AppContainer(
                                  height: theme.sizes.s28,
                                  padding: const AppEdgeInsets.symmetric(
                                      horizontal: AppGapSize.s10),
                                  decoration: BoxDecoration(
                                    color: theme.colors.gray66,
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Center(
                                    child: AppText.med14(
                                      '${widget.imageUrls.length}',
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
