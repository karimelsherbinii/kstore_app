import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/app_strings.dart';

abstract class LanguageLocalDataSource {
  Future<bool> changeLanguage({required String languageCode});
  Future<String> getSavedLanguage();
}

class LanguageLocalDataSourceImplementation implements LanguageLocalDataSource {
  final SharedPreferences sharedPreferences;
  LanguageLocalDataSourceImplementation({required this.sharedPreferences});
  @override
  Future<bool> changeLanguage({required String languageCode}) async =>
      await sharedPreferences.setString(AppStrings.locale, languageCode);

  @override
  Future<String> getSavedLanguage() async =>
      sharedPreferences.containsKey(AppStrings.locale)
          ? sharedPreferences.getString(AppStrings.locale)!
          : AppStrings.englishCode;
}
