import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class AttachProductCart extends UseCase<BaseResponse, AttachProductCartParams> {
  final CartRepository repository;

  AttachProductCart(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(
      AttachProductCartParams params) async {
    return await repository.attachProductCart(
        productId: params.productId, quantity: params.quantity, type: params.type);
  }
}

class AttachProductCartParams extends Equatable {
  final int productId;
  final int quantity;
  final String type;

  const AttachProductCartParams(
      {required this.productId, required this.quantity, required this.type});

  @override
  List<Object?> get props => [];
}
