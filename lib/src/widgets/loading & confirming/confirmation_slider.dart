import 'package:zaplab_design/zaplab_design.dart';

enum ConfirmationSliderState {
  inactive,
  readyToConfirm,
  loading,
  success,
}

class LabConfirmationSlider extends StatefulWidget {
  final String inactiveText;
  final String readyToConfirmText;
  final String loadingText;
  final Widget successContent;
  final ConfirmationSliderState state;
  final VoidCallback? onConfirm;
  final VoidCallback? onSuccessComplete;

  const LabConfirmationSlider({
    super.key,
    required this.inactiveText,
    required this.readyToConfirmText,
    required this.loadingText,
    required this.successContent,
    this.state = ConfirmationSliderState.inactive,
    this.onConfirm,
    this.onSuccessComplete,
  });

  @override
  State<LabConfirmationSlider> createState() => _LabConfirmationSliderState();
}

class _LabConfirmationSliderState extends State<LabConfirmationSlider>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _expandController;
  late Animation<double> _slideAnimation;
  late Animation<double> _expandAnimation;

  double _dragPosition = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    // Outer container animates from 80 -> 440. Inner (draggable) = outer - 16
    _expandAnimation = Tween<double>(
      begin: 80.0, // Outer container height
      end: 440.0, // Outer container height on success
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(LabConfirmationSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.state != oldWidget.state) {
      _handleStateChange();
    }
  }

  void _handleStateChange() {
    switch (widget.state) {
      case ConfirmationSliderState.inactive:
        _slideController.reset();
        _expandController.reset();
        _dragPosition = 0.0;
        break;
      case ConfirmationSliderState.readyToConfirm:
        _slideController.reset();
        _expandController.reset();
        _dragPosition = 0.0;
        break;
      case ConfirmationSliderState.loading:
        _slideController.forward();
        break;
      case ConfirmationSliderState.success:
        _expandController.forward();
        break;
    }
  }

  void _onPanStart(DragStartDetails details) {
    if (widget.state == ConfirmationSliderState.readyToConfirm) {
      setState(() {
        _isDragging = true;
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details, double availableWidth) {
    if (widget.state == ConfirmationSliderState.readyToConfirm && _isDragging) {
      setState(() {
        _dragPosition += details.delta.dx;
        _dragPosition =
            _dragPosition.clamp(0.0, _getMaxDragDistance(availableWidth));
      });
    }
  }

  void _onPanEnd(DragEndDetails details, double availableWidth) {
    if (widget.state == ConfirmationSliderState.readyToConfirm && _isDragging) {
      setState(() {
        _isDragging = false;
      });

      if (_dragPosition >= _getMaxDragDistance(availableWidth) * 0.8) {
        // Confirmed - snap to full width and trigger the action
        _slideController.forward();
        widget.onConfirm?.call();
      } else {
        // Reset to start position smoothly
        _slideController.reverse();
        _dragPosition = 0.0;
      }
    }
  }

  double _getMaxDragDistance(double availableWidth) {
    return availableWidth - 64.0; // 64px circle width
  }

  @override
  void dispose() {
    _slideController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: Listenable.merge([_slideAnimation, _expandAnimation]),
          builder: (context, child) {
            final outerHeight = _expandAnimation.value;
            final innerHeight = outerHeight - 16.0; // 8px padding on each side
            final availableWidth =
                constraints.maxWidth - 16.0; // 8px padding on each side

            return LabContainer(
              height: outerHeight,
              width: double.infinity,
              padding: const LabEdgeInsets.all(LabGapSize.s8),
              decoration: BoxDecoration(
                color: theme.colors.black33,
                borderRadius: theme.radius.asBorderRadius().rad40,
              ),
              child:
                  _buildDraggableContainer(theme, availableWidth, innerHeight),
            );
          },
        );
      },
    );
  }

  Widget _buildDraggableContainer(
      LabThemeData theme, double availableWidth, double innerHeight) {
    // Use drag position if dragging, otherwise use animation value
    // But if we're in loading state and have confirmed, keep full width
    double slideProgress;
    if (_isDragging) {
      slideProgress =
          (_dragPosition / _getMaxDragDistance(availableWidth)).clamp(0.0, 1.0);
    } else if (widget.state == ConfirmationSliderState.loading ||
        widget.state == ConfirmationSliderState.success) {
      // Once confirmed, always stay at full width
      slideProgress = 1.0;
    } else {
      slideProgress = _slideAnimation.value;
    }

    // Calculate width: starts at 64px, expands to full width when dragged
    final currentWidth =
        64.0 + (slideProgress * _getMaxDragDistance(availableWidth));

    // Keep left edge pinned; do not move container, only grow width
    const double currentPosition = 0.0;

    // Get gradient based on state
    Gradient containerGradient;
    Color chevronColor;

    switch (widget.state) {
      case ConfirmationSliderState.inactive:
        containerGradient = theme.colors.blurple33;
        chevronColor = theme.colors.whiteEnforced.withValues(alpha: 0.50);
        break;
      case ConfirmationSliderState.readyToConfirm:
        containerGradient = theme.colors.blurple;
        chevronColor = theme.colors.whiteEnforced;
        break;
      case ConfirmationSliderState.loading:
        containerGradient = theme.colors.blurple;
        chevronColor = theme.colors.whiteEnforced;
        break;
      case ConfirmationSliderState.success:
        containerGradient = theme.colors.blurple;
        chevronColor = theme.colors.whiteEnforced;
        break;
    }

    return Stack(
      children: [
        // Text content (always centered in the outer container)
        Center(
          child: _buildTextContent(theme),
        ),
        // Draggable container (starts as circle, expands horizontally)
        Positioned(
          left: currentPosition,
          top: 0.0, // Always at top, fills full height
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: (details) => _onPanUpdate(details, availableWidth),
            onPanEnd: (details) => _onPanEnd(details, availableWidth),
            child: LabContainer(
              width: currentWidth,
              height: innerHeight, // Fill the inner height
              decoration: BoxDecoration(
                gradient: containerGradient,
                borderRadius: theme.radius.asBorderRadius().rad32,
              ),
              child: widget.state == ConfirmationSliderState.success
                  ? SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: LabContainer(
                        padding: const LabEdgeInsets.all(LabGapSize.s16),
                        child: Expanded(
                          child: Column(
                            children: [
                              const LabGap.s32(),
                              LabContainer(
                                padding: const LabEdgeInsets.only(
                                  left: LabGapSize.s16,
                                  bottom: LabGapSize.s6,
                                ),
                                child: Image(
                                  image: const AssetImage(
                                    'assets/emoji/success.gif',
                                    package: 'zaplab_design',
                                  ),
                                  width: 124,
                                  height: 124,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: LabIcon(
                                        theme.icons.characters.emojiFill,
                                        size: LabIconSize.s80,
                                        color: theme.colors.white33,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              LabText(
                                color: theme.colors.white,
                                'Done!',
                                textAlign: TextAlign.center,
                                level: LabTextLevel.h1,
                                fontSize: 38,
                              ),
                              LabContainer(
                                height: 174,
                                child: widget.successContent,
                              ),
                            ],
                          ),
                        ),
                      ))
                  : _buildCircleContent(theme, chevronColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleContent(LabThemeData theme, Color chevronColor) {
    return Stack(
      children: [
        // Loading text centered in the container
        if (widget.state == ConfirmationSliderState.loading)
          Center(
            child: LabText.med16(
              widget.loadingText,
              color: theme.colors.white,
              textAlign: TextAlign.center,
            ),
          ),
        // Chevron always positioned at the right edge
        Positioned(
          right: 26.0,
          top: 0,
          bottom: 0,
          child: Center(
            child: LabIcon.s16(
              theme.icons.characters.chevronRight,
              outlineColor: chevronColor,
              outlineThickness: LabLineThicknessData.normal().thick,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextContent(LabThemeData theme) {
    String text;
    Gradient textGradient;

    switch (widget.state) {
      case ConfirmationSliderState.inactive:
        text = widget.inactiveText;
        textGradient = theme.colors.graydient33;
        break;
      case ConfirmationSliderState.readyToConfirm:
        text = widget.readyToConfirmText;
        textGradient = theme.colors.graydient33;
        break;
      case ConfirmationSliderState.loading:
        text = widget.loadingText;
        textGradient = theme.colors.graydient66;
        break;
      case ConfirmationSliderState.success:
        text = '';
        textGradient = theme.colors.graydient66;
        ;
        break;
    }

    return LabText.reg16(
      text,
      gradient: textGradient,
      textAlign: TextAlign.center,
    );
  }
}
