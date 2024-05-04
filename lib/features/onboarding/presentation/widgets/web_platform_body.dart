// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:kstore/config/locale/app_localizations.dart';
// import 'package:kstore/core/utils/app_colors.dart';
// import 'package:kstore/core/utils/media_query_values.dart';
// import 'package:kstore/features/splash/presentation/cubit/locale_cubit.dart';
// import '../../../../config/routes/app_routes.dart';
// import '../../../../core/animation/slide_in.dart';
// import '../../../../core/utils/assets_manager.dart';

// PageView webPlatformBody(BuildContext context,
//     {required PageController pageController,
//     Function()? goToNextPage,
//     Function()? goHome}) {
//   return PageView(controller: pageController, children: [
//     Container(
//       color: Colors.white,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Align(
//               alignment: context.read<LocaleCubit>().currentLangCode == 'ar'
//                   ? Alignment.topLeft
//                   : Alignment.topRight,
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pushNamed(context, Routes.home);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Text(
//                     AppLocalizations.of(context)!.translate('skip')!,
//                     style: const TextStyle(color: Colors.black, fontSize: 20),
//                   ),
//                 ),
//               ),
//             ),
//             SlideIn(
//               msDelay: 500,
//               child: Image.asset(
//                 AppImageAssets.kstorelogo,
//                 width: context.width * 0.15,
//               ),
//             ),
//             SizedBox(
//               height: context.height * 0.05,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 child: SlideIn(
//                   msDelay: 300,
//                   child: Image.asset(
//                     AppImageAssets.splash1,
//                     width: context.width * 0.4,
//                     height: context.height * 0.4,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: context.height * 0.05,
//             ),
//             SizedBox(
//               width: context.width * 0.7,
//               child: SlideIn(
//                 msDelay: 1500,
//                 child: Text(
//                   textAlign: TextAlign.center,
//                   'Delivery Right to Your Door Step',
//                   style: Theme.of(context).textTheme.headline6!.copyWith(
//                         fontSize: 40,
//                       ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: context.height * 0.05,
//             ),
//             SlideIn(
//               msDelay: 1700,
//               child: SizedBox(
//                 width: context.width * 0.7,
//                 child: Text(
//                   maxLines: 2,
//                   textAlign: TextAlign.center,
//                   'Our delivery will ensure your items are delivered right to the door steps',
//                   style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                         fontSize: 22,
//                       ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: context.height * 0.05,
//             ),
//             SlideIn(
//               msDelay: 2000,
//               child: InkWell(
//                 onTap: goToNextPage,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: context.width * 0.14,
//                     vertical: context.height * 0.02,
//                   ),
//                   decoration: BoxDecoration(
//                       color: AppColors.primaryColor,
//                       borderRadius: BorderRadius.circular(15)),
//                   child: Text(
//                     'Next',
//                     style: Theme.of(context).textTheme.button,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: context.height * 0.05,
//             ),
//           ],
//         ),
//       ),
//     ),
//     //!screen 2
//     AnimationLimiter(
//         child: AnimationConfiguration.staggeredList(
//       position: 1,
//       duration: const Duration(milliseconds: 2000),
//       child: SlideAnimation(
//         horizontalOffset: 510,
//         child: FadeInAnimation(
//           child: Container(
//             color: Colors.white,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Center(
//                     child: SlideIn(
//                       msDelay: 1300,
//                       child: Image.asset(
//                         AppImageAssets.splash2,
//                         width: context.width * 0.4,
//                         height: context.height * 0.4,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: context.height * 0.05,
//                   ),
//                   SlideIn(
//                       msDelay: 500,
//                       child: Text(
//                         'Delevery App',
//                         style: Theme.of(context)
//                             .textTheme
//                             .displayLarge!
//                             .copyWith(fontSize: 60, color: Colors.black),
//                       )),
//                   SizedBox(
//                     height: context.height * 0.05,
//                   ),
//                   SizedBox(
//                     width: context.width * 0.7,
//                     child: SlideIn(
//                       msDelay: 1500,
//                       child: Text(
//                         textAlign: TextAlign.center,
//                         'Great variety of goodies,You can order anything ',
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleLarge!
//                             .copyWith(fontSize: 40),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: context.height * 0.05,
//                   ),
//                   SlideIn(
//                     msDelay: 1700,
//                     child: SizedBox(
//                       width: context.width * 0.7,
//                       child: Text(
//                         maxLines: 2,
//                         textAlign: TextAlign.center,
//                         'We tried to cover all your shopping needs in a one place',
//                         style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                               fontSize: 22,
//                             ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: context.height * 0.05,
//                   ),
//                   SlideIn(
//                     msDelay: 2000,
//                     child: InkWell(
//                       onTap: goHome,
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: context.width * 0.14,
//                           vertical: context.height * 0.02,
//                         ),
//                         decoration: BoxDecoration(
//                             color: AppColors.primaryColor,
//                             borderRadius: BorderRadius.circular(15)),
//                         child: Text(
//                           'Next',
//                           style: Theme.of(context).textTheme.labelLarge,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: context.height * 0.05,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     )),
//   ]);
// }
