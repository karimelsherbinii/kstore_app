import 'package:dartz/dartz.dart';
import 'package:kstore/core/error/failures.dart';

import '../../../../core/api/responses/base_response.dart';
import '../../data/models/order_model.dart';

abstract class OrdersRepository {
  Future<Either<Failure, BaseResponse>> getOrders({
    int? pageNo,
    int? perPage,
    int? status,
    String? sortBy,
    String? sortOrder,
  });
  Future<Either<Failure, OrderModel>> getOrderById(int id);
  Future<Either<Failure, BaseResponse>> addOrder({
    required int paymentProviderId,
    required int branchId,
    required int delivery,
    required int addressId,
    String? promoCode,
    String? phone,
  });

  Future<Either<Failure, BaseResponse>> reorder({
    required int orderId,
  });

  Future<Either<Failure, BaseResponse>> cancelOrder({
    required int orderId,
  });
}
