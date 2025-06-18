import 'package:zaplab_design/zaplab_design.dart';
import 'dart:ui';

enum LabBadgeSize {
  small,
  medium,
  large,
}

class LabBadge extends StatelessWidget {
  const LabBadge(
    this.badgeImageUrl, {
    super.key,
    this.size = LabBadgeSize.medium,
    this.child,
    this.onTap,
    this.hideLeftDovetail = false,
  });

  const LabBadge.small(
    this.badgeImageUrl, {
    super.key,
    this.child,
    this.onTap,
    this.hideLeftDovetail = false,
  }) : size = LabBadgeSize.small;

  const LabBadge.large(
    this.badgeImageUrl, {
    super.key,
    this.child,
    this.onTap,
    this.hideLeftDovetail = false,
  }) : size = LabBadgeSize.large;

  final String badgeImageUrl;
  final LabBadgeSize size;
  final Widget? child;
  final VoidCallback? onTap;
  final bool hideLeftDovetail;

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final dimensions = _getDimensions(size);

    return LabContainer(
      width: dimensions.width,
      height: dimensions.height,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Dovetail decorations
          Positioned(
            bottom: 0,
            child: BadgeDecoration(
              color: theme.colors.white16,
              size: size,
              hideLeftDovetail: hideLeftDovetail,
            ),
          ),
          // Profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(1000),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: dimensions.width / 5, sigmaY: dimensions.width / 5),
              child: LabContainer(
                padding: LabEdgeInsets.all(dimensions.padding),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colors.white16,
                ),
                child: LabProfilePic.fromUrl(
                  badgeImageUrl,
                  size: dimensions.profileSize,
                  onTap: onTap,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BadgeDimensions _getDimensions(LabBadgeSize size) {
    switch (size) {
      case LabBadgeSize.small:
        return const BadgeDimensions(
          width: 32,
          height: 40,
          profileSize: LabProfilePicSize.s28,
          padding: LabGapSize.s2,
        );
      case LabBadgeSize.medium:
        return const BadgeDimensions(
          width: 42,
          height: 52,
          profileSize: LabProfilePicSize.s38,
          padding: LabGapSize.s2,
        );
      case LabBadgeSize.large:
        return const BadgeDimensions(
          width: 104,
          height: 126,
          profileSize: LabProfilePicSize.s96,
          padding: LabGapSize.s4,
        );
    }
  }
}

class BadgeDimensions {
  final double width;
  final double height;
  final LabProfilePicSize profileSize;
  final LabGapSize padding;

  const BadgeDimensions({
    required this.width,
    required this.height,
    required this.profileSize,
    required this.padding,
  });
}

class DoveTailPainter extends CustomPainter {
  final Color color;

  DoveTailPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw the dovetail shape with inward triangular cutout
    final path = Path()
      ..moveTo(0, 0) // Top left
      ..lineTo(size.width, 0) // Top right
      ..lineTo(size.width, size.height) // Bottom right
      ..lineTo(size.width / 2,
          size.height - (size.height / 4)) // Bottom center (cutout peak)
      ..lineTo(0, size.height) // Bottom left
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BadgeDecoration extends StatelessWidget {
  const BadgeDecoration({
    super.key,
    required this.color,
    required this.size,
    required this.hideLeftDovetail,
  });

  final Color color;
  final LabBadgeSize size;
  final bool hideLeftDovetail;

  @override
  Widget build(BuildContext context) {
    final dimensions = _getDecorationDimensions(size);

    return SizedBox(
      width: dimensions.width,
      height: dimensions.height,
      child: Stack(
        children: [
          // Left dovetail
          if (!hideLeftDovetail)
            Positioned(
              left: 0,
              bottom: 0,
              child: Transform.rotate(
                angle: 30 * (3.14159 / 180),
                child: CustomPaint(
                  size:
                      Size(dimensions.dovetailWidth, dimensions.dovetailHeight),
                  painter: DoveTailPainter(color: color),
                ),
              ),
            ),
          // Right dovetail
          Positioned(
            right: 0,
            bottom: 0,
            child: Transform.rotate(
              angle: -30 * (3.14159 / 180),
              child: CustomPaint(
                size: Size(dimensions.dovetailWidth, dimensions.dovetailHeight),
                painter: DoveTailPainter(color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DecorationDimensions _getDecorationDimensions(LabBadgeSize size) {
    switch (size) {
      case LabBadgeSize.small:
        return const DecorationDimensions(
          width: 21,
          height: 24,
          dovetailWidth: 11,
          dovetailHeight: 19,
        );
      case LabBadgeSize.medium:
        return const DecorationDimensions(
          width: 31,
          height: 24,
          dovetailWidth: 16,
          dovetailHeight: 24,
        );
      case LabBadgeSize.large:
        return const DecorationDimensions(
          width: 80,
          height: 80,
          dovetailWidth: 38,
          dovetailHeight: 48,
        );
    }
  }
}

class DecorationDimensions {
  final double width;
  final double height;
  final double dovetailWidth;
  final double dovetailHeight;

  const DecorationDimensions({
    required this.width,
    required this.height,
    required this.dovetailWidth,
    required this.dovetailHeight,
  });
}
