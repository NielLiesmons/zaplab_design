import 'package:zaplab_design/zaplab_design.dart';

class AppImageCard extends StatelessWidget {
  final String url;

  const AppImageCard({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return AppContainer(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colors.gray66,
        borderRadius: theme.radius.asBorderRadius().rad16,
        border: Border.all(
          color: theme.colors.white16,
          width: AppLineThicknessData.normal().thin,
        ),
      ),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const AppSkeletonLoader();
        },
      ),
    );
  }
}
