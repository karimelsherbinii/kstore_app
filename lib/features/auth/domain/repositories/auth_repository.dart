import 'package:dartz/dartz.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/features/profile/data/models/user_model.dart';

import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, BaseResponse>> login(
      {String? email, String? userName, required String password});
  Future<Either<Failure, BaseResponse>> register(
      {required String userName,
      required String email,
      required String password,
      required String confirmPassword});
    Future<Either<Failure, bool>> saveCredentials({required UserModel userModel});
  Future<Either<Failure, UserModel?>> getCredentials();
  Future<Either<Failure, bool>> logoutLocally();
}
