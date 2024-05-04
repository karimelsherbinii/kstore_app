import 'package:get_it/get_it.dart';
import 'package:kstore/features/ads/data/datasources/ads_remote_datasource.dart';
import 'package:kstore/features/ads/data/repositories/ads_repository_impl.dart';
import 'package:kstore/features/ads/domain/repositories/ads_repository.dart';
import 'package:kstore/features/ads/domain/usecases/get_ads.dart';
import 'package:kstore/features/ads/presentation/cubit/ads_cubit.dart';
import 'package:kstore/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:kstore/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kstore/features/auth/domain/usecases/get_saved_login_credentials.dart';
import 'package:kstore/features/auth/domain/usecases/logout_locally.dart';
import 'package:kstore/features/auth/domain/usecases/save_login_credentials.dart';
import 'package:kstore/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kstore/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:kstore/features/auth/presentation/cubit/register/register_cubit.dart';



final sl = GetIt.instance;

Future<void> adsInjectionFeature() async {
  //! Blocs
  sl.registerFactory(() => AdsCubit(
        getAdsUseCase: sl(),
      ));
  //! Use cases
  sl.registerLazySingleton(() => GetAds(sl()));

  //! Repository
  sl.registerLazySingleton<AdsRepository>(
      () => AdsRepositoryImpl(adsRemoteDataSource: sl()));
      
  //! Data Sources
  sl.registerLazySingleton<AdsRemoteDataSource>(() => AdsRemoteDataSourceImpl(
        apiConsumer: sl(),
      ));
}
