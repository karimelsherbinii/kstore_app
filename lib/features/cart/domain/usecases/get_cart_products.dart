import 'package:dartz/dartz.dart';
import 'package:kstore/core/api/responses/base_response.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class GetCartProducts extends UseCase<BaseResponse, NoParams> {
  final CartRepository repository;

  GetCartProducts(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(NoParams params) async {
    return await repository.getCart();
  }
}