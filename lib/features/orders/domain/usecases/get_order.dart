import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/order_model.dart';
import '../repositories/orders_repository.dart';

class GetOrder extends UseCase<OrderModel, GetOrderParams> {
  final OrdersRepository repository;

  GetOrder({
    required this.repository,
  });

  @override
  Future<Either<Failure, OrderModel>> call(GetOrderParams params) async {
    return await repository.getOrderById(params.id);
  }
}

class GetOrderParams extends Equatable {
  final int id;

  const GetOrderParams({required this.id});

  @override
  List<Object> get props => [id];
}
