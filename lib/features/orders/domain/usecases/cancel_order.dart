import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/core/usecases/usecase.dart';
import 'package:kstore/features/orders/domain/repositories/orders_repository.dart';

class CancelOrder extends UseCase<BaseResponse, CancelOrderParams> {
  final OrdersRepository repository;

  CancelOrder(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(CancelOrderParams params) async {
    return await repository.cancelOrder(orderId: params.orderId);
  }
}

class CancelOrderParams extends Equatable {
  final int orderId;

  const CancelOrderParams({
    required this.orderId,
  });

  @override
  List<Object> get props => [
        orderId,
      ];
}
