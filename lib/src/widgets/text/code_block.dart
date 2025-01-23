import 'package:flutter/services.dart';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:zaplab_design/src/widgets/text/code_block_highlighter.dart';
import 'dart:ui';

class AppCodeBlock extends StatefulWidget {
  final String code;
  final String language;

  const AppCodeBlock({
    super.key,
    required this.code,
    required this.language,
  });

  @override
  State<AppCodeBlock> createState() => _AppCodeBlockState();
}

class _AppCodeBlockState extends State<AppCodeBlock>
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
    final theme = AppTheme.of(context);

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          AppContainer(
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            padding: const AppEdgeInsets.symmetric(
              horizontal: AppGapSize.s8,
              vertical: AppGapSize.s6,
            ),
            decoration: BoxDecoration(
              color: theme.colors.grey33,
              borderRadius: theme.radius.asBorderRadius().rad16,
              border: Border.all(
                color: theme.colors.white16,
                width: LineThicknessData.normal().medium,
              ),
            ),
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              child: CodeBlockHighlighter(code: widget.code),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: ClipRRect(
              borderRadius: theme.radius.asBorderRadius().rad8,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: AppSmallButton(
                  inactiveColor: theme.colors.white16,
                  square: true,
                  onTap: _handleCopy,
                  content: [
                    _showCheckmark
                        ? ScaleTransition(
                            scale: _scaleAnimation,
                            child: AppIcon.s10(
                              theme.icons.characters.check,
                              outlineColor: theme.colors.white66,
                              outlineThickness:
                                  LineThicknessData.normal().thick,
                            ),
                          )
                        : AppIcon.s18(
                            theme.icons.characters.copy,
                            outlineColor: theme.colors.white66,
                            outlineThickness: LineThicknessData.normal().medium,
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
