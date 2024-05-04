import 'package:get_it/get_it.dart';
import 'package:kstore/features/profile/data/datasources/user_remote_datasource.dart';
import 'package:kstore/features/profile/data/repositories/user_repository_impl.dart';
import 'package:kstore/features/profile/domain/repositories/user_repository.dart';
import 'package:kstore/features/profile/domain/usecases/add_user_address.dart';
import 'package:kstore/features/profile/domain/usecases/delete_user_address.dart';
import 'package:kstore/features/profile/domain/usecases/get_user_address.dart';
import 'package:kstore/features/profile/domain/usecases/get_user_info.dart';
import 'package:kstore/features/profile/domain/usecases/updata_user_address.dart';
import 'package:kstore/features/profile/domain/usecases/update_user_info.dart';
import 'package:kstore/features/profile/presentation/cubit/profile_cubit.dart';

final sl = GetIt.instance;

Future<void> profileInjectionFeature() async {
  //! Blocs
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(
        getUserAddressUseCase: sl(),
        getUserInfoUseCase: sl(),
        updateUserInfoUseCase: sl(),
        updateUseAddressUseCase: sl(),
        addUseAddressUseCase: sl(),
        deleteUseAddressUseCase: sl(),
      ));
  //! Use cases
  sl.registerLazySingleton(() => GetUserAddress(sl()));
  sl.registerLazySingleton(() => UpdateUseAddress(sl()));
  sl.registerLazySingleton(() => AddUseAddress(sl()));
  sl.registerLazySingleton(() => DeleteUseAddress(sl()));
  sl.registerLazySingleton(() => GetUserInfo(sl()));
  sl.registerLazySingleton(() => UpdateUserInfo(sl()));

  //! Repository
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(userRemoteDataSource: sl()));

  //! Data Sources
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(apiConsumer: sl()));
}
