import 'package:zaplab_design/zaplab_design.dart';

class AppPreferencesModal extends StatelessWidget {
  const AppPreferencesModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppModal(
      title: 'Preferences',
      children: [
        Row(children: [
          const AppGap.s12(),
          AppText.h3('THEME', color: theme.colors.white66),
        ]),
        const AppGap.s8(),
        AppSelector(
          children: [
            AppSelectorButton(
              selectedContent: const [AppText.med14('System')],
              unselectedContent: [
                AppText.med14(
                  'System',
                  color: theme.colors.white33,
                )
              ],
              isSelected: true,
              onTap: () {},
            ),
            AppSelectorButton(
              selectedContent: const [AppText.med14('Dark')],
              unselectedContent: [
                AppText.med14(
                  'Dark',
                  color: theme.colors.white33,
                )
              ],
              isSelected: false,
              onTap: () {},
            ),
            AppSelectorButton(
              selectedContent: const [AppText.med14('Gray')],
              unselectedContent: [
                AppText.med14(
                  'Gray',
                  color: theme.colors.white33,
                )
              ],
              isSelected: false,
              onTap: () {
                Future.microtask(() {
                  // ignore: use_build_context_synchronously
                  AppResponsiveTheme.of(context).setColorMode(
                    AppThemeColorMode.grey,
                  );
                });
              },
            ),
            AppSelectorButton(
              selectedContent: const [AppText.med14('Light')],
              unselectedContent: [
                AppText.med14(
                  'Light',
                  color: theme.colors.white33,
                )
              ],
              isSelected: false,
              onTap: () {},
            ),
          ],
          onChanged: (index) {},
        ),
      ],
    );
  }
}
