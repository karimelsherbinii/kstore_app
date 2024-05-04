// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kstore/core/utils/app_colors.dart';
import 'package:kstore/core/utils/media_query_values.dart';
import 'package:kstore/features/orders/domain/entities/order_product.dart';
import 'package:kstore/features/products/domain/entities/child_product.dart';
import 'package:kstore/features/products/presentation/widgets/exrta_item_widget.dart';

import '../../../../core/widgets/counter_widget.dart';
import '../../../products/presentation/cubit/products_cubit.dart';
import '../cubit/cart_cubit.dart';

class CartItem extends StatefulWidget {
  final int id;
  final String name;
  final String imgPath;
  final String price;
  final String description;
  final String rate;
  final String avilability;
  final Function()? onTap;
  final bool haveExtraItems;
  final List<OrderProduct>? extraItems;
  int quantity;
  final Function(DismissDirection)? onRemoveItem;

  CartItem({
    Key? key,
    required this.id,
    required this.name,
    required this.imgPath,
    required this.price,
    required this.description,
    required this.rate,
    required this.avilability,
    this.onTap,
    this.haveExtraItems = false,
    this.extraItems,
    required this.quantity,
    this.onRemoveItem,
  }) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        log('extra items: ${widget.extraItems}');
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: widget.onRemoveItem,
          background: Container(
            padding: EdgeInsets.only(right: context.width * 0.05),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            ),
          ),
          child: Container(
            height: widget.haveExtraItems
                ? widget.extraItems!.length > 2
                    ? MediaQuery.of(context).size.height * 0.4
                    : context.height * 0.25
                : MediaQuery.of(context).size.height * 0.13,
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.13),
            width: context.width * 0.9,
            margin: EdgeInsets.only(
              bottom: context.height * 0.015,
            ),
            padding: EdgeInsets.all(context.width * 0.03),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: context.height * 0.01),
                SizedBox(
                  height: context.height * 0.08,
                  child: Row(
                    children: [
                      SizedBox(
                        width: context.width * 0.18,
                        height: context.height * 0.08,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)),
                            child: Image.network(
                              widget.imgPath,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: context.width * 0.04,
                      ),
                      SizedBox(
                        width: context.width * 0.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: context.width,
                              child: SizedBox(
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
                            ),
                            const Spacer(),
                            SizedBox(
                              width: context.width,
                              child: SizedBox(
                                width: context.width * 0.2,
                                child: Text('\$${widget.price}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          // letterSpacing: context.width * 0.0025,
                                        )),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.width * 0.02,
                            vertical: context.height * 0.01),
                        child: Text(
                          '${widget.quantity}',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: context.width * 0.0025,
                                  ),
                        ),
                      )
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: SizedBox(
                      //       child: CounterWidget(
                      //     width: context.width * 0.28,
                      //     count:
                      //         context.read<CartCubit>().getQuantityForProduct(
                      //               widget
                      //                   .id, // context.read<CartCubit>().productQuantity,
                      //             ),
                      //     haveShadow: true,
                      //     onDecrement: () {
                      //       setState(() {
                      //         context
                      //             .read<CartCubit>()
                      //             .decrementProductQuantity();
                      //         context
                      //             .read<CartCubit>()
                      //             .getCartProductsTotalPrice();
                      //       });
                      //     },
                      //     onIncrement: () {
                      //       setState(() {
                      //         context
                      //             .read<CartCubit>()
                      //             .incrementProductQuantity();
                      //         context
                      //             .read<CartCubit>()
                      //             .getCartProductsTotalPrice();
                      //       });
                      //     },
                      //   )),
                      // )
                    ],
                  ),
                ),
                const Spacer(),
                // haveExtraItems
                //     ?
                //Row of extra item with price
                widget.haveExtraItems
                    ? BlocBuilder<CartCubit, CartState>(
                        builder: (context, state) {
                          return Wrap(
                              runSpacing: 20,
                              direction: Axis.horizontal,
                              children: [
                                ...widget.extraItems!.map((item) {
                                  log('Exstraitem: $item');
                                  return SizedBox(
                                    width: context.width * 0.3,
                                    child: Row(
                                      children: [
                                        ExtraItemWidget(
                                          fromCart: true,
                                          width: context.width * 0.15,
                                          height: context.height * 0.07,
                                          quantity: context
                                              .read<CartCubit>()
                                              .getQuantityForProduct(
                                                item.id!,
                                              ),
                                          haveAddButton: false,
                                          title: item.name!,
                                          image: item.images!.isNotEmpty
                                              ? item.images![0]
                                              : '',
                                          onTap: () {},
                                        ),
                                        const Spacer(),
                                        Text(
                                          '\$${item.price}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing:
                                                    context.width * 0.0025,
                                              ),
                                        )
                                      ],
                                    ),
                                  );
                                })
                              ]);
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}
