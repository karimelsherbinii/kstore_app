import 'package:dartz/dartz.dart';

import '../../../../core/api/responses/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, BaseResponse>> getFavorites({
    required String type,
  });
  Future<Either<Failure, BaseResponse>> addToFavourite(
      {required int productId, required String type});
  Future<Either<Failure, BaseResponse>> removeFavorite(
      {required int productId, required String type});
}
