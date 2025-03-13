import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';

class AppProfileInline extends StatelessWidget {
  final String profileName;
  final String profilePicUrl;
  final void Function()? onTap;
  final bool? isArticle;
  final bool? isEditableText;

  const AppProfileInline({
    super.key,
    required this.profileName,
    required this.profilePicUrl,
    this.onTap,
    this.isArticle = false,
    this.isEditableText = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return TapBuilder(
      onTap: onTap,
      builder: (context, state, hasFocus) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 160),
          child: IntrinsicWidth(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                Flexible(
                  child: Transform.translate(
                    offset: const Offset(0, -0.2),
                    child: profileName.isNotEmpty
                        ? (isArticle == false)
                            ? isEditableText == true
                                ? AppText.med16(
                                    profileName,
                                    color: theme.colors.blurpleColor,
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  )
                                : AppText.med14(
                                    profileName,
                                    color: theme.colors.blurpleColor,
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  )
                            : AppText.boldArticle(
                                profileName,
                                color: theme.colors.blurpleColor,
                                maxLines: 1,
                                textOverflow: TextOverflow.ellipsis,
                              )
                        : (isArticle == false)
                            ? isEditableText == true
                                ? AppText.med16(
                                    'ProfileName',
                                    color: theme.colors.blurpleColor66,
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  )
                                : AppText.med14(
                                    'ProfileName',
                                    color: theme.colors.blurpleColor66,
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  )
                            : AppText.boldArticle(
                                'ProfileName',
                                color: theme.colors.blurpleColor66,
                                maxLines: 1,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
