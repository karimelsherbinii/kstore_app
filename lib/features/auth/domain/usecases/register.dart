import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class Register extends UseCase<BaseResponse, RegisterParams> {
  final AuthRepository repository;

  Register(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(RegisterParams params) async {
    return await repository.register(
        userName: params.userName,
        email: params.email,
        password: params.password,
        confirmPassword: params.confirmPassword);
  }
}

class RegisterParams extends Equatable {
  final String userName;
  final String email;
  final String password;
  final String confirmPassword;

  const RegisterParams({
    required this.userName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [userName, email, password, confirmPassword];
}
