import 'package:get_it/get_it.dart';
import 'package:kstore/features/cart/presentation/cubit/cart_cubit.dart';

import 'data/datasources/cart_remote_datasource.dart';
import 'data/repositories/cart_repository_impl.dart';
import 'domain/repositories/cart_repository.dart';
import 'domain/usecases/attach_product_cart.dart';
import 'domain/usecases/get_cart_products.dart';

final sl = GetIt.instance;

Future<void> cartInjectionFeature() async {
  //! Blocs
  sl.registerFactory<CartCubit>(() => CartCubit(getCartProductsUseCase: sl(), attachProductCartUseCase: sl()));

  //! Use cases
  sl.registerLazySingleton(() => GetCartProducts(sl()));
  sl.registerLazySingleton(() => AttachProductCart(sl()));

  //! Repository
  sl.registerLazySingleton<CartRepository>(() => CartRepsitoryImpl(cartRemoteDataSource: sl()));

  //! Data Sources
  sl.registerLazySingleton<CartRemoteDataSource>(() => CartRemoteDataSourceImpl(apiConsumer: sl()));
}
