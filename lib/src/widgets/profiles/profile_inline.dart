import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class AppProfileInline extends StatelessWidget {
  final Profile profile;
  final void Function()? onTap;
  final bool? isArticle;
  final bool? isEditableText;
  final bool isCompact;

  const AppProfileInline({
    super.key,
    required this.profile,
    this.onTap,
    this.isArticle = false,
    this.isEditableText = false,
    this.isCompact = false,
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
                if (profile.pictureUrl != null &&
                    profile.pictureUrl!.isNotEmpty)
                  Transform.translate(
                    offset: isArticle == false
                        ? const Offset(0, -0.1)
                        : const Offset(0, 0.2),
                    child: isCompact
                        ? AppProfilePic.s16(profile.pictureUrl ?? '',
                            onTap: onTap)
                        : AppProfilePic.s20(profile.pictureUrl ?? '',
                            onTap: onTap),
                  )
                else
                  isCompact
                      ? AppProfilePic.s16('non-functional url', onTap: onTap)
                      : AppProfilePic.s20('non-functional url', onTap: onTap),
                const AppGap.s4(),
                Flexible(
                  child: Transform.translate(
                    offset: const Offset(0, -0.2),
                    child: profile.name!.isNotEmpty
                        ? (isArticle == false)
                            ? isEditableText == true
                                ? AppText.med16(
                                    profile.name!,
                                    color: theme.colors.blurpleColor,
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  )
                                : isCompact
                                    ? AppText.med12(
                                        profile.name!,
                                        color: theme.colors.blurpleColor66,
                                        maxLines: 1,
                                        textOverflow: TextOverflow.ellipsis,
                                      )
                                    : AppText.med14(
                                        profile.name!,
                                        color: theme.colors.blurpleColor,
                                        maxLines: 1,
                                        textOverflow: TextOverflow.ellipsis,
                                      )
                            : AppText.boldArticle(
                                profile.name!,
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
                                : isCompact
                                    ? AppText.med12(
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
