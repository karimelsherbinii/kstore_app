import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/orders_repository.dart';

class GetOrders extends UseCase<BaseResponse, GetOrdersParams> {
  final OrdersRepository repository;

  GetOrders({
    required this.repository,
  });

  @override
  Future<Either<Failure, BaseResponse>> call(GetOrdersParams params) async {
    return await repository.getOrders(
      pageNo: params.pageNo,
      perPage: params.perPage,
      status: params.status,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
    );
  }
}

class GetOrdersParams extends Equatable {
  final int? pageNo;
  final int? perPage;
  final int? status;
  final String? sortBy;
  final String? sortOrder;

  const GetOrdersParams({
    this.pageNo,
    this.perPage,
    this.status,
    this.sortBy,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [
        pageNo,
        perPage,
        status,
        sortBy,
        sortOrder,
      ];
}