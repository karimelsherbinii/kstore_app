import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/favorites_repository.dart';

class DeleteFavorite extends UseCase<BaseResponse, DeleteFavoriteParams> {
  final FavoritesRepository repository;

  DeleteFavorite(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(
      DeleteFavoriteParams params) async {
    return await repository.removeFavorite(
      productId: params.productId,
      type: params.type,
    );
  }
}

class DeleteFavoriteParams extends Equatable {
  final int productId;
  final String type;

  const DeleteFavoriteParams({
    required this.productId,
    required this.type,
  });

  @override
  List<Object?> get props => [productId, type];
}
