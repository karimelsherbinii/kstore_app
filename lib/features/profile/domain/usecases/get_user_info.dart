import 'package:dartz/dartz.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/core/usecases/usecase.dart';
import 'package:kstore/features/profile/domain/repositories/user_repository.dart';

class GetUserInfo extends UseCase<BaseResponse, NoParams> {
  final UserRepository repository;

  GetUserInfo(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(NoParams params) async {
    return await repository.getUser();
  }
}