import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class Login extends UseCase<BaseResponse, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(LoginParams params) async {
    return await repository.login(
        email: params.email,
        userName: params.userName,
        password: params.password);
  }
}

class LoginParams extends Equatable {
  final String? email;
  final String? userName;
  final String password;

  const LoginParams({
    this.email,
    this.userName,
    required this.password,
  });

  @override
  List<Object?> get props => [email, userName, password];
}
