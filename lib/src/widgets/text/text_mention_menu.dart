import 'dart:ui';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabTextMentionMenuItem {
  final Profile profile;
  final void Function(EditableTextState) onTap;

  const LabTextMentionMenuItem({
    required this.profile,
    required this.onTap,
  });
}

class LabTextMentionMenu extends StatefulWidget {
  final Offset position;
  final EditableTextState editableTextState;
  final List<LabTextMentionMenuItem>? menuItems;

  const LabTextMentionMenu({
    super.key,
    required this.position,
    required this.editableTextState,
    this.menuItems,
  });

  @override
  State<LabTextMentionMenu> createState() => _LabTextMentionMenuState();
}

class _LabTextMentionMenuState extends State<LabTextMentionMenu> {
  final ScrollController _scrollController = ScrollController();

  double _calculateWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final selectionX = widget.position.dx;

    // Use the same logic as text selection controls
    if (selectionX <= screenWidth / 3) {
      // Left third
      return screenWidth * 0.5;
    } else if (selectionX >= screenWidth * 2 / 3) {
      // Right third
      return screenWidth * 0.4;
    } else {
      // Middle third
      return screenWidth * 0.4;
    }
  }

  Offset _calculatePosition(
      BuildContext context, double menuWidth, double menuHeight) {
    final screenWidth = MediaQuery.of(context).size.width;
    final selectionX = widget.position.dx;

    // Use the same logic as text selection controls
    final double xOffset = selectionX <= screenWidth / 3
        ? -64 // Left third - align with cursor
        : selectionX >= screenWidth * 2 / 3
            ? -menuWidth // Right third
            : -(menuWidth / 2); // Middle third

    return Offset(xOffset, -menuHeight);
  }

  Widget _buildMentionItem(LabTextMentionMenuItem item) {
    final theme = LabTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => item.onTap(widget.editableTextState),
        child: LabContainer(
          height: theme.sizes.s38,
          padding: const LabEdgeInsets.symmetric(
            horizontal: LabGapSize.s10,
          ),
          child: Row(
            children: [
              LabProfilePic.s24(item.profile),
              const LabGap.s12(),
              Expanded(
                child: LabText.med14(
                  item.profile.name ?? formatNpub(item.profile.npub),
                  color: theme.colors.white,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final items = widget.menuItems ?? [];
    final itemHeight = theme.sizes.s38;
    final menuHeight = items.length <= 4 ? itemHeight * items.length : 168.0;
    final menuWidth = _calculateWidth(context);

    // Platform-specific positioning adjustments
    final isMobile = LabPlatformUtils.isMobile;
    final xOffset = isMobile ? -8.0 : -76.0;
    final yOffset = isMobile ? -menuHeight + 12.0 : -menuHeight + 19.0;

    return Transform.translate(
      offset: Offset(xOffset, yOffset),
      child: ClipRRect(
        borderRadius: theme.radius.asBorderRadius().rad8,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: LabContainer(
            height: menuHeight,
            constraints: BoxConstraints(
              maxWidth: menuWidth,
              maxHeight: 168.0,
            ),
            decoration: BoxDecoration(
              color: theme.colors.white16,
              borderRadius: theme.radius.asBorderRadius().rad8,
              border: Border.all(
                color: theme.colors.white33,
                width: LabLineThicknessData.normal().thin,
              ),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final item in items) ...[
                        _buildMentionItem(item),
                        if (item != items.last) const LabDivider.horizontal(),
                      ],
                    ],
                  ),
                ),
                if (items.length > 4)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 24,
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0x00000000),
                              theme.colors.black16,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
