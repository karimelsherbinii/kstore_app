import 'package:kstore/features/orders/data/models/order_model.dart';

import 'package:kstore/core/error/failures.dart';

import 'package:kstore/core/api/responses/base_response.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_datasorce.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, BaseResponse>> addOrder({
    required int paymentProviderId,
    required int branchId,
    required int delivery,
    required int addressId,
    String? promoCode,
    String? phone,
  }) async {
    try {
      final response = await remoteDataSource.addOrder(
        paymentProviderId: paymentProviderId,
        branchId: branchId,
        delivery: delivery,
        addressId: addressId,
        promoCode: promoCode,
        phone: phone,
      );
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> getOrderById(int id) async {
    try {
      final response = await remoteDataSource.getOrderById(id);
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> getOrders({
    int? pageNo,
    int? perPage,
    int? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final response = await remoteDataSource.getOrders(
        pageNo: pageNo,
        perPage: perPage,
        status: status,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }
  
  @override
  Future<Either<Failure, BaseResponse>> reorder({required int orderId}) async{
    try {
      final response = await remoteDataSource.reorder(orderId: orderId);
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }
  
  @override
  Future<Either<Failure, BaseResponse>> cancelOrder({required int orderId}) async{
    try {
      final response = await remoteDataSource.cancelOrder(orderId: orderId);
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }
}
