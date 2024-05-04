// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/core/api/cach_helper.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/utils/hex_color.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/utils/shared_preferences.dart';
import 'package:kstore/core/widgets/product_images_slider.dart';
import 'package:kstore/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:kstore/features/favorites/presentation/cubit/favorite_cubit.dart';
import 'package:kstore/features/products/domain/entities/color.dart';
import 'package:kstore/features/products/presentation/cubit/products_cubit.dart';
import 'package:kstore/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:kstore/features/settings/presentation/cubit/settings_cubit.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/widgets/buttons/default_button.dart';
import '../../../../core/widgets/counter_widget.dart';

//error widget
import '../../../../core/widgets/error_widget.dart' as errorWidget;
import '../../domain/entities/child_product.dart';
import '../../domain/entities/color_size.dart';
import '../../domain/entities/product.dart';
import '../widgets/exrta_item_widget.dart';
import '../widgets/sizes_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  _getProduct() {
    context.read<ProductsCubit>().getProductById(productId: widget.productId);
    if (context.read<ProfileCubit>().user != null) {
      context.read<CartCubit>().getCartProducts();
    }
  }

  _resetCart() => context.read<CartCubit>().resetCart();

  _getCrtProducts() => context.read<CartCubit>().getCartProducts();

  _getCartTotalPrice() => context.read<CartCubit>().getCartProductsTotalPrice();

  // _getCartProductsQuantity() =>
  //     context.read<CartCubit>().getCartProductsQuantity();

  Future<void> _refreshCart() async {
    await _resetCart();
    await _getCrtProducts();
    await _getCartTotalPrice();
  }

  // _loadCartData() async {
  //   try {
  //     context.read<CartCubit>().cartProducts.clear();
  //     await _getCrtProducts();
  //     await _getCartTotalPrice();
  //     // await _getCartProductsQuantity();
  //   } catch (e) {
  //     log('error in load data');
  //   }
  // }

  _getFavoriteProducts() =>
      BlocProvider.of<FavoriteCubit>(context).getFavoriteProducts();

  _resetProductData() {
    context.read<ProductsCubit>().resetProductData();
  }

  Future<void> _loadData() async {
    try {
      await _getProduct();
      await _resetProductData();
      await _getFavoriteProducts();
    } catch (e) {
      log('error in load data');
    }
  }

  _getProducts() {
    context.read<ProductsCubit>().clearData();
    context.read<ProductsCubit>().getProducts();
  }

  _resetQuantitiesToZero() =>
      context.read<ProductsCubit>().resetQuantitiesToZero();

  @override
  void initState() {
    super.initState();
    _resetQuantitiesToZero();
    _loadData();
    if (context.read<ProfileCubit>().user != null) {
      context.read<CartCubit>().resetCart();
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    _loadData();
    context.read<CartCubit>().resetCart();
    _getProducts();
  }

  ColorSize? selectedSize;
  //selected size color
  ProductColor? selectedColor;
  List<ChildProduct> selectedSubProducts = [];
  Set<ChildProduct> uniqueSubProducts = Set<ChildProduct>();

  void addSubProduct(ChildProduct subProduct) {
    if (uniqueSubProducts.add(subProduct)) {
      selectedSubProducts.add(subProduct);
    }
  }

  List<int> productsIdiesHaveSubProducts = [];
  Set<int> uniqueProductsIdiesHaveSubProducts = Set<int>();
  void addProductsIdiesHaveSupProducts(int productId) {
    if (uniqueProductsIdiesHaveSubProducts.add(productId)) {
      productsIdiesHaveSubProducts.add(productId);
    }
  }

  void addProductsIdiesHaveSupProductsWithLocal(int productId) {
    // CacheHelper.removeData(
    //     key: AppSharedPreferences.productsIdiesHaveExstraItems);
    List<Object?>? productsIdiesHaveExstraItemsFromLocal = CacheHelper.getData(
          key: AppSharedPreferences.productsIdiesHaveExstraItems,
        ) ??
        [];
    if (productsIdiesHaveExstraItemsFromLocal != null) {
      if (uniqueProductsIdiesHaveSubProducts.add(productId)) {
        productsIdiesHaveSubProducts.addAll(
            productsIdiesHaveExstraItemsFromLocal
                .map((e) => int.parse(e.toString())));
        productsIdiesHaveSubProducts.add(productId);
      }
    } else {
      CacheHelper.saveData(
          key: AppSharedPreferences.productsIdiesHaveExstraItems, value: []);
      if (uniqueProductsIdiesHaveSubProducts.add(productId)) {
        productsIdiesHaveSubProducts.addAll(
            productsIdiesHaveExstraItemsFromLocal!
                .map((e) => int.parse(e.toString())));
        productsIdiesHaveSubProducts.add(productId);
      }
    }
  }

  bool iswithSubProducts = false;
  @override
  Widget build(BuildContext context) {
    var appTranslations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
          if (state is GetProductsLoadingState) {
            return Baseline(
                baseline: context.height * 0.5,
                baselineType: TextBaseline.alphabetic,
                child: const Center(child: CircularProgressIndicator()));
          }
          if (state is GetProductsErrorState) {
            return Center(
                child: errorWidget.ErrorWidget(
              msg: state.message,
            ));
          }

          return context.read<ProductsCubit>().product != null
              ? Stack(
                  children: [
                    AnimationLimiter(
                      child: AnimationConfiguration.staggeredList(
                        position: 1,
                        duration: const Duration(milliseconds: 2000),
                        child: SlideAnimation(
                          verticalOffset: 510,
                          child: FadeInAnimation(
                            child: CustomScrollView(
                              slivers: [
                                SliverPersistentHeader(
                                  floating: true,
                                  delegate: CustomSliverDelegate(
                                    expandedHeight: 300,
                                    product:
                                        context.read<ProductsCubit>().product!,
                                  ),
                                ),
                                SliverFillRemaining(
                                    child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          Constants.getScreenMargin(context)),
                                  child: ListView(
                                    physics: NeverScrollableScrollPhysics(),
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.start,
                                    // mainAxisSize: MainAxisSize.min,
                                    // physics:
                                    //     const NeverScrollableScrollPhysics(),
                                    children: [
                                      if (getProductColors().isNotEmpty)
                                        productColorsSection(
                                            appTranslations, context),
                                      if (getProductSizes().isNotEmpty)
                                        productSizesSectionByColor(
                                          color: getProductColors()[context
                                              .read<ProductsCubit>()
                                              .productColorIndex],
                                        ),
                                      if (context
                                          .read<ProductsCubit>()
                                          .getSubProducts(context)
                                          .isNotEmpty)
                                        subProductsSection(
                                          appTranslations,
                                          context,
                                        ),
                                      SizedBox(height: context.height * 0.04),
                                      Text(
                                        '${appTranslations.translate('description')!}: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: context.height * 0.01),
                                      SizedBox(
                                        width: context.width,
                                        height: context.height,
                                        child: Text(
                                          context
                                                  .read<ProductsCubit>()
                                                  .product!
                                                  .description ??
                                              '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    //!!!!!!!!!!!!!!!!!!!!!
                    Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: context.width,
                        height: context.height * 0.17,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Constants.getScreenMargin(context)),
                          decoration: BoxDecoration(
                            color: context
                                    .read<SettingsCubit>()
                                    .currentDarkModeState
                                ? AppColors.darkBackground
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowColor.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: context.width * 0.3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      appTranslations.translate('discount') ??
                                          '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${context.read<ProductsCubit>().getDiscountPrice() ?? 0.0} \$',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 16,
                                            color: Colors.green,
                                          ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${appTranslations.translate('total_price') ?? ''}: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${context.read<ProductsCubit>().getTotalPrice()} \$',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              addToCartButton(context),
                            ],
                          ),
                        ),
                      ),
                    )
                    //!!!!!!!!
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ));
        }),
      ),
    );
  }

  addToCartButton(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is AttachProductCartLoadedState) {
          if (!context.read<CartCubit>().getProductIsInCart(getProductId())) {
            //   Constants.showToast(
            //       msg: AppLocalizations.of(context)!
            //           .translate('product_added_to_cart')!);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Text(AppLocalizations.of(context)!
                        .translate('product_added_to_cart')!),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, Routes.cartScreen);
                      },
                      child: Card(
                        color: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('go_to_cart')!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.secandryColor,
              ),
            );
            _refreshCart();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!
                    .translate('product_removed_from_cart')!),
                backgroundColor: AppColors.secandryColor,
              ),
            );
            _refreshCart();
          }
        } else if (state is AttachProductCartErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0
              // horizontal: 10,
              ),
          child: SizedBox(
            width: context.width * 0.5,
            height: context.height * 0.06,
            child: DefaultButton(
                width: context.width * 0.5,
                height: context.height * 0.06,
                isLoading: state is AttachProductCartLoadingState,
                backgroudColor: context.read<CartCubit>().getProductIsInCart(
                        context.read<ProductsCubit>().product!.id!)
                    ? Colors.red
                    : AppColors.primaryColor,
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
                label: context
                            .read<CartCubit>()
                            .getProductIsInCart(getProductId()) ==
                        true
                    ? 'remove'
                    : '${AppLocalizations.of(context)!.translate('add_to_cart')}',
                onTap: () async {
                  if (context.read<ProfileCubit>().user == null) {
                    Constants.showAskToLoginDialog(context);
                    return;
                  }
                  await context
                      .read<CartCubit>()
                      .attachProductCart(
                          productId: getProductId(),
                          type: getPtoductTypeIsProductOrSize(),
                          quantity:
                              context.read<ProductsCubit>().productQuantity)
                      .then(
                    (value) {

                      if (selectedSubProducts.isNotEmpty) {
                        log('selectedSubProducts is not empty');
                        // this part to check in cart screen if the products have exstra items will show sup products under it
                        //will check if cart items list contain(productsHaveExstraItemsIdies) if true will show exstra items .
                        // now should i add new idies on old idies

                        // if productsIdiesHaveExstraItems not empty
                        List<Object?> productsIdiesHaveExstraItemsFromLocal =
                            CacheHelper.getData(
                                  key: AppSharedPreferences
                                      .productsIdiesHaveExstraItems,
                                ) ??
                                [];

                        if (productsIdiesHaveExstraItemsFromLocal.isNotEmpty) {
                          addProductsIdiesHaveSupProductsWithLocal(
                              getProductId());
                          log('productsIdiesHaveExstraItemsFromLocal is $productsIdiesHaveExstraItemsFromLocal');
                          //and then save the new list
                          CacheHelper.saveData(
                                  key: AppSharedPreferences
                                      .productsIdiesHaveExstraItems,
                                  value: productsIdiesHaveSubProducts)
                              .then((value) {
                            List<String> productsIdiesHaveExstraItems =
                                CacheHelper.getData(
                                        key: AppSharedPreferences
                                            .productsIdiesHaveExstraItems) ??
                                    [];
                            log('productsIdiesHaveExstraItems is $productsIdiesHaveExstraItems');
                          });
                        }

                        addProductsIdiesHaveSupProducts(getProductId());
                        CacheHelper.saveData(
                                key: AppSharedPreferences
                                    .productsIdiesHaveExstraItems,
                                value: productsIdiesHaveSubProducts)
                            .then((value) {
                          List<String> productsIdiesHaveExstraItems =
                              CacheHelper.getData(
                                      key: AppSharedPreferences
                                          .productsIdiesHaveExstraItems) ??
                                  [];
                          log('productsIdiesHaveExstraItems is $productsIdiesHaveExstraItems');
                        });
                      }

                      //! ======= [sub products] ======
                      for (var i = 0; i < selectedSubProducts.length; i++) {
                        log(selectedSubProducts[i].name.toString(),
                            name: 'selectedSubProducts names');
                        if (selectedSubProducts[i].id == null) {
                          log('sub product id is null');
                          return;
                        }
                        if (context
                                .read<ProductsCubit>()
                                .subProductsQuantities[i] !=
                            0) {
                          log(selectedSubProducts[i].id.toString(),
                              name: 'selectedSubProductsIdies');
                          //! Start Testing from here
                          if (!context
                              .read<CartCubit>()
                              .getProductIsInCart(selectedSubProducts[i].id!)) {
                            context
                                .read<CartCubit>()
                                .attachProductCart(
                                    productId: selectedSubProducts[i].id!,
                                    type: 'product',
                                    quantity: context
                                        .read<ProductsCubit>()
                                        .subProductsQuantities[i])
                                .then((value) {
                              // int subQuantity = context
                              //     .read<ProductsCubit>()
                              //     .subProductsQuantities[i];
                              // //TODO: add condition if subProducts if not empty i will add this product id to products ides list
                              // addProductsIdiesHaveSupProducts(selectedSubProducts[i].id!);
                              // CacheHelper.saveData(
                              //         key: AppSharedPreferences
                              //             .productsIdiesHaveExstraItems,
                              //         value: productsIdiesHaveSubProducts)
                              //     .then((value) {
                              //   List<String> productsIdiesHaveExstraItems =
                              //       CacheHelper.getData(
                              //               key: AppSharedPreferences
                              //                   .productsIdiesHaveExstraItems) ??
                              //           [];
                              //   log('productsIdiesHaveExstraItems is $productsIdiesHaveExstraItems');
                              // });
                              // log('sub product quantity is $subQuantity');
                              // log('selectedSubProductsIdes is $productsIdiesHaveSubProducts');
                              // log('sub product attached from selectedSubProducts is $selectedSubProducts ');
                            });
                          } else {
                            //please complete your order first
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('please complete your order first'
                                    // AppLocalizations.of(context)!
                                    //   .translate(
                                    //       'please_complete_your_order_first')!
                                    ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                  );

                  // //attach sub product from child product from the main product
                }),
          ),
        );
      },
    );
  }

  String getPtoductTypeIsProductOrSize() {
    if (context.read<ProductsCubit>().product!.colors!.isEmpty) {
      return 'product';
    } else {
      return 'size';
    }
  }

  Column subProductsSection(
      AppLocalizations appTranslations, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.height * 0.04),
        Text(
          '${appTranslations.translate('add_on')!}: ',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: context.height * 0.01),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...context
                  .read<ProductsCubit>()
                  .getSubProducts(context)
                  .asMap()
                  .entries
                  .map((entry) {
                var subProduct = entry.value;
                var index = entry.key;

                return ExtraItemWidget(
                  title: subProduct.name!,
                  price: context
                      .read<ProductsCubit>()
                      .getSubProductPrice(index)
                      .toInt(),
                  quantity: context
                      .read<ProductsCubit>()
                      .subProductsQuantities[index],
                  image: subProduct.images!.isNotEmpty
                      ? subProduct.images![0]
                      : 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/A_black_image.jpg/640px-A_black_image.jpg',
                  onTapAdd: () {
                    setState(() {
                      // add item in selectedSubProduct var
                      addSubProduct(subProduct);
                      log(subProduct.name.toString(), name: 'sub product name');
                      if (selectedSubProducts.isNotEmpty) {
                        // Check if index is valid before accessing the list.
                        // log('selected name: ${subProduct.name}');
                      }
                    });

                    log(' sub p idies is ${productsIdiesHaveSubProducts.length}');

                    //log subproducts ides
                    // log('sub products ides is ${getSubProductIdes()}');

                    context.read<ProductsCubit>().addSubProductPriceToTotal(
                        index: index,
                        price: context
                            .read<ProductsCubit>()
                            .getSubProductPrice(index));

                    context.read<ProductsCubit>().getTotalPrice();
                  },
                  onMinusTap: () {
                    context
                        .read<ProductsCubit>()
                        .removeSubProductPriceFromTotal(
                            index: index,
                            //TODO: change price from server
                            price: context
                                .read<ProductsCubit>()
                                .getSubProductPrice(
                                  index,
                                ));
                    context.read<ProductsCubit>().getTotalPrice();
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Column productColorsSection(
      AppLocalizations appTranslations, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.height * 0.02),
        Text(
          '${appTranslations.translate('select_your_color')!}: ',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: context.height * 0.01),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...getProductColors().asMap().entries.map((entry) {
                var color = entry.value;
                var index = entry.key;
                return InkWell(
                  onTap: () {
                    log('Start Select Color');
                    setState(() {
                      context.read<ProductsCubit>().productColorIndex = index;
                      log('selected color is ${color.color} index is $index');
                      // context.read<ProductsCubit>().resetProductData();
                      //add sub product to cart with product to order all these products
                      // context.read<ProductsCubit>().addSubProductToCart(
                      //     context.read<ProductsCubit>().product!,
                      //     getSubProducts()[index]);
                    });
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.width * 0.05,
                      margin: EdgeInsets.symmetric(
                          horizontal: context.width * 0.02),
                      decoration: BoxDecoration(
                        color: HexColor(color.color!),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check,
                        size: 15,
                        color: color ==
                                getProductColors()[context
                                    .read<ProductsCubit>()
                                    .productColorIndex]
                            ? Colors.white
                            : Colors.transparent,
                      )),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Column productSizesSection(
      AppLocalizations appTranslations, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.height * 0.02),
        Text(
          '${appTranslations.translate('sizes')!}: ',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: context.height * 0.01),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...getProductSizes().asMap().entries.map((entry) {
                var size = entry.value;
                var index = entry.key;
                return SizesWidget(
                  onTap: () {
                    log('Start Select Size');
                    setState(() {
                      selectedSize = size;
                      context.read<ProductsCubit>().productSizeIndex = index;
                      log('selected size is ${size == selectedSize}');
                      // context.read<ProductsCubit>().resetProductData();
                      //add sub product to cart with product to order all these products
                      // context.read<ProductsCubit>().addSubProductToCart(
                      //     context.read<ProductsCubit>().product!,
                      //     getSubProducts()[index]);
                    });
                  },
                  isSelected: size == selectedSize,
                  subTitle: '${size.price} \$',
                  title: ' ${size.size!} ',
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  productSizesSectionByColor({
    required ProductColor color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.height * 0.02),
        Text(
          '${AppLocalizations.of(context)!.translate('sizes')!}: ',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: context.height * 0.01),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...color.sizes!.asMap().entries.map((entry) {
                var size = entry.value;
                var index = entry.key;
                var colorIndex =
                    context.read<ProductsCubit>().productColorIndex;
                return SizesWidget(
                  onTap: () {
                    log('Start Select Size');
                    setState(() {
                      selectedSize = size;
                      context.read<ProductsCubit>().productSizeIndex = index;
                      log('selected size price is ${size.price}');
                      // context.read<ProductsCubit>().resetProductData();
                      //add sub product to cart with product to order all these products
                      // context.read<ProductsCubit>().addSubProductToCart(
                      //     context.read<ProductsCubit>().product!,
                      //     getSubProducts()[index]);
                    });
                  },
                  isSelected: size == selectedSize,
                  subTitle: '${size.price} \$',
                  title: ' ${size.size!} ',
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  List<ColorSize> getProductSizes() {
    List<ColorSize> sizes = [];
    if (context.read<ProductsCubit>().product!.colors!.isNotEmpty) {
      for (var color in context.read<ProductsCubit>().product!.colors!) {
        for (var size in color.sizes!) {
          sizes.add(size);
        }
      }
    }
    return sizes;
  }

  List<ProductColor> getProductColors() {
    List<ProductColor> colors = [];
    if (context.read<ProductsCubit>().product!.colors!.isNotEmpty) {
      for (var color in context.read<ProductsCubit>().product!.colors!) {
        colors.add(color);
      }
    }
    return colors;
  }

  getProductId() {
    if (context.read<ProductsCubit>().product!.colors!.isEmpty) {
      return context.read<ProductsCubit>().product!.id;
    } else {
      return context
          .read<ProductsCubit>()
          .product!
          .colors![context.read<ProductsCubit>().productColorIndex]
          .sizes![context.read<ProductsCubit>().productSizeIndex]
          .id;
    }
  }

//   List<int> getSubProductIdes() {
//     // Create a Set to store unique IDs.
//     Set<int> subProductIds = Set();

//     // Iterate through selectedSubProducts and add their IDs to the Set.
//     for (var subProduct in selectedSubProducts) {
//       subProductIds.add(subProduct.id!);
//     }

//     // Convert the Set back to a List if needed.
//     List<int> uniqueIdsList = subProductIds.toList();

//     return uniqueIdsList;
//   }
}

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  final Product product;

  CustomSliverDelegate({
    required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
    required this.product,
  });

  int count = 0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var translator = AppLocalizations.of(context)!;
    final appBarSize = expandedHeight - shrinkOffset;
    final cardTopPosition = expandedHeight / 1.1 - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    return SizedBox(
      height: expandedHeight + expandedHeight / 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black38
            : Colors.white,
        body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300,
                    systemOverlayStyle:
                        Theme.of(context).brightness == Brightness.dark
                            ? SystemUiOverlayStyle.light
                            : SystemUiOverlayStyle.dark,
                    leading: IconButton(
                      icon: Platform.isIOS
                          ? const Icon(Icons.arrow_back_ios)
                          : const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    actions: [
                      BlocConsumer<FavoriteCubit, FavoriteState>(
                        listener: (context, state) {
                          if (state is AddFavoriteLoadingState) {
                            const Material(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (state is AddFavoriteLoadedState) {
                            context.read<FavoriteCubit>().getFavoriteProducts();
                          }
                          if (state is DeleteFavoriteLoadedState) {
                            context.read<FavoriteCubit>().getFavoriteProducts();
                          }
                          if (state is GetFavoriteProductsLoadedState) {
                            context
                                .read<FavoriteCubit>()
                                .favoriteProducts
                                .forEach((element) {
                              if (element.id == product.id) {
                                context.read<FavoriteCubit>().isFavorite = true;
                              }
                            });
                            log('is favorite is ${context.read<FavoriteCubit>().isFavorite}');
                          }
                        },
                        builder: (context, state) {
                          return IconButton(
                            icon: context
                                    .read<FavoriteCubit>()
                                    .getIsFavoriteProduct(product.id!)
                                ? Icon(
                                    Icons.favorite,
                                    color: AppColors.primaryColor,
                                  )
                                : const Icon(Icons.favorite_border),
                            onPressed: () {
                              if (context.read<ProfileCubit>().user == null) {
                                Constants.showAskToLoginDialog(context);
                                return;
                              }
                              if (context
                                  .read<FavoriteCubit>()
                                  .getIsFavoriteProduct(product.id!)) {
                                context.read<FavoriteCubit>().deleteFavorite(
                                    type: 'product', productId: product.id!);

                                context
                                    .read<FavoriteCubit>()
                                    .getIsFavoriteProduct(product.id!);
                              } else {
                                context.read<FavoriteCubit>().addToFavorite(
                                    type: 'product', productId: product.id!);
                                context
                                    .read<FavoriteCubit>()
                                    .getIsFavoriteProduct(product.id!);
                              }
                            },
                          );
                        },
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      expandedTitleScale: 1,
                      titlePadding: EdgeInsetsDirectional.only(
                        bottom: context.height * 0.07,
                      ),
                      title: CounterWidget(
                        count: context.read<ProductsCubit>().productQuantity,
                        onDecrement: () {
                          setState(() {
                            context
                                .read<ProductsCubit>()
                                .decrementProductQuantity();
                            context.read<ProductsCubit>().getTotalPrice();
                          });
                        },
                        onIncrement: () {
                          setState(() {
                            context
                                .read<ProductsCubit>()
                                .incrementProductQuantity();
                            context.read<ProductsCubit>().getTotalPrice();
                          });
                        },
                      ),
                      background: ProductImagesSliderWidget(
                        banners: getProductImages(),
                      ),

                      // Image(
                      //   image: NetworkImage(
                      //     product.images.isNotEmpty
                      //         ? product.images[0]
                      //         : 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/A_black_image.jpg/640px-A_black_image.jpg',
                      //   ),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                ],
              ),
              //! Card between appbar and body
              Positioned(
                left: 0.0,
                right: 0.0,
                top: cardTopPosition > 0 ? cardTopPosition : 0,
                bottom: 10,
                child: Opacity(
                  opacity: percent,
                  child: Container(
                      width: context.width,
                      height: context.height * 0.2,
                      decoration: BoxDecoration(
                        color:
                            context.read<SettingsCubit>().currentDarkModeState
                                ? AppColors.appAccentDarkColor
                                : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(context.width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Text(
                                  product.name!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${context.read<ProductsCubit>().getProductPrice(prdoductSizeIndex: context.read<ProductsCubit>().productSizeIndex) ?? ''} \$',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons/star-rate.svg'),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${product.rate}.0',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(
                                  getProductQuantity() != null
                                      ? getProductQuantity()! > 0
                                          ? translator.translate('available')!
                                          : translator
                                              .translate('not_available')!
                                      : translator.translate('available')!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: getProductQuantity() != null
                                            ? getProductQuantity()! > 0
                                                ? AppColors.avilableColor
                                                : AppColors.notAvilableColor
                                            : AppColors.avilableColor,
                                      ),
                                ),
                              ],
                            ),
                            Constants.getRichText(
                              context,
                              textBody: '${translator.translate('Quantity')}: ',
                              highlightText: '${getProductQuantity()}',
                              highLightcolor: AppColors.hintColor,
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  int? getProductQuantity() {
    if (product.colors!.isEmpty) {
      return product.quantity;
    } else {
      for (var color in product.colors!) {
        if (color.sizes!.isNotEmpty) {
          for (var size in color.sizes!) {
            return size.quantity;
          }
        }
      }
    }
    return null;
  }

//get product images
  List<String> getProductImages() {
    List<String> images = [];
    if (product.colors!.isEmpty) {
      for (var image in product.images) {
        images.add(image);
      }
    } else {
      for (var color in product.colors!) {
        for (var image in color.images!) {
          images.add(image);
        }
      }
    }
    return images;
  }

  @override
  double get maxExtent => expandedHeight + expandedHeight / 2;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
