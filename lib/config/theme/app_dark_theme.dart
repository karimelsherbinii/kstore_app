import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/constants.dart';
import '../../features/splash/presentation/cubit/locale_cubit.dart';

appDarkThemeData(context) {
  return ThemeData(
      iconTheme: const IconThemeData(color: Colors.white),
      fontFamily: Constants.mulish,
      primaryColor: AppColors.primaryColor,
      hintColor: AppColors.hintColor,
      brightness: Brightness.dark,
      switchTheme: SwitchThemeData(
        
        thumbColor: MaterialStateProperty.all(Colors.white),
        trackColor: MaterialStateProperty.all(Colors.grey.shade700),
      ),

      // scaffoldBackgroundColor: Colors.,
      // button theme
      buttonTheme: ButtonThemeData(buttonColor: AppColors.primaryColor),
      //appBar
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black38,
        titleTextStyle: TextStyle(
            fontSize: 22,
            fontFamily: Constants.mulish,
            fontWeight: LocaleCubit.get(context).currentLangCode == 'en'
                ? FontWeight.w300
                : FontWeight.bold,
            color: Colors.white),
        toolbarTextStyle: TextStyle(
          fontSize: 14,
          fontFamily: Constants.mulish,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(

          // main title headers
          displayLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: Constants.mulish,
          ),

          // header of text form field
          displayMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: Constants.mulish,
          ),
          //  style of title like Setting bar title

          bodyLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: Constants.mulish,
          ),

          //  style of text (normal texy body)
          bodyMedium: TextStyle(
            fontSize: 17,
            // fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: Constants.mulish,
          ),

          //  style of description text in auth screens
          bodySmall: TextStyle(
            height: 1.5,
            fontSize: 13.6,
            color: Colors.white,
            fontFamily: Constants.mulish,
          ),

          // style of button
          labelLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: Constants.mulish,
          ),

          // style of text form field
          labelSmall: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: Constants.mulish,
          ),
          titleSmall: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: Constants.mulish,
              color: Colors.white),
          titleMedium: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: Constants.mulish,
              color: Colors.white)),
      //===== input =====
      inputDecorationTheme: InputDecorationTheme(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontFamily: Constants.mulish,
        ),
        hintStyle: TextStyle(
            fontFamily: Constants.mulish,
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400),
        errorStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Colors.red,
          fontFamily: Constants.mulish,
        ),
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
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.grey.shade700,
      ));
}
