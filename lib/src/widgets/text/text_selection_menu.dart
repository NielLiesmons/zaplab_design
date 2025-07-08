import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabTextSelectionMenuItem {
  final String? label;
  final Widget? icon;
  final void Function(EditableTextState) onTap;
  final bool Function(EditableTextState)? isVisible;

  const LabTextSelectionMenuItem({
    this.label,
    this.icon,
    required this.onTap,
    this.isVisible,
  });
}

class LabTextSelectionMenu extends StatefulWidget {
  final Offset position;
  final EditableTextState editableTextState;
  final List<LabTextSelectionMenuItem>? menuItems;
  final bool showStyleMenu;
  final ValueListenable<ClipboardStatus>? clipboardStatus;

  const LabTextSelectionMenu({
    super.key,
    required this.position,
    required this.editableTextState,
    this.menuItems,
    this.showStyleMenu = false,
    this.clipboardStatus,
  });

  @override
  State<LabTextSelectionMenu> createState() => _LabTextSelectionMenuState();
}

class _LabTextSelectionMenuState extends State<LabTextSelectionMenu>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _stylingScrollController = ScrollController();
  bool _showGradient = false;
  bool _showStylingGradient = false;
  bool _showCheckmark = false;
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  double _calculateWidth(BuildContext context) {
    final theme = LabTheme.of(context);
    final screenWidth = MediaQuery.of(context).size.width / theme.system.scale;
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
        return screenWidth * 0.36;
      default:
        return screenWidth * 0.5;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _stylingScrollController.addListener(_onStylingScroll);
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50.0,
      ),
    ]).animate(_scaleController);

    // Check for overflow after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverflow();
      _checkStylingOverflow();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _stylingScrollController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _checkOverflow() {
    if (_scrollController.hasClients) {
      final hasOverflow = _scrollController.position.maxScrollExtent > 0;
      if (hasOverflow != _showGradient) {
        setState(() {
          _showGradient = hasOverflow;
        });
      }
    }
  }

  void _onScroll() {
    // Only show gradient if content actually overflows
    final hasOverflow = _scrollController.position.maxScrollExtent > 0;
    final isAtEnd =
        _scrollController.offset >= _scrollController.position.maxScrollExtent;

    if (hasOverflow && isAtEnd != !_showGradient) {
      setState(() {
        _showGradient = !isAtEnd;
      });
    } else if (!hasOverflow && _showGradient) {
      // Hide gradient if no overflow
      setState(() {
        _showGradient = false;
      });
    }
  }

  void _onStylingScroll() {
    // Only show gradient if content actually overflows
    final hasOverflow = _stylingScrollController.position.maxScrollExtent > 0;
    final isAtEnd = _stylingScrollController.offset >=
        _stylingScrollController.position.maxScrollExtent;

    if (hasOverflow && isAtEnd != !_showStylingGradient) {
      setState(() {
        _showStylingGradient = !isAtEnd;
      });
    } else if (!hasOverflow && _showStylingGradient) {
      // Hide gradient if no overflow
      setState(() {
        _showStylingGradient = false;
      });
    }
  }

  void _checkStylingOverflow() {
    if (_stylingScrollController.hasClients) {
      final hasOverflow = _stylingScrollController.position.maxScrollExtent > 0;
      if (hasOverflow != _showStylingGradient) {
        setState(() {
          _showStylingGradient = hasOverflow;
        });
      }
    }
  }

  void _handleCopyWithAnimation(EditableTextState state) {
    state.copySelection(SelectionChangedCause.tap);
    setState(() => _showCheckmark = true);
    _scaleController.forward(from: 0.0);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showCheckmark = false);
    });
  }

  List<LabTextSelectionMenuItem> _getMenuItems() {
    final theme = LabTheme.of(context);
    final isEditable = widget.editableTextState.widget.readOnly != true;
    final hasSelection =
        !widget.editableTextState.textEditingValue.selection.isCollapsed;
    final textLength = widget.editableTextState.textEditingValue.text.length;
    final selectionLength = hasSelection
        ? widget.editableTextState.textEditingValue.selection.end -
            widget.editableTextState.textEditingValue.selection.start
        : 0;
    final allSelected =
        hasSelection && selectionLength == textLength && textLength > 0;

    final baseItems = <LabTextSelectionMenuItem>[
      LabTextSelectionMenuItem(
        label: _showCheckmark ? 'Copied!' : 'Copy',
        icon: _showCheckmark
            ? ScaleTransition(
                scale: _scaleAnimation,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LabIcon.s10(
                      theme.icons.characters.check,
                      outlineColor: theme.colors.white66,
                      outlineThickness: LabLineThicknessData.normal().thick,
                    ),
                    const LabGap.s6(),
                    LabText.med14(
                      'Copied!',
                      color: theme.colors.white,
                    ),
                  ],
                ),
              )
            : null,
        onTap: (state) => _handleCopyWithAnimation(state),
      ),
    ];

    // Only show Cut if there's a selection
    if (hasSelection) {
      baseItems.add(
        LabTextSelectionMenuItem(
          label: 'Cut',
          onTap: (state) => _handleAction(state.cutSelection),
        ),
      );
    }

    // Only show Paste if editable and clipboard has content
    if (isEditable) {
      final clipboardHasContent =
          widget.clipboardStatus?.value == ClipboardStatus.pasteable;
      if (clipboardHasContent != false) {
        // Show if we have content or can't determine
        baseItems.add(
          LabTextSelectionMenuItem(
            label: 'Paste',
            onTap: (state) => _handleAction(state.pasteText),
          ),
        );
      }
    }

    // Only show Select All if not all text is already selected and there's text to select
    if (!allSelected && textLength > 0) {
      baseItems.add(
        LabTextSelectionMenuItem(
          label: 'Select All',
          onTap: (state) => _handleAction(state.selectAll),
        ),
      );
    }

    return baseItems;
  }

  void _handleAction(Function(SelectionChangedCause) action) {
    action(SelectionChangedCause.tap);
    if (action == widget.editableTextState.pasteText ||
        action == widget.editableTextState.cutSelection) {
      widget.editableTextState.hideToolbar();
    }
  }

  void _handleStylingAction(EditableTextState state, String styleType) {
    final controller = state.widget.controller;
    if (controller is InlineSpanController) {
      final selection = controller.selection;
      switch (styleType) {
        case 'bold':
          controller.applyBold(selection);
          break;
        case 'italic':
          controller.applyItalic(selection);
          break;
        case 'underline':
          controller.applyUnderline(selection);
          break;
        case 'strikethrough':
          controller.applyStrikethrough(selection);
          break;
        case 'monspace':
          controller.applyCode(selection);
          break;
      }
    }
    state.hideToolbar();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final menuWidth = _calculateWidth(context);
    final items = widget.menuItems ?? _getMenuItems();

    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: menuWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Styling bar (top row)
            if (widget.showStyleMenu) ...[
              ClipRRect(
                borderRadius: theme.radius.asBorderRadius().rad8,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: LabContainer(
                    height: theme.sizes.s38,
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
                          controller: _stylingScrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildButton(
                                context,
                                null,
                                LabIcon.s16(
                                  theme.icons.characters.bold,
                                  outlineColor: theme.colors.white,
                                  outlineThickness:
                                      LabLineThicknessData.normal().medium,
                                ),
                                () => _handleStylingAction(
                                    widget.editableTextState, 'bold'),
                              ),
                              const LabDivider.vertical(),
                              _buildButton(
                                context,
                                null,
                                LabIcon.s16(
                                  theme.icons.characters.italic,
                                  outlineColor: theme.colors.white,
                                  outlineThickness:
                                      LabLineThicknessData.normal().medium,
                                ),
                                () => _handleStylingAction(
                                    widget.editableTextState, 'italic'),
                              ),
                              const LabDivider.vertical(),
                              _buildButton(
                                context,
                                null,
                                LabIcon.s16(
                                  theme.icons.characters.underline,
                                  outlineColor: theme.colors.white,
                                  outlineThickness:
                                      LabLineThicknessData.normal().medium,
                                ),
                                () => _handleStylingAction(
                                    widget.editableTextState, 'underline'),
                              ),
                              const LabDivider.vertical(),
                              _buildButton(
                                context,
                                null,
                                LabIcon.s16(
                                  theme.icons.characters.strikeThrough,
                                  outlineColor: theme.colors.white,
                                  outlineThickness:
                                      LabLineThicknessData.normal().medium,
                                ),
                                () => _handleStylingAction(
                                    widget.editableTextState, 'strikethrough'),
                              ),
                              const LabDivider.vertical(),
                              _buildButton(
                                context,
                                null,
                                LabIcon.s16(
                                  theme.icons.characters.subscript,
                                  outlineColor: theme.colors.white,
                                  outlineThickness:
                                      LabLineThicknessData.normal().medium,
                                ),
                                () => _handleStylingAction(
                                    widget.editableTextState, 'subscript'),
                              ),
                              const LabDivider.vertical(),
                              _buildButton(
                                context,
                                null,
                                LabIcon.s16(
                                  theme.icons.characters.superscript,
                                  outlineColor: theme.colors.white,
                                  outlineThickness:
                                      LabLineThicknessData.normal().medium,
                                ),
                                () => _handleStylingAction(
                                    widget.editableTextState, 'superscript'),
                              ),
                              // const LabDivider.vertical(),
                              // _buildButton(
                              //   context,
                              //   null,
                              //   LabIcon.s16(
                              //     theme.icons.characters.monosppace,
                              //     outlineColor: theme.colors.white,
                              //     outlineThickness:
                              //         LabLineThicknessData.normal().medium,
                              //   ),
                              //   () => _handleStylingAction(
                              //       widget.editableTextState, 'monspace'),
                              // ),
                            ],
                          ),
                        ),
                        if (_showStylingGradient)
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            width: 32,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
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
              const LabGap.s6(),
            ],
            // Main menu bar (bottom row)
            ClipRRect(
              borderRadius: theme.radius.asBorderRadius().rad8,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Stack(
                  children: [
                    LabContainer(
                      height: theme.sizes.s38,
                      decoration: BoxDecoration(
                        color: theme.colors.white16,
                        borderRadius: theme.radius.asBorderRadius().rad8,
                        border: Border.all(
                          color: theme.colors.white33,
                          width: LabLineThicknessData.normal().thin,
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: items.map((item) {
                            final isLast = item == items.last;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildButton(
                                  context,
                                  item.label,
                                  item.icon,
                                  () => item.onTap(widget.editableTextState),
                                ),
                                if (!isLast) const LabDivider.vertical(),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    if (_showGradient)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        width: 32,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
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
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String? label, Widget? icon, VoidCallback onTap) {
    final theme = LabTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: LabContainer(
        padding: const LabEdgeInsets.symmetric(
          horizontal: LabGapSize.s12,
          vertical: LabGapSize.s8,
        ),
        child: icon ??
            LabText.med14(
              label!,
              color: theme.colors.white,
            ),
      ),
    );
  }
}
