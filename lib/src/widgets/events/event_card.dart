import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'dart:ui';

class LabEventCard extends StatelessWidget {
  final CalendarEvent event;
  final Function(CalendarEvent)? onTap;
  final Function(Profile) onProfileTap;

  const LabEventCard({
    super.key,
    required this.event,
    this.onTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabPanelButton(
      padding: const LabEdgeInsets.all(LabGapSize.none),
      isLight: true,
      onTap: () => onTap?.call(event),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: LabContainer(
                  width: double.infinity,
                  padding: const LabEdgeInsets.all(LabGapSize.s2),
                  child: LabContainer(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: theme.colors.gray33,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14.6),
                        topRight: Radius.circular(14.6),
                      ),
                    ),
                    child: Image.network(
                      event.imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const LabSkeletonLoader();
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $error');
                        return Center(
                          child: LabText(
                            "Image not found",
                            color: theme.colors.white33,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                child: ClipRRect(
                  borderRadius: theme.radius.asBorderRadius().rad8,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: LabContainer(
                      decoration: BoxDecoration(
                        color: theme.colors.gray33,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),

          // Model info section
          LabContainer(
            padding: const LabEdgeInsets.only(
              left: LabGapSize.s12,
              right: LabGapSize.s12,
              top: LabGapSize.s8,
              bottom: LabGapSize.s10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LabProfilePic.s40(event.author.value,
                    onTap: () => onProfileTap(event.author.value as Profile)),
                const LabGap.s12(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const LabEmojiImage(
                            emojiUrl: 'assets/emoji/article.png',
                            emojiName: 'article',
                            size: 16,
                          ),
                          const LabGap.s10(),
                          Expanded(
                            child: LabText.reg14(
                              event.name ?? '',
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const LabGap.s2(),
                      LabText.reg12(
                        event.author.value?.name ??
                            formatNpub(event.author.value?.pubkey ?? ''),
                        color: theme.colors.white66,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
