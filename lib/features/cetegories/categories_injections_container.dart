import 'package:kstore/features/cetegories/data/repositories/categories_repository_impl.dart';
import 'package:kstore/features/cetegories/domain/usecases/get_categories.dart';
import 'package:kstore/features/products/presentation/cubit/products_cubit.dart';

import '../../injection_container.dart';
import 'data/datasources/category_remote_datasource.dart';
import 'domain/repositories/categories_repository.dart';
import 'presentation/cubit/categories_cubit.dart';

Future<void> categoriesInjectionFeature() async {
  //! Blocs
  sl.registerFactory<CategoriesCubit>(
      () => CategoriesCubit(getCategoriesUseCase: sl()));
  //! Use cases

  sl.registerLazySingleton<GetCategories>(() => GetCategories(sl()));

  //! Repository
  sl.registerLazySingleton<CategoriesRepository>(
      () => CategoriresRepositoryImpl(remoteDataSource: sl()));
  //! Data Sources
  sl.registerLazySingleton<CategoriesRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(apiConsumer: sl()));
}
