import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class AppChatScreen extends StatelessWidget {
  const AppChatScreen({
    super.key,
    required this.profileName,
    required this.profilePicUrl,
  });

  final String profileName;
  final String profilePicUrl;
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      child: Column(
        children: [
          AppContainer(
            child: Row(
              children: [
                TapBuilder(
                  onTap: () {},
                  builder: (context, state, hasFocus) {
                    return Column(
                      children: [
                        AppProfilePic.s32(profilePicUrl),
                        const AppGap.s12(),
                        AppText.bold14(profileName),
                      ],
                    );
                  },
                ),
                AppIcon.s16(
                  theme.icons.characters.bell,
                  outlineColor: theme.colors.white66,
                  outlineThickness: LineThicknessData.normal().medium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
