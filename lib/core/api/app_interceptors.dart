import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kstore/core/api/cach_helper.dart';
import '../../features/splash/data/datasources/lang_local_datasource.dart';
import '../utils/app_strings.dart';
import '../utils/constants.dart';

class AppIntercepters extends Interceptor {
  final LanguageLocalDataSource languageLocalDataSource;
  AppIntercepters({required this.languageLocalDataSource});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers[AppStrings.contentType] = AppStrings.applicationJson;
    options.headers[AppStrings.xRequested] = AppStrings.xmlHttpRequest;
    //auth token
    final String? token = CacheHelper.getData(key: AppStrings.token);
    if (token != null) {
      options.headers[Constants.authorization] = 'Bearer $token';
    }
    String lang = await languageLocalDataSource.getSavedLanguage();
    options.headers[Constants.lang] = lang;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
