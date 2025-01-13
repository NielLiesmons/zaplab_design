import 'dart:ui';
import 'dart:io' show Platform;
import 'package:zaplab_design/zaplab_design.dart';

class AppInputModal extends StatelessWidget {
  final Widget? header;
  final Widget inputField;

  const AppInputModal({
    super.key,
    this.header,
    required this.inputField,
  });

  static Future<void> show(
    BuildContext context, {
    Widget? header,
    required Widget inputField,
  }) {
    final theme = AppTheme.of(context);
    // Create a FocusNode that we'll pass to the input field
    final focusNode = FocusNode()..requestFocus();

    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: const Color(0x00000000),
        transitionDuration: theme.durations.fast,
        reverseTransitionDuration: theme.durations.fast,
        pageBuilder: (_, __, ___) => AppInputModal(
          header: header,
          inputField: inputField is AppInputField
              ? (inputField).copyWith(focusNode: focusNode)
              : inputField,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final modalOffset = ValueNotifier<double>(0.0);
    final keyboardHeight =
        MediaQuery.of(context).viewInsets.bottom / theme.system.scale;
    final bottomPadding =
        Platform.isIOS || Platform.isAndroid ? AppGapSize.s4 : AppGapSize.s16;

    return Stack(
      children: [
        // Backdrop with tap to dismiss
        GestureDetector(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          onVerticalDragUpdate: (details) {
            // Only handle drag on the backdrop, not the modal content
            final RenderBox box = context.findRenderObject() as RenderBox;
            final localPosition = box.globalToLocal(details.globalPosition);
            final modalHeight =
                box.size.height * 0.7; // Approximate modal height

            // Only trigger if dragging on the backdrop area (above the modal)
            if (localPosition.dy < modalHeight &&
                details.delta.dy > 0 &&
                Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: AppContainer(
              decoration: BoxDecoration(color: theme.colors.black16),
            ),
          ),
        ),
        // Modal content
        Align(
          alignment: Alignment.bottomCenter,
          child: ValueListenableBuilder<double>(
            valueListenable: modalOffset,
            builder: (context, offset, child) {
              return Transform.translate(
                offset: Offset(0,
                    offset - keyboardHeight), // Only keyboard adjustment here
                child: GestureDetector(
                  onVerticalDragUpdate: Platform.isIOS || Platform.isAndroid
                      ? (details) {
                          if (details.delta.dy > 0) {
                            modalOffset.value += details.delta.dy;
                            if (modalOffset.value > 160 &&
                                Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }
                          }
                        }
                      : null,
                  onVerticalDragEnd: Platform.isIOS || Platform.isAndroid
                      ? (details) {
                          if (modalOffset.value > 0 &&
                              modalOffset.value <= 160) {
                            modalOffset.value = 0;
                          }
                        }
                      : null,
                  child: AppContainer(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(theme.radius.rad32.x),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colors.black33,
                          blurRadius: 32,
                          offset: const Offset(0, -12),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(theme.radius.rad32.x),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                        child: AppContainer(
                          decoration: BoxDecoration(
                            color: theme.colors.grey66,
                            border: Border(
                              top: BorderSide(
                                color: theme.colors.white16,
                                width: LineThicknessData.normal().thin,
                              ),
                            ),
                          ),
                          padding: AppEdgeInsets.only(
                            top: AppGapSize.s16,
                            bottom: bottomPadding,
                            left: AppGapSize.s16,
                            right: AppGapSize.s16,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (header != null) header!,
                              inputField,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
