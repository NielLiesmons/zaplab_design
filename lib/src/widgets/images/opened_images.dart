import 'package:zaplab_design/zaplab_design.dart';

class LabOpenedImages {
  static void show(BuildContext context, List<String> images,
      {String? scrollToImage}) {
    final theme = LabTheme.of(context);
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
            duration: LabDurationsData.normal().normal,
            curve: Curves.easeInOut,
            alignment: 0.4,
          );
        }
      });
    }

    LabScreen.show(
      context: context,
      alwaysShowTopBar: true,
      topBarContent: LabContainer(
        height: theme.sizes.s32,
        padding: const LabEdgeInsets.only(
          top: LabGapSize.s8,
        ),
        child: LabText.med14('${images.length} Images',
            color: theme.colors.white66),
      ),
      child: LabContainer(
        height: screenHeight - theme.sizes.s32,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              const LabGap.s40(),
              for (final url in images) ...[
                LabFullWidthImage(
                  key: imageKeys[url] = GlobalKey(),
                  url: url,
                ),
                const LabGap.s16(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
