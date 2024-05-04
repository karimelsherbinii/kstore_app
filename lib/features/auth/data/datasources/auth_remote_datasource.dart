import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:kstore/core/api/api_consumer.dart';
import 'package:kstore/core/api/cach_helper.dart';
import 'package:kstore/core/api/end_points.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/utils/app_strings.dart';
import 'package:kstore/features/profile/data/models/user_model.dart';

import '../../../../core/api/status_code.dart';

abstract class AuthRemoteDataSource {
  Future<BaseResponse> login({
    String? email,
    String? userName,
    required String password,
  });
  Future<BaseResponse> register(
      {required String userUame,
      required String email,
      required String password,
      required String confirmPassword});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;
  AuthRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<BaseResponse> login(
      {String? email, String? userName, required String password}) async {
    Response response = await apiConsumer.post(EndPoints.login,
        body: userName != null
            ? {
                AppStrings.userName: userName,
                AppStrings.password: password,
              }
            : {
                AppStrings.email: email,
                AppStrings.password: password,
              });
    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    var jsonResponse = response.data;
    log(jsonResponse.toString(), name: 'jsonResponse for login before 200');
      log(jsonResponse.toString(), name: 'jsonResponse for login after 200');
      String accessToken = 'Bearer ${jsonResponse[AppStrings.token]}';
      UserModel userModel = UserModel.fromJson(jsonResponse);
      baseResponse.data = userModel;
      userModel.token = accessToken;
      userModel.email = email;
      log(userModel.toString(), name: 'userModel.email');
      baseResponse.message = jsonResponse['message'];
        return baseResponse;
  }

  @override
  Future<BaseResponse> register(
      {required String userUame,
      required String email,
      required String password,
      required String confirmPassword}) async {
    final response = await apiConsumer.post(EndPoints.register, body: {
      AppStrings.email: email,
      AppStrings.userName: userUame,
      AppStrings.password: password,
      AppStrings.confirmPassword: confirmPassword
    });
    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    var jsonResponse = jsonDecode(response.toString());
    log(jsonResponse.toString());
    baseResponse.token = jsonResponse['token'];
    baseResponse.message = jsonResponse['message'];
    return baseResponse;
  }
}
