import 'dart:ui';

import 'package:models/models.dart';
import 'package:zaplab_design/zaplab_design.dart';

class AppCommunityWelcomeFeed extends StatelessWidget {
  final Community community;
  final VoidCallback onProfileTap;

  const AppCommunityWelcomeFeed({
    super.key,
    required this.community,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      padding: const AppEdgeInsets.all(AppGapSize.s12),
      child: Column(
        children: [
          const AppGap.s48(),
          AppCommunityWelcomeHeader(
            community: community,
            onProfileTap: onProfileTap,
            profileImageUrls: [
              'https://cdn.satellite.earth/946822b1ea72fd3710806c07420d6f7e7d4a7646b2002e6cc969bcf1feaa1009.png',
              'https://npub107jk7htfv243u0x5ynn43scq9wrxtaasmrwwa8lfu2ydwag6cx2quqncxg.blossom.band/3d84787d7284c879429eb0c8e6dcae0bf94cc50456d4046adf33cf040f8f5504.jpg',
              'https://m.primal.net/Mihk.jpg',
              'https://i.nostr.build/MGAFjgFvpIoFjZ09.jpg',
              'https://files.sovbit.host/media/0689df5847a8d3376892da29622d7c0fdc1ef1958f4bc4471d90966aa1eca9f2/cfba34d66cd67339aca14389b367c02f36fec87c325ab0415143ed8db45c2c74.webp',
              'https://i.nostr.build/MVIJ6OOFSUzzjVEc.jpg',
              'https://m.primal.net/HibA.png',
            ],
            emojiImageUrls: [
              'https://cdn.satellite.earth/f388f24d87d9d96076a53773c347a79767402d758edd3b2ac21da51db5ce6e73.png',
              'https://cdn.satellite.earth/503809a3c13a45b79506034e767dc693cc87566cf06263be0e28a5e15f3f8711.png',
              'https://cdn.satellite.earth/9eab0a2b2fa26a00f444213c1424ed59745e8b160572964a79739435627a83f6.png',
              'https://cdn.satellite.earth/aa1557833a08864d55bef51146d1ed9b7a19099b2e4e880fe5f2e0aeedf85d69.png',
            ],
          ),
          const AppGap.s12(),
          ClipRRect(
            borderRadius: theme.radius.asBorderRadius().rad16,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: AppContainer(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const AppEdgeInsets.symmetric(
                  horizontal: AppGapSize.s16,
                  vertical: AppGapSize.s10,
                ),
                decoration: BoxDecoration(
                  color: theme.colors.gray66,
                  borderRadius: theme.radius.asBorderRadius().rad16,
                ),
                child: AppText.reg14(
                  community.description ?? '',
                  color: AppTheme.of(context).colors.white,
                  maxLines: 3,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          const AppGap.s12(),
          ClipRRect(
            borderRadius: theme.radius.asBorderRadius().rad16,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: AppContainer(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const AppEdgeInsets.symmetric(
                  horizontal: AppGapSize.s16,
                  vertical: AppGapSize.s10,
                ),
                decoration: BoxDecoration(
                  color: theme.colors.gray66,
                  borderRadius: theme.radius.asBorderRadius().rad16,
                ),
                child: Row(
                  children: [
                    AppText.med14(
                      'Pinned Publications',
                      color: theme.colors.white66,
                    ),
                    const Spacer(),
                    AppIcon.s14(
                      theme.icons.characters.chevronRight,
                      outlineColor: theme.colors.white33,
                      outlineThickness: LineThicknessData.normal().medium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const AppGap.s12(),
          ClipRRect(
            borderRadius: theme.radius.asBorderRadius().rad16,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: AppContainer(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const AppEdgeInsets.symmetric(
                  horizontal: AppGapSize.s16,
                  vertical: AppGapSize.s10,
                ),
                decoration: BoxDecoration(
                  color: theme.colors.gray66,
                  borderRadius: theme.radius.asBorderRadius().rad16,
                ),
                child: Row(
                  children: [
                    AppText.med14(
                      'Content Types',
                      color: theme.colors.white66,
                    ),
                    const Spacer(),
                    AppIcon.s14(
                      theme.icons.characters.chevronRight,
                      outlineColor: theme.colors.white33,
                      outlineThickness: LineThicknessData.normal().medium,
                    ),
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

// AppWommunityWelcomeFeed
