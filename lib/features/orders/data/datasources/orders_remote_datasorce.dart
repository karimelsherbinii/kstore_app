import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:kstore/core/api/end_points.dart';
import 'package:kstore/core/utils/app_strings.dart';
import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/responses/base_response.dart';
import '../models/order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<BaseResponse> getOrders({
    int? pageNo,
    int? perPage,
    int? status,
    String? sortBy,
    String? sortOrder,
  });
  Future<OrderModel> getOrderById(int id);
  Future<BaseResponse> addOrder({
    required int paymentProviderId,
    String? promoCode,
    required int branchId,
    required int delivery,
    required int addressId,
    String? phone,
  });
  Future<BaseResponse> reorder({
    required int orderId,
  });
  Future<BaseResponse> cancelOrder({
    required int orderId,
  });

  //get promocodes
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final ApiConsumer apiConsumer;
  OrdersRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<OrderModel> getOrderById(int id) async {
    final response = await apiConsumer.get('${EndPoints.orders}/$id');
    OrderModel orderModel =
        OrderModel.fromJson(jsonDecode(response.toString()));
    return orderModel;
  }

  @override
  Future<BaseResponse> getOrders({
    int? pageNo,
    int? perPage,
    int? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    final response = await apiConsumer.get(EndPoints.orders, queryParameters: {
      AppStrings.pageNumber: pageNo,
      AppStrings.perPage: perPage,
      if (status != null) "status": status,
      if (sortBy != null) AppStrings.sortBy: sortBy,
      if (sortOrder != null) 'order': sortOrder,
    });
    BaseResponse baseResponse = BaseResponse();
    // var jsonResponse = jsonDecode(response.data.toString());
    Iterable iterable = response.data['data'];
    baseResponse.lastPage = response.data['meta']['last_page'];
    baseResponse.currentPage = response.data['meta']['current_page'];
    baseResponse.total = response.data['meta']['total'];
    baseResponse.data =
        iterable.map((model) => OrderModel.fromJson(model)).toList();
    log(baseResponse.data.toString(), name: 'orders response');

    return baseResponse;
  }

  @override
  Future<BaseResponse> addOrder({
    required int paymentProviderId,
    String? promoCode,
    int branchId = 1,
    required int delivery,
    required int addressId,
    String? phone,
  }) async {
    Response response = await apiConsumer.post(EndPoints.orders, body: {
      "payment_provider_id": paymentProviderId,
      "branch_id": branchId,
      "delivery": 0,
      "address_id": addressId,
      if (promoCode != null) "promo_code": promoCode,
      if (phone != null) "phone": phone,
    });
    log(response.statusCode.toString(), name: 'addOrder status code');
    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    var jsonResponse = response.data;
    baseResponse.message = jsonResponse['message'];
    if (response.statusCode == 201) {
      baseResponse.data = OrderModel.fromJson(jsonResponse['order']);
    }
    return baseResponse;
  }

  @override
  Future<BaseResponse> reorder({required int orderId}) async {
    Response response =
        await apiConsumer.post('${EndPoints.orders}/$orderId/reorder');
    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    var jsonResponse = response.data;
    baseResponse.message = jsonResponse['message'];
    return baseResponse;
  }

  @override
  Future<BaseResponse> cancelOrder({required int orderId}) async {
    Response response =
        await apiConsumer.delete('${EndPoints.orders}/$orderId');
    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    var jsonResponse = response.data;
    baseResponse.message = jsonResponse['message'];
    return baseResponse;
  }
}
