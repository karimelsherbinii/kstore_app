import 'package:dio/dio.dart';
import 'package:kstore/core/api/api_consumer.dart';
import 'package:kstore/core/api/end_points.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/features/ads/data/models/ad_model.dart';

abstract class AdsRemoteDataSource {
  Future<BaseResponse> getAds({
    bool now,
  });
}

class AdsRemoteDataSourceImpl implements AdsRemoteDataSource {
  final ApiConsumer apiConsumer;

  AdsRemoteDataSourceImpl({
    required this.apiConsumer,
  });

  @override
  Future<BaseResponse> getAds({bool now = false}) async {
    Response response = await apiConsumer.get(EndPoints.ads, queryParameters: {
      'now': now,
    });
    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    Iterable iterable = response.data['data'];
    baseResponse.data = iterable.map((model) => AdModel.fromJson(model)).toList();
    return baseResponse;
  }
}
