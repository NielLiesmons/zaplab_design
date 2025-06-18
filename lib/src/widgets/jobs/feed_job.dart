import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabJobCard extends StatelessWidget {
  final Job job;
  final void Function(Job) onTap;
  final bool? isUnread;

  const LabJobCard({
    super.key,
    required this.job,
    required this.onTap,
    this.isUnread = false,
  });
  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabPanelButton(
      onTap: () => onTap(job),
      padding: const LabEdgeInsets.only(
        top: LabGapSize.s10,
        bottom: LabGapSize.s12,
        left: LabGapSize.s12,
        right: LabGapSize.s12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LabProfilePic.s48(job.author.value),
              const LabGap.s12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: LabText.bold16(
                            job.title ?? 'No Title',
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const LabGap.s4(),
                        if (isUnread ?? false)
                          LabContainer(
                            margin:
                                const LabEdgeInsets.only(left: LabGapSize.s8),
                            height: theme.sizes.s8,
                            width: theme.sizes.s8,
                            decoration: BoxDecoration(
                              gradient: theme.colors.blurple,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                      ],
                    ),
                    const LabGap.s2(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LabText.med12(
                          job.author.value?.name ??
                              formatNpub(job.author.value?.pubkey ?? ''),
                          color: theme.colors.white66,
                        ),
                        const Spacer(),
                        LabText.reg12(
                          TimestampFormatter.format(job.createdAt,
                              format: TimestampFormat.relative),
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const LabGap.s12(),
          SingleChildScrollView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final label in job.labels)
                  LabContainer(
                    padding: const LabEdgeInsets.only(
                      right: LabGapSize.s8,
                    ),
                    child: LabSmallLabel(label),
                  ),
              ],
            ),
          ),
          const LabGap.s12(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabContainer(
                padding: const LabEdgeInsets.symmetric(
                  horizontal: LabGapSize.s4,
                ),
                child: Row(
                  children: [
                    if (job.location == 'Remote')
                      LabIcon.s12(theme.icons.characters.wifi,
                          color: theme.colors.white66)
                    else
                      LabIcon.s16(theme.icons.characters.location,
                          color: theme.colors.white66),
                    const LabGap.s8(),
                    LabText.reg12(
                      job.location ?? 'No Location',
                      color: theme.colors.white66,
                    ),
                  ],
                ),
              ),
              LabContainer(
                padding: const LabEdgeInsets.symmetric(
                  horizontal: LabGapSize.s4,
                ),
                child: LabText.reg12(
                  job.employmentType ?? 'No Employment Type',
                  color: theme.colors.blurpleLightColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
