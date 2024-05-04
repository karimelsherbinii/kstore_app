import 'package:dartz/dartz.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, BaseResponse>> getNotifications();
  Future<Either<Failure, BaseResponse>> markNotificationAsRead({
    required String id,
  });
}