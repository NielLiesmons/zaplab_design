import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppServiceHeader extends StatelessWidget {
  final Service service;
  final List<Community> communities;
  final Function(Profile) onProfileTap;

  const AppServiceHeader({
    super.key,
    required this.service,
    required this.communities,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppContainer(
          padding: const AppEdgeInsets.only(
            top: AppGapSize.s4,
            bottom: AppGapSize.s12,
            left: AppGapSize.s12,
            right: AppGapSize.s12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppProfilePic.s48(service.author.value,
                  onTap: () => onProfileTap(service.author.value as Profile)),
              const AppGap.s12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText.bold14(service.author.value?.name ??
                            formatNpub(service.author.value?.pubkey ?? '')),
                        AppText.reg12(
                          TimestampFormatter.format(service.createdAt,
                              format: TimestampFormat.relative),
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const AppGap.s6(),
                    AppCommunityStack(
                      communities: communities,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const AppDivider(),
        if (service.images.isNotEmpty) ...[
          AppImageSlider(images: service.images.toList()),
          const AppDivider(),
        ],
        AppContainer(
          padding: AppEdgeInsets.only(
            top: service.images.isEmpty ? AppGapSize.none : AppGapSize.s8,
            bottom: AppGapSize.s8,
            left: AppGapSize.s12,
            right: AppGapSize.s12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.h2(service.title ?? ''),
              const AppGap.s4(),
              if (service.summary != null)
                AppText.reg14(service.summary!, color: theme.colors.white66),
            ],
          ),
        ),
      ],
    );
  }
}
