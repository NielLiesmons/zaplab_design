import 'package:zaplab_design/zaplab_design.dart';
import 'dart:ui';

class AppToast extends StatefulWidget {
  const AppToast({
    super.key,
    required this.children,
    this.onDismiss,
    this.duration = const Duration(seconds: 3),
    this.onTap,
  });

  final List<Widget> children;
  final VoidCallback? onDismiss;
  final VoidCallback? onTap;
  final Duration duration;

  static void show(
    BuildContext context, {
    required List<Widget> children,
    Duration? duration,
    VoidCallback? onDismiss,
    VoidCallback? onTap,
  }) {
    OverlayEntry? entry;

    entry = OverlayEntry(
      builder: (context) => AppToast(
        duration: duration ?? const Duration(seconds: 3),
        onDismiss: () {
          entry?.remove();
          onDismiss?.call();
        },
        onTap: onTap,
        children: children,
      ),
    );

    Overlay.of(context).insert(entry);
  }

  @override
  State<AppToast> createState() => _AppToastState();
}

class _AppToastState extends State<AppToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  final _offset = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurationsData.normal().normal,
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();

    if (widget.duration != Duration.zero) {
      Future.delayed(widget.duration, () {
        if (mounted) _dismiss();
      });
    }
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      widget.onDismiss?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final width = MediaQuery.of(context).size.width;

    return ValueListenableBuilder<double>(
      valueListenable: _offset,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: Offset(0, offset),
          child: SlideTransition(
            position: _offsetAnimation,
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < 0) {
                    _offset.value += details.delta.dy;
                    if (_offset.value < -60) {
                      _dismiss();
                    }
                  }
                },
                onVerticalDragEnd: (details) {
                  if (_offset.value < 0 && _offset.value > -60) {
                    _offset.value = 0;
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    bottom: const AppRadiusData.normal().rad32,
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: AppContainer(
                      width: width,
                      decoration: BoxDecoration(
                        color: theme.colors.gray66,
                        borderRadius: BorderRadius.vertical(
                          bottom: const AppRadiusData.normal().rad32,
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: theme.colors.white16,
                            width: LineThicknessData.normal().thin,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AppTopSafeArea(),
                          AppContainer(
                            padding: AppEdgeInsets.only(
                              left: AppGapSize.s16,
                              right: AppGapSize.s16,
                              bottom: AppGapSize.s16,
                              top: PlatformUtils.isMobile
                                  ? AppGapSize.s4
                                  : AppGapSize.s16,
                            ),
                            constraints: BoxConstraints(maxWidth: width),
                            child: widget.children.first,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
