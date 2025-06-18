import 'package:zaplab_design/zaplab_design.dart';

class LabSwitch extends StatefulWidget {
  const LabSwitch({
    super.key,
    this.value = false,
    this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  LabSwitchState createState() => LabSwitchState();
}

class LabSwitchState extends State<LabSwitch>
    with SingleTickerProviderStateMixin {
  bool _isOn = false;
  late AnimationController _controller;
  late Animation<double> _circlePosition;

  @override
  void initState() {
    super.initState();
    _isOn = widget.value;

    // Initialize the animation controller

    _controller = AnimationController(
      vsync: this,
      duration: LabDurationsData.normal().normal,
    );

    // Set up the Tween for the circle's movement, ensuring it starts from the correct position
    _circlePosition = Tween<double>(
            begin: _isOn ? 16.0 : 0.0, end: _isOn ? 0.0 : 16.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // If the switch is initially on, animate immediately
    if (_isOn) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(LabSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        _isOn = widget.value;
      });
      _toggleSwitch(_isOn);
    }
  }

  void _toggleSwitch(bool value) {
    setState(() {
      _isOn = value;
    });

    // Animate the position of the circle
    if (value) {
      _controller.forward(); // Move the circle to the right
    } else {
      _controller.reverse(); // Move the circle to the left
    }

    widget.onChanged?.call(value); // Notify parent about the change
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return GestureDetector(
      onTap: () => _toggleSwitch(!_isOn),
      child: Container(
        width: 36, // Total width of the switch
        height: 20, // Height of the switch
        padding: const EdgeInsets.all(2), // Padding around the circle
        decoration: BoxDecoration(
          gradient: _isOn
              ? theme.colors.blurple // Gradient for "on" state
              : null, // No gradient for "off" state
          color: _isOn
              ? null // No solid color when "on"
              : theme.colors.white16, // Solid color for "off" state
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // Animated circle movement
            AnimatedBuilder(
              animation: _circlePosition,
              builder: (context, child) {
                return Align(
                  // The circle's position is now mapped correctly
                  alignment: Alignment(_circlePosition.value / 16 * 2 - 1,
                      0.0), // Correct mapping
                  child: Container(
                    width: 16, // Circle size
                    height: 16,
                    decoration: BoxDecoration(
                      color: _isOn
                          ? theme.colors.whiteEnforced // Color for "on" state
                          : theme.colors.white33, // Color for "off" state
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
