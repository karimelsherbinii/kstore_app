import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kstore/config/locale/app_localizations.dart';
import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/assets_manager.dart';
import 'package:kstore/core/utils/hex_color.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/core/widgets/buttons/default_button.dart';
import 'package:kstore/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:kstore/features/cetegories/domain/entities/category.dart';
import 'package:kstore/features/cetegories/presentation/cubit/categories_cubit.dart';
import 'package:kstore/features/products/presentation/cubit/category_products/category_products_cubit.dart';
import 'package:transparent_image/transparent_image.dart';

class SecondProductItem extends StatefulWidget {
  final String name;
  final String imgPath;
  final String price;
  final String description;
  final String rate;
  final bool avilability;
  final Function()? onAddToCartTap;
  final Function()? onProductTap;
  final double? height;
  final double? width;
  final String bottonLable;
  bool addedToCart;
  final Category category;

  SecondProductItem(
      {super.key,
      required this.name,
      required this.imgPath,
      required this.price,
      required this.description,
      required this.rate,
      this.onAddToCartTap,
      required this.avilability,
      this.height,
      this.width,
      required this.bottonLable,
      required this.addedToCart,
      this.onProductTap,
      required this.category});

  @override
  State<SecondProductItem> createState() => _SecondProductItemState();
}

class _SecondProductItemState extends State<SecondProductItem> {
  _getCategoryProducts() =>
      BlocProvider.of<CategoryProductsCubit>(context).getProductsByCategory(
        categoryId: widget.category.id!,
      );
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onProductTap,
      child: Container(
        height: widget.height ?? context.height * 0.16,
        width: widget.width ?? context.width * 0.9,
        margin: EdgeInsets.only(
          bottom: context.height * 0.015,
        ),
        padding: EdgeInsets.symmetric(
            horizontal: context.width * 0.04, vertical: context.height * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: context.width * 0.27,
              height: context.height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    width: context.width * 0.27,
                    image: widget.imgPath,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        widget.imgPath,
                      );
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: context.width * 0.04,
            ),
            SizedBox(
              width: context.width * 0.48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: context.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: context.width * 0.4,
                          child: Text(widget.name,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: context.width * 0.0025,
                                  )),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: context.height * 0.04,
                          child: Row(
                            children: [
                              SvgPicture.asset(AppImageAssets.starRateIcon),
                              Text(widget.rate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: context.width * 0.0015,
                                        color: AppColors.hintColor,
                                      )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: context.width * 0.4,
                    child: Text(
                      widget.description,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(),
                      maxLines: widget.height! > context.height * 0.16 ? 2 : 1,
                    ),
                  ),
                  const Spacer(),
                  //avilabilaty
                  Text(
                    widget.avilability ? 'In Stock' : 'Out of Stock',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: widget.avilability
                            ? AppColors.avilableColor
                            : AppColors.notAvilableColor),
                  ),
                  SizedBox(
                    width: context.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: context.width * 0.2,
                          child: Text(widget.price,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: context.width * 0.0025,
                                  )),
                        ),
                        const Spacer(),
                        !widget.addedToCart
                            ? BlocConsumer<CartCubit, CartState>(
                                listener: (context, state) {
                                  if (state is AttachProductCartLoadedState) {
                                    setState(() {
                                      widget.addedToCart = true;
                                    });
                                    context.read<CartCubit>().getCartProducts();
                                  }
                                  if (state is AttachProductCartErrorState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return DefaultButton(
                                      isLoading: state
                                          is AttachProductCartLoadingState,
                                      width: context.width * 0.2,
                                      height: context.height * 0.04,
                                      backgroudColor: Colors.white,
                                      borderRadius: 10,
                                      textSize: 14,
                                      textColor: Colors.black,
                                      border: Border.all(
                                          color: HexColor('#F2F2F2')),
                                      fontWeight: FontWeight.w700,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.shadowColor
                                              .withOpacity(0.1),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      label: widget.bottonLable,
                                      onTap: widget.onAddToCartTap);
                                },
                              )
                            : const Icon(Icons.done, color: Colors.green),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
