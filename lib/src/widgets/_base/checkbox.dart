import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabCheckBox extends StatefulWidget {
  const LabCheckBox({
    super.key,
    this.value = false,
    this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  LabCheckBoxState createState() => LabCheckBoxState();
}

class LabCheckBoxState extends State<LabCheckBox>
    with SingleTickerProviderStateMixin {
  bool _isChecked = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.value;
    _controller = AnimationController(
      vsync: this,
      duration: LabDurationsData.normal().normal,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.16)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.16, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_controller);

    _checkAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.4, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_controller);

    if (_isChecked) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(LabCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        _isChecked = widget.value;
      });
      if (_isChecked) {
        _controller.forward(from: 0);
      }
    }
  }

  void _toggleCheckbox(bool value) {
    setState(() {
      _isChecked = value;
    });
    if (value) {
      _controller.forward(from: 0);
    }
    widget.onChanged?.call(value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final isEnabled = widget.onChanged != null;

    return TapBuilder(
      onTap: isEnabled ? () => _toggleCheckbox(!_isChecked) : null,
      builder: (context, state, hasFocus) {
        double scaleFactor = 1.0;
        if (state == TapState.pressed) {
          scaleFactor = 0.99;
        } else if (state == TapState.hover) {
          scaleFactor = 1.01;
        }

        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: scaleFactor * _scaleAnimation.value,
              child: LabContainer(
                width: theme.sizes.s24,
                height: theme.sizes.s24,
                decoration: BoxDecoration(
                  borderRadius: theme.radius.asBorderRadius().rad8,
                  gradient: _isChecked ? theme.colors.blurple : null,
                  color: _isChecked ? null : theme.colors.black33,
                  border: _isChecked
                      ? null
                      : Border.all(
                          color: theme.colors.white33,
                          width: LabLineThicknessData.normal().medium,
                        ),
                ),
                child: _isChecked
                    ? Center(
                        child: Transform.scale(
                          scale: _checkAnimation.value,
                          child: LabIcon.s8(
                            theme.icons.characters.check,
                            outlineColor: theme.colors.whiteEnforced,
                            outlineThickness:
                                LabLineThicknessData.normal().thick,
                          ),
                        ),
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
