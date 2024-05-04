import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/core/usecases/usecase.dart';
import 'package:kstore/features/profile/domain/repositories/user_repository.dart';

class UpdateUseAddress extends UseCase<BaseResponse, UpdateUseAddressParams> {
  final UserRepository repository;

  UpdateUseAddress(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(
      UpdateUseAddressParams params) async {
    return await repository.updateAddress(
      street: params.street,
      city: params.city,
      state: params.state,
      zip: params.zip,
      country: params.country,
    );
  }
}

class UpdateUseAddressParams extends Equatable {
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;

  const UpdateUseAddressParams({
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });

  @override
  List<Object?> get props => [
        street,
        city,
        state,
        zip,
        country,
      ];
}
