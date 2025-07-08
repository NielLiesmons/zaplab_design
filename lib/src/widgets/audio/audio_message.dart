import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class LabAudioMessage extends StatefulWidget {
  final String audioUrl;
  final bool isOutgoing;

  const LabAudioMessage({
    super.key,
    required this.audioUrl,
    this.isOutgoing = false,
  });

  @override
  State<LabAudioMessage> createState() => _LabAudioMessageState();
}

class _LabAudioMessageState extends State<LabAudioMessage>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _player;
  bool _isLoading = true;
  Duration _currentDuration = Duration.zero;
  bool _hasError = false;
  Waveform? _waveformData;
  final GlobalKey _waveformKey = GlobalKey();
  double _playbackSpeed = 1.0;
  StreamSubscription? _waveformSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;
  late AnimationController _loadingController;
  List<double> _loadingAmplitudes = [];

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Generate random amplitudes for loading animation
    _loadingAmplitudes = List.generate(20, (index) => 0.3 + (index % 3) * 0.2);

    _initAudioPlayer();
    _extractWaveform();
  }

  Future<void> _extractWaveform() async {
    try {
      final tempDir = await Directory.systemTemp.createTemp();
      final tempFile = File('${tempDir.path}/temp_audio.mp3');

      // Download the file
      final response = await HttpClient().getUrl(Uri.parse(widget.audioUrl));
      final downloadedFile = await response.close();
      await downloadedFile.pipe(tempFile.openWrite());

      final progressStream = JustWaveform.extract(
        audioInFile: tempFile,
        waveOutFile: File('${tempDir.path}/waveform.wave'),
        zoom: const WaveformZoom.pixelsPerSecond(100),
      );

      _waveformSubscription = progressStream.listen((waveformProgress) {
        if (waveformProgress.waveform != null && mounted) {
          setState(() {
            _waveformData = waveformProgress.waveform;
          });
        }
      });
    } catch (e) {
      debugPrint('Error extracting waveform: $e');
    }
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _player.setUrl(widget.audioUrl);

      // Listen to duration changes
      _durationSubscription = _player.durationStream.listen((duration) {
        if (duration != null && mounted) {
          setState(() {
            _currentDuration = duration;
          });
        }
      });

      // Listen to position changes
      _positionSubscription = _player.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _currentDuration = position;
          });
        }
      });

      // Listen to player state changes
      _playerStateSubscription = _player.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isLoading = state.processingState == ProcessingState.loading;
            _hasError = state.processingState == ProcessingState.idle &&
                _player.duration == null;
          });
        }
      });

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error initializing audio player: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _waveformSubscription?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    if (_hasError) {
      return LabContainer(
        constraints: const BoxConstraints(maxWidth: 264),
        padding: const LabEdgeInsets.all(LabGapSize.s4),
        child: Row(
          children: [
            LabContainer(
              width: theme.sizes.s32,
              height: theme.sizes.s32,
              decoration: BoxDecoration(
                color: theme.colors.white8,
                borderRadius: BorderRadius.all(theme.radius.rad16),
              ),
              alignment: Alignment.center,
              child: LabIcon.s16(
                theme.icons.characters.info,
                outlineColor: theme.colors.white66,
                outlineThickness: LabLineThicknessData.normal().medium,
              ),
            ),
            const LabGap.s8(),
            LabText.reg12(
              'Failed to load audio',
              color: theme.colors.white66,
            ),
          ],
        ),
      );
    }

    return LabContainer(
      padding: const LabEdgeInsets.all(LabGapSize.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Play/Pause button
              LabSmallButton(
                square: true,
                rounded: true,
                color: _isLoading ? theme.colors.white8 : theme.colors.white16,
                onTap: _isLoading
                    ? null
                    : () {
                        if (_player.playing) {
                          _player.pause();
                        } else {
                          _player.play();
                        }
                      },
                children: [
                  _player.playing
                      ? const SizedBox(width: 0)
                      : const SizedBox(width: 1),
                  LabIcon.s12(
                    _player.playing
                        ? theme.icons.characters.pause
                        : theme.icons.characters.play,
                    color: (_isLoading || _waveformData == null)
                        ? theme.colors.white33
                        : theme.colors.white,
                  ),
                ],
              ),
              const LabGap.s8(),
              // Progress bar with waveform
              Expanded(
                child: _isLoading || _waveformData == null
                    ? LabContainer(
                        height: 24,
                        width: 160,
                        child: AnimatedBuilder(
                          animation: _loadingController,
                          builder: (context, child) {
                            return CustomPaint(
                              size: const Size(160, 24),
                              painter: LoadingWaveformPainter(
                                amplitudes: _loadingAmplitudes,
                                color: theme.colors.white8,
                                animation: _loadingController.value,
                              ),
                            );
                          },
                        ),
                      )
                    : Stack(
                        children: [
                          LabContainer(
                            height: 32,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: theme.radius.asBorderRadius().rad4,
                              child: GestureDetector(
                                onTapDown: (details) {
                                  final waveformBox = _waveformKey
                                      .currentContext
                                      ?.findRenderObject() as RenderBox?;
                                  if (waveformBox != null) {
                                    final localPosition = waveformBox
                                        .globalToLocal(details.globalPosition);
                                    final duration = _player.duration;

                                    if (duration != null) {
                                      final position = (localPosition.dx / 160)
                                          .clamp(0.0, 1.0);
                                      final seekPosition = duration * position;
                                      _player.seek(seekPosition);
                                    }
                                  }
                                },
                                child: CustomPaint(
                                  key: _waveformKey,
                                  size: const Size(160, 32),
                                  painter: WaveformPainter(
                                    waveform: _waveformData!,
                                    color: theme.colors.white,
                                    progress: _player.duration != null
                                        ? (_currentDuration.inMilliseconds /
                                            _player.duration!.inMilliseconds)
                                        : 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              const LabGap.s8(),
              // Duration
              LabText.reg12(
                LabDurationFormatter.format(_player.duration != null
                    ? _player.duration! - _currentDuration
                    : Duration.zero),
                color: theme.colors.white33,
              ),
            ],
          ),
          if (_player.playing) ...[
            const LabGap.s8(),
            Row(
              children: [
                LabContainer(
                  width: 32,
                  height: 18,
                  decoration: BoxDecoration(
                    color: theme.colors.white16,
                    borderRadius: theme.radius.asBorderRadius().rad8,
                  ),
                  child: TapBuilder(
                    onTap: () {
                      setState(() {
                        _playbackSpeed = switch (_playbackSpeed) {
                          1.0 => 1.5,
                          1.5 => 2.0,
                          _ => 1.0,
                        };
                        _player.setSpeed(_playbackSpeed);
                      });
                    },
                    builder: (context, state, hasFocus) {
                      return Center(
                        child: LabText.reg10(
                          '${_playbackSpeed}x',
                          color: theme.colors.white66,
                        ),
                      );
                    },
                  ),
                ),
                const Spacer(),
                LabContainer(
                  width: 32,
                  height: 18,
                  decoration: BoxDecoration(
                    color: theme.colors.white16,
                    borderRadius: theme.radius.asBorderRadius().rad8,
                  ),
                  child: TapBuilder(
                    onTap: () {
                      // TODO: Implement magic feature
                    },
                    builder: (context, state, hasFocus) {
                      return Center(
                        child: LabIcon.s12(
                          theme.icons.characters.magic,
                          gradient: theme.colors.graydient66,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final Waveform waveform;
  final Color color;
  final double progress;

  WaveformPainter({
    required this.waveform,
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final centerY = height / 2;

    // Define line width and spacing
    const lineWidth = 2.8;
    const spacing = 2.4;
    final totalWidth = lineWidth + spacing;
    final numLines = (width / totalWidth).floor();

    // Calculate the actual spacing to distribute lines evenly
    final actualSpacing = (width - (numLines * lineWidth)) / (numLines - 1);

    // Find the maximum absolute value for normalization
    double maxAmplitude = 0;
    for (var amplitude in waveform.data) {
      maxAmplitude = maxAmplitude > amplitude.abs()
          ? maxAmplitude
          : amplitude.abs().toDouble();
    }

    for (var i = 0; i < numLines; i++) {
      final amplitude =
          waveform.data[i * (waveform.length ~/ numLines)].toDouble();
      final normalizedAmplitude = amplitude.abs() / maxAmplitude;
      final barHeight =
          (normalizedAmplitude * height * 0.8).clamp(1.0, height * 0.8);
      final x = i * (lineWidth + actualSpacing);
      final y = centerY - barHeight / 2;

      final isPlayed = (i / numLines) <= progress;

      final paint = Paint()
        ..color = isPlayed ? color.withOpacity(0.8) : color.withOpacity(0.3)
        ..strokeWidth = lineWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.waveform != waveform ||
        oldDelegate.color != color ||
        oldDelegate.progress != progress;
  }
}

class LoadingWaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final Color color;
  final double animation;

  LoadingWaveformPainter({
    required this.amplitudes,
    required this.color,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final centerY = height / 2;

    // Define line width and spacing
    const lineWidth = 2.8;
    const spacing = 2.4;
    final totalWidth = lineWidth + spacing;
    final numLines = (width / totalWidth).floor();

    // Calculate the actual spacing to distribute lines evenly
    final actualSpacing = (width - (numLines * lineWidth)) / (numLines - 1);

    for (var i = 0; i < numLines; i++) {
      // Use animation to create a wave effect
      final waveOffset = (i / numLines + animation) * 2 * 3.14159;
      final amplitude = amplitudes[i % amplitudes.length];
      final animatedAmplitude = amplitude * (0.8 + 0.2 * (1 + sin(waveOffset)));

      final barHeight =
          (animatedAmplitude * height * 0.8).clamp(1.0, height * 0.8);
      final x = i * (lineWidth + actualSpacing);
      final y = centerY - barHeight / 2;

      final paint = Paint()
        ..color = color
        ..strokeWidth = lineWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(LoadingWaveformPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
