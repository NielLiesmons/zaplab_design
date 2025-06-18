import 'package:zaplab_design/zaplab_design.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:models/models.dart';

class LabCommunityWelcomeHeader extends StatefulWidget {
  final Community community;
  final VoidCallback? onProfileTap;
  final List<Profile>? profiles;
  final List<String>? emojiImageUrls;

  const LabCommunityWelcomeHeader({
    super.key,
    required this.community,
    this.onProfileTap,
    this.profiles,
    this.emojiImageUrls,
  });

  @override
  State<LabCommunityWelcomeHeader> createState() =>
      _LabCommunityWelcomeHeaderState();
}

class _LabCommunityWelcomeHeaderState extends State<LabCommunityWelcomeHeader>
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
    final theme = LabTheme.of(context);

    return LabContainer(
      padding: const LabEdgeInsets.all(LabGapSize.s16),
      clipBehavior: Clip.none,
      child: Column(
        children: [
          // Concentric circles with community image
          LabContainer(
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
                      child: LabContainer(
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
                                profiles: widget.profiles,
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
                LabProfilePic.s104(widget.community.author.value,
                    onTap: widget.onProfileTap),
              ],
            ),
          ),
          const LabGap.s8(),
          // Community name
          Stack(
            alignment: Alignment.center,
            children: [
              // Blurred background
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: LabContainer(
                  decoration: BoxDecoration(
                    color: theme.colors.black,
                    borderRadius: theme.radius.asBorderRadius().rad16,
                  ),
                  padding: const LabEdgeInsets.all(LabGapSize.s8),
                  child: Opacity(
                    opacity: 0,
                    child: LabText.h1(
                      widget.community.author.value?.name ??
                          formatNpub(widget.community.author.value?.npub ?? ''),
                      textAlign: TextAlign.center,
                      color: theme.colors.white,
                    ),
                  ),
                ),
              ),
              // Original text on top
              LabText.h1(
                widget.community.author.value?.name ??
                    formatNpub(widget.community.author.value?.npub ?? ''),
                textAlign: TextAlign.center,
                color: theme.colors.white,
              ),
            ],
          ),
          const LabGap.s4(),
          // Community description
          ClipRRect(
            borderRadius: theme.radius.asBorderRadius().rad24,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: LabContainer(
                padding: const LabEdgeInsets.only(
                  left: LabGapSize.s12,
                  right: LabGapSize.s14,
                  top: LabGapSize.s6,
                  bottom: LabGapSize.s6,
                ),
                decoration: BoxDecoration(
                  color: theme.colors.white8,
                  borderRadius: theme.radius.asBorderRadius().rad24,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LabEmojiContentType(
                      contentType: 'community',
                      size: 16,
                    ),
                    const LabGap.s6(),
                    LabText.reg12(
                      'Community',
                      color: theme.colors.white66,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleItems extends StatelessWidget {
  final double diameter;
  final int circleIndex;
  final List<Profile>? profiles;
  final List<String>? emojiImageUrls;
  final double rotationAngle;

  const _CircleItems({
    required this.diameter,
    required this.circleIndex,
    this.profiles,
    this.emojiImageUrls,
    required this.rotationAngle,
  });

  @override
  Widget build(BuildContext context) {
    final radius = diameter / 2;
    final _profiles = profiles ?? [];
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
              child: LabEmojiImage(
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
      if (_profiles.isNotEmpty) {
        final profileIndex = (circleIndex * 2 + i) % _profiles.length;
        final angle = angleStep * (i + 1); // Offset from emoji
        final x = radius + (radius * math.cos(angle));
        final y = radius + (radius * math.sin(angle));
        final profilePic = circleIndex < 2
            ? LabProfilePic.s18(_profiles[profileIndex])
            : (circleIndex < 4
                ? LabProfilePic.s16(_profiles[profileIndex])
                : LabProfilePic.s12(_profiles[profileIndex]));
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