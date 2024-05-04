import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/core/usecases/usecase.dart';
import 'package:kstore/features/profile/domain/repositories/user_repository.dart';

class DeleteUseAddress extends UseCase<BaseResponse, DeleteUseAddressParams> {
  final UserRepository repository;

  DeleteUseAddress(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(
      DeleteUseAddressParams params) async {
    return await repository.deleteAddress(id: params.id);
  }
}

class DeleteUseAddressParams extends Equatable {
  final int id;

  const DeleteUseAddressParams({
    required this.id,
  });

  @override
  List<Object?> get props => [
        id,
      ];
}
