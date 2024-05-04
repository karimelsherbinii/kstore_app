import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/core/usecases/usecase.dart';
import 'package:kstore/features/profile/domain/repositories/user_repository.dart';

class AddUseAddress extends UseCase<BaseResponse, AddUseAddressParams> {
  final UserRepository repository;

  AddUseAddress(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(
      AddUseAddressParams params) async {
    return await repository.addAddress(
      street: params.street,
      city: params.city,
      state: params.state,
      zip: params.zip,
      country: params.country,
    );
  }
}

class AddUseAddressParams extends Equatable {
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;

  const AddUseAddressParams({
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
