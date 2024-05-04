part of 'ads_cubit.dart';

abstract class AdsState extends Equatable {
  const AdsState();

  @override
  List<Object> get props => [];
}

class AdsInitial extends AdsState {}

class GetAdsLoadingState extends AdsState {}

class GetAdsLoadedState extends AdsState {
  final List<Ad> ads;

  const GetAdsLoadedState({
    required this.ads,
  });

  @override
  List<Object> get props => [
        ads,
      ];
}

class GetAdsErrorState extends AdsState {
  final String message;

  const GetAdsErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [
        message,
      ];
}


