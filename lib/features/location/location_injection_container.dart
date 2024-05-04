import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kstore/features/location/presentation/cubit/location_cubit.dart';

import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> locationInjectionFeature() async {
  //! Blocs
  sl.registerFactory(() => LocationCubit());
  //! Use cases

  //! Repository

  //! Data Sources
}
