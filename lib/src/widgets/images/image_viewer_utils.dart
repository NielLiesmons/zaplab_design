import 'package:zaplab_design/zaplab_design.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageViewerUtils {
  static const List<String> _videoExtensions = [
    'mp4',
    'webm',
    'avi',
    'mov',
    'mkv',
    'flv',
    'wmv',
    'm4v'
  ];

  static bool isVideoUrl(String url) {
    final lowercaseUrl = url.toLowerCase();
    return _videoExtensions.any((ext) => lowercaseUrl.endsWith('.$ext'));
  }

  static void showFullScreenImage(BuildContext context, String url) {
    if (isVideoUrl(url)) {
      // For videos, push the full screen video player
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LabFullScreenVideoPlayer(videoUrl: url),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else {
      // For images, use the custom image viewer
      _showCustomImageViewer(context, url);
    }
  }

  static void _showCustomImageViewer(BuildContext context, String url) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _CustomImageViewer(imageUrl: url),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

class _CustomImageViewer extends StatelessWidget {
  final String imageUrl;

  const _CustomImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabScaffold(
      backgroundColor: theme.colors.black,
      body: Stack(
        children: [
          // Full screen image
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                errorWidget: (context, url, error) => Center(
                  child: LabText(
                    "Image not found",
                    color: theme.colors.white33,
                  ),
                ),
              ),
            ),
          ),
          // Close button
          Positioned(
            top: MediaQuery.viewPaddingOf(context).top + 16,
            right: 16,
            child: LabCrossButton.s32(
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
