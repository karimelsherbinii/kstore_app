import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kstore/core/api/api_consumer.dart';
import 'package:kstore/core/api/end_points.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/features/profile/data/models/address_model.dart';
import 'package:kstore/features/profile/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<BaseResponse> getUser();
  Future<BaseResponse> updateUser({
    required String firstName,
    required String lastName,
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
    required String birthDate,
    required String phone,
    required String gender,
    File? profileImage,
  });
  Future<BaseResponse> getAddress();
  Future<BaseResponse> updateAddress({
    required String street,
    required String city,
    required String state,
    required String zip,
    required String country,
  });

  Future<BaseResponse> addAddress({
    required String street,
    required String city,
    required String state,
    required String zip,
    required String country,
  });

  Future<BaseResponse> deleteAddress({required int id});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiConsumer apiConsumer;
  UserRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> addAddress(
      {required String street,
      required String city,
      required String state,
      required String zip,
      required String country}) async {
    final response = await apiConsumer.post(EndPoints.address, body: {
      "street": street,
      "city": city,
      "state": state,
      "zip": zip,
      "country": country,
    });

    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    var jsonResponse = response.data;

    if (response.statusCode == 201) {
      baseResponse.data = AddressModel.fromJson(jsonResponse);
    } else {
      baseResponse.message = jsonResponse['message'];
    }

    return baseResponse;
  }

  @override
  Future<BaseResponse> deleteAddress({required int id}) async {
    final response = await apiConsumer.delete("${EndPoints.address}/$id");

    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    var jsonResponse = Constants.decodeJson(response);

    if (response.statusCode == 200) {
      baseResponse.data = jsonResponse;
    } else {
      baseResponse.message = jsonResponse['message'];
    }

    return baseResponse;
  }

  @override
  Future<BaseResponse> getAddress() async {
    final response = await apiConsumer.get(EndPoints.address);

    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    var jsonResponse = response.data;
    Iterable iterable = jsonResponse;

    if (response.statusCode == 200) {
      baseResponse.data =
          iterable.map((e) => AddressModel.fromJson(e)).toList();
    } else {
      baseResponse.message = jsonResponse['message'];
    }

    return baseResponse;
  }

  @override
  Future<BaseResponse> getUser() async {
    final response = await apiConsumer.get(EndPoints.user);

    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    var jsonResponse = response.data;
    if (response.statusCode == 200) {
      baseResponse.data = UserModel.fromJson(jsonResponse);
      print("${baseResponse.data}user info:");
    } else {
      baseResponse.message = jsonResponse['message'];
    }

    return baseResponse;
  }

  @override
  Future<BaseResponse> updateAddress(
      {required String street,
      required String city,
      required String state,
      required String zip,
      required String country}) async {
    final response = await apiConsumer.patch(EndPoints.address, body: {
      "street": street,
      "city": city,
      "state": state,
      "zip": zip,
      "country": country,
    });

    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    var jsonResponse = Constants.decodeJson(response);

    if (response.statusCode == 200) {
      baseResponse.data = jsonResponse;
    } else {
      baseResponse.message = jsonResponse['message'];
    }

    return baseResponse;
  }

  @override
  Future<BaseResponse> updateUser(
      {required String firstName,
      required String lastName,
      required String userName,
      required String email,
      required String password,
      required String confirmPassword,
      required String birthDate,
      required String phone,
      required String gender,
      File? profileImage}) async {
    log('username: $userName');

    final response = await apiConsumer.patch("${EndPoints.user}/update",
        // formDataIsEnabled: true,
        body: {
          'method': 'PATCH',
          'first_name': firstName,
          'last_name': lastName,
          'username': userName,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
          'birth_date': birthDate,
          'phone': phone,
          'gender': gender,
          if (profileImage != null)
            'avatar': await MultipartFile.fromFile(profileImage.path),
        });

    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    var jsonResponse = response.data;

    if (response.statusCode == 200) {
      baseResponse.data = UserModel.fromJson(jsonResponse);
    } else {
      baseResponse.message = jsonResponse['message'];
    }

    return baseResponse;
  }
}
