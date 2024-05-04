import 'dart:convert';
import 'dart:developer';

import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/features/orders/data/models/order_model.dart';
import 'package:kstore/features/products/data/models/product_model.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/api/responses/base_response.dart';
import '../../../../core/utils/app_strings.dart';

abstract class FavoritesRemoteDataSource {
  Future<BaseResponse> getFavorites({
    required String type,
  });

  Future<BaseResponse> addToFavourite(
      {required int productId, required String type});

  Future<BaseResponse> removeFavorite(
      {required int productId, required String type});
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final ApiConsumer apiConsumer;

  FavoritesRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<BaseResponse> addToFavourite(
      {required int productId, required String type}) async {
    final response = await apiConsumer.post(
      EndPoints.favorites,
      body: {
        AppStrings.productId: productId,
        AppStrings.type: type,
      },
    );
    BaseResponse baseResponse = BaseResponse();
    var jsonResponse = jsonDecode(response.toString());
    baseResponse.message = jsonResponse[AppStrings.message];
    return baseResponse;
  }

  @override
  Future<BaseResponse> getFavorites({
    required String type,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.favorites,
      queryParameters: {
        AppStrings.type: type,
      },
    );
    BaseResponse baseResponse = BaseResponse();
    var jsonResponse = json.encode(response.data);
    Iterable iterable = json.decode(jsonResponse);
    baseResponse.data = type == 'product'
        ? iterable.map((e) => ProductModel.fromJson(e)).toList()
        : iterable.map((e) => OrderModel.fromJson(e)).toList();
    return baseResponse;
  }

  @override
  Future<BaseResponse> removeFavorite(
      {required int productId, required String type}) async {
    final response = await apiConsumer.delete(
      '${EndPoints.favorites}/$productId',
      queryParameters: {
        AppStrings.type: type,
      },
    );
    BaseResponse baseResponse = BaseResponse();
    var jsonResponse = jsonDecode(response.toString());
    baseResponse.message = jsonResponse[AppStrings.message];
    return baseResponse;
  }
}
