import 'package:dartz/dartz.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/exceptions.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:kstore/features/cart/domain/repositories/cart_repository.dart';

class CartRepsitoryImpl implements CartRepository {
  final CartRemoteDataSource cartRemoteDataSource;
  CartRepsitoryImpl({required this.cartRemoteDataSource});
  @override
  Future<Either<Failure, BaseResponse>> attachProductCart(
      {required int productId, required int quantity, required String type}) async{
     try{
        final response = await cartRemoteDataSource.attachProductCart(productId: productId, quantity: quantity, type: type);
        return Right(response);
     } on ServerException catch (e){
       return Left(ServerFailure(message: e.message));
     }
  }

  @override
  Future<Either<Failure, BaseResponse>> getCart() async{
    try{
      final response = await cartRemoteDataSource.getCart();
      return Right(response);
    } on ServerException catch (e){
      return Left(ServerFailure(message: e.message));
    }
  }
}
