import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/exceptions.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/features/profile/data/datasources/user_remote_datasource.dart';
import 'package:kstore/features/profile/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;
  UserRepositoryImpl({required this.userRemoteDataSource});
  @override
  Future<Either<Failure, BaseResponse>> addAddress(
      {required String street,
      required String city,
      required String state,
      required String zip,
      required String country}) async {
    try {
      final response = await userRemoteDataSource.addAddress(
        street: street,
        city: city,
        state: state,
        zip: zip,
        country: country,
      );
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> deleteAddress({required int id}) async {
    try {
      final response = await userRemoteDataSource.deleteAddress(id: id);
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> getAddress() async {
    try {
      final response = await userRemoteDataSource.getAddress();
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> getUser() async {
    try {
      final response = await userRemoteDataSource.getUser();
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> updateAddress(
      {required String street,
      required String city,
      required String state,
      required String zip,
      required String country}) async {
    try {
      final response = await userRemoteDataSource.updateAddress(
        street: street,
        city: city,
        state: state,
        zip: zip,
        country: country,
      );
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> updateUser(
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
    try {
      final reponse = await userRemoteDataSource.updateUser(
          firstName: firstName,
          lastName: lastName,
          userName: userName,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          birthDate: birthDate,
          phone: phone,
          gender: gender);
      return Right(reponse);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }
}
