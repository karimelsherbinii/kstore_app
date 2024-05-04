import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/core/utils/app_localization_strings.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/widgets/loading_indicator.dart';
import 'package:kstore/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:kstore/features/cetegories/domain/entities/category.dart';
import 'package:kstore/features/products/domain/entities/product.dart';
import 'package:kstore/features/products/presentation/cubit/products_cubit.dart';
import 'package:kstore/features/profile/presentation/cubit/profile_cubit.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/widgets/products/second_product_item.dart';
import '../../../products/presentation/cubit/category_products/category_products_cubit.dart';
import '../cubit/categories_cubit.dart';

class CategoryProductsScreen extends StatefulWidget {
  final Category category; //final Category category;
  const CategoryProductsScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  void _setupScrollController(context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0 &&
            BlocProvider.of<CategoryProductsCubit>(context).pageNo <=
                BlocProvider.of<CategoryProductsCubit>(context).totalPages) {
          _getCategoryProducts();
        }
      }
    });
  }

  _getCategoryProducts() =>
      BlocProvider.of<CategoryProductsCubit>(context).getProductsByCategory(
        categoryId: widget.category.id!,
      );

  @override
  void initState() {
    super.initState();
    context.read<CategoryProductsCubit>().clearData();
    _getCategoryProducts();
    _setupScrollController(context);
  }

  @override
  void deactivate() {
    super.deactivate();
    context.read<CategoriesCubit>().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Constants.getAppBar(context, title: widget.category.name!),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.055),
            child: buildProducts(),
          ),
        ));
  }

  buildProducts() {
    var translator = AppLocalizations.of(context)!;
    return BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
      builder: (context, state) {
        if (state is CategoryProductsLoading && state.isFirstFetch) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        }
        if (state is CategoryProductsLoading) {
          BlocProvider.of<CategoryProductsCubit>(context).loadMore = true;
        }
        if (state is CategoryProductsError) {
          return Expanded(
            child: Center(
              child: Text(state.message),
            ),
          );
        }
        log(context.read<CategoryProductsCubit>().products.length.toString());
        return
            //  Expanded(
            //   child: context.read<CategoryProductsCubit>().products.isNotEmpty
            //       ?
            Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: context.read<CategoryProductsCubit>().products.length +
                (context.read<CategoryProductsCubit>().loadMore ? 1 : 0),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if (index <
                  context.read<CategoryProductsCubit>().products.length) {
                return SecondProductItem(
                  category: widget.category,
                  onProductTap: () => Navigator.pushNamed(
                    context,
                    Routes.productDetails,
                    arguments: context
                        .read<CategoryProductsCubit>()
                        .products[index]
                        .id,
                  ),
                  height: context.height * 0.18,
                  onAddToCartTap: () async {
                    if (context.read<ProfileCubit>().user == null) {
                      Constants.showAskToLoginDialog(context);
                      return;
                    }
                    await context.read<CartCubit>().attachProductCart(
                        productId: context
                            .read<CategoryProductsCubit>()
                            .products[index]
                            .id!,
                        type: getPtoductTypeIsProductOrSize(index),
                        quantity:
                            context.read<ProductsCubit>().productQuantity);
                  },
                  name: context
                      .read<CategoryProductsCubit>()
                      .products[index]
                      .name!,
                  price: Constants.getProductPriceByCategory(index, context),
                  rate: context
                      .read<CategoryProductsCubit>()
                      .products[index]
                      .rate
                      .toString(),
                  imgPath: context
                          .read<CategoryProductsCubit>()
                          .products[index]
                          .images
                          .isNotEmpty
                      ? context
                          .read<CategoryProductsCubit>()
                          .products[index]
                          .images[0]
                      : "",
                  avilability: context
                          .read<CategoryProductsCubit>()
                          .products[index]
                          .quantity! >
                      0,
                  bottonLable:
                      translator.translate(AppLocalizationStrings.add)!,
                  description: context
                      .read<CategoryProductsCubit>()
                      .products[index]
                      .description!,
                  addedToCart: context.read<CartCubit>().getProductIsInCart(
                        context
                            .read<CategoryProductsCubit>()
                            .products[index]
                            .id!,
                      ),
                );
              } else if (BlocProvider.of<CategoryProductsCubit>(context)
                      .pageNo <=
                  BlocProvider.of<CategoryProductsCubit>(context).totalPages) {
                Timer(const Duration(milliseconds: 30), () {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });
                return const LoadingIndicator();
              } else {
                return const SizedBox();
              }
            },
          ),
        );
        // : NoData(
        //     msg: translator
        //         .translate(AppLocalizationStrings.noProductsFound),
        //   ),
        // );
      },
    );
  }

  // getProductId() {
  //   if (context.read<CategoryProductsCubit>().product!.colors!.isEmpty) {
  //     return context.read<ProductsCubit>().product!.id;
  //   } else {
  //     return context
  //         .read<ProductsCubit>()
  //         .product!
  //         .colors![context.read<ProductsCubit>().productColorIndex]
  //         .sizes![context.read<ProductsCubit>().productSizeIndex]
  //         .id;
  //   }
  // }

  String getPtoductTypeIsProductOrSize(int index) {
    Product product = context.read<CategoryProductsCubit>().products[index];
    if (product.colors!.isEmpty) {
      return 'product';
    } else {
      return 'size';
    }
  }
}
