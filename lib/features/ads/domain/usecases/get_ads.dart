import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/core/usecases/usecase.dart';
import 'package:kstore/features/ads/domain/entities/ad.dart';
import 'package:kstore/features/ads/domain/repositories/ads_repository.dart';

class GetAds extends UseCase<BaseResponse, GetAdsParams> {
  final AdsRepository repository;

  GetAds(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(GetAdsParams params) async {
    return await repository.getAds(
      now: params.now,
    );
  }
}

class GetAdsParams extends Equatable {
  final bool now;

  const GetAdsParams({required this.now});

  @override
  List<Object?> get props => [now];
}