import 'package:kstore/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:kstore/features/products/presentation/cubit/category_products/category_products_cubit.dart';
import 'package:kstore/features/products/presentation/cubit/products_cubit.dart';

import '../../injection_container.dart';
import 'data/datasources/favorites_remote_datasource.dart';
import 'data/repositories/favorites_repository_impl.dart';
import 'domain/repositories/favorites_repository.dart';
import 'domain/usecases/add_to_favorite.dart';
import 'domain/usecases/delete_favorite.dart';
import 'domain/usecases/get_favorites.dart';

Future<void> favoritesInjectionFeature() async {
  //! Blocs
  sl.registerFactory<FavoriteCubit>(() => FavoriteCubit(
        repository: sl(),
        addFavoriteUseCase: sl(),
        getFavoritesUseCase: sl(),
        deleteFavoriteUseCase: sl(),
      ));

  //! Use cases
  sl.registerLazySingleton(() => AddFavorite(sl()));
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => DeleteFavorite(sl()));

  //! Repository
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(remoteDataSource: sl()),
  );

  //! Data Sources
  sl.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
