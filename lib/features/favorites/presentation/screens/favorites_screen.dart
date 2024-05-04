 

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/config/routes/app_routes.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/app_localization_strings.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/widgets/default_widget_tree.dart';
import 'package:kstore/core/widgets/loading_indicator.dart';
import 'package:kstore/core/widgets/product_item_widget.dart';
import 'package:kstore/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:kstore/features/orders/presentation/widgets/recent_order_widget.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  _getFavoriteProducts() =>
      BlocProvider.of<FavoriteCubit>(context).getFavoriteProducts();

  _getFavoriteOrders() =>
      BlocProvider.of<FavoriteCubit>(context).getFavoriteOrders();

  Future<void> _loadData() async {
    try {
      await _getFavoriteProducts();
      await _getFavoriteOrders();
    } catch (e) {
      log(e.toString(), name: 'FavoritesScreen');
    }
  }

  _removeProductFromFavorites(int productId) =>
      BlocProvider.of<FavoriteCubit>(context)
          .deleteFavorite(productId: productId, type: 'product');

  _removeOrderFromFavorites(int orderId) =>
      BlocProvider.of<FavoriteCubit>(context)
          .deleteFavorite(productId: orderId, type: 'order');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void deactivate() {
    _loadData();
    super.deactivate();
  }

  bool isRemovable = false;
  @override
  Widget build(BuildContext context) {
    var appTranslations = AppLocalizations.of(context)!;
    var favoriteProducts = context.read<FavoriteCubit>().favoriteProducts;
    var favoriteOrders = context.read<FavoriteCubit>().favoriteOrders;
    return DefaultWidgetTree(
        haveAppBar: true,
        haveLeading: false,
        appBarTitle: appTranslations.translate(AppLocalizationStrings.favorite),
        actions: [
          context.read<FavoriteCubit>().favoriteProducts.isNotEmpty ||
                  context.read<FavoriteCubit>().favoriteOrders.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isRemovable = !isRemovable;
                    });
                  },
                  icon: const Icon(Icons.edit),
                )
              : const SizedBox()
        ],
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Constants.getScreenMargin(context), vertical: 20),
            child: (favoriteProducts.isEmpty && favoriteOrders.isEmpty)
                ? SizedBox(
                    height: context.height * 0.5,
                    child: Center(
                      child: Text(
                        appTranslations
                            .translate(AppLocalizationStrings.noFavorites)!,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      isRemovable
                          ? buildRemovableFavoriteProducts(context)
                          : buildfavotiteProducts(context),
                      const SizedBox(height: 20),
                      // isRemovable
                      //     ? buildRemovableFavoriteOrders(context)
                      //     : buildFavoriteOrders(context),
                    ],
                  ),
          ),
        ));
  }

  buildfavotiteProducts(BuildContext context) {
    var translator = AppLocalizations.of(context)!;
    return BlocBuilder<FavoriteCubit, FavoriteState>(builder: (context, state) {
      if (state is GetFavoriteProductsLoadingState) {
        return const LoadingIndicator();
      }
      var favoriteProducts = context.read<FavoriteCubit>().favoriteProducts;
      if (favoriteProducts.isEmpty) {
        return const SizedBox();
      }
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          translator.translate(AppLocalizationStrings.products)!,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 20),
        ListView.separated(
          separatorBuilder: (context, index) =>
              index != 0 ? const SizedBox(height: 20) : const SizedBox(),
          itemCount: favoriteProducts.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            log(getProductCategoryName(index), name: 'getProductCategoryName');
            return getProductCategoryName(index) != 'Sub Products'
                ? ProductItemWidget(
                    name: context
                        .read<FavoriteCubit>()
                        .favoriteProducts[index]
                        .name!,
                    price: Constants.getFavoriteProductPrice(index, context),
                    rate:
                        '${context.read<FavoriteCubit>().favoriteProducts[index].rate}.0',
                    image: context
                            .read<FavoriteCubit>()
                            .favoriteProducts[index]
                            .images
                            .isNotEmpty
                        ? context
                            .read<FavoriteCubit>()
                            .favoriteProducts[index]
                            .images[0]
                        : '',
                    onTap: () => Navigator.pushNamed(
                        context, Routes.productDetails,
                        arguments: context
                            .read<FavoriteCubit>()
                            .favoriteProducts[index]
                            .id),
                  )
                : const SizedBox();
          },
        )
      ]);
    });
  }

  getProductCategoryName(int index) {
    return context
        .read<FavoriteCubit>()
        .favoriteProducts[index]
        .categories![0]
        .name;
  }

  buildRemovableFavoriteProducts(BuildContext context) {
    var translator = AppLocalizations.of(context)!;
    return BlocBuilder<FavoriteCubit, FavoriteState>(builder: (context, state) {
      if (state is GetFavoriteProductsLoadingState) {
        return const LoadingIndicator();
      }
      var favoriteProducts = context.read<FavoriteCubit>().favoriteProducts;
      if (favoriteProducts.isEmpty) {
        return const SizedBox();
      }
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          translator.translate(AppLocalizationStrings.products)!,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 20),
        ListView.separated(
          separatorBuilder: (context, index) =>
              index != 0 ? const SizedBox(height: 20) : const SizedBox(),
          itemCount: favoriteProducts.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return getProductCategoryName(index) != 'Sub Products'
                ? Stack(
                    children: [
                      ProductItemWidget(
                        name: context
                            .read<FavoriteCubit>()
                            .favoriteProducts[index]
                            .name!,
                        price: Constants.getProductPrice(index, context),
                        rate:
                            '${context.read<FavoriteCubit>().favoriteProducts[index].rate}.0',
                        image: context
                                .read<FavoriteCubit>()
                                .favoriteProducts[index]
                                .images
                                .isNotEmpty
                            ? context
                                .read<FavoriteCubit>()
                                .favoriteProducts[index]
                                .images[0]
                            : '',
                        onTap: () => Navigator.pushNamed(
                            context, Routes.productDetails,
                            arguments: context
                                .read<FavoriteCubit>()
                                .favoriteProducts[index]
                                .id),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            _removeProductFromFavorites(context
                                .read<FavoriteCubit>()
                                .favoriteProducts[index]
                                .id!);
                            setState(() {
                              favoriteProducts.removeAt(index);
                            });
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                    ],
                  )
                : const SizedBox();
          },
        )
      ]);
    });
  }

  buildFavoriteOrders(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        var translator = AppLocalizations.of(context)!;
        if (state is GetFavoriteOrdersLoadingState) {
          return const LoadingIndicator();
        }
        var favoriteOrders = context.read<FavoriteCubit>().favoriteOrders;
        if (favoriteOrders.isEmpty) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translator.translate(AppLocalizationStrings.orders)!,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemCount: favoriteOrders.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return RecentOrdersWidget(
                    height: context.height * 0.16,
                    width: context.width,
                    name: favoriteOrders[index].products[0].orderProduct!.name!,
                    imgPath: favoriteOrders[index]
                            .products[0]
                            .orderProduct!
                            .images!
                            .isNotEmpty
                        ? favoriteOrders[index]
                            .products[0]
                            .orderProduct!
                            .images![0]
                        : '',
                    price:
                        '${favoriteOrders[index].products[0].orderProduct!.price}\$',
                    description: favoriteOrders[index]
                        .products[0]
                        .orderProduct!
                        .description!,
                    rate:
                        '${favoriteOrders[index].products[0].orderProduct!.rate}.0',
                    avilability: favoriteOrders[index]
                                .products[0]
                                .orderProduct!
                                .quantity! >
                            0
                        ? translator
                            .translate(AppLocalizationStrings.available)!
                        : translator
                            .translate(AppLocalizationStrings.notAvailable)!,
                  );
                }),
          ],
        );
      },
    );
  }

  buildRemovableFavoriteOrders(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        var translator = AppLocalizations.of(context)!;
        if (state is GetFavoriteOrdersLoadingState) {
          return const LoadingIndicator();
        }
        var favoriteOrders = context.read<FavoriteCubit>().favoriteOrders;
        if (favoriteOrders.isEmpty) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translator.translate(AppLocalizationStrings.orders)!,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemCount: favoriteOrders.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: context.height * 0.175,
                    width: context.width,
                    child: Stack(
                      children: [
                        Positioned(
                          top: context.height * 0.01,
                          left: 0,
                          right: 0,
                          child: RecentOrdersWidget(
                            withShadow: false,
                            height: context.height * 0.16,
                            width: context.width,
                            name: favoriteOrders[index]
                                .products[0]
                                .orderProduct!
                                .name!,
                            imgPath: favoriteOrders[index]
                                    .products[0]
                                    .orderProduct!
                                    .images!
                                    .isNotEmpty
                                ? favoriteOrders[index]
                                    .products[0]
                                    .orderProduct!
                                    .images![0]
                                : '',
                            price:
                                '${favoriteOrders[index].products[0].orderProduct!.price}\$',
                            description: favoriteOrders[index]
                                .products[0]
                                .orderProduct!
                                .description!,
                            rate:
                                '${favoriteOrders[index].products[0].orderProduct!.rate}.0',
                            avilability: favoriteOrders[index]
                                        .products[0]
                                        .orderProduct!
                                        .quantity! >
                                    0
                                ? translator.translate(
                                    AppLocalizationStrings.available)!
                                : translator.translate(
                                    AppLocalizationStrings.notAvailable)!,
                          ),
                        ),
                        Positioned(
                          top: -8,
                          right: 0,
                          child: IconButton(
                            onPressed: () {
                              _removeOrderFromFavorites(context
                                  .read<FavoriteCubit>()
                                  .favoriteOrders[index]
                                  .id);
                              setState(() {
                                favoriteOrders.removeAt(index);
                              });
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.close,
                                size: 10,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ],
        );
      },
    );
  }
}
