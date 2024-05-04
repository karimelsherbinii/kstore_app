import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/widgets/default_widget_tree.dart';
import 'package:kstore/core/widgets/loading_indicator.dart';
import 'package:kstore/features/home/presentation/widgets/search_widget.dart';
import 'package:kstore/features/products/presentation/cubit/products_cubit.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/widgets/products/product_item_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ScrollController _scrollController = ScrollController();
  void _setupScrollController(context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0 &&
            BlocProvider.of<ProductsCubit>(context).pageNo <=
                BlocProvider.of<ProductsCubit>(context).totalPages) {
          _getProducts();
        }
      }
    });
  }

  _getProducts() async {
    await context.read<ProductsCubit>().getProducts();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductsCubit>(context).clearData();
    _getProducts();
    _setupScrollController(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Constants.getScreenMargin(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const SearchWidget(),
                const SizedBox(height: 20),
                Text(
                    '${AppLocalizations.of(context)!.translate('search_results')}'),
                const SizedBox(height: 10),
                SizedBox(
                  height: context.height - context.height * 0.2,
                  child: buildSearchResultItems(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildSearchResultItems(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetProductsLoadingState && state.isFirstFetch) {
            return const LoadingIndicator();
          }
          if (state is GetProductsLoadingState) {
            BlocProvider.of<ProductsCubit>(context).loadMore = true;
          } else if (state is GetProductsErrorState) {
            return Center(
              child: Text(state.message),
            );
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: context.read<ProductsCubit>().products.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index < context.read<ProductsCubit>().products.length) {
                return SizedBox(
                  height: context.height * 0.2,
                  child: ProductItemWidget(
                    name: context.read<ProductsCubit>().products[index].name!,
                    price: Constants.getProductPrice(index, context),
                    rate:
                        '${context.read<ProductsCubit>().products[index].rate}.0',
                    image:
                        context.read<ProductsCubit>().products[index].images[0],
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.productDetails,
                        arguments:
                            context.read<ProductsCubit>().products[index].id,
                      );
                    },
                  ),
                );
              } else if (BlocProvider.of<ProductsCubit>(context).loadMore) {
                Timer(const Duration(milliseconds: 30), () {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });

                return const LoadingIndicator();
              }
              return const SizedBox();
            },
          );
        });
  }
}
