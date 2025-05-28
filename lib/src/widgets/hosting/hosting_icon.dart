import 'package:zaplab_design/zaplab_design.dart';

enum HostingStatus {
  online,
  warning,
  offline,
  none;

  Gradient getGradient(AppThemeData theme) {
    switch (this) {
      case HostingStatus.online:
        return theme.colors.green;
      case HostingStatus.warning:
        return theme.colors.gold;
      case HostingStatus.offline:
        return theme.colors.rouge;
      case HostingStatus.none:
        return LinearGradient(
          colors: [
            theme.colors.white16,
            theme.colors.white33,
          ],
        );
    }
  }
}

class AppHostingIcon extends StatelessWidget {
  final List<HostingStatus>? hostingStatuses;

  const AppHostingIcon({
    super.key,
    this.hostingStatuses,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      width: theme.sizes.s48,
      decoration: BoxDecoration(
        gradient: theme.colors.graydient66,
        borderRadius: theme.radius.asBorderRadius().rad12,
        border: Border(
          top: BorderSide(
            color: theme.colors.white8,
            width: 0.8,
          ),
          left: BorderSide(
            color: theme.colors.white8,
            width: 0.6,
          ),
          right: BorderSide(
            color: theme.colors.white8,
            width: 0.6,
          ),
        ),
      ),
      child: AppContainer(
        decoration: BoxDecoration(
          color: theme.colors.black33,
          borderRadius: theme.radius.asBorderRadius().rad12,
          border: Border(
            bottom: BorderSide(
              color: theme.colors.black8,
              width: AppLineThicknessData.normal().medium,
            ),
          ),
        ),
        child: Column(
          children: [
            for (var i = 0;
                i < (hostingStatuses?.length ?? 0) && i < 5;
                i++) ...[
              AppContainer(
                height: theme.sizes.s20,
                padding:
                    const AppEdgeInsets.symmetric(horizontal: AppGapSize.s6),
                child: Center(
                  child: Row(
                    children: [
                      AppContainer(
                        height: theme.sizes.s6,
                        width: theme.sizes.s8,
                        decoration: BoxDecoration(
                          gradient: hostingStatuses![i].getGradient(theme),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const AppGap.s4(),
                      Expanded(
                        child: AppContainer(
                          height: theme.sizes.s6,
                          decoration: BoxDecoration(
                            color: theme.colors.black16,
                            borderRadius: theme.radius.asBorderRadius().rad12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (i < (hostingStatuses?.length ?? 0) - 1 && i < 4)
                Column(
                  children: [
                    AppContainer(
                      height: 2,
                      decoration: BoxDecoration(
                        color: AppColorsData.dark().white8,
                      ),
                    ),
                    AppContainer(
                      height: 1,
                      decoration: BoxDecoration(
                        color: AppColorsData.dark().black33,
                      ),
                    )
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }
}
