import 'dart:developer';

import 'package:kstore/core/error/failures.dart';

import 'package:kstore/core/api/responses/base_response.dart';

import 'package:dartz/dartz.dart';
import 'package:kstore/core/utils/app_strings.dart';
import 'package:kstore/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kstore/features/profile/data/models/user_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, BaseResponse>> login(
      {String? email, String? userName, required String password}) async {
    try {
      final response = await remoteDataSource.login(
          email: email, userName: userName, password: password);
      return Right(response);
    } on ServerException catch (exception) {
      log(exception.message.toString(), name: 'message error');
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> register(
      {required String userName,
      required String email,
      required String password,
      required String confirmPassword}) async {
    try {
      final response = await remoteDataSource.register(
          userUame: userName,
          email: email,
          password: password,
          confirmPassword: password);
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
  @override
  Future<Either<Failure, UserModel?>> getCredentials() async {
    try {
      final response = await localDataSource.getSavedLoginCredentials();
      return Right(response);
    } on CacheException catch (exeption) {
      return const Left(CacheFailure(message: AppStrings.cacheFailure));
    }
  }

  @override
  Future<Either<Failure, bool>> logoutLocally() async {
    try {
      final response = await localDataSource.logoutLocally();
      return Right(response);
    } on CacheException catch (exeption) {
      return const Left(CacheFailure(message: AppStrings.cacheFailure));
    }
  }

  @override
  Future<Either<Failure, bool>> saveCredentials(
      {required UserModel userModel}) async {
    try {
      final response =
          await localDataSource.saveLoginCredentials(userModel: userModel);
      return Right(response);
    } on CacheException catch (exeption) {
      return const Left(CacheFailure(message: AppStrings.cacheFailure));
    }
  }
}
