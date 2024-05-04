import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/products_repository.dart';

class GetProducts extends UseCase<BaseResponse, ProductParams> {
  final ProductsRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(ProductParams params) async =>
      await repository.getProducts(
        pageNo: params.pageNo,
        searchQuery: params.searchQuery,
        perPage: params.perPage,
        categoryId: params.categoryId,
        sortBy: params.sortBy,
        sortOrder: params.sortOrder,
      );
}

class ProductParams extends Equatable {
  final int pageNo;
  final String? searchQuery;
  final String? perPage;
  final String? categoryId;
  final String? sortBy;
  final String? sortOrder;

  const ProductParams({
    required this.pageNo,
    this.searchQuery,
    this.perPage,
    this.categoryId,
    this.sortBy,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [
        pageNo,
        searchQuery,
        perPage,
        categoryId,
        sortBy,
        sortOrder,
  ];
}
