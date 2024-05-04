import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kstore/features/ads/ads_injection_container.dart';
import 'package:kstore/features/notifications/notifications_injection_container.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/api_consumer.dart';
import 'core/api/app_interceptors.dart';
import 'core/api/dio_consumer.dart';
import 'core/network/netwok_info.dart';
import 'features/auth/auth_injection_container.dart';
import 'features/cart/cart_injection_feature.dart';
import 'features/cetegories/categories_injections_container.dart';
import 'features/favorites/products_injection_feature.dart';
import 'features/home/home_injection_container.dart';
import 'features/location/location_injection_container.dart';
import 'features/orders/orders_injection_feature.dart';
import 'features/payments/payments_injection_container.dart';
import 'features/products/products_injection_feature.dart';
import 'features/profile/profile_injection_container.dart';
import 'features/settings/settings_injection_container.dart';
import 'features/splash/data/datasources/lang_local_datasource.dart';
import 'features/splash/data/repositories/lang.repository_impl.dart';
import 'features/splash/domain/repositories/lang_repository.dart';
import 'features/splash/domain/usecases/change_language_usecase.dart';
import 'features/splash/domain/usecases/get_saved_language.dart';
import 'features/splash/presentation/cubit/locale_cubit.dart';
import 'features/stories/stories_injection_feature.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  sl.registerFactory<LocaleCubit>(() =>
      LocaleCubit(getSavedLanguageUseCase: sl(), changeLanguageUseCase: sl()));

  //! Use cases

  sl.registerLazySingleton<GetSavedLanguageUseCase>(
      () => GetSavedLanguageUseCase(languageRepository: sl()));
  sl.registerLazySingleton<ChangeLanguageUseCase>(
      () => ChangeLanguageUseCase(languageRepository: sl()));

  //! Repository

  sl.registerLazySingleton<LanguageRepository>(
      () => LanguageRepositoryImplementation(languageLocalDataSource: sl()));

  //! Data Sources

  sl.registerLazySingleton<LanguageLocalDataSource>(
      () => LanguageLocalDataSourceImplementation(sharedPreferences: sl()));
//!? =========[features]===========

  settingInjectionFeature();
  authInjectionFeature();
  locationInjectionFeature();
  homeInjectionFeature();
  paymentsInjectionFeature();
  profileInjectionFeature();
  cartInjectionFeature();
  productsInjectionFeature();
  categoriesInjectionFeature();
  favoritesInjectionFeature();
  orderInjectionFeature();
  storiesInjectionFeature();
  notificationsInjectionFeature();
  adsInjectionFeature();
  //! Core
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(
      () => AppIntercepters(languageLocalDataSource: sl()));
  sl.registerLazySingleton(() => LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true));
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Dio());
}
