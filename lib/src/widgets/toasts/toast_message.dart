import 'package:zaplab_design/zaplab_design.dart';
import 'package:zaplab_design/src/utils/timestamp_formatter.dart';
import 'package:models/models.dart';

class AppToastMessage extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onTap;

  const AppToastMessage({
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
    AppToast.show(
      context,
      duration: duration,
      onTap: onTap,
      children: [
        AppToastMessage(
          message: message,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppProfilePic.s32(message.author.value),
        const AppGap.s8(),
        Expanded(
          child: AppContainer(
            decoration: BoxDecoration(
              color: theme.colors.white16,
              borderRadius: BorderRadius.only(
                topRight: theme.radius.rad16,
                bottomRight: theme.radius.rad16,
                bottomLeft: theme.radius.rad16,
                topLeft: theme.radius.rad4,
              ),
            ),
            padding: const AppEdgeInsets.symmetric(
              horizontal: AppGapSize.s12,
              vertical: AppGapSize.s8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: AppText.bold12(
                        message.author.value?.name ??
                            formatNpub(message.author.value?.npub ?? ''),
                        color: theme.colors.white66,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const AppGap.s8(),
                    AppText.reg12(
                      TimestampFormatter.format(message.createdAt,
                          format: TimestampFormat.relative),
                      color: theme.colors.white33,
                    ),
                  ],
                ),
                AppText.reg14(
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
