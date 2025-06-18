import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';

class LabFeedService extends StatelessWidget {
  final Service service;
  final Function(Model) onTap;
  final Function(Profile) onProfileTap;
  final bool isUnread;

  const LabFeedService({
    super.key,
    required this.service,
    required this.onTap,
    required this.onProfileTap,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return TapBuilder(
      onTap: () => onTap(service),
      builder: (context, state, hasFocus) {
        return Column(
          children: [
            LabServiceCard(
              service: service,
              onTap: onTap,
              onProfileTap: onProfileTap,
              isUnread: isUnread,
            ),
            const LabDivider(),
          ],
        );
      },
    );
  }
}
