import 'package:dartz/dartz.dart';

import '../../../../core/api/responses/base_response.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, BaseResponse>> getProducts({
    required int pageNo,
    String? searchQuery,
    String? perPage,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final response = await remoteDataSource.getProducts(
        pageNo:  pageNo,
        searchQuery: searchQuery,
        perPage: perPage,
        categoryId: categoryId,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> getProductsByCategory(
      {required int categoryId,
      required int pageNo,
      String? searchQuery}) async {
    try {
      final response = await remoteDataSource.getProductsByCategory(
          categoryId: categoryId, pageNo: pageNo, searchQuery: searchQuery);
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> getProductById(
      {required int productId}) async {
    try {
      final response =
          await remoteDataSource.getProductById(productId: productId);
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }
}
