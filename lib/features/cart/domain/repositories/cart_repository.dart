import 'package:dartz/dartz.dart';

import '../../../../core/api/responses/base_response.dart';
import '../../../../core/error/failures.dart';

abstract class CartRepository {
  Future<Either<Failure, BaseResponse>> getCart();
  Future<Either<Failure, BaseResponse>> attachProductCart({
    required int productId,
    required int quantity,
    required String type,
});
  // Future<BaseResponse> updateProductQuantity(String productId, int quantity);
}