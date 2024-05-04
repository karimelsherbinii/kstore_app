import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:pinput/pinput.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/hex_color.dart';
import '../../features/splash/presentation/cubit/locale_cubit.dart';

/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5
/// ``
class AppTheme {
  //! ======= PIN PUT THEME =========
  static var borderColor = HexColor('#0E5575');
  static const errorColor = Color.fromRGBO(255, 234, 238, 1);
  static var fillColor = Colors.white;
  // static final defaultPinTheme = PinTheme(
  //   margin: const EdgeInsets.all(5),
  //   width: 50,
  //   height: 50,
  //   textStyle: TextStyle(
  //       fontSize: 20,
  //       color: AppColors.secandryColor,
  //       fontWeight: FontWeight.w600),
  //   decoration: BoxDecoration(
  //     color: fillColor,
  //     border: Border.all(color: borderColor),
  //     borderRadius: BorderRadius.circular(12),
  //   ),
  // );

  // static final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  //   border: Border.all(color: borderColor),
  //   borderRadius: BorderRadius.circular(8),
  // );

  // static final submittedPinTheme = defaultPinTheme.copyWith(
  //   decoration: defaultPinTheme.decoration!.copyWith(
  //     color: const Color.fromRGBO(234, 239, 243, 1),
  //   ),
  // );

  static appThemeData(context) {
    return ThemeData(
      iconTheme: IconThemeData(color: AppColors.iconColorBlack),
      fontFamily: Constants.mulish,
      primaryColor: AppColors.primaryColor,
      hintColor: AppColors.hintColor,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      switchTheme: SwitchThemeData(
        trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
      ),
      // button theme
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.primaryColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      //appBar
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.black,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        titleTextStyle: TextStyle(
            fontSize: 22,
            fontFamily: Constants.mulish,
            fontWeight: FontWeight.bold,
            color: AppColors.secandryColor),
        toolbarTextStyle: TextStyle(
          fontSize: 14,
          fontFamily: LocaleCubit.get(context).currentLangCode == 'en'
              ? Constants.mulish
              : Constants.mulish,
          fontWeight: FontWeight.bold,
          color: AppColors.headersColor,
        ),
      ),
      textTheme: TextTheme(
          // main title headers
          displayLarge: TextStyle(
              fontFamily: Constants.mulish,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor),

          // header of text form field
          displayMedium: TextStyle(
              fontFamily: Constants.mulish,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.secandryColor),

          //  style of title like Setting bar title
          bodyLarge: TextStyle(
            fontFamily: Constants.mulish,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.secandryColor,
          ),

          //  style of text (normal texy body)
          bodyMedium: TextStyle(
            fontFamily: Constants.mulish,
            fontSize: 17,
            // fontWeight: FontWeight.bold,
            color: AppColors.secandryColor,
          ),

          //  style of description text in auth screens
          bodySmall: TextStyle(
            fontFamily: Constants.mulish,
            fontWeight: FontWeight.w500,
            height: 1.5,
            fontSize: 12,
            color: AppColors.secandryColor,
          ),

          //// style of button
          labelLarge: const TextStyle(
              fontFamily: Constants.mulish,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white),

          // style of text form field
          labelSmall: TextStyle(
              fontFamily: Constants.mulish,
              color: AppColors.secandryColor,
              fontSize: 16,
              fontWeight: FontWeight.w400),
          titleSmall: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: Constants.mulish,
              color: AppColors.hintColor),
          titleMedium: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: Constants.mulish,
              color: AppColors.primaryColor)),
      //===== input =====
      inputDecorationTheme: InputDecorationTheme(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.primaryColor),
        hintStyle: TextStyle(
            fontFamily: Constants.mulish,
            color: AppColors.hintColor,
            fontSize: 16,
            fontWeight: FontWeight.w400),
        errorStyle: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w400, color: Colors.red),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.transparent)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.transparent)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
