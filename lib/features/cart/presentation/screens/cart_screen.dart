import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/config/routes/app_routes.dart';
import 'package:kstore/core/api/cach_helper.dart';
import 'package:kstore/core/utils/app_localization_strings.dart';
import 'package:kstore/core/utils/assets_manager.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/utils/shared_preferences.dart';
import 'package:kstore/core/widgets/loading_indicator.dart';
import 'package:kstore/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:kstore/features/cart/presentation/widgets/cart_item.dart';
import 'package:kstore/features/orders/domain/entities/order_product.dart';
import 'package:kstore/features/payments/presentation/screens/payment_screen.dart';
import 'package:kstore/features/settings/presentation/cubit/settings_cubit.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/buttons/default_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  _getCartTotalPrice() => context.read<CartCubit>().getCartProductsTotalPrice();

  _resetCart() => context.read<CartCubit>().resetCart();

  _getCrtProducts() => context.read<CartCubit>().getCartProducts();

  // _getSubProducts() => context.read<CartCubit>().getSubProducts(context);

  Future<void> _refreshCart() async {
    await _resetCart();
    await _getCrtProducts();
    await _getCartTotalPrice();
    // _getSubProducts();
    // await _getCartQuantityForEveryProduct();
  }

  @override
  void initState() {
    super.initState();
    debugPrint('cart screen init');
    _refreshCart();
  }

  List<int> productsIdsFromLocal = [];

  @override
  Widget build(BuildContext context) {
    var appTranslations = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            appTranslations.translate('cart') ?? '',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: context.read<SettingsCubit>().currentDarkModeState
              ? AppColors.darkBackground
              : Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushReplacementNamed(context, Routes.home);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, Routes.productsScreen);
              },
            ),
          ],
        ),
        // haveLeading: false,
        bottomNavigationBar: bottomNavBarWidget(context, appTranslations),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(Constants.getScreenMargin(context)),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                buildCartItems(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  bottomNavBarWidget(BuildContext context, AppLocalizations appTranslations) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return SizedBox(
          width: context.width,
          height: context.height * 0.15,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                SizedBox(
                  width: context.width * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const SizedBox(height: 15),
                      Text(
                        '${appTranslations.translate('total_price') ?? ''}: ',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${context.read<CartCubit>().totalPrice}\$',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: DefaultButton(
                      width: context.width * 0.5,
                      height: context.height * 0.06,
                      borderRadius: 12,
                      textSize: 14,
                      fontWeight: FontWeight.w700,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      label:
                          '${AppLocalizations.of(context)!.translate('proceed')}',
                      onTap: () {
                        if (context.read<CartCubit>().cartProducts.isNotEmpty) {
                          context
                              .read<CartCubit>()
                              .getDiscountPriceOfCartProdcts();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                        orderProducts: context
                                            .read<CartCubit>()
                                            .cartProducts,
                                        totalPrice: context
                                            .read<CartCubit>()
                                            .totalPrice,
                                        discount: context
                                            .read<CartCubit>()
                                            .discountPrice,
                                      )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.translate(
                                    AppLocalizationStrings.cartEmptyToProceed)!,
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  buildCartItems() {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is AttachProductCartLoadedState) {
          _resetCart();
          _getCrtProducts();
        }
      },
      builder: (context, state) {
        if (state is GetCartProductsLoadingState) {
          return const LoadingIndicator();
        }
        if (state is GetCartProductsErrorState) {
          return ErrorWidget(state.message);
        }
        var products = context.read<CartCubit>().cartProducts;
        // log('products length is ${products.length}');
        if (products.isEmpty) {
          return SizedBox(
            height: context.height * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppImageAssets.emptyCart,
                      width: context.width * 0.5, height: context.height * 0.3),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!
                        .translate(AppLocalizationStrings.cartEmpty)!,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ],
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: products.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                // log('product quantity is ${products[index].orderProduct!.name}');
                context.read<CartCubit>().categories = [];
                if (products[index].orderProduct!.categories!.isNotEmpty) {
                  context.read<CartCubit>().categories =
                      products[index].orderProduct!.categories!;
                  context.read<CartCubit>().subProducts = [];
                }
                bool subProductsIfItsHaveCategoryName = false;

                // getSubProductsIfItsHaveCategoryName() {
                if (context.read<CartCubit>().categories.isNotEmpty) {
                  if (context.read<CartCubit>().categories[0].name ==
                      'Sub Products') {
                    for (var i = 0; i < products.length; i++) {
                      if (products[i].orderProduct!.categories!.isNotEmpty) {
                        if (products[i].orderProduct!.categories![0].name ==
                            'Sub Products') {
                          // log('sub product is ${products[i].orderProduct!.name}');
                          context
                              .read<CartCubit>()
                              .subProducts
                              .add(products[i].orderProduct!);
                        }
                      }
                    }
                    // log('sub products name is ${context.read<CartCubit>().subProducts[0].name}');
                    // log('sub products length is ${context.read<CartCubit>().subProducts.length}');
                    subProductsIfItsHaveCategoryName = true;
                  } else {
                    subProductsIfItsHaveCategoryName = false;
                  }
                } else {
                  subProductsIfItsHaveCategoryName = false;
                }

                if (!subProductsIfItsHaveCategoryName) {
                  List<Object?>? productsIdiesHaveExstraItemsFromLocal =
                      CacheHelper.getData(
                            key: AppSharedPreferences
                                .productsIdiesHaveExstraItems,
                          ) ??
                          [];
                  productsIdsFromLocal.addAll(
                      productsIdiesHaveExstraItemsFromLocal!
                          .map((e) => int.parse(e.toString())));

                  log(products[index].orderProduct!.id!.toString(),
                      name: 'haveExstraItems id');

                  log(productsIdsFromLocal.toString(),
                      name: 'haveExstraItems local list');

                  log(products[index].orderProduct!.id!.toString(),
                      name: 'ExstraItemsId-------');
                  return CartItem(
                    id: products[index].orderProduct!.id!,
                    haveExtraItems: productsIdsFromLocal
                        .contains(products[index].orderProduct!.id!),
                    extraItems: context
                        .read<CartCubit>()
                        .getSubProductsFromProductById(
                            context: context,
                            productId: products[index].orderProduct!.id!),
                    name: products[index].orderProduct!.name!,
                    imgPath: products[index].orderProduct!.images![0],
                    price: '${products[index].orderProduct!.price}',
                    description: products[index].orderProduct!.description!,
                    rate: products[index]
                        .orderProduct!
                        .rate!
                        .toDouble()
                        .toString(),
                    avilability: products[index].quantity == 0
                        ? AppLocalizations.of(context)!
                            .translate(AppLocalizationStrings.notAvailable)!
                        : AppLocalizations.of(context)!
                            .translate(AppLocalizationStrings.available)!,
                    quantity: products[index].quantity!,
                    onRemoveItem: (direction) {
                      removeMainProductFromLocal(
                          products[index].orderProduct!.id!);
                      debugPrint(
                          'product id is ${products[index].orderProduct!.id}');
                      log('product quantity is ${products[index].quantity}');
                      log('product type is ${getPtoductTypeIsProductOrSizeById(
                        productId: products[index].orderProduct!.id!,
                      )}');
                      log('product type is ${getPtoductTypeIsProductOrSizeById(
                        productId: products[index].orderProduct!.id!,
                      )}');

                      context
                          .read<CartCubit>()
                          .attachProductCart(
                              productId: products[index].orderProduct!.id!,
                              quantity: products[index].quantity!,
                              type: getPtoductTypeIsProductOrSizeById(
                                productId: products[index].orderProduct!.id!,
                              ))
                          .then((v) {
                        // if (
                        // subProductsIfItsHaveCategoryName &&
                        // productsIdsFromLocal
                        //     .contains(products[index].orderProduct!.id!)

                        // ) {
                        log('Done remove sub products');
                        //print sub products
                        for (var i = 0;
                            i < context.read<CartCubit>().subProducts.length;
                            i++) {
                          log('sub product is ${context.read<CartCubit>().subProducts[i].name}');
                        }
                        // removeAnySubProductsForSelectedProduct(
                        //     productId: products[index].orderProduct!.id!,
                        //     quantity: products[index].quantity!);
                        //print child products of product

                        // }

                        _refreshCart();
                      });
                    },
                  );
                } else {
                  return const SizedBox();
                }
              }),
        );
      },
    );
  }

  removeMainProductFromLocal(int productId) {
    if (productsIdsFromLocal.contains(productId)) {
      // Create a Set to remove duplicates
      Set<int> uniqueProductIds = Set<int>.from(productsIdsFromLocal);

      // Convert the Set back to a List
      productsIdsFromLocal = uniqueProductIds.toList();
      //remove selected item
      productsIdsFromLocal.remove(productId);
      log(productsIdsFromLocal.toString(),
          name: 'productsIdsFromLocal after removed');

      // Save the updated list to cache
      CacheHelper.saveData(
        key: AppSharedPreferences.productsIdiesHaveExstraItems,
        value: productsIdsFromLocal,
      );
    }
  }

  getSubProductsIdies(int productId) {
    List<int> subProductsIdies = [];
    var subProducts = context
        .read<CartCubit>()
        .getSubProductsFromProductById(context: context, productId: productId);
    for (var i = 0; i < subProducts.length; i++) {
      subProductsIdies.add(subProducts[i].id!);
      log('sub products idies is ${subProductsIdies[i]}');
    }
    return subProductsIdies;
  }

  void removeAnySubProductsForSelectedProduct({
    required int productId,
    required int quantity,
  }) {
    if (context.read<CartCubit>().getProductIsInCart(productId) &&
        productsIdsFromLocal.contains(productId)) {
      var subProductIds = getSubProductsIdies(productId);
      debugPrint('Subproduct IDs: $subProductIds'); // Debug line

      for (var i = 0; i < subProductIds.length; i++) {
        debugPrint('Loop iteration: $i'); // Debug line
        debugPrint('product id is ${subProductIds[i]}');
        context.read<CartCubit>().attachProductCart(
            productId: subProductIds[i], quantity: quantity, type: 'product');
      }
    }
  }

  removeProductFromCart({
    required int productId,
    required int quantity,
  }) {
    for (var i = 0; i < context.read<CartCubit>().cartProducts.length; i++) {
      if (context.read<CartCubit>().cartProducts[i].orderProduct!.id ==
          productId) {
        //log context.read<CartCubit>().cartProducts[i].quantity!
        context.read<CartCubit>().cartProducts.removeAt(i);
        context.read<CartCubit>().attachProductCart(
            productId: productId,
            quantity: quantity,
            type: getPtoductTypeIsProductOrSizeById(productId: productId));
      }
    }
  }

  String getPtoductTypeIsProductOrSizeById({
    required int productId,
  }) {
    //if product have colors

    if (context.read<CartCubit>().cartProducts.isNotEmpty) {
      for (var i = 0; i < context.read<CartCubit>().cartProducts.length; i++) {
        if (context.read<CartCubit>().cartProducts[i].orderProduct!.id ==
            productId) {
          if (context.read<CartCubit>().cartProducts[i].orderProduct!.size !=
              null) {
            return 'size';
          } else {
            return 'product';
          }
        }
      }
    }
    return 'product';
  }

  // Future<void> removeSubProductFromCart({
  //   required int productId,
  //   required List<int> subProductsIdies,
  //   required int quantity,
  // }) async {
  //   await context
  //       .read<ProductsCubit>()
  //       .getProductById(productId: productId)
  //       .then((value) {
  //     if (context.read<ProductsCubit>().product != null) {
  //       log('product name is ${context.read<ProductsCubit>().product!.name}');
  //       Product product = context.read<ProductsCubit>().product!;
  //       log('product name is ${product.name}');
  //       List<ChildProduct> subProducts = product.childrens!;
  //       if (subProducts.isNotEmpty) {
  //         log('sub products name is ${subProducts[0].name}');
  //         log('product id is ${productId}');
  //         //if sub product is in cart and its found in product child list from products remove it
  //         //get sub product of product
  //         for (var i = 0; i < subProducts.length; i++) {
  //           log('sub product is befiore removed ${subProducts[i].name}');

  //           if (subProductsIdies.contains(subProducts[i].id)) {
  //             log('sub product is removed ${subProducts[i].name}');
  //             //remove sub product from cart
  //             removeProductFromCart(
  //               productId: subProducts[i].id!,
  //               quantity: quantity,
  //             );
  //           }
  //         }
  //       }
  //     }
  //   });
  // }
  // if null will search in size color product in
}
