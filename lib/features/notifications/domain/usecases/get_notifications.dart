import 'package:dartz/dartz.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/core/usecases/usecase.dart';
import 'package:kstore/features/notifications/domain/repositories/notifications_repository.dart';

class GetNotifications extends UseCase<BaseResponse, NoParams> {
  final NotificationsRepository repository;

  GetNotifications(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(NoParams params) async {
    return await repository.getNotifications();
  }
}