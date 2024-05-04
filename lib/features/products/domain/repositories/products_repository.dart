import 'package:dartz/dartz.dart';

import '../../../../core/api/responses/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class ProductsRepository {
  Future<Either<Failure, BaseResponse>> getProducts({
    required int pageNo,
    String? searchQuery,
    String? perPage,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
  });
  Future<Either<Failure, BaseResponse>> getProductsByCategory({
    required int categoryId,
    required int pageNo,
    String? searchQuery,
  });
  Future<Either<Failure, BaseResponse>> getProductById({
    required int productId,
  });
}
