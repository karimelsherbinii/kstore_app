import 'package:kstore/core/error/failures.dart';

import 'package:kstore/core/api/responses/base_response.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl({
    required this.remoteDataSource,
  });
  @override
  Future<Either<Failure, BaseResponse>> addToFavourite(
      {required int productId, required String type}) async {
    try {
      final response = await remoteDataSource.addToFavourite(
          productId: productId, type: type);
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> getFavorites({
    required String type,
  }) async {
    try {
      final response = await remoteDataSource.getFavorites(type: type);
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> removeFavorite(
      {required int productId, required String type}) async {
    try {
      final response = await remoteDataSource.removeFavorite(
          productId: productId, type: type);
      return Right(response);
    } on ServerException catch (exeption) {
      return Left(ServerFailure(message: exeption.message));
    }
  }
}
