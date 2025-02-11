import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class AppProfileInline extends StatelessWidget {
  final String profileName;
  final String profilePicUrl;
  final void Function()? onTap;
  final bool? isArticle;

  const AppProfileInline({
    super.key,
    required this.profileName,
    required this.profilePicUrl,
    this.onTap,
    this.isArticle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return TapBuilder(
      onTap: onTap,
      builder: (context, state, hasFocus) {
        return IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppGap.s2(),
              if (profilePicUrl.isNotEmpty)
                Transform.translate(
                  offset: isArticle == false
                      ? const Offset(0, -0.1)
                      : const Offset(0, 0.2),
                  child: AppProfilePic.s20(profilePicUrl),
                )
              else
                AppProfilePic.s20('non-functional url'),
              const AppGap.s4(),
              Transform.translate(
                offset: const Offset(0, -0.2),
                child: profileName.isNotEmpty
                    ? (isArticle == false)
                        ? AppText.bold14(
                            profileName,
                            color: theme.colors.blurpleColor,
                          )
                        : AppText.boldArticle(
                            profileName,
                            color: theme.colors.blurpleColor,
                          )
                    : (isArticle == false)
                        ? AppText.bold14(
                            'ProfileName',
                            color: theme.colors.blurpleColor66,
                          )
                        : AppText.boldArticle(
                            'ProfileName',
                            color: theme.colors.blurpleColor66,
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}
