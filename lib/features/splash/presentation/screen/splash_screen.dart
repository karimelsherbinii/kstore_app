import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kstore/core/api/cach_helper.dart';
import 'package:kstore/core/utils/app_strings.dart';
import 'package:kstore/core/utils/assets_manager.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/widgets/screen_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFirstTime = CacheHelper.getData(key: AppStrings.isFirstTime) ?? true;
  bool isAuthenticated = CacheHelper.getData(key: AppStrings.token) != null;
  var langIsSelected = CacheHelper.getData(key: 'langIsSelected') ?? false;

  _goToOnboarding() {
    if (kIsWeb) {
      _goAuth();
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.onboardingScreen, (Route<dynamic> route) => false);
    }
  }

  _goAuth() => Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.authScreen, (Route<dynamic> route) => false);

  _goHome() => Navigator.of(context)
      .pushNamedAndRemoveUntil(Routes.home, (Route<dynamic> route) => false);

  _goNext() => Future.delayed(const Duration(seconds: 2), () {
        if (isFirstTime) {
          //!TODO change to true
          log('isFirstTime: $isFirstTime');
          langIsSelected ? _goLang() : _goToOnboarding();
        } else {
          log('not FirstTime: $isFirstTime');
          if (isAuthenticated == true) {
            log('token: $isAuthenticated');
            _goHome();
          } else {
            log('token: $isAuthenticated is null');
            !langIsSelected ? _goLang() : _goAuth();
          }
        }
      });

  Future<Object?> _goLang() {
    return Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.languagesScreens, (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    _goNext();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
        child: Scaffold(
            body: Container(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          AppImageAssets.appIcon,
          width: context.width * 0.5,
        ),
      ),
    )));
  }
}
