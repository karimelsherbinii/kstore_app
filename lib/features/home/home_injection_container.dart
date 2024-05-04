import 'package:get_it/get_it.dart';
import 'package:kstore/features/home/presentation/cubit/home_cubit.dart';

final sl = GetIt.instance;

Future<void> homeInjectionFeature() async {
  //! Blocs
  sl.registerFactory(() => HomeCubit());
  //! Use cases

  //! Repository

  //! Data Sources
}
