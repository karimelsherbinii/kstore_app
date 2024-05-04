import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/core/usecases/usecase.dart';
import 'package:kstore/features/profile/domain/repositories/user_repository.dart';

class UpdateUserInfo extends UseCase<BaseResponse, UpdateUserInfoParams> {
  final UserRepository repository;

  UpdateUserInfo(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(
      UpdateUserInfoParams params) async {
    return await repository.updateUser(
        firstName: params.firstName,
        lastName: params.lastName,
        userName: params.userName,
        email: params.email,
        password: params.password,
        confirmPassword: params.confirmPassword,
        birthDate: params.birthDate,
        phone: params.phone,
        profileImage: params.profileImage,
        gender: params.gender);
  }
}

class UpdateUserInfoParams extends Equatable {
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String password;
  final String confirmPassword;
  final String birthDate;
  final String phone;
  final File? profileImage;
  final String gender;

  const UpdateUserInfoParams({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.birthDate,
    required this.phone,
    this.profileImage,
    required this.gender,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        userName,
        email,
        password,
        confirmPassword,
        birthDate,
        phone,
        profileImage,
        gender,
      ];
}
