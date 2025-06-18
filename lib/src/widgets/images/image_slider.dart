import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class LabImageSlider extends StatelessWidget {
  final List<String> images;

  const LabImageSlider({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return LabContainer(
      padding: const LabEdgeInsets.all(LabGapSize.s12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: [
            for (final imageUrl in images)
              LabContainer(
                padding: const LabEdgeInsets.only(right: LabGapSize.s12),
                child: LabImageCard(
                  url: imageUrl,
                  onTap: () {
                    LabOpenedImages.show(context, images,
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
