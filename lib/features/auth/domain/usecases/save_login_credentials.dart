import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/features/profile/data/models/user_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SaveLoginCredentials extends UseCase<bool, SaveLoginCredentialsParams> {
  final AuthRepository repository;

  SaveLoginCredentials(this.repository);

  @override
  Future<Either<Failure, bool>> call(SaveLoginCredentialsParams params) async {
    return await repository.saveCredentials(userModel: params.user);
  }
}

class SaveLoginCredentialsParams extends Equatable {
  final UserModel user;

  const SaveLoginCredentialsParams({required this.user});

  @override
  List<Object?> get props => [user];
}
