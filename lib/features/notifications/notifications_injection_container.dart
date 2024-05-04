import 'package:get_it/get_it.dart';
import 'package:kstore/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:kstore/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:kstore/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:kstore/features/notifications/domain/usecases/get_notifications.dart';
import 'package:kstore/features/notifications/presentation/cubit/notifications_cubit.dart';

import 'domain/usecases/mark_notifications_as_read.dart';

final sl = GetIt.instance;

Future<void> notificationsInjectionFeature() async {
  //! Blocs
  sl.registerFactory<NotificationsCubit>(() => NotificationsCubit(
        getNotificationsUseCase: sl(),
        markNotificationsAsReadUseCase: sl(),
  ));
  //! Use cases
  sl.registerLazySingleton<GetNotifications>(() => GetNotifications(sl()));
  sl.registerLazySingleton<MarkNotificationsAsRead>(
      () => MarkNotificationsAsRead(sl()));

  //! Repository
  sl.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(
           notificationsRemoteDataSource:  sl()
          ));

  //! Data Sources
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImpl(apiConsumer: sl()));
}
