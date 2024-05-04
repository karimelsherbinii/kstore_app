// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:kstore/core/utils/hex_color.dart';
// import 'package:kstore/core/utils/media_query_values.dart';
// import 'package:kstore/core/widgets/buttons/default_button.dart';
// import 'package:pinput/pinput.dart';

// import '../../../../../config/locale/app_localizations.dart';
// import '../../../../../config/routes/app_routes.dart';
// import '../../../../../config/theme/app_theme.dart';
// import '../../../../../core/utils/app_colors.dart';
// import '../../../../../core/utils/app_localization_strings.dart';
// import '../../../../../core/utils/app_strings.dart';
// import '../../../../../core/utils/assets_manager.dart';
// import '../../../../../core/utils/constants.dart';
// import '../../../../../core/widgets/screen_container.dart';
// import '../../cubit/auth_cubit.dart';

// class VerificationCodeScreen extends StatefulWidget {
//   const VerificationCodeScreen({super.key});

//   @override
//   State<VerificationCodeScreen> createState() => _VerificationCodeState();
// }

// class _VerificationCodeState extends State<VerificationCodeScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   FocusNode otpFocusNode = FocusNode();
//   // FocusNode myFocusNodeTwo = FocusNode();
//   // FocusNode myFocusNodeThree = FocusNode();
//   // FocusNode myFocusNodeFour = FocusNode();
//   // FocusNode myFocusNodeFive = FocusNode();
//   // FocusNode myFocusNodeSix = FocusNode();
//   late String otpCode;
//   final FocusNode _pinPutFocusNode = FocusNode();

//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _pinPutController = TextEditingController();

//   @override
//   void dispose() {
//     _pinPutController.dispose();
//     _pinPutFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appTranslations = AppLocalizations.of(context)!;

//     return ScreenContainer(
//         child: Scaffold(
//       key: _scaffoldKey,
//       body: SafeArea(
//         child: SingleChildScrollView(child: BlocBuilder<AuthCubit, AuthState>(
//           builder: (context, state) {
//             return Column(
//               children: [
//                 Constants.getAppBar(context,
//                     title:
//                         '${appTranslations.translate(AppLocalizationStrings.verificationCode)}',
//                     moreHeight: true,
//                     haveLeading: false),
//                 SizedBox(
//                   height: context.height * 0.02,
//                 ),
//                 Form(
//                   key: _formKey,
//                   child: Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: context.width * 0.04),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           height: context.height * 0.02,
//                         ),
//                         Constants.getRichText(context,
//                             textBody:
//                                 'We have sent verification code to your number ',
//                             highlightText: '+0475 00000000',
//                             textbodyColor: HexColor('#2D4057').withOpacity(0.4),
//                             highLightcolor: Colors.black),
//                         SizedBox(
//                           height: context.height * 0.02,
//                         ),
//                         Constants.getRichText(context,
//                             textBody: 'Didn\'t receive code?',
//                             highlightText: 'Resend',
//                             textbodyColor: HexColor('#A7A9B7'),
//                             highLightcolor: Colors.black),

//                         SizedBox(
//                           height: context.height * 0.06,
//                         ),
//                         //!--- Numbers fields ---
//                         Container(
//                           // margin: EdgeInsets.all(15.0.sp),
//                           padding: EdgeInsets.all(context.width * 0.02),
//                           child: Center(
//                             child: Pinput(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               length: 4,
//                               defaultPinTheme: AppTheme.defaultPinTheme,
//                               focusedPinTheme: AppTheme.focusedPinTheme,
//                               submittedPinTheme: AppTheme.submittedPinTheme,
//                               validator: (value) {
//                                 return value == '2222'
//                                     ? null
//                                     : 'Pin is incorrect';
//                               },
//                               pinputAutovalidateMode:
//                                   PinputAutovalidateMode.onSubmit,
//                               showCursor: true,
//                               onCompleted: (String otp) {
//                                 otpCode = otp;
//                                 Constants.showToast(
//                                     msg: "Pin Submitted. Value: $otp");
//                               },
//                               focusNode: _pinPutFocusNode,
//                               controller: _pinPutController,
//                               onSubmitted: (value) {
//                                 otpCode = value;
//                                 Constants.showToast(
//                                     msg: 'Pin Submitted. Value: $otpCode');
//                               },
//                               keyboardType: TextInputType.number,
//                               textCapitalization: TextCapitalization.none,
//                             ),
//                           ),
//                         ),

//                         //!---- end Number fields ----
//                         SizedBox(
//                           height: context.height * 0.06,
//                         ),
//                         Center(
//                             child: DefaultButton(
//                                 label:
//                                     '${appTranslations.translate(AppLocalizationStrings.submit)}',
//                                 onTap: () {
//                                   Navigator.pushNamed(
//                                       context, Routes.locationScreen);
//                                 }))
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         )),
//       ),
//     ));
//   }
// }
