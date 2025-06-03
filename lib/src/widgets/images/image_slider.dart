import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class AppImageSlider extends StatelessWidget {
  final List<String> images;

  const AppImageSlider({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      padding: const AppEdgeInsets.all(AppGapSize.s12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: [
            for (final imageUrl in images)
              AppContainer(
                padding: const AppEdgeInsets.only(right: AppGapSize.s12),
                child: AppImageCard(
                  url: imageUrl,
                  onTap: () {
                    AppOpenedImages.show(context, images,
                        scrollToImage: imageUrl);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
