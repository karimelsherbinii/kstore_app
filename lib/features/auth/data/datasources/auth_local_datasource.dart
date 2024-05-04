import 'dart:convert';

import 'package:kstore/core/api/cach_helper.dart';
import 'package:kstore/features/profile/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/app_strings.dart';

abstract class AuthLocalDataSource {
  Future<bool> saveLoginCredentials({required UserModel userModel});

  Future<UserModel?> getSavedLoginCredentials();

  Future<bool> logoutLocally();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getSavedLoginCredentials() async {
    if (sharedPreferences.containsKey(AppStrings.user)) {
      final userJson = sharedPreferences.getString(AppStrings.user);
      return UserModel.fromJson(json.decode(userJson!));
    }
    return null;
  }

  @override
  Future<bool> logoutLocally() async {
    if (sharedPreferences.containsKey(AppStrings.user)) {
      CacheHelper.removeData(key: AppStrings.token);
      return await sharedPreferences.remove(AppStrings.user);
    }
    return false;
  }

  @override
  Future<bool> saveLoginCredentials({required UserModel userModel}) async =>
      await sharedPreferences.setString(
          AppStrings.user, json.encode(userModel.toJson()));
}
