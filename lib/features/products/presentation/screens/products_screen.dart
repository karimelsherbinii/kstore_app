import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/config/routes/app_routes.dart';
import 'package:kstore/core/utils/app_localization_strings.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/widgets/loading_indicator.dart';
import 'package:kstore/core/widgets/product_item_widget.dart';
import 'package:kstore/features/products/presentation/cubit/products_cubit.dart';
import 'package:kstore/features/settings/presentation/cubit/settings_cubit.dart';
import '../../../../core/widgets/error_widget.dart' as errorWidget;
import '../../../../core/utils/app_colors.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  _getProducts() async {
    await BlocProvider.of<ProductsCubit>(context)
        .getProducts(sortOrder: 'desc', sortBy: 'created_at');
  }

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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductsCubit>(context).clearData();
    _getProducts();
    _setupScrollController(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.getAppBar(
        context,
        title: AppLocalizations.of(context)!
            .translate(AppLocalizationStrings.products)!,
        haveLeading: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(Constants.getScreenMargin(context)),
        child: Container(
            color: context.read<SettingsCubit>().currentDarkModeState
                ? AppColors.darkBackground
                : Colors.white,
            child: buildProducts(context)),
      ),
    );
  }

  buildProducts(BuildContext context) {
    // var translator = AppLocalizations.of(context)!;
    return BlocBuilder<ProductsCubit, ProductsState>(builder: (context, state) {
      if (state is GetProductsLoadingState && state.isFirstFetch) {
        return const LoadingIndicator();
      }
      if (state is GetProductsLoadingState) {
        context.read<ProductsCubit>().loadMore = true;
      } else if (state is GetProductsErrorState) {
        return errorWidget.ErrorWidget(
          onRetryPressed: () => _getProducts(),
          msg: state.message,
        );
      }

      return ListView.separated(
        controller: _scrollController,
        separatorBuilder: (context, index) =>
            index != 0 ? const SizedBox(height: 20) : const SizedBox(),
        itemCount: context.read<ProductsCubit>().products.length +
            (context.read<ProductsCubit>().loadMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < BlocProvider.of<ProductsCubit>(context).products.length) {
            return getProductCategoryName(index) != 'Sub Products'
                ? ProductItemWidget(
                    name: context.read<ProductsCubit>().products[index].name!,
                    price: Constants.getProductPrice(index, context),
                    rate:
                        '${context.read<ProductsCubit>().products[index].rate}.0',
                    image: context
                            .read<ProductsCubit>()
                            .products[index]
                            .images
                            .isNotEmpty
                        ? context
                            .read<ProductsCubit>()
                            .products[index]
                            .images[0]
                        : '',
                    onTap: () => Navigator.pushNamed(
                        context, Routes.productDetails,
                        arguments:
                            context.read<ProductsCubit>().products[index].id),
                  )
                : const SizedBox();
          } else if (BlocProvider.of<ProductsCubit>(context).pageNo <=
              BlocProvider.of<ProductsCubit>(context).totalPages) {
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

  getProductCategoryName(int index) {
    if (context.read<ProductsCubit>().products[index].categories!.isEmpty)
      return '';
    return context.read<ProductsCubit>().products[index].categories![0].name;
  }
}
