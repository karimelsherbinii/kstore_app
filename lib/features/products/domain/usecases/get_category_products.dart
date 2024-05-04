import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/products_repository.dart';

class GetCategoryProducts
    extends UseCase<BaseResponse, GetCategoryProductsParams> {
  final ProductsRepository repository;

  GetCategoryProducts(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(
      GetCategoryProductsParams params) async {
    return await repository.getProductsByCategory(
      categoryId: params.categoryId,
      pageNo: params.pageNo,
      searchQuery: params.searchQuery,
    );
  }
}

class GetCategoryProductsParams extends Equatable {
  final int categoryId;
  final int pageNo;
  final String? searchQuery;

  const GetCategoryProductsParams({
    required this.categoryId,
    required this.pageNo,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [categoryId, pageNo, searchQuery];
}
