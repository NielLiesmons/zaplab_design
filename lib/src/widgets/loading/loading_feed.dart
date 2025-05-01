import 'package:zaplab_design/zaplab_design.dart';

enum LoadingFeedType {
  content,
  chat,
  thread,
}

class AppLoadingFeed extends StatefulWidget {
  final LoadingFeedType type;
  final Widget? customLoader;

  const AppLoadingFeed({
    super.key,
    this.type = LoadingFeedType.content,
    this.customLoader,
  });

  @override
  State<AppLoadingFeed> createState() => _AppLoadingFeedState();
}

class _AppLoadingFeedState extends State<AppLoadingFeed> {
  bool _showLoading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      if (mounted) {
        setState(() {
          _showLoading = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_showLoading) {
      return const SizedBox.shrink();
    }

    final theme = AppTheme.of(context);

    switch (widget.type) {
      case LoadingFeedType.content:
        return AppContainer(
          padding: const AppEdgeInsets.all(AppGapSize.s16),
          child: Column(
            children: [
              for (var i = 0; i < 21; i++) ...[
                AppContainer(
                  height: 160,
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: theme.radius.asBorderRadius().rad16,
                  ),
                  child: widget.customLoader ?? const AppSkeletonLoader(),
                ),
                const AppGap.s16(),
              ],
            ],
          ),
        );
      case LoadingFeedType.chat:
        return AppContainer(
          padding: const AppEdgeInsets.all(AppGapSize.s8),
          child: Column(
            children: [
              for (var i = 0; i < 21; i++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const AppContainer(
                      height: 32,
                      width: 32,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: AppSkeletonLoader(),
                    ),
                    const AppGap.s6(),
                    Opacity(
                      opacity: 0.66,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Random height message bubbles with varying widths
                          for (var j = 0; j < (i % 3) + 1; j++) ...[
                            Column(
                              children: [
                                AppContainer(
                                  height: (j % 2 == 0 ? 40.0 : 60.0) +
                                      (i % 3) * 10.0,
                                  width: i % 3 == 0
                                      ? 104.0
                                      : i % 3 == 1
                                          ? 200.0
                                          : 240.0,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: theme.colors.gray33,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(theme.sizes.s16),
                                      topRight:
                                          Radius.circular(theme.sizes.s16),
                                      bottomRight:
                                          Radius.circular(theme.sizes.s16),
                                      bottomLeft: Radius.circular(j == (i % 3)
                                          ? theme.sizes.s4
                                          : theme.sizes.s16),
                                    ),
                                  ),
                                  child: const AppSkeletonLoader(),
                                ),
                                if (j < (i % 3)) const AppGap.s2(),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const AppGap.s48(),
                  ],
                ),
                const AppGap.s6(),
              ],
            ],
          ),
        );
      case LoadingFeedType.thread:
        return Column(
          children: [
            for (var i = 0; i < 21; i++) ...[
              AppContainer(
                padding: const AppEdgeInsets.all(AppGapSize.s12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          const Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              AppContainer(
                                height: 38,
                                width: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: AppSkeletonLoader(),
                              ),
                            ],
                          ),
                          const AppGap.s12(),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AppContainer(
                                      height: 16,
                                      width: 128,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            theme.radius.asBorderRadius().rad16,
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: const AppSkeletonLoader(),
                                    ),
                                    const Spacer(),
                                    AppContainer(
                                      height: 14,
                                      width: 32,
                                      decoration: BoxDecoration(
                                        color: theme.colors.white8,
                                        borderRadius:
                                            theme.radius.asBorderRadius().rad16,
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                                  ],
                                ),
                                const AppGap.s8(),
                                AppContainer(
                                  height: 160,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        theme.radius.asBorderRadius().rad16,
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: const Opacity(
                                    opacity: 0.50,
                                    child: AppSkeletonLoader(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppDivider.horizontal(color: theme.colors.white8),
            ],
          ],
        );
    }
  }
}
