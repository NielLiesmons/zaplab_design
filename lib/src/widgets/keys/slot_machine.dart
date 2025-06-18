import 'package:zaplab_design/zaplab_design.dart';
import 'dart:math';

class LabSlotMachine extends StatefulWidget {
  final String? initialNsec; // Optional initial nsec to display
  final bool showSelector; // Controls visibility of the mode selector
  final void Function(String secretKey, String mode)? onSpinComplete;

  const LabSlotMachine({
    super.key,
    this.initialNsec,
    this.showSelector = false,
    this.onSpinComplete,
  });

  @override
  State<LabSlotMachine> createState() => _LabSlotMachineState();
}

class SlotSpinCurve extends Curve {
  @override
  double transform(double t) {
    // First 60%: Fast spinning
    if (t < 0.6) {
      return t * 1.4; // Accelerated speed
    }
    // Next 30%: Heavy deceleration
    else if (t < 0.9) {
      final slowT = (t - 0.6) / 0.3;
      return 0.84 + (0.14 * (1 - pow(1 - slowT, 3)));
    }
    // Final 10%: Overshoot and settle
    else {
      final settleT = (t - 0.9) / 0.1;
      // Create overshoot that settles back
      return 0.98 + (sin(settleT * pi) * 0.04);
    }
  }
}

class SlotMachineCurve extends Curve {
  @override
  double transform(double t) {
    if (t < 0.7) {
      // First 70%: very fast motion
      return t * 1.6;
    } else if (t < 0.85) {
      // Next 15%: dramatic slowdown
      final slowT = (t - 0.7) / 0.15;
      return 1.12 + (slowT * 0.08);
    } else {
      // Final 15%: overshoot and settle back
      final settleT = (t - 0.85) / 0.15;
      // Create a more pronounced overshoot that settles back
      final overshoot = 1.2 - (pow(settleT - 0.5, 2) * 0.4);
      // Add a small bounce at the very end
      final bounce = sin(settleT * pi * 2) * 0.03 * (1 - settleT);
      return overshoot + bounce;
    }
  }
}

class _LabSlotMachineState extends State<LabSlotMachine>
    with TickerProviderStateMixin {
  List<String> targetEmojis = [];
  String targetNsec = '';
  String targetMnemonic = '';
  final List<String> _currentEmojis = List.filled(12, '-');
  final List<List<int>> _diskIndices = List.generate(12, (_) => []);
  String _currentMode = 'Emoji';

  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;
  final List<int> _currentIndices = List.generate(12, (index) => 0);
  double _handleOffset = 18.0;
  bool _isDragging = false;
  late final AnimationController _handleController;
  late Animation<double> _handleAnimation;

  List<String> _nsecParts = [];
  List<String> _mnemonicWords = [];

  @override
  void initState() {
    super.initState();
    _initializeEmojis();
    _initializeAnimations();
    _initializeNsecParts();

    _handleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _handleController.addListener(() {
      setState(() {
        if (_handleController.isAnimating) {
          _handleOffset = _handleAnimation.value;
        }
      });
    });
  }

  void _initializeEmojis() {
    if (widget.initialNsec != null) {
      // Initialize with provided nsec
      setState(() {
        targetNsec = widget.initialNsec!;
        // Verify the checksum
        final isValid = LabKeyGenerator.verifyNsecChecksum(widget.initialNsec!);
        targetMnemonic =
            LabKeyGenerator.nsecToMnemonic(widget.initialNsec!) ?? '';
        _mnemonicWords = targetMnemonic.split(' ');
        final emojis = LabKeyGenerator.nsecToEmojis(widget.initialNsec!);
        if (emojis != null) {
          targetEmojis = List<String>.from(
              emojis); // Create a copy to prmodel reference issues
          _currentEmojis.fillRange(0, _currentEmojis.length, '-');
        }
      });
    } else {
      // Generate a new key with valid mnemonic
      _generateNewKey();
    }
  }

  void _initializeAnimations() {
    // Initialize controllers and animations
    _controllers = List.generate(
      12,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2000),
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0,
        end: targetEmojis.length.toDouble(),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();
  }

  void _initializeNsecParts() {
    if (widget.initialNsec != null) {
      _nsecParts = _splitNsecIntoParts(widget.initialNsec!);
    } else if (targetNsec.isNotEmpty) {
      _nsecParts = _splitNsecIntoParts(targetNsec);
    }
  }

  void _generateNewKey() {
    // Generate a new mnemonic
    final mnemonic = LabKeyGenerator.generateMnemonic();

    // Convert mnemonic to nsec
    final nsec = LabKeyGenerator.mnemonicToNsec(mnemonic);

    // Verify the checksum
    final isValid = LabKeyGenerator.verifyNsecChecksum(nsec);

    // Convert nsec to emojis
    final emojis = LabKeyGenerator.nsecToEmojis(nsec);
    if (emojis == null) {
      throw Exception('Failed to generate emojis from nsec');
    }

    setState(() {
      targetMnemonic = mnemonic;
      _mnemonicWords = mnemonic.split(' ');
      targetNsec = nsec;
      targetEmojis = List<String>.from(
          emojis); // Create a copy to prmodel reference issues
      _nsecParts = _splitNsecIntoParts(nsec);
      _currentEmojis.fillRange(0, _currentEmojis.length, '-');
      // Initialize disk indices with empty lists
      for (var i = 0; i < _diskIndices.length; i++) {
        _diskIndices[i] = [];
      }
    });
  }

  List<String> _splitNsecIntoParts(String nsec) {
    // First slot shows 'nsec1'
    final parts = ['nsec1'];

    // Get the hex part (after 'nsec1')
    final hex = nsec.substring(5);

    // Split remaining hex into 6-character chunks
    for (var i = 0; i < 11; i++) {
      final start = i * 6;
      final end = start + 6;
      if (start < hex.length) {
        // If we have characters left, add them (even if less than 6)
        parts.add(hex.substring(start, end > hex.length ? hex.length : end));
      } else {
        // If we don't have enough characters, pad with empty string
        parts.add('');
      }
    }

    return parts;
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _handleController.dispose();
    super.dispose();
  }

  void _spin() {
    // For each disk, create its sequence of indices
    for (var i = 0; i < _controllers.length; i++) {
      final staggerDelay = i * 100; // Stagger start times

      Future.delayed(Duration(milliseconds: staggerDelay), () {
        // Create a sequence of 50 random indices
        final diskIndices = List<int>.generate(50, (index) {
          return Random().nextInt(emojis.length);
        });

        // Add the current emoji index at the start
        if (_currentEmojis[i] != '-') {
          diskIndices.insert(0, emojis.indexOf(_currentEmojis[i]));
        }

        // Add the target index at the end
        diskIndices.add(emojis.indexOf(targetEmojis[i]));

        // Set the indices for this disk
        setState(() {
          _diskIndices[i] = diskIndices;
        });

        _controllers[i].duration = const Duration(milliseconds: 2000);
        _controllers[i].reset();

        _animations[i] = Tween<double>(
          begin: 0,
          end: diskIndices.length.toDouble(),
        ).animate(CurvedAnimation(
          parent: _controllers[i],
          curve: SlotSpinCurve(),
        ));

        _controllers[i].forward().then((_) {
          setState(() {
            _currentEmojis[i] = targetEmojis[i];
            // Update the disk indices to start with the current emoji for next spin
            _diskIndices[i] = [emojis.indexOf(_currentEmojis[i])];
          });

          // Check if this was the last disk to finish spinning
          if (i == _controllers.length - 1) {
            // All disks have finished spinning
            widget.onSpinComplete?.call(targetNsec, _currentMode);
          }
        });
      });
    }
  }

  void _onHandleDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onHandleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    setState(() {
      // Constrain circle position between 18 and 234
      _handleOffset = (_handleOffset + details.delta.dy).clamp(18.0, 234.0);
    });
  }

  void _onHandleDragEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });

    // Only generate new key if we don't have an initial nsec
    if (widget.initialNsec == null) {
      _generateNewKey();
    }

    // Trigger spin with new emojis
    _spin();

    // Handle animation back
    _handleAnimation = Tween<double>(
      begin: _handleOffset,
      end: 18.0,
    ).animate(CurvedAnimation(
      parent: _handleController,
      curve: Curves.easeOut,
    ));

    _handleController.reset();
    _handleController.forward();
  }

  Widget _buildDisk(LabThemeData theme, int rowIndex, int diskIndex) {
    final controllerIndex = (rowIndex * 4) + diskIndex;

    return LabContainer(
      width: 56,
      height: 88,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: theme.colors.white16,
      ),
      child: AnimatedBuilder(
        animation: _animations[controllerIndex],
        builder: (context, child) {
          final value = _animations[controllerIndex].value;
          final currentIndex = value.floor();
          final offset = -(value % 1.0) * 56.0 + 16;

          String getDisplayText(String emoji) {
            if (_currentMode == 'Words') {
              if (_mnemonicWords.isEmpty) return '-';
              return _mnemonicWords[controllerIndex % _mnemonicWords.length];
            } else if (_currentMode == 'Nsec') {
              if (_nsecParts.isEmpty) return '-';
              return controllerIndex < _nsecParts.length
                  ? _nsecParts[controllerIndex]
                  : '';
            }
            return emoji;
          }

          final diskIndices = _diskIndices[controllerIndex];
          final currentEmoji = _currentEmojis[controllerIndex];

          // If we're not spinning, show the current emoji
          if (diskIndices.isEmpty ||
              !_controllers[controllerIndex].isAnimating) {
            return Stack(
              children: [
                Positioned(
                  top: offset - 56,
                  left: 0,
                  right: 0,
                  child: LabContainer(
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colors.black33,
                          width: LabLineThicknessData.normal().medium,
                        ),
                      ),
                    ),
                    child: Center(
                      child: LabText(
                        getDisplayText(currentEmoji),
                        fontSize: _currentMode == 'Words'
                            ? 11
                            : _currentMode == 'Nsec'
                                ? 11
                                : 30,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: offset,
                  left: 0,
                  right: 0,
                  child: LabContainer(
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colors.black33,
                          width: LabLineThicknessData.normal().medium,
                        ),
                      ),
                    ),
                    child: Center(
                      child: currentEmoji == '-'
                          ? LabContainer(
                              width: 24,
                              height: 8,
                              decoration: BoxDecoration(
                                color: theme.colors.white33,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            )
                          : LabText(
                              getDisplayText(currentEmoji),
                              fontSize: _currentMode == 'Words'
                                  ? 11
                                  : _currentMode == 'Nsec'
                                      ? 11
                                      : 30,
                            ),
                    ),
                  ),
                ),
                Positioned(
                  top: offset + 56,
                  left: 0,
                  right: 0,
                  child: LabContainer(
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colors.black33,
                          width: LabLineThicknessData.normal().medium,
                        ),
                      ),
                    ),
                    child: Center(
                      child: LabText(
                        getDisplayText(currentEmoji),
                        fontSize: _currentMode == 'Words'
                            ? 11
                            : _currentMode == 'Nsec'
                                ? 11
                                : 30,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // Show spinning animation
          final currentSpinEmoji =
              emojis[diskIndices[currentIndex % diskIndices.length]];
          final prevSpinEmoji =
              emojis[diskIndices[(currentIndex - 1) % diskIndices.length]];
          final nextSpinEmoji =
              emojis[diskIndices[(currentIndex + 1) % diskIndices.length]];

          return Stack(
            children: [
              Positioned(
                top: offset - 56,
                left: 0,
                right: 0,
                child: LabContainer(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colors.black33,
                        width: LabLineThicknessData.normal().medium,
                      ),
                    ),
                  ),
                  child: Center(
                    child: LabText(
                      getDisplayText(prevSpinEmoji),
                      fontSize: _currentMode == 'Words'
                          ? 11
                          : _currentMode == 'Nsec'
                              ? 12
                              : 30,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: offset,
                left: 0,
                right: 0,
                child: LabContainer(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colors.black33,
                        width: LabLineThicknessData.normal().medium,
                      ),
                    ),
                  ),
                  child: Center(
                    child: LabText(
                      getDisplayText(currentSpinEmoji),
                      fontSize: _currentMode == 'Words'
                          ? 11
                          : _currentMode == 'Nsec'
                              ? 12
                              : 30,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: offset + 56,
                left: 0,
                right: 0,
                child: LabContainer(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colors.black33,
                        width: LabLineThicknessData.normal().medium,
                      ),
                    ),
                  ),
                  child: Center(
                    child: LabText(
                      getDisplayText(nextSpinEmoji),
                      fontSize: _currentMode == 'Words'
                          ? 11
                          : _currentMode == 'Nsec'
                              ? 12
                              : 30,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDiskRow(LabThemeData theme, int rowIndex) {
    return LabContainer(
      height: 88,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: theme.colors.black66,
        borderRadius: theme.radius.asBorderRadius().rad16,
        border: Border.all(
          color: theme.colors.white16,
          width: LabLineThicknessData.normal().thin,
        ),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const LabGap.s8(),
              _buildDisk(theme, rowIndex, 0),
              const LabGap.s4(),
              _buildDisk(theme, rowIndex, 1),
              const LabGap.s4(),
              _buildDisk(theme, rowIndex, 2),
              const LabGap.s4(),
              _buildDisk(theme, rowIndex, 3),
              const LabGap.s8(),
            ],
          ),
          // Top gradient overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 28,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    if (theme.colors.white ==
                        const Color(0xFF000000)) // Light theme
                      const Color(0xFF888888)
                    else if (theme.colors.white ==
                        const Color(0xFFFFFFFF)) // Dark theme
                      const Color(0xFF111111)
                    else // Grey theme
                      const Color(0xFF1A1A1A),
                    if (theme.colors.white ==
                        const Color(0xFF000000)) // Light theme
                      const Color(0x00E0E0E0)
                    else if (theme.colors.white ==
                        const Color(0xFFFFFFFF)) // Dark theme
                      const Color(0x00111111)
                    else // Grey theme
                      const Color(0x001A1A1A),
                  ],
                ),
              ),
            ),
          ),
          // Bottom gradient overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 28,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    if (theme.colors.white ==
                        const Color(0xFF000000)) // Light theme
                      const Color(0xFF888888)
                    else if (theme.colors.white ==
                        const Color(0xFFFFFFFF)) // Dark theme
                      const Color(0xFF111111)
                    else // Grey theme
                      const Color(0xFF232323),
                    if (theme.colors.white ==
                        const Color(0xFF000000)) // Light theme
                      const Color(0x00E0E0E0)
                    else if (theme.colors.white ==
                        const Color(0xFFFFFFFF)) // Dark theme
                      const Color(0x00111111)
                    else // Grey theme
                      const Color(0x00232323),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(LabThemeData theme, double totalHeight) {
    final handleBarLength = totalHeight / 2 - 40;
    final centerY = totalHeight / 2; // 148.0
    const baseCircleSize = 44.0;
    const circleGrowth = 6.0; // maxCircleSize - baseCircleSize

    // Calculate handle bar parameters based on circle position
    final isBottomHalf = _handleOffset > centerY;
    final progress = isBottomHalf
        ? (_handleOffset - centerY) / (234 - centerY) // Progress in bottom half
        : (_handleOffset - 18) / (centerY - 18); // Progress in top half

    // Calculate circle size based on distance from center
    final distanceFromCenter = (_handleOffset - centerY).abs();
    final maxDistanceFromCenter = centerY - 18; // Distance from center to top
    final circleProgress = 1.0 - (distanceFromCenter / maxDistanceFromCenter);
    final circleSize = baseCircleSize + (circleGrowth * circleProgress);
    final circleSizeOffset = (circleSize - baseCircleSize) / 2; // For centering

    // Calculate handle bar height and position
    double barHeight;
    double barTop;
    bool isFlipped = false;

    if (isBottomHalf) {
      barHeight = handleBarLength * progress;
      barTop = centerY + (256 - centerY) * progress;
      isFlipped = true;
    } else {
      barHeight = handleBarLength * (1 - progress);
      barTop = 40 + (centerY - 40) * progress;
    }

    return SizedBox(
      width: 48,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Handle opening (slot) - stays fixed
          Positioned(
            left: 8,
            top: (totalHeight - 88) / 2,
            child: LabContainer(
              width: 32,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0x88000000),
                borderRadius: theme.radius.asBorderRadius().rad16,
                border: Border.all(
                  color: theme.colors.white16,
                  width: LabLineThicknessData.normal().thin,
                ),
              ),
            ),
          ),
          // Handle bar - animates
          if (barHeight > 0) // Only show if height > 0
            Positioned(
              left: 16,
              top: barTop,
              child: Transform.scale(
                scaleY: isFlipped ? -1 : 1,
                alignment: Alignment.topCenter,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFF232323),
                        Color(0x00000000),
                      ],
                      stops: [0.5, 0.66, 1],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: LabContainer(
                    width: 16,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9696A3),
                      borderRadius: theme.radius.asBorderRadius().rad8,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            const Color(0x00000000),
                            LabColorsData.dark().black16,
                            LabColorsData.dark().black8,
                          ],
                          stops: const [0.33, 0.80, 1],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // Draggable circle with size animation
          Positioned(
            // Adjust left position to keep circle centered as it grows
            left: 2 - circleSizeOffset,
            // Adjust top position to account for size change while maintaining center point
            top: _handleOffset - circleSizeOffset,
            child: GestureDetector(
              onVerticalDragStart: _onHandleDragStart,
              onVerticalDragUpdate: _onHandleDragUpdate,
              onVerticalDragEnd: _onHandleDragEnd,
              child: LabContainer(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  gradient: theme.colors.blurple,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: LabColorsData.dark().black33,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: const Alignment(-0.6, -0.6),
                      radius: 1.2,
                      colors: theme.colors.white ==
                              const Color(0xFF000000) // Light theme
                          ? [
                              theme.colors.black33,
                              const Color(0x00000000),
                            ]
                          : [
                              const Color(0x00000000),
                              theme.colors.black33,
                            ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    const totalHeight = 296.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                _buildDiskRow(theme, 0),
                const LabGap.s16(),
                _buildDiskRow(theme, 1),
                const LabGap.s16(),
                _buildDiskRow(theme, 2),
              ],
            ),
            const LabGap.s16(),
            _buildHandle(theme, totalHeight),
          ],
        ),
        if (widget.showSelector) ...[
          const LabGap.s32(),
          LabContainer(
            width: 344,
            child: LabSelector(
              children: [
                LabSelectorButton(
                  selectedContent: const [
                    LabText.reg14("Emoji"),
                  ],
                  unselectedContent: [
                    LabText.reg14("Emoji", color: theme.colors.white66),
                  ],
                  isSelected: _currentMode == 'Emoji',
                ),
                LabSelectorButton(
                  selectedContent: const [
                    LabText.reg14("Words"),
                  ],
                  unselectedContent: [
                    LabText.reg14("Words", color: theme.colors.white66),
                  ],
                  isSelected: _currentMode == 'Words',
                ),
                LabSelectorButton(
                  selectedContent: const [
                    LabText.reg14("Nsec"),
                  ],
                  unselectedContent: [
                    LabText.reg14("Nsec", color: theme.colors.white66),
                  ],
                  isSelected: _currentMode == 'Nsec',
                ),
              ],
              onChanged: (index) {
                setState(() {
                  switch (index) {
                    case 0:
                      _currentMode = 'Emoji';
                      break;
                    case 1:
                      _currentMode = 'Words';
                      // If we have a nsec but no mnemonic, generate the mnemonic
                      if (targetNsec.isNotEmpty && targetMnemonic.isEmpty) {
                        targetMnemonic =
                            LabKeyGenerator.nsecToMnemonic(targetNsec) ?? '';
                      }
                      break;
                    case 2:
                      _currentMode = 'Nsec';
                      break;
                  }
                  // Only reset current emojis if we don't have a valid nsec
                  if (targetNsec.isEmpty) {
                    _currentEmojis.fillRange(0, _currentEmojis.length, '-');
                  }
                });
              },
            ),
          ),
        ],
      ],
    );
  }
}
