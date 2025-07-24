import 'package:zaplab_design/zaplab_design.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:models/models.dart';

class LabProfileInline extends StatelessWidget {
  final Profile? profile;
  final void Function()? onTap;
  final bool? isArticle;
  final bool? isEditableText;
  final bool isCompact;

  const LabProfileInline({
    super.key,
    this.profile,
    this.onTap,
    this.isArticle = false,
    this.isEditableText = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    return TapBuilder(
      onTap: onTap,
      builder: (context, state, hasFocus) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 160),
          child: IntrinsicWidth(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const LabGap.s2(),
                if (profile?.pictureUrl != null &&
                    profile!.pictureUrl!.isNotEmpty)
                  Transform.translate(
                    offset: isArticle == false
                        ? const Offset(0, -0.1)
                        : const Offset(0, 0.2),
                    child: isCompact
                        ? LabProfilePic.s16(profile, onTap: onTap)
                        : LabProfilePic.s20(profile, onTap: onTap),
                  )
                else
                  isCompact
                      ? LabProfilePic.s16(null, onTap: onTap)
                      : LabProfilePic.s20(null, onTap: onTap),
                const LabGap.s4(),
                Column(
                  children: [
                    isCompact ? const LabGap.s2() : const SizedBox.shrink(),
                    (isArticle == false)
                        ? isEditableText == true
                            ? LabText.med16(
                                profile?.name ??
                                    formatNpub(profile?.npub ?? "Profile..."),
                                color: theme.colors.blurpleLightColor,
                                maxLines: 1,
                                textOverflow: TextOverflow.ellipsis,
                              )
                            : isCompact
                                ? LabText.med12(
                                    profile?.name ??
                                        formatNpub(
                                            profile?.npub ?? "Profile..."),
                                    color: theme.colors.blurpleLightColor66,
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  )
                                : LabText.med14(
                                    profile != null
                                        ? profile?.name ??
                                            formatNpub(profile!.npub)
                                        : "Profile...",
                                    color: theme.colors.blurpleLightColor,
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  )
                        : LabText.boldArticle(
                            profile?.name ??
                                formatNpub(profile?.npub ?? "Profile..."),
                            color: theme.colors.blurpleLightColor,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
