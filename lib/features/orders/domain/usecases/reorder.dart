import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/core/usecases/usecase.dart';
import 'package:kstore/features/orders/domain/repositories/orders_repository.dart';

class ReOrder extends UseCase<BaseResponse, ReOrderParams> {
  final OrdersRepository repository;

  ReOrder(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(ReOrderParams params) async {
    return await repository.reorder(orderId: params.order);
  }
}

class ReOrderParams extends Equatable {
  final int order;

  const ReOrderParams({
    required this.order,
  });

  @override
  List<Object> get props => [
        order,
      ];
}
