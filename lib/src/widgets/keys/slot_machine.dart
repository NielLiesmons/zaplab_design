import 'package:zaplab_design/zaplab_design.dart';
import 'dart:math';

class AppSlotMachine extends StatefulWidget {
  final List<int>? targetIndices; // Optional predetermined final positions
  final int minRandomEmojis; // Minimum number of emojis to show before settling

  const AppSlotMachine({
    super.key,
    this.targetIndices,
    this.minRandomEmojis = 50,
  });

  @override
  State<AppSlotMachine> createState() => _AppSlotMachineState();
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

class _AppSlotMachineState extends State<AppSlotMachine>
    with TickerProviderStateMixin {
  static const List<String> _emojis = [
    // Animals
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯', '🦁', '🐮',
    '🐷', '🐸',
    '🐵', '🐔', '🐧', '🐦', '🦆', '🦅', '🦉', '🦇', '🐺', '🐗', '🐴', '🦄',
    '🐝', '🐛',
    '🦋', '🐌', '🐞', '🐜', '🦗', '🕷', '🦂', '🦀', '🦑', '🐙', '🦐', '🐠',
    '🐟', '🐡',
    '🐬', '🦈', '🐳', '🐋', '🦒', '🦏', '🦍', '🐘', '🦛', '🦘', '🦬', '🦙',
    '🦥', '🦨',
    // Plants
    '🌸', '🌺', '🌹', '🌷', '🌼', '🌻', '🌞', '🌝', '🌵', '🌴', '🌳', '🌲',
    '🎄', '🌿',
    '☘️', '🍀', '🎍', '🎋', '🍃', '🍂', '🍁', '🌾', '🌱', '🌿', '🍄', '🌰',
    '🥜', '🌸',
    '🏵️', '🌹', '🥀', '🌺', '🌻', '🌼', '🌷', '💐', '🌾', '🌱', '🌿', '🍀',
    '🎍', '🎋',
    // Smileys
    '😀', '😃', '😄', '😁', '😆', '😅', '😂', '🤣', '🥲', '☺️', '😊', '😇',
    '🙂', '🙃',
    '😉', '😌', '😍', '🥰', '😘', '😗', '😙', '😚', '😋', '😛', '😝', '😜',
    '🤪', '🤨',
    '🧐', '🤓', '😎', '🥸', '🤩', '🥳', '😏', '😒', '😞', '😔', '😟', '😕',
    '🙁', '☹️',
    '😣', '😖', '😫', '😩', '🥺', '😢', '😭', '😤', '😠', '😡', '🤬', '🤯',
    '😳', '🥵',
    // More fun ones
    '🌈', '⭐', '✨', '💫', '🌟', '☄️', '🌙', '🌎', '🌍', '🌏', '🪐', '💥', '🔥',
    '⚡',
    '🌪', '🌈', '🌤', '⛅', '🌥', '☁️', '🌦', '🌧', '⛈', '🌩', '🌨', '❄️', '☃️',
    '⛄',
    '🌬', '💨', '💧', '💦', '☔', '🌊', '🎪', '🎭', '🎨', '🎰', '🎲', '🎯', '🎳',
    '🎮',
  ];

  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;
  final List<int> _currentIndices =
      List.generate(12, (index) => 0); // 3 rows * 4 disks
  double _handleOffset = 18.0; // Initial circle position
  bool _isDragging = false;
  late final AnimationController _handleController;
  late Animation<double> _handleAnimation;

  @override
  void initState() {
    super.initState();
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
        end: _emojis.length.toDouble(),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();

    _handleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Add listener to trigger rebuild
    _handleController.addListener(() {
      setState(() {
        if (_handleController.isAnimating) {
          _handleOffset = _handleAnimation.value;
        }
      });
    });
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
    for (var i = 0; i < _controllers.length; i++) {
      final staggerDelay = i * 100; // Stagger start times

      Future.delayed(Duration(milliseconds: staggerDelay), () {
        // Calculate final position
        final targetIndex = widget.targetIndices != null
            ? widget.targetIndices![i % widget.targetIndices!.length]
            : Random().nextInt(_emojis.length);

        // Show exactly 50 random emojis before the target
        final endValue = 50 + targetIndex.toDouble();

        _controllers[i].duration = const Duration(milliseconds: 2000);
        _controllers[i].reset();

        _animations[i] = Tween<double>(
          begin: 0,
          end: endValue,
        ).animate(CurvedAnimation(
          parent: _controllers[i],
          curve: SlotSpinCurve(),
        ));

        _controllers[i].forward().then((_) {
          setState(() {
            _currentIndices[i] = targetIndex;
          });
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

    // Trigger spin when letting go
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

  Widget _buildDisk(AppThemeData theme, int rowIndex, int diskIndex) {
    final controllerIndex = (rowIndex * 4) + diskIndex;

    return AppContainer(
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
          final currentIndex = value.floor() % _emojis.length;
          final offset = -(value % 1.0) * 56.0 +
              16; // Add 16px offset to center vertically (88 - 56)/2

          return Stack(
            children: [
              Positioned(
                top: offset - 56,
                left: 0,
                right: 0,
                child: AppContainer(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colors.black33,
                        width: LineThicknessData.normal().medium,
                      ),
                    ),
                  ),
                  child: Center(
                    child: AppText(
                      _emojis[(currentIndex - 1) % _emojis.length],
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: offset,
                left: 0,
                right: 0,
                child: AppContainer(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colors.black33,
                        width: LineThicknessData.normal().medium,
                      ),
                    ),
                  ),
                  child: Center(
                    child: AppText(
                      _emojis[currentIndex],
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: offset + 56,
                left: 0,
                right: 0,
                child: AppContainer(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colors.black33,
                        width: LineThicknessData.normal().medium,
                      ),
                    ),
                  ),
                  child: Center(
                    child: AppText(
                      _emojis[(currentIndex + 1) % _emojis.length],
                      fontSize: 30,
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

  Widget _buildDiskRow(AppThemeData theme, int rowIndex) {
    return AppContainer(
      height: 88,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: theme.colors.black66,
        borderRadius: theme.radius.asBorderRadius().rad16,
        border: Border.all(
          color: theme.colors.white16,
          width: LineThicknessData.normal().thin,
        ),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppGap.s8(),
              _buildDisk(theme, rowIndex, 0),
              const AppGap.s4(),
              _buildDisk(theme, rowIndex, 1),
              const AppGap.s4(),
              _buildDisk(theme, rowIndex, 2),
              const AppGap.s4(),
              _buildDisk(theme, rowIndex, 3),
              const AppGap.s8(),
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

  Widget _buildHandle(AppThemeData theme, double totalHeight) {
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
            child: AppContainer(
              width: 32,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0x88000000),
                borderRadius: theme.radius.asBorderRadius().rad16,
                border: Border.all(
                  color: theme.colors.white16,
                  width: LineThicknessData.normal().thin,
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
                  child: AppContainer(
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
                            AppColorsData.dark().black16,
                            AppColorsData.dark().black8,
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
              child: AppContainer(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  gradient: theme.colors.blurple,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColorsData.dark().black33,
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
    final theme = AppTheme.of(context);
    const totalHeight = 296.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            _buildDiskRow(theme, 0),
            const AppGap.s16(),
            _buildDiskRow(theme, 1),
            const AppGap.s16(),
            _buildDiskRow(theme, 2),
          ],
        ),
        const AppGap.s16(),
        _buildHandle(theme, totalHeight),
      ],
    );
  }
}

// New spin curve for the precise control we need
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
