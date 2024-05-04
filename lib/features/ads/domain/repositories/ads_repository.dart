import 'package:dartz/dartz.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';

abstract class AdsRepository {
  Future<Either<Failure, BaseResponse>> getAds({bool now});
}