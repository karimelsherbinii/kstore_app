import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/core/usecases/usecase.dart';
import 'package:kstore/features/notifications/domain/repositories/notifications_repository.dart';

class MarkNotificationsAsRead extends UseCase<BaseResponse, MarkNotificationsAsReadParams> {
  final NotificationsRepository repository;

  MarkNotificationsAsRead(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(MarkNotificationsAsReadParams params) async {
    return await repository.markNotificationAsRead(id: params.id);
  }
}

class MarkNotificationsAsReadParams extends Equatable {
  final String id;

  const MarkNotificationsAsReadParams({required this.id});

  @override
  List<Object?> get props => [id];
}