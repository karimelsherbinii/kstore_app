import 'package:dartz/dartz.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/core/usecases/usecase.dart';
import 'package:kstore/features/profile/domain/repositories/user_repository.dart';

class GetUserAddress extends UseCase<BaseResponse, NoParams> {
  final UserRepository repository;

  GetUserAddress(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(NoParams params) async {
    return await repository.getAddress();
  }
}