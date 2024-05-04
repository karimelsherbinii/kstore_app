import 'dart:developer';

import 'package:kstore/core/api/api_consumer.dart';
import 'package:kstore/core/api/end_points.dart';
import 'package:kstore/core/api/responses/base_response.dart';

import '../../../orders/data/models/order_products_model.dart';

abstract class CartRemoteDataSource {
  Future<BaseResponse> getCart();
  Future<BaseResponse> attachProductCart({
    required int productId,
    required int quantity,
    required String type,
  });
  // Future<BaseResponse> updateProductQuantity(String productId, int quantity);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiConsumer apiConsumer;
  CartRemoteDataSourceImpl({required this.apiConsumer});
  @override
  Future<BaseResponse> attachProductCart(
      {required int productId,
      required int quantity,
      required String type}) async {
    final response = await apiConsumer.post(
      EndPoints.cart,
      body: {
        'product_id': productId,
        'quantity': quantity,
        'type': type,
      },
    );
    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    // var jsonResponse = response.data;
    // baseResponse.message = jsonResponse['message'];
    return baseResponse;
  }

  @override
  Future<BaseResponse> getCart() async {
    final response = await apiConsumer.get(EndPoints.cart);
    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    var data = response.data;
    Iterable iterable = data;
    baseResponse.data =
        iterable.map((model) => OrderProductsModel.fromJson(model)).toList();
    List<OrderProductsModel> orderProducts = baseResponse.data;
    log(orderProducts.length.toString(), name: 'order products length');
    return baseResponse;
  }
}
