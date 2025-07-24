import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:models/models.dart';

class LabBookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const LabBookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return TapBuilder(
      onTap: onTap,
      builder: (context, state, hasFocus) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.99;
        } else if (state == TapState.hover) {
          scaleFactor = 1.005;
        }

        return Transform.scale(
          scale: scaleFactor,
          child: LabContainer(
            width: 148,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LabContainer(
                  clipBehavior: Clip.hardEdge,
                  width: 144,
                  height: 216,
                  decoration: BoxDecoration(
                    color: theme.colors.gray33,
                    borderRadius: theme.radius.asBorderRadius().rad8,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: book.imageUrl ?? '',
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        const LabSkeletonLoader(),
                    errorWidget: (context, url, error) => LabContainer(
                      decoration: BoxDecoration(
                        color: theme.colors.gray33,
                      ),
                    ),
                  ),
                ),
                const LabGap.s12(),
                LabText.med14(
                  book.title ?? '',
                  color: theme.colors.white,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                const LabGap.s4(),
                LabText.reg12(
                  book.writer ?? 'Writer not specified',
                  color: theme.colors.white66,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
