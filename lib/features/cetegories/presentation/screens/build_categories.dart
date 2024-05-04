import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/core/utils/constants.dart';
import 'package:kstore/features/cetegories/presentation/cubit/categories_state.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../home/presentation/widgets/category_item_widget.dart';
import '../../../products/presentation/cubit/category_products/category_products_cubit.dart';
import '../cubit/categories_cubit.dart';

class BuildCategoriesWidgets extends StatefulWidget {
  final bool isGrid;

  const BuildCategoriesWidgets({
    Key? key,
    required this.isGrid,
  }) : super(key: key);

  @override
  State<BuildCategoriesWidgets> createState() => _BuildCategoriesWidgetsState();
}

class _BuildCategoriesWidgetsState extends State<BuildCategoriesWidgets> {
  // _getCategories() async {
  //   BlocProvider.of<CategoryProductsCubit>(context).clearData();
  //   await BlocProvider.of<CategoriesCubit>(context).getCategories();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // _getCategories();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
      if (state is GetCategoriesError) {
        return Center(
          child: Text(state.msg),
        );
      }
      if (state is GetCategoriesLoaded) {
        if (state.categories.isEmpty) {
          return Center(
              child: Text(AppLocalizations.of(context)!
                  .translate('no_categories_found')!));
        }

        return widget.isGrid
            ? Wrap(
                children: state.categories
                    .map(
                      (category) => category.name == 'Sub Products'
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CategoryItemWidget(
                                isGrid: widget.isGrid,
                                categoryName: category.name!,
                                image: category.images!.isNotEmpty
                                    ? category.images![0]
                                    : testGreyImage,
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    Routes.categoryProductsScreen,
                                    arguments: category,
                                  );
                                },
                              ),
                            ),
                    )
                    .toList(),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  width: 20,
                ),
                itemCount: context.read<CategoriesCubit>().categories.length,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return context
                              .read<CategoriesCubit>()
                              .categories[index]
                              .name ==
                          'Sub Products'
                      ? Container()
                      : CategoryItemWidget(
                          isGrid: widget.isGrid,
                          categoryName: context
                              .read<CategoriesCubit>()
                              .categories[index]
                              .name!,
                          image: context
                                  .read<CategoriesCubit>()
                                  .categories[index]
                                  .images!
                                  .isNotEmpty
                              ? context
                                  .read<CategoriesCubit>()
                                  .categories[index]
                                  .images![0]
                              : testGreyImage,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              Routes.categoryProductsScreen,
                              arguments: context
                                  .read<CategoriesCubit>()
                                  .categories[index],
                            );
                          },
                        );
                },
              );
      } else {
        return Container();
      }
    });
  }
}
