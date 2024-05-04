import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/assets_manager.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/widgets/screen_container.dart';
import 'package:kstore/features/ads/presentation/cubit/ads_cubit.dart';
import 'package:kstore/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:kstore/features/cart/presentation/screens/cart_screen.dart';
import 'package:kstore/features/cetegories/presentation/cubit/categories_cubit.dart';
import 'package:kstore/features/home/presentation/screens/home_body_screen.dart';
import 'package:kstore/features/offers/presentation/screens/offers_screen.dart';
import 'package:kstore/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:kstore/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:kstore/features/profile/presentation/screens/profile_screen.dart';
import 'package:kstore/features/stories/presentation/cubit/stories_cubit.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../favorites/presentation/cubit/favorite_cubit.dart';
import '../../../favorites/presentation/screens/favorites_screen.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _getFavoriteProducts() =>
      BlocProvider.of<FavoriteCubit>(context).getFavoriteProducts();
  _getFavoriteOrders() =>
      BlocProvider.of<FavoriteCubit>(context).getFavoriteOrders();
  _getCartProducts() => BlocProvider.of<CartCubit>(context).getCartProducts();
  _getOrders() async {
    BlocProvider.of<OrdersCubit>(context).clearData();
    await BlocProvider.of<OrdersCubit>(context).getRecentOrders();
  }

  _resetCart() => context.read<CartCubit>().resetCart();
  _getStories() => context.read<StoriesCubit>().getStories();
  _getAds() => context.read<AdsCubit>().getAds(now: false).then((value) {
        log('get ads done');
      });
  _getCategories() async {
    BlocProvider.of<CategoriesCubit>(context).getCategories();
    // BlocProvider.of<CategoryProductsCubit>(context).getProductsByCategory(
    //   categoryId: 16,
    // );
  }

  Future<void> _loadData() async {
    try {
      // await _getStories();
      await _getAds();
      // await _getCategories();
      // await _getFavoriteProducts();
      // await _getFavoriteOrders();
      // await _resetCart();
      // await _getCartProducts();
      // await _getOrders();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _getCartTotalPrice() => context.read<CartCubit>().getCartProductsTotalPrice();

  _getCrtProducts() => context.read<CartCubit>().getCartProducts();

  @override
  void initState() {
    pageController.initialPage == 0;
    super.initState();
    // _loadData();
  }

  // @override
  // void deactivate() {
  //   super.deactivate();
  //   _getStories();
  //   _getCategories();
  //   _getFavoriteProducts();
  //   _getFavoriteOrders();
  //   _refreshCart();
  //   _getCartProducts();
  //   _getOrders();
  // }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  PageController pageController = PageController();
  int selectedIndex = 0;
  final List<Widget> _widgetsList = [
    const HomeBodyScreen(),
    const FavoritesScreen(),
    const CartScreen(),
    // const OffersScreen(),//TODO: Will be added later
    const ProfileScreen()
  ];

  final List<String> _navIcons = [
    AppImageAssets.homeIcon,
    AppImageAssets.favoriteIcon,
    AppImageAssets.cartIcon,
    AppImageAssets.person,
  ];
  final List<String> titlesList = [
    'Home',
    'Favorive',
    'Cart',
    'Offers',
  ];
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  //smart refresh functions
  Future<void> _onRefresh() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: _widgetsList,
              ),
              Positioned(
                bottom: 5,
                left: 2,
                right: 2,
                child: customNavigationBar(),
              ),
            ],
          ),
        ),
        // bottomNavigationBar:
      ),
    );
  }

  Material customNavigationBar() {
    return Material(
      elevation: 0,
      shape: RoundedRectangleBorder(
        //radius: Radius.circular(20),
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: SizedBox(
        height: context.height * 0.07,
        width: context.width * 0.98,
        child: ListView.builder(
          itemCount: _navIcons.length,
          itemBuilder: (_, i) => GestureDetector(
            onTap: () {
              if (i != 0) {
                if (context.read<LoginCubit>().authenticatedUser == null) {
                  Constants.showAskToLoginDialog(context);
                  return;
                }
              }
              if (i == 2) {
                if (context.read<LoginCubit>().authenticatedUser == null) {
                 Constants.showAskToLoginDialog(context);
                  return;
                }
                Navigator.pushNamed(context, Routes.cartScreen);
                return;
              } else if (i == 3) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ProfileScreen(
                    fromHome: true,
                  );
                }));
                return;
              }
              onItemTapped(i);
            },
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 200,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: context.width > 600 ? context.width * 0.05 : 0,
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: context.width * 0.06),
                      height: context.height * 0.05,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: i == selectedIndex
                              ? AppColors.primaryColor
                              : Colors.transparent),
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              _navIcons[i],
                              color: i == selectedIndex
                                  ? Colors.white
                                  : AppColors.primaryColor,
                              width: context.width > 600
                                  ? context.width * 0.02
                                  : context.width * 0.05,
                            ),
                            SizedBox(
                              width: context.width > 600
                                  ? 10
                                  : context.width * 0.01,
                            ),
                            Text(
                              i == selectedIndex ? titlesList[i] : '',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: i == selectedIndex
                                      ? Colors.white
                                      : AppColors.primaryColor,
                                  fontSize: context.width > 600
                                      ? 16
                                      : context.width * 0.04),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
