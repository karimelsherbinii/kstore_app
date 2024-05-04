import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/usecases/usecase.dart';

import '../../../../core/error/failures.dart';
import '../repositories/products_repository.dart';

class GetProduct extends UseCase<BaseResponse, GetProductParams> {
  final ProductsRepository repository;

  GetProduct({
    required this.repository,
  });

  @override
  Future<Either<Failure, BaseResponse>> call(GetProductParams params) async {
    return await repository.getProductById(productId: params.productId);
  }
}

class GetProductParams extends Equatable {
  final int productId;

  const GetProductParams({required this.productId});

  @override
  List<Object> get props => [productId];
}
