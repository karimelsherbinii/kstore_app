import 'package:kstore/features/products/presentation/cubit/category_products/category_products_cubit.dart';
import 'package:kstore/features/products/presentation/cubit/products_cubit.dart';

import '../../injection_container.dart';
import 'data/datasources/products_remote_datasource.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/products_repository.dart';
import 'domain/usecases/get_category_products.dart';
import 'domain/usecases/get_product.dart';
import 'domain/usecases/get_products.dart';

Future<void> productsInjectionFeature() async {
  //! Blocs
  sl.registerFactory<ProductsCubit>(() => ProductsCubit(
        getProductsUseCase: sl(),
        getCategoryProductsUseCase: sl(),
        getProductUseCase: sl(),
      ));
  sl.registerFactory<CategoryProductsCubit>(() => CategoryProductsCubit(
        sl(),
        sl(),
      ));
  //! Use cases

  sl.registerLazySingleton<GetProducts>(() => GetProducts(sl()));
  sl.registerLazySingleton<GetCategoryProducts>(
      () => GetCategoryProducts(sl()));
  sl.registerLazySingleton<GetProduct>(() => GetProduct(repository: sl()));

  //! Repository
  sl.registerLazySingleton<ProductsRepository>(
      () => ProductsRepositoryImpl(remoteDataSource: sl()));
  //! Data Sources
  sl.registerLazySingleton<ProductsRemoteDataSource>(
      () => ProductsRemoteDataSourceImpl(apiConsumer: sl()));
}
