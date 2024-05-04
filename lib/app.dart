import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kstore/core/api/cach_helper.dart';
import 'package:kstore/core/utils/shared_preferences.dart';
import 'package:kstore/features/ads/presentation/cubit/ads_cubit.dart';
import 'package:kstore/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kstore/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:kstore/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:kstore/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:kstore/features/orders/presentation/cubit/orders_cubit.dart';

import 'config/locale/app_localizations_setup.dart';
import 'config/routes/app_routes.dart';
import 'config/theme/app_dark_theme.dart';
import 'config/theme/app_theme.dart';
import 'core/utils/app_strings.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/cetegories/presentation/cubit/categories_cubit.dart';
import 'features/favorites/presentation/cubit/favorite_cubit.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/payments/presentation/cubit/payments_cubit.dart';
import 'features/products/presentation/cubit/category_products/category_products_cubit.dart';
import 'features/products/presentation/cubit/products_cubit.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/splash/presentation/cubit/locale_cubit.dart';
import 'features/splash/presentation/cubit/locale_states.dart';
import 'features/stories/presentation/cubit/stories_cubit.dart';
import 'injection_container.dart' as di;

class KStoreApp extends StatefulWidget {
  const KStoreApp({super.key});

  @override
  State<KStoreApp> createState() => _KStoreAppState();
}

class _KStoreAppState extends State<KStoreApp> {
  @override
  void initState() {
    super.initState();
    log(CacheHelper.getData(key: 'token').toString(), name: 'tokentoken');
    // log(
    //     CacheHelper.getData(
    //             key: AppSharedPreferences.productsIdiesHaveExstraItems)
    //         .toString(),
    //     name: 'productsIdiesHaveExstraItems');
    // CacheHelper.removeData(
    //     key: AppSharedPreferences.productsIdiesHaveExstraItems);

  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<LocaleCubit>()..getSavedLanguage(),
        ),
        BlocProvider(
          create: (_) => di.sl<NotificationsCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<SettingsCubit>()..getSavedDarkMode(),
        ),
        BlocProvider(
          create: (_) => di.sl<AuthCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<RegisterCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<LoginCubit>()..getSavedLoginCredentials(),
        ),
        BlocProvider(
          create: (_) => di.sl<HomeCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<PaymentsCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<ProfileCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<CartCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<ProductsCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<CategoriesCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<CategoryProductsCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<FavoriteCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<OrdersCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<StoriesCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<AdsCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<PaymentsCubit>(),
        ),
      ],
      child: BlocBuilder<LocaleCubit, LocaleStates>(
          buildWhen: (previousState, currentState) =>
              previousState != currentState,
          builder: (_, localeState) {
            return BlocBuilder<SettingsCubit, SettingsState>(
              buildWhen: (previousState, currentState) =>
                  previousState != currentState,
              builder: (context, state) {
                return MaterialApp(
                  useInheritedMediaQuery: true,
                  title: AppStrings.appName,
                  debugShowCheckedModeBanner: false,
                  // initialRoute: Routes.home,

                  // locale: DevicePreview.locale(context),
                  builder: DevicePreview.appBuilder,
                  onGenerateRoute: AppRoutes.onGenerateRoute,
                  themeMode:
                      !context.watch<SettingsCubit>().currentDarkModeState
                          ? ThemeMode.dark
                          : ThemeMode.light,
                  theme: !context.watch<SettingsCubit>().currentDarkModeState
                      ? AppTheme.appThemeData(context)
                      : appDarkThemeData(context),
                  darkTheme: context.watch<SettingsCubit>().currentDarkModeState
                      ? appDarkThemeData(context)
                      : AppTheme.appThemeData(context),
                  supportedLocales: AppLocalizationsSetup.supportedLocales,
                  localizationsDelegates:
                      AppLocalizationsSetup.localizationsDelegates,
                  localeResolutionCallback:
                      AppLocalizationsSetup.localeResolutionCallback,
                  locale: localeState.locale,
                );
              },
            );
          }),
    );
  }
}
