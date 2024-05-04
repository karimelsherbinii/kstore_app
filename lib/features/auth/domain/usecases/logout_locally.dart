import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutLocally extends UseCase<bool, NoParams> {
  final AuthRepository repository;

  LogoutLocally(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.logoutLocally();
  }
}