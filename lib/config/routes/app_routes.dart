import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/features/auth/presentation/screens/reset_password/reset_password.dart';
import 'package:kstore/features/auth/presentation/screens/signin/signin_screen.dart';
import 'package:kstore/features/home/presentation/screens/home_screen.dart';
import 'package:kstore/features/home/presentation/screens/search_screen.dart';
import 'package:kstore/features/onboarding/presentation/screen/onboarding_screen.dart';
import 'package:kstore/features/orders/domain/entities/order_products.dart';
import 'package:kstore/features/orders/presentation/screens/orders_screen.dart';
import 'package:kstore/features/products/presentation/screens/product_details_screen.dart';
import 'package:kstore/features/lang/presentation/screens/languages_screen.dart';
import '../../core/api/cach_helper.dart';
import '../../core/utils/app_strings.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/cetegories/domain/entities/category.dart' as cat;
import '../../features/cetegories/presentation/screens/category_products_screen.dart';
import '../../features/location/presentation/cubit/location_cubit.dart';
import '../../features/location/presentation/screens/location_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/orders/presentation/screens/tracking_orders_screen.dart';
import '../../features/payments/presentation/screens/payment_info_screen.dart';
import '../../features/payments/presentation/screens/payment_screen.dart';
import '../../features/products/presentation/screens/products_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/help_center_screen.dart';
import '../../features/settings/presentation/screens/privacy_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/screen/splash_screen.dart';
import '/injection_container.dart' as di;

class Routes {
  static const String initialRoute = '/';
  static const String home = '/home';
  static const String signUp = '/signUp';
  static const String signIn = '/signIn';
  static const String authScreen = '/authScreen';
  static const String verificationCode = '/verificationCode';
  static const String locationScreen = '/LocationScreen';
  static const String resetPassword = '/resetPassword';
  static const String searchScreen = '/searchScreen';
  static const String productDetails = '/productDetails';
  static const String cartScreen = '/cartScreen';
  static const String paymentScreen = '/paymentScreen';
  static const String settingsScreen = '/settingsScreen';
  static const String profileScreen = '/profileScreen';
  static const String languagesScreens = '/languagesScreens';
  static const String privacyScreen = '/privacyScreen';
  static const String paymentInfoScreen = '/paymentInfoScreen';
  static const String trackingOrdersScreen = '/trackingOrdersScreen';
  static const String categoryProductsScreen = '/categoryProductsScreen';
  static const String productsScreen = '/productsScreen';
  static const String onboardingScreen = '/onboardingScreen';
  static const String notificationsScreen = '/notificationsScreen';
  static const String helpCenterScreen = '/helpCenterScreen';
  static const String ordersScreen = '/ordersScreen';
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case Routes.initialRoute:
        return MaterialPageRoute(builder: (_) {
          if (!kIsWeb) {
            return HomeScreen();
          } else {
            return SplashScreen();
          }
        });

      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case Routes.authScreen:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case Routes.signUp:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (_) => di.sl<AuthCubit>(), child: const AuthScreen()));
      // case Routes.verificationCode:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (_) => di.sl<AuthCubit>(),
      //       child: const VerificationCodeScreen(),
      //     ),
      //   );
      case Routes.locationScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.sl<LocationCubit>(),
            child: const LocationScreen(),
          ),
        );
      case Routes.resetPassword:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.sl<AuthCubit>(),
            child: const ResetPasswordScreen(),
          ),
        );
      case Routes.searchScreen:
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
        );
      case Routes.productDetails:
        int productId = args as int;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(productId: productId),
        );
      case Routes.cartScreen:
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
        );
      case Routes.paymentScreen:
        var orderProducts = args as List<OrderProducts>;
        var totalPrice = args as double;
        var discount = args as double;
        return MaterialPageRoute(
          builder: (_) => PaymentScreen(
            orderProducts: orderProducts,
            totalPrice: totalPrice,
            discount: discount,
          ),
        );
      case Routes.settingsScreen:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      case Routes.profileScreen:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );
      case Routes.languagesScreens:
        return MaterialPageRoute(
          builder: (_) => const LanguagesScreen(),
        );
      case Routes.privacyScreen:
        return MaterialPageRoute(
          builder: (_) => const PrivacyScreen(),
        );
      case Routes.paymentInfoScreen:
        return MaterialPageRoute(
          builder: (_) => const PaymentInfoScreen(),
        );
      case Routes.trackingOrdersScreen:
        var orderId = args as int;
        return MaterialPageRoute(
          builder: (_) => TrackingOrdersScreen(orderId: orderId),
        );
      case Routes.productsScreen:
        return MaterialPageRoute(
          builder: (_) => const ProductsScreen(),
        );

      case Routes.onboardingScreen:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );

      case Routes.notificationsScreen:
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
        );

      case Routes.categoryProductsScreen:
        var category = args as cat.Category;
        return MaterialPageRoute(
          builder: (_) => CategoryProductsScreen(
            category: category,
          ),
        );
      case Routes.helpCenterScreen:
        return MaterialPageRoute(
          builder: (_) => const HelpCenterScreen(),
        );
      case Routes.ordersScreen:
        return MaterialPageRoute(
          builder: (_) => const OrdersScreen(),
        );

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteFound),
              ),
              body: const Center(child: Text(AppStrings.noRouteFound)),
            ));
  }
}
