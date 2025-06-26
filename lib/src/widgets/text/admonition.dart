import 'package:zaplab_design/zaplab_design.dart';
import 'dart:ui';

class LabAdmonition extends StatelessWidget {
  final String type;
  final Widget child;

  const LabAdmonition({
    super.key,
    required this.type,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final isInsideModal = ModalScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabGap.s12(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            LabPanel(
              color: isInsideModal ? theme.colors.white8 : theme.colors.gray66,
              padding: const LabEdgeInsets.only(
                left: LabGapSize.s12,
                right: LabGapSize.s12,
                top: LabGapSize.s20,
                bottom: LabGapSize.s8,
              ),
              child: child,
            ),
            Positioned(
              left: 12,
              top: -8,
              child: ClipRRect(
                borderRadius: theme.radius.asBorderRadius().rad8,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: LabContainer(
                    padding: const LabEdgeInsets.symmetric(
                      horizontal: LabGapSize.s8,
                      vertical: LabGapSize.s2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colors.white16,
                      borderRadius: theme.radius.asBorderRadius().rad8,
                    ),
                    child: LabText.h3(
                      type.toUpperCase(),
                      color: theme.colors.white66,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
