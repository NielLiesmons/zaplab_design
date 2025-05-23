import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';

class AppFeedService extends StatelessWidget {
  final Service service;
  final Function(Model) onTap;
  final bool isUnread;

  const AppFeedService({
    super.key,
    required this.service,
    required this.onTap,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return TapBuilder(
      onTap: () => onTap(service),
      builder: (context, state, hasFocus) {
        return Column(
          children: [
            AppServiceCard(
              service: service,
              onTap: onTap,
              isUnread: isUnread,
            ),
            const AppDivider(),
          ],
        );
      },
    );
  }
}
