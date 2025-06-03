import 'package:zaplab_design/zaplab_design.dart';

class AppOpenedImages {
  static void show(BuildContext context, List<String> images,
      {String? scrollToImage}) {
    final theme = AppTheme.of(context);
    final screenHeight =
        MediaQuery.of(context).size.height / theme.system.scale;
    final scrollController = ScrollController();
    final imageKeys = <String, GlobalKey>{};

    if (scrollToImage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final key = imageKeys[scrollToImage];
        if (key?.currentContext != null) {
          Scrollable.ensureVisible(
            key!.currentContext!,
            duration: AppDurationsData.normal().normal,
            curve: Curves.easeInOut,
            alignment: 0.4,
          );
        }
      });
    }

    AppScreen.show(
      context: context,
      alwaysShowTopBar: true,
      topBarContent: AppContainer(
        height: theme.sizes.s32,
        padding: const AppEdgeInsets.only(
          top: AppGapSize.s8,
        ),
        child: AppText.med14('${images.length} Images',
            color: theme.colors.white66),
      ),
      child: AppContainer(
        height: screenHeight - theme.sizes.s32,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              const AppGap.s40(),
              for (final url in images) ...[
                AppFullWidthImage(
                  key: imageKeys[url] = GlobalKey(),
                  url: url,
                ),
                const AppGap.s16(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
