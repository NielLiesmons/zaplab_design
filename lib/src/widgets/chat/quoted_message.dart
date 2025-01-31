import 'package:zaplab_design/zaplab_design.dart';
import 'package:zaplab_design/src/utils/timestamp_formatter.dart';

class QuotedMessage {
  final String eventId;
  final String content;
  final String profileName;
  final String profilePicUrl;
  final DateTime timestamp;

  const QuotedMessage({
    required this.eventId,
    required this.content,
    required this.profileName,
    required this.profilePicUrl,
    required this.timestamp,
  });
}

class AppQuotedMessage extends StatelessWidget {
  final String profileName;
  final String profilePicUrl;
  final String content;
  final DateTime timestamp;
  final String? eventId;

  const AppQuotedMessage({
    super.key,
    required this.profileName,
    required this.profilePicUrl,
    required this.content,
    required this.timestamp,
    this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      decoration: BoxDecoration(
        color: theme.colors.white8,
        borderRadius: theme.radius.asBorderRadius().rad8,
      ),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          children: [
            AppContainer(
              width: LineThicknessData.normal().thick,
              decoration: BoxDecoration(
                color: theme.colors.white66,
              ),
            ),
            Expanded(
              child: AppContainer(
                padding: const AppEdgeInsets.only(
                  left: AppGapSize.s8,
                  right: AppGapSize.s12,
                  top: AppGapSize.s8,
                  bottom: AppGapSize.s6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppProfilePic.s18(profilePicUrl),
                        const AppGap.s6(),
                        AppText.bold12(
                          profileName,
                          color: theme.colors.white66,
                        ),
                        const Spacer(),
                        AppText.reg12(
                          TimestampFormatter.format(timestamp,
                              format: TimestampFormat.relative),
                          color: theme.colors.white33,
                        ),
                      ],
                    ),
                    const AppGap.s2(),
                    AppContainer(
                      padding: const AppEdgeInsets.only(
                        left: AppGapSize.s2,
                      ),
                      child: AppText.reg14(
                        content,
                        color: theme.colors.white66,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
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
}
