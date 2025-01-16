import 'package:zaplab_design/zaplab_design.dart';

class AppInteractionPills extends StatefulWidget {
  final List<Zap> zaps;
  final List<Reaction> reactions;
  final String eventId;
  final void Function(String, int, String?)? onZap;
  final void Function(String, String)? onReact;

  const AppInteractionPills({
    super.key,
    required this.eventId,
    this.zaps = const [],
    this.reactions = const [],
    this.onZap,
    this.onReact,
  });

  @override
  State<AppInteractionPills> createState() => _AppInteractionPillsState();
}

class _AppInteractionPillsState extends State<AppInteractionPills>
    with TickerProviderStateMixin {
  final Map<String, AnimationController> _pillControllers = {};

  @override
  void didUpdateWidget(AppInteractionPills oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkNewInteractions(oldWidget);
  }

  void _checkNewInteractions(AppInteractionPills oldWidget) {
    // Check for new zaps
    for (final zap in widget.zaps) {
      if (!oldWidget.zaps.contains(zap)) {
        _animateNewPill(
            '${widget.eventId}-zap-${zap.timestamp.millisecondsSinceEpoch}');
      }
    }
    // Check for new reactions
    for (final reaction in widget.reactions) {
      if (!oldWidget.reactions.contains(reaction)) {
        _animateNewPill(
            '${widget.eventId}-reaction-${reaction.timestamp.millisecondsSinceEpoch}');
      }
    }
  }

  void _animateNewPill(String key) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pillControllers[key] = controller;
    controller.forward().then((_) {
      if (mounted) {
        setState(() {
          _pillControllers.remove(key);
        });
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _pillControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.zaps.isEmpty && widget.reactions.isEmpty)
      return const SizedBox();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...widget.zaps.map((zap) {
            final key =
                '${widget.eventId}-zap-${zap.timestamp.millisecondsSinceEpoch}';
            final controller = _pillControllers[key];

            return _buildAnimatedPill(
              key: key,
              controller: controller,
              child: AppZapPill(
                amount: zap.amount,
                profilePicUrl: zap.profilePicUrl,
                onTap: () =>
                    widget.onZap?.call(widget.eventId, zap.amount, zap.comment),
              ),
            );
          }),
          ...widget.reactions.map((reaction) {
            final key =
                '${widget.eventId}-reaction-${reaction.timestamp.millisecondsSinceEpoch}';
            final controller = _pillControllers[key];

            return _buildAnimatedPill(
              key: key,
              controller: controller,
              child: AppReactionPill(
                emojiUrl: reaction.emojiUrl,
                profilePicUrl: reaction.profilePicUrl,
                onTap: () =>
                    widget.onReact?.call(widget.eventId, reaction.emojiUrl),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnimatedPill({
    required String key,
    required AnimationController? controller,
    required Widget child,
  }) {
    if (controller == null) {
      return AppContainer(
        padding: const AppEdgeInsets.only(right: AppGapSize.s12),
        child: child,
      );
    }

    return ScaleTransition(
      key: ValueKey(key),
      scale: TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.2)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 40.0,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 1.2, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 60.0,
        ),
      ]).animate(controller),
      child: AppContainer(
        padding: const AppEdgeInsets.only(right: AppGapSize.s12),
        child: child,
      ),
    );
  }
}
