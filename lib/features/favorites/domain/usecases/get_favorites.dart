import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites extends UseCase<BaseResponse, GetFavoritesPrams> {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(GetFavoritesPrams params) async {
    return await repository.getFavorites(type: params.type);
  }
}

class GetFavoritesPrams extends Equatable {
  final String type;
  const GetFavoritesPrams({required this.type});
  @override
  List<Object?> get props => [type];
}
