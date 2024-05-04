import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/features/cart/presentation/cubit/cart_cubit.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/widgets/product_item_widget.dart';
import '../../../products/presentation/cubit/products_cubit.dart';

class BuildReCommendedItemsWidgets extends StatefulWidget {
  final bool isViewAll;
  const BuildReCommendedItemsWidgets({
    Key? key,
    required this.isViewAll,
  }) : super(key: key);

  @override
  State<BuildReCommendedItemsWidgets> createState() =>
      _BuildReCommendedItemsWidgetsState();
}

class _BuildReCommendedItemsWidgetsState
    extends State<BuildReCommendedItemsWidgets> {
  _getProducts() => BlocProvider.of<ProductsCubit>(context).getProducts();
  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(builder: (context, state) {
      var products = context.read<ProductsCubit>().products;
      if (products.isEmpty && state is GetCartProductsLoadedState) {
        return Center(
            child: Text(
                AppLocalizations.of(context)!.translate('no_products_found')!));
      }
      return ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          width: context.width * 0.04,
        ),
        scrollDirection: widget.isViewAll ? Axis.vertical : Axis.horizontal,
        itemCount: products.length,
        physics: widget.isViewAll ? const NeverScrollableScrollPhysics() : null,
        itemBuilder: (context, index) {
          return SizedBox(
            // height: context.height * 0.22,
            child: getProductCategoryName(index) != 'Sub Products'
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
                : const SizedBox(),
          );
        },
      );
    });
  }

  getProductCategoryName(int index) {
    if (context.read<ProductsCubit>().products[index].categories!.isNotEmpty) {
      return context.read<ProductsCubit>().products[index].categories![0].name;
    } else {
      return 'Products';
    }
  }
}
