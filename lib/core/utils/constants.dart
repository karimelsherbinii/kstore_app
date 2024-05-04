import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kstore/config/routes/app_routes.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:kstore/features/products/presentation/cubit/category_products/category_products_cubit.dart';
import 'package:kstore/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/locale/app_localizations.dart';
import '../../features/auth/presentation/cubit/login/login_cubit.dart';
import '../../features/products/presentation/cubit/products_cubit.dart';
import '../../features/splash/presentation/cubit/locale_cubit.dart';
import 'app_colors.dart';
import 'app_strings.dart';

String testGreyImage =
    'https://media.tarkett-image.com/large/TH_24567080_24594080_24596080_24601080_24563080_24565080_24588080_001.jpg';

class Constants {
  static const double desktopBreakpoint = 950;
  static const double tabletBreakpoint = 600;
  static const double watchBreakpoint = 300;
  static const int fetchLimit = 7;
  static const String mulish = 'Mulish';
  static const String amiriFontFamily = 'Amiri';
  static const String accept = 'Accept';
  // static const String sempolyFontFamily = 'KFGQPC Arabic Symbols 01';
  static const String apiKey = 'APIKEY';
  static const String kstoreKey = '';
  static const String lang = 'APILang';
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String authorization = 'Authorization';

  static getScreenMargin(BuildContext context) {
    return context.width * 0.055;
  }

  static String getProductPrice(int index, BuildContext context) {
    if (context.read<ProductsCubit>().products[index].price != 0) {
      return '\$ ${context.read<ProductsCubit>().products[index].price}';
    } else if (context
            .read<ProductsCubit>()
            .products[index]
            .colors!
            .isNotEmpty &&
        context
            .read<ProductsCubit>()
            .products[index]
            .colors![0]
            .sizes!
            .isNotEmpty) {
      return '\$ ${context.read<ProductsCubit>().products[index].colors![0].sizes![0].price}';
    } else {
      return '\$ 0';
    }
  }

  static String getProductPriceByCategory(int index, BuildContext context) {
    if (context.read<CategoryProductsCubit>().products[index].price != 0) {
      return '\$ ${context.read<CategoryProductsCubit>().products[index].price}';
    } else if (context
            .read<CategoryProductsCubit>()
            .products[index]
            .colors!
            .isNotEmpty &&
        context
            .read<CategoryProductsCubit>()
            .products[index]
            .colors![0]
            .sizes!
            .isNotEmpty) {
      return '\$ ${context.read<CategoryProductsCubit>().products[index].colors![0].sizes![0].price}';
    } else {
      return '\$ 0';
    }
  }

  static Future<void> openUrl(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView)) {
      throw 'Could not launch $url';
    }
  }

  

  static String getFavoriteProductPrice(int index, BuildContext context) {
    if (context.read<FavoriteCubit>().favoriteProducts[index].price != 0) {
      return '\$ ${context.read<FavoriteCubit>().favoriteProducts[index].price}';
    } else if (context
            .read<FavoriteCubit>()
            .favoriteProducts[index]
            .colors!
            .isNotEmpty &&
        context
            .read<FavoriteCubit>()
            .favoriteProducts[index]
            .colors![0]
            .sizes!
            .isNotEmpty) {
      return '\$ ${context.read<FavoriteCubit>().favoriteProducts[index].colors![0].sizes![0].price}';
    } else {
      return '\$ 0';
    }
  }

  static Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => Directionality(
              textDirection: context.read<LocaleCubit>().currentLangCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: AlertDialog(
                alignment: Alignment.center,
                titleTextStyle: TextStyle(
                  color: AppColors.appAccentDarkColor,
                  fontSize: 16,
                  fontFamily: AppStrings.almaraiFontFamily,
                ),
                actionsAlignment: MainAxisAlignment.center,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                title: Text(
                  AppLocalizations.of(context)!.translate('want_to_logout')!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.appAccentDarkColor,
                    fontSize: 16,
                    fontFamily: AppStrings.almaraiFontFamily,
                  ),
                ),
                actions: <Widget>[
                  SizedBox(
                    width: context.width * 0.25,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primaryColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: AppStrings.almaraiFontFamily,
                              fontSize: 14),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(AppLocalizations.of(context)!
                            .translate('cancel')!)),
                  ),
                  SizedBox(
                    width: context.width * 0.25,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primaryColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: AppStrings.almaraiFontFamily,
                              fontSize: 14),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<LoginCubit>(context)
                              .logoutLocally(context: context);
                        },
                        child: Text(
                            AppLocalizations.of(context)!.translate('ok')!)),
                  ),
                ],
              ),
            ));
  }

  static PreferredSize getAppBar(
    BuildContext context, {
    required String title,
    bool moreHeight = false,
    final bool haveLeading = true,
    VoidCallback? onPressed,
    List<Widget>? actions,
  }) {
    return PreferredSize(
      preferredSize: Size.fromHeight(
        moreHeight ? 70 : 50,
      ),
      child: AppBar(
        toolbarHeight: moreHeight ? 70 : 50,
        backgroundColor: context.read<SettingsCubit>().currentDarkModeState
            ? AppColors.darkBackground
            : Colors.white,
        elevation: 0,
        leading: haveLeading
            ? IconButton(
                icon: Platform.isIOS
                    ? Icon(
                        Icons.arrow_back_ios,
                        color:
                            context.read<SettingsCubit>().currentDarkModeState
                                ? Colors.white
                                : AppColors.secandryColor,
                      )
                    : Icon(
                        Icons.arrow_back,
                        color:
                            context.read<SettingsCubit>().currentDarkModeState
                                ? Colors.white
                                : AppColors.secandryColor,
                      ),
                onPressed: onPressed ??
                    () {
                      Navigator.pop(context);
                    },
              )
            : null,
        title: Text(title,
            style: Theme.of(context).textTheme.headline1!.copyWith(
                color: context.read<SettingsCubit>().currentDarkModeState
                    ? Colors.white
                    : Colors.black,
                fontSize: context.width * 0.06,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                height: 30 / 24)),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: context.width * 0.05,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        actions: actions,
      ),
    );
  }

  //!
  static getRichText(
    BuildContext context, {
    String textBody = '',
    String highlightText = '',
    Color? highLightcolor = Colors.red,
    Color? textbodyColor = Colors.black,
    // text body
    double textBodySize = 15.6,
    FontWeight textBodyWeight = FontWeight.normal,
    //highlight
    double highlightTextSize = 15.6,
    FontWeight highlightWeight = FontWeight.normal,
    final bool haveThreeItems = false,
    final thirdItem = '',
    final thirdItemColor,
    final thirdItemSize = 15.6,
    final thirdItemWeight = FontWeight.normal,
  }) {
    List<TextSpan> textSpans = <TextSpan>[
      TextSpan(
          text: textBody,
          style: TextStyle(
              fontSize: textBodySize,
              color: haveThreeItems ? AppColors.primaryColor : textbodyColor,
              fontWeight: textBodyWeight)),
      TextSpan(
          text: ' $highlightText ',
          style: TextStyle(
              fontSize: highlightTextSize,
              color: haveThreeItems ? Colors.black : highLightcolor,
              fontWeight: highlightWeight)),
      haveThreeItems
          ? TextSpan(
              text: thirdItem,
              style: TextStyle(
                  fontSize: thirdItemSize,
                  color: thirdItemColor ?? AppColors.primaryColor,
                  fontWeight: thirdItemWeight))
          : const TextSpan(),
    ];
    return RichText(
      text: TextSpan(
        style: TextStyle(color: AppColors.primaryColor, fontSize: 18),
        children: textSpans,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    showDialog(
        context: context,
        //backgroud color

        builder: (BuildContext context) => Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: AppStrings.almaraiFontFamily,
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(
                      AppLocalizations.of(context)!.translate('ok')!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppStrings.almaraiFontFamily,
                          fontSize: 14),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              )
            : Directionality(
                textDirection:
                    context.read<LocaleCubit>().currentLangCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                child: AlertDialog(
                  actionsAlignment: MainAxisAlignment.center,
                  alignment: Alignment.center,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  backgroundColor: Colors.white,
                  titleTextStyle: TextStyle(
                    color: AppColors.secandryColor,
                    fontSize: 16,
                    fontFamily: AppStrings.almaraiFontFamily,
                  ),
                  title: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secandryColor,
                      fontSize: 16,
                      fontFamily: AppStrings.almaraiFontFamily,
                    ),
                  ),
                  actions: <Widget>[
                    SizedBox(
                      width: context.width * 0.25,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppColors.primaryColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: AppStrings.almaraiFontFamily,
                                fontSize: 14),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                              AppLocalizations.of(context)!.translate('ok')!)),
                    ),
                  ],
                ),
              ));
  }

  //ask to login dialog

  static void showAskToLoginDialog(BuildContext context) {
    showDialog(
        context: context,
        //backgroud color

        builder: (BuildContext context) => Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(
                  AppLocalizations.of(context)!
                      .translate('you_must_login_first')!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: AppStrings.almaraiFontFamily,
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text(
                        AppLocalizations.of(context)!.translate('login')!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: AppStrings.almaraiFontFamily,
                            fontSize: 14),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, Routes.authScreen);
                      }),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(
                      AppLocalizations.of(context)!.translate('cancel')!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppStrings.almaraiFontFamily,
                          fontSize: 14),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              )
            : Directionality(
                textDirection:
                    context.read<LocaleCubit>().currentLangCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                child: AlertDialog(
                  actionsAlignment: MainAxisAlignment.center,
                  alignment: Alignment.center,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  backgroundColor: Colors.white,
                  titleTextStyle: TextStyle(
                    color: AppColors.secandryColor,
                    fontSize: 16,
                    fontFamily: AppStrings.almaraiFontFamily,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!
                        .translate('you_must_login_first')!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secandryColor,
                      fontSize: 16,
                      fontFamily: AppStrings.almaraiFontFamily,
                    ),
                  ),
                  actions: <Widget>[
                    SizedBox(
                      width: context.width * 0.25,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppColors.primaryColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: AppStrings.almaraiFontFamily,
                                fontSize: 14),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, Routes.authScreen);
                          },
                          child: Text(AppLocalizations.of(context)!
                              .translate('login')!)),
                    ),
                    SizedBox(
                      width: context.width * 0.25,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppColors.primaryColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: AppStrings.almaraiFontFamily,
                                fontSize: 14),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(AppLocalizations.of(context)!
                              .translate('cancel')!)),
                    ),
                  ],
                ),
              ));
  }

  static void showToast(
      {required String msg, Color? color, ToastGravity? gravity}) {
    Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        msg: msg,
        backgroundColor: color ?? AppColors.appAccentDarkColor,
        gravity: gravity ?? ToastGravity.BOTTOM);
  }

  //
  static void showCustomSnackBar(String pin, BuildContext context) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: SizedBox(
        height: 80.0,
        child: Center(
          child: Text(
            'Pin Submitted. Value: $pin',
            style: const TextStyle(fontSize: 25.0),
          ),
        ),
      ),
      backgroundColor: AppColors.primaryColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static dynamic decodeJson(Response<dynamic> response) {
    var responseJson = jsonDecode(response.data.toString());
    return responseJson;
  }

  static String? handleErrorMsg(BuildContext context, String message) {
    return message == AppStrings.noInternetConnection
        ? AppLocalizations.of(context)!.translate('no_internet_connection')
        : message == AppStrings.badRequest
            ? AppLocalizations.of(context)!.translate('bad_request')
            : message == AppStrings.unauthorized
                ? AppLocalizations.of(context)!.translate('unauthorized')
                : message == AppStrings.requestedInfoNotFound
                    ? AppLocalizations.of(context)!
                        .translate('requested_info_not_found')
                    : message == AppStrings.conflictOccurred
                        ? AppLocalizations.of(context)!
                            .translate('conflict_occurred')
                        : message == AppStrings.internalServerError
                            ? AppLocalizations.of(context)!
                                .translate('internal_server_error')
                            : message == AppStrings.errorDuringCommunication
                                ? AppLocalizations.of(context)!
                                    .translate('errorـduring_communication')
                                : AppLocalizations.of(context)!
                                    .translate('something_went_wrong')!;
  }
}
