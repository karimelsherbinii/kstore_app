import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/widgets/loading_indicator.dart';
import 'package:kstore/core/widgets/slider.dart';
import 'package:kstore/features/ads/presentation/cubit/ads_cubit.dart';
import 'package:kstore/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:kstore/features/cetegories/presentation/cubit/categories_cubit.dart';
import 'package:kstore/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:kstore/features/home/presentation/widgets/build_recent_orders.dart';
import 'package:kstore/features/orders/domain/entities/order.dart';
import 'package:kstore/features/orders/presentation/widgets/recent_order_widget.dart';
import 'package:kstore/features/orders/presentation/cubit/orders_state.dart';
import 'package:kstore/features/stories/presentation/cubit/stories_cubit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_localization_strings.dart';
import '../../../../core/widgets/view_all_list_tile.dart';
import '../../../cetegories/presentation/screens/build_categories.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../products/presentation/widgets/recommended_products_widget.dart';
import '../../../stories/presentation/widgets/build_stories_widget.dart';
import '../widgets/home_appbar.dart';
import '../widgets/search_widget.dart';

class HomeBodyScreen extends StatefulWidget {
  const HomeBodyScreen({Key? key}) : super(key: key);

  @override
  State<HomeBodyScreen> createState() => _HomeBodyScreenState();
}

class _HomeBodyScreenState extends State<HomeBodyScreen> {
  bool isGrid = false;
  bool isViewAll = false;
  bool ordersIsViewAll = false;
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
      await _getStories();
      await _getAds();
      await _getCategories();
      await _getFavoriteProducts();
      await _getFavoriteOrders();
      await _resetCart();
      await _getCartProducts();
      await _getOrders();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  _onRefresh() async {
    await _loadData();
    await Future.delayed(const Duration(seconds: 2));
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //         '${AppLocalizations.of(context)!.translate(AppLocalizationStrings.refreshed)}'),
    //   ),
    // );
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    _refreshController.refreshCompleted();
    _loadData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var translator = AppLocalizations.of(context)!;
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropHeader(
        complete: Text(
          '${AppLocalizations.of(context)!.translate(AppLocalizationStrings.refreshed)}',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        waterDropColor: AppColors.primaryColor,
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state is ReOrderSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
            context.read<OrdersCubit>().clearData();
            _getOrders();
          }
        },
        builder: (context, state) {
          // if (state is GetRecentOrdersLoadingState) {
          //   return const LoadingIndicator();
          // }
          return SingleChildScrollView(
            child: Column(
              children: [
                const HomeAppBar(),
                Padding(
                  padding: EdgeInsets.all(Constants.getScreenMargin(context)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      SearchWidget(
                        onSearch: () =>
                            Navigator.pushNamed(context, Routes.searchScreen),
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      storiesSection(translator, context),
                      adsSection(context),
                      categoriesSection(translator, context),
                      productsSection(context, translator),
                      ordersSection(translator),
                      SizedBox(
                        height: context.height * 0.1,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Column productsSection(BuildContext context, AppLocalizations translator) {
    return Column(
      children: [
        ViewAllListTile(
          onTap: () {
            Navigator.pushNamed(context, Routes.productsScreen);
          },
          isViewAll: isViewAll,
          title:
              '${translator.translate(AppLocalizationStrings.recommendedItems)}',
        ),
        AnimationLimiter(
            child: AnimationConfiguration.staggeredList(
          position: 1,
          duration: const Duration(milliseconds: 2300),
          child: SlideAnimation(
            horizontalOffset: 514,
            child: FadeInAnimation(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: context.width > 600
                    ? context.height * 0.3
                    : context.height * 0.22,
                child: BuildReCommendedItemsWidgets(
                  isViewAll: isViewAll,
                ),
              ),
            ),
          ),
        )),
      ],
    );
  }

  Column categoriesSection(AppLocalizations translator, BuildContext context) {
    return Column(
      children: [
        ViewAllListTile(
          onTap: () {
            setState(() {
              isGrid = !isGrid;
            });
          },
          isViewAll: isGrid,
          title: '${translator.translate(AppLocalizationStrings.categories)}',
        ),
        AnimationLimiter(
            child: AnimationConfiguration.staggeredList(
          position: 1,
          duration: const Duration(milliseconds: 2200),
          child: SlideAnimation(
            horizontalOffset: 512,
            child: FadeInAnimation(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: _getCategoriesSectionHeight(context),
                child: BuildCategoriesWidgets(
                  isGrid: isGrid,
                ),
              ),
            ),
          ),
        )),
      ],
    );
  }

  double? _getCategoriesSectionHeight(BuildContext context) {
    // !isGrid ? context.height * 0.15 : null;
    if (isGrid) {
      return null;
    } else {
      if (context.width > 500) {
        return context.height * 0.3;
      } else {
        return context.height * 0.15;
      }
    }
  }

  storiesSection(AppLocalizations translator, BuildContext context) {
    return BlocBuilder<StoriesCubit, StoriesState>(
      builder: (context, state) {
        if (BlocProvider.of<StoriesCubit>(context).stories.isNotEmpty) {
          return Column(
            children: [
              ViewAllListTile(
                onTap: () {},
                haveViewAll: false,
                isViewAll: false,
                title:
                    '${translator.translate(AppLocalizationStrings.stories)}',
              ),
              AnimationLimiter(
                  child: AnimationConfiguration.staggeredList(
                position: 1,
                duration: const Duration(milliseconds: 3000),
                child: SlideAnimation(
                  horizontalOffset: 510,
                  child: FadeInAnimation(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: context.width > 600
                          ? context.height * 0.4
                          : context.height * 0.25,
                      child: const BuildStoriesWidgets(),
                    ),
                  ),
                ),
              )),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  ordersSection(translator) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is GetRecentOrdersLoadedState &&
            context.read<OrdersCubit>().recentOrders.isNotEmpty) {
          return Column(
            children: [
              ViewAllListTile(
                onTap: () {
                  Navigator.pushNamed(context, Routes.ordersScreen);
                },
                isViewAll: ordersIsViewAll,
                title:
                    '${translator.translate(AppLocalizationStrings.recentOrders)}',
              ),
              AnimationLimiter(
                  child: AnimationConfiguration.staggeredList(
                position: 1,
                duration: const Duration(milliseconds: 2400),
                child: SlideAnimation(
                  horizontalOffset: 516,
                  child: FadeInAnimation(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const buildRecentOrders()),
                  ),
                ),
              )),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  String getOrderVisability(
      BuildContext context, int index, AppLocalizations translator) {
    return context
                .read<OrdersCubit>()
                .recentOrders[index]
                .products[0]
                .orderProduct!
                .quantity! >
            0
        ? translator.translate(AppLocalizationStrings.available)!
        : translator.translate(AppLocalizationStrings.notAvailable)!;
  }

  adsSection(BuildContext context) {
    return BlocBuilder<AdsCubit, AdsState>(
      builder: (context, state) {
        print('ads: ${context.read<AdsCubit>().ads}');
        if (state is GetAdsLoadedState &&
            context.read<AdsCubit>().ads.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.only(
                top: _getSliderPadding(context), bottom: context.height * 0.02),
            // width: MediaQuery.of(context).size.width,
            // height: context.width > 600
            //     ? context.height * 0.3
            //     : context.height * 0.2,
            child:
                SliderWidget(banners: context.read<AdsCubit>().getAdsImages()),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  double _getSliderPadding(BuildContext context) {
    if (context.width > 500) {
      return context.height * 0.1;
    } else {
      return context.height * 0.05;
    }
  }
}
