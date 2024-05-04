import 'package:dartz/dartz.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/exceptions.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:kstore/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource notificationsRemoteDataSource;

  NotificationsRepositoryImpl({required this.notificationsRemoteDataSource});
  @override
  Future<Either<Failure, BaseResponse>> getNotifications() async{
    try {
      final response = await notificationsRemoteDataSource.getNotifications();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> markNotificationAsRead(
      {required String id})async {
    try {
      final response = await notificationsRemoteDataSource.markNotificationAsRead(id: id);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
