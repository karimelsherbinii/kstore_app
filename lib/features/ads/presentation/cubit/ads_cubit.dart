import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kstore/features/ads/domain/entities/ad.dart';
import 'package:kstore/features/ads/domain/usecases/get_ads.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  final GetAds getAdsUseCase;
  AdsCubit({
    required this.getAdsUseCase,
  }) : super(AdsInitial());

  List<Ad> ads = [];

  Future<void> getAds({required bool now}) async {
    emit(GetAdsLoadingState());
    final response = await getAdsUseCase(GetAdsParams(now: now));
    response.fold(
      (failure) {
        emit(GetAdsErrorState(message: failure.message!));
      },
      (success) {
        ads = success.data;
        emit(GetAdsLoadedState(ads: ads));
      },
    );
  }

  getAdsImages() {
    List<String> adsImages = [];
    ads.forEach((element) {
      adsImages.add(element.image!);
    });
    return adsImages;
  }
}
