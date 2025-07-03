import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabServiceHeader extends StatelessWidget {
  final Service service;
  final List<Community> communities;
  final Function(Profile) onProfileTap;

  const LabServiceHeader({
    super.key,
    required this.service,
    required this.communities,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabContainer(
          padding: const LabEdgeInsets.only(
            top: LabGapSize.s4,
            bottom: LabGapSize.s12,
            left: LabGapSize.s12,
            right: LabGapSize.s12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabProfilePic.s48(service.author.value,
                  onTap: () => onProfileTap(service.author.value as Profile)),
              const LabGap.s12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LabText.bold14(service.author.value?.name ??
                            formatNpub(service.author.value?.pubkey ?? '')),
                        LabText.reg12(
                          TimestampFormatter.format(service.createdAt,
                              format: TimestampFormat.relative),
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const LabGap.s6(),
                    LabCommunityStack(
                      communities: communities,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (service.images.isNotEmpty) ...[
          const LabDivider(),
          LabImageSlider(images: service.images.toList()),
          const LabDivider(),
        ],
        LabContainer(
          padding: LabEdgeInsets.only(
            top: service.images.isEmpty ? LabGapSize.none : LabGapSize.s8,
            bottom: LabGapSize.s8,
            left: LabGapSize.s12,
            right: LabGapSize.s12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabText.h2(service.title ?? ''),
              const LabGap.s4(),
              if (service.summary != null)
                LabText.reg14(service.summary!, color: theme.colors.white66),
            ],
          ),
        ),
      ],
    );
  }
}
