import 'package:zaplab_design/zaplab_design.dart';

class LabBadgeStack extends StatelessWidget {
  const LabBadgeStack(
    this.badgeUrls, {
    super.key,
    this.size = LabBadgeSize.medium,
    this.maxBadges = 3,
    this.overlap = 24,
    this.onBadgeTap,
  });

  const LabBadgeStack.small(
    this.badgeUrls, {
    super.key,
    this.maxBadges = 3,
    this.overlap = 16,
    this.onBadgeTap,
  }) : size = LabBadgeSize.small;

  const LabBadgeStack.large(
    this.badgeUrls, {
    super.key,
    this.maxBadges = 3,
    this.overlap = 52,
    this.onBadgeTap,
  }) : size = LabBadgeSize.large;

  final List<String> badgeUrls;
  final LabBadgeSize size;
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
              child: LabBadge(
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

  double _getStackWidth(LabBadgeSize size, int badgeCount, double overlap) {
    final baseWidth = _getBadgeWidth(size);
    return baseWidth + (overlap * (badgeCount - 1));
  }

  double _getStackHeight(LabBadgeSize size) {
    return _getBadgeHeight(size);
  }

  double _getBadgeWidth(LabBadgeSize size) {
    switch (size) {
      case LabBadgeSize.small:
        return 32;
      case LabBadgeSize.medium:
        return 42;
      case LabBadgeSize.large:
        return 104;
    }
  }

  double _getBadgeHeight(LabBadgeSize size) {
    switch (size) {
      case LabBadgeSize.small:
        return 38;
      case LabBadgeSize.medium:
        return 52;
      case LabBadgeSize.large:
        return 126;
    }
  }
}
