import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppJobCard extends StatelessWidget {
  final Job job;
  final void Function(Job) onTap;
  final bool? isUnread;

  const AppJobCard({
    super.key,
    required this.job,
    required this.onTap,
    this.isUnread = false,
  });
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppPanelButton(
      onTap: () => onTap(job),
      padding: const AppEdgeInsets.only(
        top: AppGapSize.s10,
        bottom: AppGapSize.s12,
        left: AppGapSize.s12,
        right: AppGapSize.s12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppProfilePic.s48(job.author.value),
              const AppGap.s12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppText.bold16(
                            job.title ?? 'No Title',
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const AppGap.s4(),
                        if (isUnread ?? false)
                          AppContainer(
                            margin:
                                const AppEdgeInsets.only(left: AppGapSize.s8),
                            height: theme.sizes.s8,
                            width: theme.sizes.s8,
                            decoration: BoxDecoration(
                              gradient: theme.colors.blurple,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                      ],
                    ),
                    const AppGap.s2(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText.med12(
                          job.author.value?.name ??
                              formatNpub(job.author.value?.pubkey ?? ''),
                          color: theme.colors.white66,
                        ),
                        const Spacer(),
                        AppText.reg12(
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
          const AppGap.s12(),
          SingleChildScrollView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final label in job.labels)
                  AppContainer(
                    padding: const AppEdgeInsets.only(
                      right: AppGapSize.s8,
                    ),
                    child: AppSmallLabel(label),
                  ),
              ],
            ),
          ),
          const AppGap.s12(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppContainer(
                padding: const AppEdgeInsets.symmetric(
                  horizontal: AppGapSize.s4,
                ),
                child: Row(
                  children: [
                    if (job.location == 'Remote')
                      AppIcon.s12(theme.icons.characters.wifi,
                          color: theme.colors.white66)
                    else
                      AppIcon.s16(theme.icons.characters.location,
                          color: theme.colors.white66),
                    const AppGap.s8(),
                    AppText.reg12(
                      job.location ?? 'No Location',
                      color: theme.colors.white66,
                    ),
                  ],
                ),
              ),
              AppContainer(
                padding: const AppEdgeInsets.symmetric(
                  horizontal: AppGapSize.s4,
                ),
                child: AppText.reg12(
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
