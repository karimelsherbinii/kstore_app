import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/favorites_repository.dart';

class AddFavorite extends UseCase<BaseResponse, AddToFavoriteParams> {
  final FavoritesRepository repository;

  AddFavorite(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(AddToFavoriteParams params) async {
    return await repository.addToFavourite(
      productId: params.productId,
      type: params.type,
    );
  }
}

class AddToFavoriteParams extends Equatable {
  final int productId;
  final String type;

  const AddToFavoriteParams({
    required this.productId,
    required this.type,
  });

  @override
  List<Object?> get props => [productId, type];
}
