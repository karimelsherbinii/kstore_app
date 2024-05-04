import 'package:dartz/dartz.dart';
import 'package:kstore/features/profile/data/models/user_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class GetLoginCredentials implements UseCase<UserModel?, NoParams> {
  final AuthRepository repository;

  GetLoginCredentials(this.repository);

  @override
  Future<Either<Failure, UserModel?>> call(NoParams params) async {
    return await repository.getCredentials();
  }
}