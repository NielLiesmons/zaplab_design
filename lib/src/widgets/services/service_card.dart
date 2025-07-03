import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';

class LabServiceCard extends StatelessWidget {
  final Service service;
  final Function(Model) onTap;
  final Function(Profile) onProfileTap;
  final bool isUnread;
  final bool noPadding;

  const LabServiceCard({
    super.key,
    required this.service,
    required this.onTap,
    required this.onProfileTap,
    this.isUnread = false,
    this.noPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return TapBuilder(
      onTap: () => onTap(service),
      builder: (context, state, hasFocus) {
        return LabContainer(
          padding: noPadding
              ? const LabEdgeInsets.all(LabGapSize.none)
              : LabEdgeInsets.only(
                  top:
                      service.images.isEmpty ? LabGapSize.none : LabGapSize.s12,
                  bottom: LabGapSize.s8,
                  left: LabGapSize.s12,
                  right: LabGapSize.s12,
                ),
          child: Column(
            children: [
              // Image container with 16:9 aspect ratio
              if (service.images.isNotEmpty)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final maxWidth = constraints.maxWidth;
                    if (maxWidth > 400) {
                      return LabContainer(
                        width: double.infinity,
                        height: 400 * (9 / 16),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: theme.colors.gray33,
                          borderRadius: theme.radius.asBorderRadius().rad16,
                          border: Border.all(
                            color: theme.colors.white16,
                            width: LabLineThicknessData.normal().thin,
                          ),
                        ),
                        child: Image.network(
                          service.images.first,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const LabSkeletonLoader();
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: LabText(
                                "Image not found",
                                color: theme.colors.white33,
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: LabContainer(
                        width: double.infinity,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: theme.colors.gray33,
                          borderRadius: theme.radius.asBorderRadius().rad16,
                          border: Border.all(
                            color: theme.colors.white16,
                            width: LabLineThicknessData.normal().thin,
                          ),
                        ),
                        child: Image.network(
                          service.images.first,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const LabSkeletonLoader();
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: LabText(
                                "Image not found",
                                color: theme.colors.white33,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              const LabGap.s8(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const LabGap.s4(),
                            LabProfilePic.s38(service.author.value,
                                onTap: () => onProfileTap(
                                    service.author.value as Profile)),
                          ],
                        ),
                        const LabGap.s12(),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: LabText.bold16(
                                      service.title ?? 'No Title',
                                      maxLines: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const LabGap.s4(),
                                  if (isUnread)
                                    LabContainer(
                                      margin: const LabEdgeInsets.only(
                                          top: LabGapSize.s8),
                                      height: theme.sizes.s8,
                                      width: theme.sizes.s8,
                                      decoration: BoxDecoration(
                                        gradient: theme.colors.blurple,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const LabGap.s2(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  LabText.med12(
                                      service.author.value?.name ??
                                          formatNpub(
                                              service.author.value?.pubkey ??
                                                  ''),
                                      color: theme.colors.white66),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (service.content.isNotEmpty)
                    LabContainer(
                      padding: const LabEdgeInsets.only(
                          top: LabGapSize.s6,
                          bottom: LabGapSize.s2,
                          left: LabGapSize.s2,
                          right: LabGapSize.s2),
                      child: LabText.reg14(
                        service.summary ?? "No summary specified",
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
