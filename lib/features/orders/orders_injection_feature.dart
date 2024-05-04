import 'package:kstore/features/orders/data/datasources/orders_remote_datasorce.dart';
import 'package:kstore/features/orders/domain/usecases/add_order.dart';
import 'package:kstore/features/orders/domain/usecases/cancel_order.dart';
import 'package:kstore/features/orders/domain/usecases/reorder.dart';
import 'package:kstore/features/orders/presentation/cubit/orders_cubit.dart';

import '../../injection_container.dart';
import 'data/repositories/orders_repository_impl.dart';
import 'domain/repositories/orders_repository.dart';
import 'domain/usecases/get_order.dart';
import 'domain/usecases/get_orders.dart';

Future<void> orderInjectionFeature() async {
  //! Blocs
  sl.registerFactory<OrdersCubit>(() => OrdersCubit(
        addOrderUseCase: sl(),
        getOrdersUseCase: sl(),
        getOrderUseCase: sl(),
        reOrderUseCase: sl(),
        cancelOrderUseCase: sl(),
      ));
  //! Use cases

  sl.registerLazySingleton<AddOrder>(() => AddOrder(
        repository: sl(),
      ));
  sl.registerLazySingleton<GetOrders>(() => GetOrders(
        repository: sl(),
      ));
  sl.registerLazySingleton<GetOrder>(() => GetOrder(
        repository: sl(),
      ));
  sl.registerLazySingleton<ReOrder>(() => ReOrder(
        sl(),
      ));
  sl.registerLazySingleton<CancelOrder>(() => CancelOrder(
        sl(),
      ));
  //! Repository
  sl.registerLazySingleton<OrdersRepository>(
      () => OrdersRepositoryImpl(remoteDataSource: sl()));
  //! Data Sources
  sl.registerLazySingleton<OrdersRemoteDataSource>(
      () => OrdersRemoteDataSourceImpl(apiConsumer: sl()));
}
