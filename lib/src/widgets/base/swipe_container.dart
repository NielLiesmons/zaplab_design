import 'package:zaplab_design/zaplab_design.dart';
import 'dart:io' show Platform;

class AppSwipeContainer extends StatefulWidget {
  final Widget child;
  final Widget? leftContent;
  final Widget? rightContent;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final double actionWidth;
  final BoxDecoration? decoration;
  final AppEdgeInsets? padding;
  final AppEdgeInsets? margin;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;

  const AppSwipeContainer({
    super.key,
    required this.child,
    this.leftContent,
    this.rightContent,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.actionWidth = 56,
    this.decoration,
    this.padding,
    this.margin,
    this.alignment,
    this.constraints,
  });

  @override
  State<AppSwipeContainer> createState() => _AppSwipeContainerState();
}

class _AppSwipeContainerState extends State<AppSwipeContainer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _popController;
  late Animation<double> _leftWidthAnimation;
  late Animation<double> _rightWidthAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _leftScaleAnimation;
  late Animation<double> _rightScaleAnimation;
  double _dragStart = 0;
  bool _isLeftActionVisible = false;
  bool _isRightActionVisible = false;
  Axis? _lockedAxis;
  double _initialDragDelta = 0;
  static const double _kTouchSlopMobile = 8.0;
  static const double _kTouchSlopDesktop = 40.0;

  double get _touchSlop {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return _kTouchSlopDesktop;
    }
    return _kTouchSlopMobile;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurationsData.normal().normal,
    );
    _popController = AnimationController(
      vsync: this,
      duration: AppDurationsData.normal().fast,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _leftWidthAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _rightWidthAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _leftScaleAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    _rightScaleAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _popController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _dragStart = details.localPosition.dx;
    _lockedAxis = null;
    _initialDragDelta = 0;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final delta = details.localPosition.dx - _dragStart;

    // If we haven't locked the direction yet
    if (_lockedAxis == null) {
      _initialDragDelta = delta.abs();

      // Only lock direction once we've passed the touch slop threshold
      if (_initialDragDelta > _touchSlop) {
        _lockedAxis = Axis.horizontal;
        // Reset visibility states based on initial direction
        setState(() {
          _isLeftActionVisible = delta > 0 && widget.leftContent != null;
          _isRightActionVisible = delta < 0 && widget.rightContent != null;
        });
      } else {
        return; // Don't process the drag until we pass threshold
      }
    }

    if (_isLeftActionVisible) {
      final progress = (delta / widget.actionWidth).clamp(0, 1);
      _leftWidthAnimation = Tween<double>(
        begin: 0,
        end: delta.clamp(0, widget.actionWidth),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));

      // Only trigger pop when reaching full scale during expansion
      final previousScale = _leftScaleAnimation.value;
      _leftScaleAnimation = Tween<double>(
        begin: 0,
        end: progress.toDouble(),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ));

      if (progress >= 0.99 &&
          previousScale < 0.99 &&
          !_popController.isAnimating) {
        _popController.forward(from: 0).then((_) => _popController.reverse());
      }
    } else if (_isRightActionVisible) {
      final progress = (-delta / widget.actionWidth).clamp(0, 1);

      // Only trigger pop when reaching full scale during expansion
      final previousScale = _rightScaleAnimation.value;
      _rightScaleAnimation = Tween<double>(
        begin: 0,
        end: progress.toDouble(),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ));

      if (progress >= 0.99 &&
          previousScale < 0.99 &&
          !_popController.isAnimating) {
        _popController.forward(from: 0).then((_) => _popController.reverse());
      }

      _rightWidthAnimation = Tween<double>(
        begin: 0,
        end: (-delta).clamp(0, widget.actionWidth),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
    }

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(
        delta.clamp(-widget.actionWidth, widget.actionWidth),
        0,
      ),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.value = 1.0;
  }

  void _handleDragEnd(DragEndDetails details) {
    _lockedAxis = null;
    _initialDragDelta = 0;
    final velocity = details.velocity.pixelsPerSecond.dx;
    final threshold = widget.actionWidth * 0.5;

    if (_isLeftActionVisible && velocity > threshold) {
      widget.onSwipeRight?.call();
    } else if (_isRightActionVisible && velocity < -threshold) {
      widget.onSwipeLeft?.call();
    }

    setState(() {
      _isLeftActionVisible = false;
      _isRightActionVisible = false;
    });

    _leftWidthAnimation = Tween<double>(
      begin: _leftWidthAnimation.value,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _rightWidthAnimation = Tween<double>(
      begin: _rightWidthAnimation.value,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: _slideAnimation.value,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _leftScaleAnimation = Tween<double>(
      begin: _leftScaleAnimation.value,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _rightScaleAnimation = Tween<double>(
      begin: _rightScaleAnimation.value,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: AppContainer(
        decoration: widget.decoration,
        padding: widget.padding,
        margin: widget.margin,
        alignment: widget.alignment,
        constraints: widget.constraints,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // Main content
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) => Transform.translate(
                offset: _slideAnimation.value,
                child: widget.child,
              ),
            ),
            // Left action overlay
            if (widget.leftContent != null)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: AnimatedBuilder(
                  animation: _leftWidthAnimation,
                  builder: (context, child) => SizedBox(
                    width: _leftWidthAnimation.value,
                    child: AppContainer(
                      decoration: BoxDecoration(
                        color: theme.colors.white16,
                      ),
                      child: Center(
                        child: ScaleTransition(
                          scale: _leftScaleAnimation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 1.0, end: 1.25)
                                .animate(CurvedAnimation(
                              parent: _popController,
                              curve: Curves.easeOut,
                            )),
                            child: widget.leftContent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // Right action overlay
            if (widget.rightContent != null)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: AnimatedBuilder(
                  animation: _rightWidthAnimation,
                  builder: (context, child) => SizedBox(
                    width: _rightWidthAnimation.value,
                    child: AppContainer(
                      decoration: BoxDecoration(
                        color: theme.colors.white16,
                      ),
                      child: Center(
                        child: ScaleTransition(
                          scale: _rightScaleAnimation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 1.0, end: 1.25)
                                .animate(CurvedAnimation(
                              parent: _popController,
                              curve: Curves.easeOut,
                            )),
                            child: widget.rightContent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
