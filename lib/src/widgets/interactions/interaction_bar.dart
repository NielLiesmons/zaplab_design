import 'package:zaplab_design/zaplab_design.dart';

class AppInteractionBar extends StatefulWidget {
  final List<Zap> zaps;
  final List<Reaction> reactions;
  final String nevent;
  final void Function(String)? onZapTap;
  final void Function(String)? onReactionTap;
  final VoidCallback? onExpand;

  const AppInteractionBar({
    super.key,
    required this.nevent,
    this.zaps = const [],
    this.reactions = const [],
    this.onZapTap,
    this.onReactionTap,
    this.onExpand,
  });

  @override
  State<AppInteractionBar> createState() => _AppInteractionBarState();
}

class _AppInteractionBarState extends State<AppInteractionBar>
    with TickerProviderStateMixin {
  final _scrollController = ScrollController();
  late final AnimationController _actionZoneController;
  late final AnimationController _popController;
  late Animation<double> _actionWidthAnimation;
  late Animation<double> _actionScaleAnimation;
  final _initialScrollPosition = 0;
  static const double _actionWidth = 56.0;

  @override
  void initState() {
    super.initState();
    _actionZoneController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _popController = AnimationController(
      duration: AppDurationsData.normal().fast,
      vsync: this,
    );
    _setupAnimations();
    _scrollController.addListener(_handleScroll);
  }

  void _setupAnimations() {
    _actionWidthAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: _actionZoneController,
        curve: Curves.easeInOut,
      ),
    );
    _actionScaleAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: _actionZoneController,
        curve: Curves.elasticOut,
      ),
    );
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    final delta = _scrollController.position.pixels - _initialScrollPosition;
    if (delta < 0) {
      final progress = (-delta / _actionWidth).clamp(0, 1);

      final previousScale = _actionScaleAnimation.value;
      _actionScaleAnimation = Tween<double>(
        begin: 0,
        end: progress.toDouble(),
      ).animate(CurvedAnimation(
        parent: _actionZoneController,
        curve: Curves.elasticOut,
      ));

      _actionWidthAnimation = Tween<double>(
        begin: 0,
        end: (-delta).clamp(0, _actionWidth),
      ).animate(CurvedAnimation(
        parent: _actionZoneController,
        curve: Curves.easeInOut,
      ));

      if (progress >= 0.99 &&
          previousScale < 0.99 &&
          !_popController.isAnimating) {
        widget.onExpand?.call();
        _popController.forward(from: 0).then((_) => _popController.reverse());
      }

      _actionZoneController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _actionZoneController.dispose();
    _popController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    if (widget.zaps.isEmpty && widget.reactions.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        const AppDivider(),
        Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ScrollPhysics(),
              child: AppContainer(
                padding: const AppEdgeInsets.symmetric(
                  horizontal: AppGapSize.s12,
                  vertical: AppGapSize.s12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppInteractionPills(
                      nevent: widget.nevent,
                      zaps: widget.zaps,
                      reactions: widget.reactions,
                      onZapTap: widget.onZapTap,
                      onReactionTap: widget.onReactionTap,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: AnimatedBuilder(
                animation: _actionWidthAnimation,
                builder: (context, child) => SizedBox(
                  width: _actionWidthAnimation.value,
                  child: AppContainer(
                    decoration: BoxDecoration(
                      color: theme.colors.white16,
                    ),
                    child: Center(
                      child: ScaleTransition(
                        scale: _actionScaleAnimation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 1.0, end: 1.25).animate(
                            CurvedAnimation(
                              parent: _popController,
                              curve: Curves.easeOut,
                            ),
                          ),
                          child: AppIcon.s16(
                            theme.icons.characters.expand,
                            color: theme.colors.white66,
                            outlineColor: theme.colors.white66,
                            outlineThickness: LineThicknessData.normal().medium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
