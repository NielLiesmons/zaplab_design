import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';

class AppServiceCard extends StatelessWidget {
  final Service service;
  final Function(Model) onTap;
  final Function(Profile) onProfileTap;
  final bool isUnread;
  final bool noPadding;

  const AppServiceCard({
    super.key,
    required this.service,
    required this.onTap,
    required this.onProfileTap,
    this.isUnread = false,
    this.noPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return TapBuilder(
      onTap: () => onTap(service),
      builder: (context, state, hasFocus) {
        return AppContainer(
          padding: noPadding
              ? const AppEdgeInsets.all(AppGapSize.none)
              : AppEdgeInsets.only(
                  top:
                      service.images.isEmpty ? AppGapSize.none : AppGapSize.s12,
                  bottom: AppGapSize.s8,
                  left: AppGapSize.s12,
                  right: AppGapSize.s12,
                ),
          child: Column(
            children: [
              // Image container with 16:9 aspect ratio
              if (service.images.isNotEmpty)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final maxWidth = constraints.maxWidth;
                    if (maxWidth > 400) {
                      return AppContainer(
                        width: double.infinity,
                        height: 400 * (9 / 16),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: theme.colors.gray33,
                          borderRadius: theme.radius.asBorderRadius().rad16,
                          border: Border.all(
                            color: theme.colors.white16,
                            width: AppLineThicknessData.normal().thin,
                          ),
                        ),
                        child: Image.network(
                          service.images.first,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const AppSkeletonLoader();
                          },
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            return const AppSkeletonLoader();
                          },
                        ),
                      );
                    }
                    return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: AppContainer(
                        width: double.infinity,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: theme.colors.gray33,
                          borderRadius: theme.radius.asBorderRadius().rad16,
                          border: Border.all(
                            color: theme.colors.white16,
                            width: AppLineThicknessData.normal().thin,
                          ),
                        ),
                        child: Image.network(
                          service.images.first,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const AppSkeletonLoader();
                          },
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            return const AppSkeletonLoader();
                          },
                        ),
                      ),
                    );
                  },
                ),
              const AppGap.s8(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const AppGap.s4(),
                            AppProfilePic.s38(service.author.value,
                                onTap: () => onProfileTap(
                                    service.author.value as Profile)),
                          ],
                        ),
                        const AppGap.s12(),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: AppText.bold16(
                                      service.title ?? 'No Title',
                                      maxLines: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const AppGap.s4(),
                                  if (isUnread)
                                    AppContainer(
                                      margin: const AppEdgeInsets.only(
                                          top: AppGapSize.s8),
                                      height: theme.sizes.s8,
                                      width: theme.sizes.s8,
                                      decoration: BoxDecoration(
                                        gradient: theme.colors.blurple,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                ],
                              ),
                              const AppGap.s2(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AppText.med12(
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
                    AppContainer(
                      padding: const AppEdgeInsets.all(AppGapSize.s6),
                      child: AppText.reg14(
                        service.content,
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
