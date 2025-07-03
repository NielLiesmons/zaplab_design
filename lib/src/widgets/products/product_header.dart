import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabProductHeader extends StatelessWidget {
  final Product product;
  final List<Community> communities;
  final Function(Profile) onProfileTap;

  const LabProductHeader({
    super.key,
    required this.product,
    required this.communities,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabContainer(
          padding: const LabEdgeInsets.only(
            top: LabGapSize.s4,
            bottom: LabGapSize.s12,
            left: LabGapSize.s12,
            right: LabGapSize.s12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabProfilePic.s48(product.author.value,
                  onTap: () => onProfileTap(product.author.value as Profile)),
              const LabGap.s12(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LabText.bold14(product.author.value?.name ??
                            formatNpub(product.author.value?.pubkey ?? '')),
                        LabText.reg12(
                          TimestampFormatter.format(product.createdAt,
                              format: TimestampFormat.relative),
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const LabGap.s6(),
                    LabCommunityStack(
                      communities: communities,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (product.images.isNotEmpty) ...[
          const LabDivider(),
          LabImageSlider(images: product.images.toList()),
          const LabDivider(),
        ],
        LabContainer(
          padding: LabEdgeInsets.only(
            top: product.images.isEmpty ? LabGapSize.none : LabGapSize.s8,
            bottom: LabGapSize.s8,
            left: LabGapSize.s12,
            right: LabGapSize.s12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabText.h2(product.title ?? ''),
              const LabGap.s4(),
              Row(
                children: [
                  LabSmallButton(
                    children: [
                      LabIcon.s12(theme.icons.characters.zap,
                          color: theme.colors.white),
                      const LabGap.s6(),
                      LabAmount(product.price as double)
                    ],
                  ),
                  const LabGap.s12(),
                  Expanded(
                    child: LabSmallButton(
                      children: [
                        LabText.reg14(
                          "Option description",
                          color: theme.colors.white66,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        const LabGap.s6(),
                        LabIcon.s8(
                          theme.icons.characters.chevronDown,
                          outlineColor: theme.colors.white33,
                          outlineThickness:
                              LabLineThicknessData.normal().medium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (product.summary != null)
                LabText.reg14(product.summary!, color: theme.colors.white66),
            ],
          ),
        ),
      ],
    );
  }
}
