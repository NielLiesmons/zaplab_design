import 'package:zaplab_design/zaplab_design.dart';

class AppBadgeStack extends StatelessWidget {
  const AppBadgeStack(
    this.badgeUrls, {
    super.key,
    this.size = AppBadgeSize.medium,
    this.maxBadges = 3,
    this.overlap = 24,
    this.onBadgeTap,
  });

  const AppBadgeStack.small(
    this.badgeUrls, {
    super.key,
    this.maxBadges = 3,
    this.overlap = 16,
    this.onBadgeTap,
  }) : size = AppBadgeSize.small;

  const AppBadgeStack.large(
    this.badgeUrls, {
    super.key,
    this.maxBadges = 3,
    this.overlap = 52,
    this.onBadgeTap,
  }) : size = AppBadgeSize.large;

  final List<String> badgeUrls;
  final AppBadgeSize size;
  final int maxBadges;
  final double overlap;
  final void Function(int index)? onBadgeTap;

  @override
  Widget build(BuildContext context) {
    final displayBadges = badgeUrls.take(maxBadges).toList();

    return SizedBox(
      width: _getStackWidth(size, displayBadges.length, overlap),
      height: _getStackHeight(size),
      child: Stack(
        children: [
          for (var i = displayBadges.length - 1; i >= 0; i--)
            Positioned(
              left: i * overlap,
              child: AppBadge(
                displayBadges[i],
                size: size,
                hideLeftDovetail: i != 0,
                onTap: onBadgeTap != null ? () => onBadgeTap!(i) : null,
              ),
            ),
        ],
      ),
    );
  }

  double _getStackWidth(AppBadgeSize size, int badgeCount, double overlap) {
    final baseWidth = _getBadgeWidth(size);
    return baseWidth + (overlap * (badgeCount - 1));
  }

  double _getStackHeight(AppBadgeSize size) {
    return _getBadgeHeight(size);
  }

  double _getBadgeWidth(AppBadgeSize size) {
    switch (size) {
      case AppBadgeSize.small:
        return 32;
      case AppBadgeSize.medium:
        return 42;
      case AppBadgeSize.large:
        return 104;
    }
  }

  double _getBadgeHeight(AppBadgeSize size) {
    switch (size) {
      case AppBadgeSize.small:
        return 38;
      case AppBadgeSize.medium:
        return 52;
      case AppBadgeSize.large:
        return 126;
    }
  }
}
