// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:kstore/core/utils/media_query_values.dart';
// import '../../../../config/locale/app_localizations.dart';
// import '../../../../config/routes/app_routes.dart';
// import '../../../../core/animation/slide_in.dart';
// import '../../../../core/utils/app_colors.dart';
// import '../../../../core/utils/assets_manager.dart';


// PageView mobilePlatformBody(BuildContext context,
//     {required PageController pageController,
//     Function()? goToNextPage,
//     Function()? goHome}) {
//   return PageView(controller: pageController, children: [
//     Container(
//       color: Colors.white,
//       child: Stack(
//         children: [
//           Positioned(
//               top: 10,
//               right: 15,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.pushReplacementNamed(context, Routes.home);
//                 },
//                 child: Text(
//                   AppLocalizations.of(context)!.translate('skip')!,
//                   style: const TextStyle(color: Colors.grey, fontSize: 16),
//                 ),
//               )),
//           Positioned(
//             top: context.height * 0.15,
//             left: 0,
//             right: 0,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 child: SlideIn(
//                   msDelay: 1300,
//                   child: Image.asset(
//                     AppImageAssets.splash1,
//                     width: context.width * 0.4,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: context.height * 0.02,
//             left: 0,
//             right: 0,
//             child: SlideIn(
//               msDelay: 500,
//               child: Image.asset(
//                 AppImageAssets.kstorelogo,
//                 scale: context.width / 300,
//               ),
//             ),
//           ),
//           Positioned(
//             top: context.height * 0.5,
//             left: 0,
//             right: 0,
//             child: SizedBox(
//               width: context.width * 0.7,
//               child: SlideIn(
//                 msDelay: 1500,
//                 child: Text(
//                   textAlign: TextAlign.center,
//                   'Delivery Right to Your Door Step',
//                   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                         fontSize: context.width / 20,
//                       ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: context.height * 0.57,
//             left: 0,
//             right: 0,
//             child: SlideIn(
//               msDelay: 1700,
//               child: SizedBox(
//                 width: context.width * 0.7,
//                 child: Text(
//                   maxLines: 2,
//                   textAlign: TextAlign.center,
//                   'Our delivery will ensure your items are delivered right to the door steps',
//                   style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                         fontSize: context.width / 30,
//                       ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: context.height * 0.7,
//             left: 0,
//             right: 0,
//             child: SlideIn(
//               msDelay: 2000,
//               child: InkWell(
//                 onTap: goToNextPage,
//                 child: Container(
//                   margin:
//                       EdgeInsets.symmetric(horizontal: context.width * 0.25),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: context.width * 0.14,
//                     vertical: context.height * 0.02,
//                   ),
//                   decoration: BoxDecoration(
//                       color: AppColors.primaryColor,
//                       borderRadius: BorderRadius.circular(15)),
//                   child: Center(
//                     child: Text(
//                       'Next',
//                       style: Theme.of(context).textTheme.button,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
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
//             child: Stack(
//               children: [
//                 Positioned(
//                   top: context.height * 0.15,
//                   right: 0,
//                   left: 0,
//                   child: Center(
//                     child: SlideIn(
//                       msDelay: 1300,
//                       child: Image.asset(
//                         AppImageAssets.splash2,
//                         width: context.width * 0.6,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: context.height * 0.02,
//                   left: 0,
//                   right: 0,
//                   child: SlideIn(
//                       msDelay: 500,
//                       child: Text(
//                         'Delevery App',
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context)
//                             .textTheme
//                             .displayLarge!
//                             .copyWith(
//                                 fontSize: context.width * 0.09,
//                                 color: Colors.black),
//                       )),
//                 ),
//                 Positioned(
//                   top: context.height * 0.5,
//                   left: 0,
//                   right: 0,
//                   child: SizedBox(
//                     width: context.width * 0.7,
//                     child: SlideIn(
//                       msDelay: 1500,
//                       child: Text(
//                         textAlign: TextAlign.center,
//                         'Great variety of goodies,You can order anything ',
//                         style: Theme.of(context)
//                             .textTheme
//                             .headline6!
//                             .copyWith(fontSize: context.width * 0.05),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: context.height * 0.57,
//                   left: 0,
//                   right: 0,
//                   child: SlideIn(
//                     msDelay: 1700,
//                     child: SizedBox(
//                       width: context.width * 0.7,
//                       child: Text(
//                         maxLines: 2,
//                         textAlign: TextAlign.center,
//                         'We tried to cover all your shopping needs in a one place',
//                         style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                               fontSize: context.width * 0.04,
//                             ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: context.height * 0.7,
//                   left: 0,
//                   right: 0,
//                   child: SlideIn(
//                     msDelay: 2000,
//                     child: InkWell(
//                       onTap: goHome,
//                       child: Container(
//                         margin: EdgeInsets.symmetric(
//                             horizontal: context.width * 0.25),
//                         padding: EdgeInsets.symmetric(
//                           horizontal: context.width * 0.14,
//                           vertical: context.height * 0.02,
//                         ),
//                         decoration: BoxDecoration(
//                             color: AppColors.primaryColor,
//                             borderRadius: BorderRadius.circular(15)),
//                         child: Center(
//                           child: Text(
//                             'Next',
//                             style: Theme.of(context).textTheme.button,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     )),
//   ]);
// }
