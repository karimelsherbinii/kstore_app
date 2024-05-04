import 'dart:convert';

import 'package:kstore/core/api/api_consumer.dart';
import 'package:kstore/core/api/end_points.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/features/notifications/data/models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<BaseResponse> getNotifications();

  Future<BaseResponse> markNotificationAsRead({
    required String id,
  });
}

class NotificationsRemoteDataSourceImpl extends NotificationsRemoteDataSource {
  final ApiConsumer apiConsumer;

  NotificationsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<BaseResponse> getNotifications() async {
    final response = await apiConsumer.get(EndPoints.notifications);
    BaseResponse baseResponse = BaseResponse();
    var jsonResponse = response.data;
    Iterable iterable = jsonResponse['data'];
    baseResponse.data =
        iterable.map((model) => NotificationModel.fromJson(model)).toList();
    baseResponse.message = jsonResponse['message'];
    return baseResponse;
  }

  @override
  Future<BaseResponse> markNotificationAsRead({
    required String id,
  }) async {
    final response =
        await apiConsumer.get('${EndPoints.notifications}/$id/read');
    BaseResponse baseResponse = BaseResponse();
    // var jsonResponse = jsonDecode(response.toString());
    // baseResponse.message = int.parse(source) ;
    return baseResponse;
  }
}
