import 'package:get_it/get_it.dart';
import 'package:kstore/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:kstore/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kstore/features/auth/domain/usecases/get_saved_login_credentials.dart';
import 'package:kstore/features/auth/domain/usecases/logout_locally.dart';
import 'package:kstore/features/auth/domain/usecases/save_login_credentials.dart';
import 'package:kstore/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kstore/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:kstore/features/auth/presentation/cubit/register/register_cubit.dart';

import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/login.dart';
import 'domain/usecases/register.dart';

final sl = GetIt.instance;

Future<void> authInjectionFeature() async {
  //! Blocs
  sl.registerFactory(() => LoginCubit(
        loginUseCase: sl(),
        saveLoginCredentialsUseCase: sl(),
        getLoginCredentials: sl(),
        logoutLocallyUseCase: sl(),
      ));
  sl.registerFactory(() => RegisterCubit(
        registerUseCase: sl(),
      ));
  sl.registerFactory(() => AuthCubit());
  //! Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton<SaveLoginCredentials>(
      () => SaveLoginCredentials(sl()));
  sl.registerLazySingleton<GetLoginCredentials>(
      () => GetLoginCredentials(sl()));
  sl.registerLazySingleton<LogoutLocally>(() => LogoutLocally(sl()));

  //! Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()));

  //! Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
        apiConsumer: sl(),
      ));
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sharedPreferences: sl()));
}
