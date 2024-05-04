import 'package:kstore/core/error/failures.dart';

import 'package:kstore/core/api/responses/base_response.dart';

import 'package:dartz/dartz.dart';

import '../../domain/repositories/categories_repository.dart';
import '../datasources/category_remote_datasource.dart';

class CategoriresRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource remoteDataSource;

  CategoriresRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, BaseResponse>> getCategories(
      {required int pageNo}) async {
    try {
      final response = await remoteDataSource.getCategories(pageNo: pageNo);
      return Right(response);
    } on ServerFailure catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
}
