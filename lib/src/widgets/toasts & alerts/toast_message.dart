import 'package:zaplab_design/zaplab_design.dart';
import 'package:zaplab_design/src/utils/timestamp_formatter.dart';
import 'package:models/models.dart';

class LabToastMessage extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onTap;

  const LabToastMessage({
    super.key,
    required this.message,
    this.onTap,
  });

  static void show(
    BuildContext context, {
    required ChatMessage message,
    Duration? duration,
    VoidCallback? onTap,
  }) {
    LabToast.show(
      context,
      duration: duration,
      onTap: onTap,
      children: [
        LabToastMessage(
          message: message,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabProfilePic.s32(message.author.value),
        const LabGap.s8(),
        Expanded(
          child: LabContainer(
            decoration: BoxDecoration(
              color: theme.colors.white16,
              borderRadius: BorderRadius.only(
                topRight: theme.radius.rad16,
                bottomRight: theme.radius.rad16,
                bottomLeft: theme.radius.rad16,
                topLeft: theme.radius.rad4,
              ),
            ),
            padding: const LabEdgeInsets.symmetric(
              horizontal: LabGapSize.s12,
              vertical: LabGapSize.s8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: LabText.bold12(
                        message.author.value?.name ??
                            formatNpub(message.author.value?.npub ?? ''),
                        color: theme.colors.white66,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const LabGap.s8(),
                    LabText.reg12(
                      TimestampFormatter.format(message.createdAt,
                          format: TimestampFormat.relative),
                      color: theme.colors.white33,
                    ),
                  ],
                ),
                LabText.reg14(
                  message.content,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
