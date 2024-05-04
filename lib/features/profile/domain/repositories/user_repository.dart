import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';

abstract class UserRepository{
  Future<Either<Failure, BaseResponse>> getUser();
  Future<Either<Failure, BaseResponse>> updateUser({
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
  Future<Either<Failure, BaseResponse>> getAddress();
  Future<Either<Failure, BaseResponse>> updateAddress({
    required String street,
    required String city,
    required String state,
    required String zip,
    required String country,
  });

  Future<Either<Failure, BaseResponse>> addAddress({
    required String street,
    required String city,
    required String state,
    required String zip,
    required String country,
  });

  Future<Either<Failure, BaseResponse>> deleteAddress({required int id});
}