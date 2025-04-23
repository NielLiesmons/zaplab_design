import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

// class AppBookCard extends StatelessWidget {
//   final Book book;
//   final VoidCallback? onTap;

//   const AppBookCard({
//     super.key,
//     required this.book,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = AppTheme.of(context);
//     // TODO: Get image URL from article model once implemented
//     final imageUrl = null;

//     return AppPanelButton(
//       padding: const AppEdgeInsets.all(AppGapSize.none),
//       onTap: onTap,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ConstrainedBox(
//             constraints: const BoxConstraints(
//               maxHeight: 240,
//             ),
//             child: AppContainer(
//               padding: const AppEdgeInsets.all(AppGapSize.s8),
//               width: double.infinity,
//               child: AspectRatio(
//                 aspectRatio: 9 / 16,
//                 child: AppContainer(
//                   clipBehavior: Clip.hardEdge,
//                   decoration: BoxDecoration(
//                     color: theme.colors.grey33,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(14.6),
//                       topRight: Radius.circular(14.6),
//                     ),
//                   ),
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return const AppSkeletonLoader();
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       print('Error loading asset: $error');
//                       return AppContainer(
//                         decoration: BoxDecoration(
//                           color: theme.colors.grey33,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Model info section
//           AppContainer(
//             padding: const AppEdgeInsets.only(
//               left: AppGapSize.s12,
//               right: AppGapSize.s12,
//               top: AppGapSize.s8,
//               bottom: AppGapSize.s10,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText.med14(
//                   book.title ?? '',
//                   color: theme.colors.white,
//                   maxLines: 1,
//                   textOverflow: TextOverflow.ellipsis,
//                 ),
//                 const AppGap.s2(),
//                 AppText.reg12(
//                   book.writer.value?.name ?? book.author.value?.name ?? '',
//                   color: theme.colors.white66,
//                   maxLines: 1,
//                   textOverflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
