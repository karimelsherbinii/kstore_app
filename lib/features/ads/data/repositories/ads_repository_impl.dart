import 'package:dartz/dartz.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/exceptions.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/features/ads/data/datasources/ads_remote_datasource.dart';
import 'package:kstore/features/ads/domain/repositories/ads_repository.dart';

class AdsRepositoryImpl implements AdsRepository {
  final AdsRemoteDataSource adsRemoteDataSource;
    
  AdsRepositoryImpl({
    required this.adsRemoteDataSource,
  });

  @override
  Future<Either<Failure, BaseResponse>> getAds({bool now = false}) async{
   try {
      final response = await adsRemoteDataSource.getAds(now: now);
      return Right(response);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  



  
}
