import 'dart:ui';
import 'package:zaplab_design/zaplab_design.dart';

class AppTextMentionMenuItem {
  final Profile profile;
  final void Function(EditableTextState) onTap;

  const AppTextMentionMenuItem({
    required this.profile,
    required this.onTap,
  });
}

class AppTextMentionMenu extends StatefulWidget {
  final Offset position;
  final EditableTextState editableTextState;
  final List<AppTextMentionMenuItem>? menuItems;

  const AppTextMentionMenu({
    super.key,
    required this.position,
    required this.editableTextState,
    this.menuItems,
  });

  @override
  State<AppTextMentionMenu> createState() => _AppTextMentionMenuState();
}

class _AppTextMentionMenuState extends State<AppTextMentionMenu> {
  final ScrollController _scrollController = ScrollController();
  bool _showGradient = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isAtEnd =
        _scrollController.offset >= _scrollController.position.maxScrollExtent;
    if (isAtEnd != !_showGradient) {
      setState(() {
        _showGradient = !isAtEnd;
      });
    }
  }

  void _insertMention(Profile profile) {
    final state = widget.editableTextState;
    final text = state.textEditingValue.text;
    final selection = state.textEditingValue.selection;

    final beforeCursor = text.substring(0, selection.baseOffset);
    final lastAtSymbol = beforeCursor.lastIndexOf('@');

    if (lastAtSymbol != -1) {
      final newText = text.replaceRange(
        lastAtSymbol,
        selection.baseOffset,
        '@${profile.profileName} ',
      );

      state.updateEditingValue(
        TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(
            offset: lastAtSymbol +
                profile.profileName.length +
                2, // +2 for @ and space
          ),
        ),
      );
    }
  }

  double _calculateWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final selectionX = widget.position.dx;
    final thirdOfScreen = screenWidth / 3;

    // Calculate which third of the screen the selection starts in
    final selectionThird = (selectionX / thirdOfScreen).floor();

    // Adjust width based on position
    switch (selectionThird) {
      case 0: // Left third
        return screenWidth * 0.5;
      case 1: // Middle third
        return screenWidth * 0.4;
      case 2: // Right third
        return screenWidth * 0.4;
      default:
        return screenWidth * 0.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final items = widget.menuItems ?? [];
    final itemHeight = theme.sizes.s38;
    final menuHeight = itemHeight * items.length;
    final menuWidth = _calculateWidth(context);

    return Transform.translate(
      offset: Offset(0, -menuHeight),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: ClipRRect(
          borderRadius: theme.radius.asBorderRadius().rad8,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Stack(
              children: [
                AppContainer(
                  height: menuHeight,
                  constraints: BoxConstraints(
                    maxWidth: menuWidth,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colors.white16,
                    borderRadius: theme.radius.asBorderRadius().rad8,
                    border: Border.all(
                      color: theme.colors.white33,
                      width: LineThicknessData.normal().thin,
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: items.map((item) {
                        final isLast = item == items.last;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: itemHeight,
                              child: _buildMentionItem(
                                context,
                                item.profile,
                                () => item.onTap(widget.editableTextState),
                              ),
                            ),
                            if (!isLast) const AppDivider.horizontal(),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (_showGradient)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 32,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.colors.black33.withValues(alpha: 0),
                            theme.colors.black33,
                          ],
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

  Widget _buildMentionItem(
      BuildContext context, Profile profile, VoidCallback onTap) {
    final theme = AppTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        padding: const AppEdgeInsets.symmetric(
          horizontal: AppGapSize.s12,
          vertical: AppGapSize.s8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                profile.profilePicUrl,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => AppContainer(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: theme.colors.white16,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AppText.med14(
                      profile.profileName[0].toUpperCase(),
                      color: theme.colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const AppGap.s8(),
            AppText.med14(
              profile.profileName,
              color: theme.colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
