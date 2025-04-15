import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class AppSupportersStage extends StatelessWidget {
  const AppSupportersStage({super.key, required this.topThreeSupporters});

  final List<Profile> topThreeSupporters;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // First place (left)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppProfilePic.s56(
                topThreeSupporters[0].author.value?.pictureUrl ?? ''),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: AppContainer(
                child: Center(
                  child: AppText.med14(
                      topThreeSupporters[0].author.value?.name ??
                          formatNpub(
                              topThreeSupporters[0].author.value?.npub ?? '')),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        // Second place (center - winner)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppProfilePic.s56(
                topThreeSupporters[1].author.value?.pictureUrl ?? ''),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: AppContainer(
                child: Center(
                  child: AppText.med14('Winner'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        // Third place (right)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppProfilePic.s56(
                topThreeSupporters[2].author.value?.pictureUrl ?? ''),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: AppContainer(
                child: Center(
                  child: AppText.med14('Supporter 3'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
