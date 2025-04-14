import 'package:zaplab_design/zaplab_design.dart';
import 'dart:math' as math;
import 'package:models/models.dart';

class AppCommunityWelcomeHeader extends StatefulWidget {
  final Community community;
  final VoidCallback? onTap;
  final List<String>? profileImageUrls;
  final List<String>? emojiImageUrls;

  const AppCommunityWelcomeHeader({
    super.key,
    required this.community,
    this.onTap,
    this.profileImageUrls,
    this.emojiImageUrls,
  });

  @override
  State<AppCommunityWelcomeHeader> createState() =>
      _AppCommunityWelcomeHeaderState();
}

class _AppCommunityWelcomeHeaderState extends State<AppCommunityWelcomeHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _circleOffsets = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 40),
      vsync: this,
    )..repeat();

    // Generate fixed 40-degree offsets for each circle
    for (var i = 0; i < 6; i++) {
      _circleOffsets
          .add((i * 2 * math.pi / 9) % (2 * math.pi)); // 40 degrees = 2π/9
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      padding: const AppEdgeInsets.all(AppGapSize.s16),
      clipBehavior: Clip.none,
      child: Column(
        children: [
          // Concentric circles with community image
          AppContainer(
            height: 104,
            clipBehavior: Clip.none,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Concentric circles
                ...List.generate(
                  6,
                  (index) {
                    final diameter = 104.0 + (60.0 * (index + 1));
                    final borderWidth = 1.4 - (0.2 * index);
                    return Positioned(
                      left: -(diameter - 104) / 2,
                      top: -(diameter - 104) / 2,
                      child: AppContainer(
                        width: diameter,
                        height: diameter,
                        clipBehavior: Clip.none,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colors.white16,
                            width: borderWidth,
                          ),
                        ),
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            final rotationAngle =
                                _controller.value * 2 * math.pi +
                                    _circleOffsets[index];
                            return Transform.rotate(
                              angle: rotationAngle,
                              child: _CircleItems(
                                diameter: diameter,
                                circleIndex: index,
                                profileImageUrls: widget.profileImageUrls,
                                emojiImageUrls: widget.emojiImageUrls,
                                rotationAngle: rotationAngle,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                // Community image
                AppProfilePic.s104(
                    widget.community.author.value?.pictureUrl ?? '',
                    onTap: widget.onTap),
              ],
            ),
          ),
          const AppGap.s4(),
          // Community name
          AppText.h2(
            widget.community.author.value?.name ??
                formatNpub(widget.community.author.value?.npub ?? ''),
            textAlign: TextAlign.center,
            color: theme.colors.white,
          ),
        ],
      ),
    );
  }
}

class _CircleItems extends StatelessWidget {
  final double diameter;
  final int circleIndex;
  final List<String>? profileImageUrls;
  final List<String>? emojiImageUrls;
  final double rotationAngle;

  const _CircleItems({
    required this.diameter,
    required this.circleIndex,
    this.profileImageUrls,
    this.emojiImageUrls,
    required this.rotationAngle,
  });

  @override
  Widget build(BuildContext context) {
    final radius = diameter / 2;
    final profileUrls = profileImageUrls ?? [];
    final emojiUrls = emojiImageUrls ?? [];

    // Calculate item sizes based on circle index
    final emojiSize =
        16.0 - circleIndex; // Start at 16px and decrease by 1px each circle

    // Calculate positions for items
    final items = <Widget>[];
    final angleStep = (2 * math.pi) / 3; // 3 items per circle

    // Add emoji
    if (emojiUrls.isNotEmpty) {
      final emojiIndex = circleIndex % emojiUrls.length;
      final angle = 0.0; // Start at top
      final x = radius + (radius * math.cos(angle));
      final y = radius + (radius * math.sin(angle));
      items.add(
        Positioned(
          left: x - emojiSize / 2,
          top: y - emojiSize / 2,
          child: Transform.rotate(
            angle: -rotationAngle,
            child: Opacity(
              opacity: 0.9 -
                  (circleIndex *
                      0.15), // Start at 90%, decrease by 15% each circle
              child: AppEmojiImage(
                emojiUrl: emojiUrls[emojiIndex],
                emojiName: '',
                size: emojiSize,
              ),
            ),
          ),
        ),
      );
    }

    // Add profile pictures
    for (var i = 0; i < 2; i++) {
      if (profileUrls.isNotEmpty) {
        final profileIndex = (circleIndex * 2 + i) % profileUrls.length;
        final angle = angleStep * (i + 1); // Offset from emoji
        final x = radius + (radius * math.cos(angle));
        final y = radius + (radius * math.sin(angle));
        final profilePic = circleIndex < 2
            ? AppProfilePic.s18(profileUrls[profileIndex])
            : (circleIndex < 4
                ? AppProfilePic.s16(profileUrls[profileIndex])
                : AppProfilePic.s12(profileUrls[profileIndex]));
        items.add(
          Positioned(
            left: x - emojiSize / 2,
            top: y - emojiSize / 2,
            child: Transform.rotate(
              angle: -rotationAngle,
              child: Opacity(
                opacity: 0.9 -
                    (circleIndex *
                        0.15), // Start at 90%, decrease by 15% each circle
                child: profilePic,
              ),
            ),
          ),
        );
      }
    }

    return Stack(
      clipBehavior: Clip.none,
      children: items,
    );
  }
}


// Here