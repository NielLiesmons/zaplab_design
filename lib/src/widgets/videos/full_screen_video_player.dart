import 'package:zaplab_design/zaplab_design.dart';
import 'package:video_player/video_player.dart';
import '../images/video_preview_cache.dart';

class LabFullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const LabFullScreenVideoPlayer({
    super.key,
    required this.videoUrl,
  });

  @override
  State<LabFullScreenVideoPlayer> createState() =>
      _LabFullScreenVideoPlayerState();
}

class _LabFullScreenVideoPlayerState extends State<LabFullScreenVideoPlayer> {
  VideoPlayerController? _videoController;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _showControls = true;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  @override
  void dispose() {
    // Don't release the controller here since it's shared
    super.dispose();
  }

  void _initializeVideoController() async {
    // Use the shared controller from cache
    final controller = await VideoPreviewCache.acquire(widget.videoUrl);
    if (!mounted) return;

    setState(() {
      _videoController = controller;
      _duration = controller?.value.duration ?? Duration.zero;
    });

    // Set up listeners
    controller?.addListener(_videoListener);

    // Start playing automatically
    await controller?.play();
    setState(() {
      _isPlaying = true;
    });
  }

  void _videoListener() {
    if (!mounted) return;
    setState(() {
      _position = _videoController?.value.position ?? Duration.zero;
      _duration = _videoController?.value.duration ?? Duration.zero;
    });
  }

  void _togglePlayPause() async {
    if (_videoController == null) return;

    if (_isPlaying) {
      await _videoController!.pause();
    } else {
      await _videoController!.play();
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleMute() async {
    if (_videoController == null) return;

    await _videoController!.setVolume(_isMuted ? 1.0 : 0.0);
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    if (_videoController == null || !_videoController!.value.isInitialized) {
      return LabScaffold(
        backgroundColor: theme.colors.black,
        body: const Center(child: LabSkeletonLoader()),
      );
    }

    return LabScaffold(
      backgroundColor: theme.colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Video player
            Center(
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            ),

            // Controls overlay
            if (_showControls) _buildControlsOverlay(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsOverlay(LabThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colors.black66,
            theme.colors.black.withValues(alpha: 0),
            theme.colors.black.withValues(alpha: 0),
            theme.colors.black66,
          ],
        ),
      ),
      child: Column(
        children: [
          // Top controls
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.viewPaddingOf(context).top + 16,
              left: 16,
              right: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LabCrossButton.s32(
                  onTap: () => Navigator.of(context).pop(),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _toggleMute,
                      child: LabIcon(
                        _isMuted
                            ? theme.icons.characters.bell
                            : theme.icons.characters.mic,
                        size: LabIconSize.s24,
                        color: theme.colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // Center play/pause button with bigger tap zone
          Center(
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                width: 120,
                height: 120,
                child: Center(
                  child: LabIcon(
                    _isPlaying
                        ? theme.icons.characters.pause
                        : theme.icons.characters.play,
                    size: LabIconSize.s48,
                    color: theme.colors.white,
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          // Bottom progress bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Progress bar
                GestureDetector(
                  onTapDown: (details) {
                    if (_duration.inMilliseconds > 0) {
                      final RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      final localPosition =
                          renderBox.globalToLocal(details.globalPosition);
                      final progressWidth =
                          MediaQuery.of(context).size.width - 32;
                      final tapPosition = localPosition.dx;
                      final progress =
                          (tapPosition / progressWidth).clamp(0.0, 1.0);
                      final newPosition = Duration(
                          milliseconds:
                              (progress * _duration.inMilliseconds).round());
                      _videoController?.seekTo(newPosition);
                      setState(() {
                        _position = newPosition;
                      });
                    }
                  },
                  onPanUpdate: (details) {
                    if (_duration.inMilliseconds > 0) {
                      final RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      final localPosition =
                          renderBox.globalToLocal(details.globalPosition);
                      final progressWidth =
                          MediaQuery.of(context).size.width - 32;
                      final dragPosition = localPosition.dx;
                      final progress =
                          (dragPosition / progressWidth).clamp(0.0, 1.0);
                      final newPosition = Duration(
                          milliseconds:
                              (progress * _duration.inMilliseconds).round());
                      _videoController?.seekTo(newPosition);
                      setState(() {
                        _position = newPosition;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 8, // 8px high as requested
                    decoration: BoxDecoration(
                      color: theme.colors.gray66,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      children: [
                        // Progress bar (blurple)
                        FractionallySizedBox(
                          widthFactor: _duration.inMilliseconds > 0
                              ? _position.inMilliseconds /
                                  _duration.inMilliseconds
                              : 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colors.blurpleColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        // Drag handle (24px, white, on top, not clipped)
                        Positioned(
                          left: _duration.inMilliseconds > 0
                              ? (_position.inMilliseconds /
                                          _duration.inMilliseconds) *
                                      (MediaQuery.of(context).size.width - 32) -
                                  12
                              : -12,
                          top:
                              -8, // Positioned above the bar so it doesn't get clipped
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: theme.colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colors.black33,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Time and duration
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LabText.reg12(
                      _formatDuration(_position),
                      color: theme.colors.white,
                    ),
                    LabText.reg12(
                      _formatDuration(_duration),
                      color: theme.colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
