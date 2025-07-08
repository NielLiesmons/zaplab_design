import 'package:flutter/services.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:zaplab_design/src/widgets/text/code_block_highlighter.dart';
import 'dart:ui';

class LabCodeBlock extends StatefulWidget {
  final String code;
  final String? language;
  final bool allowCopy;

  const LabCodeBlock({
    super.key,
    required this.code,
    this.language,
    this.allowCopy = true,
  });

  @override
  State<LabCodeBlock> createState() => _LabCodeBlockState();
}

class _LabCodeBlockState extends State<LabCodeBlock>
    with SingleTickerProviderStateMixin {
  bool _showCheckmark = false;
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleCopy() {
    Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _showCheckmark = true);
    _scaleController.forward(from: 0.0);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showCheckmark = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final isInsideModal = ModalScope.of(context);

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          LabContainer(
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            padding: const LabEdgeInsets.symmetric(
              horizontal: LabGapSize.s10,
              vertical: LabGapSize.s6,
            ),
            decoration: BoxDecoration(
              color: isInsideModal ? theme.colors.black33 : theme.colors.gray33,
              borderRadius: theme.radius.asBorderRadius().rad16,
              border: Border.all(
                color: theme.colors.white16,
                width: LabLineThicknessData.normal().medium,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabText.h3(widget.language ?? '', color: theme.colors.white33),
                const LabGap.s2(),
                SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: CodeBlockHighlighter(
                    code: widget.code,
                    language: widget.language,
                  ),
                ),
              ],
            ),
          ),
          if (widget.allowCopy == true)
            Positioned(
              top: 8,
              right: 8,
              child: ClipRRect(
                borderRadius: theme.radius.asBorderRadius().rad8,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: LabSmallButton(
                    color: isInsideModal
                        ? theme.colors.white8
                        : theme.colors.white16,
                    square: true,
                    onTap: _handleCopy,
                    children: [
                      _showCheckmark
                          ? ScaleTransition(
                              scale: _scaleAnimation,
                              child: LabIcon.s10(
                                theme.icons.characters.check,
                                outlineColor: theme.colors.white66,
                                outlineThickness:
                                    LabLineThicknessData.normal().thick,
                              ),
                            )
                          : LabIcon.s18(
                              theme.icons.characters.copy,
                              outlineColor: theme.colors.white66,
                              outlineThickness:
                                  LabLineThicknessData.normal().medium,
                            )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
