import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/core/api/cach_helper.dart';
import 'package:kstore/core/usecases/usecase.dart';
import 'package:kstore/features/cetegories/domain/entities/category.dart';
import 'package:kstore/features/orders/domain/entities/order_product.dart';
import 'package:kstore/features/orders/domain/entities/order_products.dart';
import 'package:kstore/features/products/domain/entities/child_product.dart';
import 'package:kstore/features/products/presentation/cubit/products_cubit.dart';

import '../../domain/usecases/attach_product_cart.dart';
import '../../domain/usecases/get_cart_products.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartProducts getCartProductsUseCase;
  final AttachProductCart attachProductCartUseCase;

  CartCubit({
    required this.getCartProductsUseCase,
    required this.attachProductCartUseCase,
  }) : super(CartInitial());

  List<OrderProducts> cartProducts = [];
  int productQuantity = 0;
  double totalPrice = 0.0;
  double discountPrice = 0.0;
  List<OrderProduct> subProducts = [];
  List<Category> categories = [];
  //products idies have exstra items = List<int>
  // List<String> productsIdiesHaveExstraItems =
  //     CacheHelper.getData(key: 'productsIdiesHaveExstraItems') ?? [];

  // saveProductsIdiesHaveExstraItemsToCache({
  //   required List<int> productsIdies,
  // }) {
  //   productsIdiesHaveExstraItems.clear();
  //   CacheHelper.saveData(
  //     key: 'productsIdiesHaveExstraItems',
  //     value: productsIdies,
  //   );
  //   emit(ProductsIdiesHaveExstraItemsSavedState());
  // }

  Future<void> attachProductCart({
    required int productId,
    required int quantity,
    required String type,
  }) async {
    emit(AttachProductCartLoadingState());
    final result = await attachProductCartUseCase(AttachProductCartParams(
      productId: productId,
      quantity: quantity,
      type: type,
    ));
    result.fold(
      (failure) => emit(AttachProductCartErrorState(message: failure.message!)),
      (response) {
        emit(AttachProductCartLoadedState());
      },
    );
  }

  Future<void> getCartProducts() async {
    emit(GetCartProductsLoadingState());
    final result = await getCartProductsUseCase(NoParams());
    result.fold(
      (failure) => emit(GetCartProductsErrorState(message: failure.message!)),
      (response) {
        cartProducts.clear();
        cartProducts.addAll(response.data);
        emit(GetCartProductsLoadedState(products: response.data));
      },
    );
  }

  // getCartQuantityForEveryProduct() {

  //   emit(CartProductsQuantityChangedState());
  // }

  int getQuantityForProduct(int productId) {
    final item = cartProducts.firstWhere(
        (item) => item.orderProduct!.id == productId,
        orElse: () => const OrderProducts());
    return item.quantity ?? 0;
  }

  getDiscountPriceOfCartProdcts() {
    log(totalPrice.toString(), name: 'totalPrice');
    if (cartProducts.isNotEmpty) {
      for (var element in cartProducts) {
        discountPrice += element.orderProduct!.discount! * element.quantity!;
      }
    }
    emit(DiscountPriceOfCartProdctsChangedState());
  }

  getCartProductsTotalPrice() {
    totalPrice = 0.0;
    if (cartProducts.isNotEmpty) {
      for (var element in cartProducts) {
        if (element.orderProduct!.discount != null) {
          totalPrice +=
              (element.orderProduct!.price! - element.orderProduct!.discount!) *
                  element.quantity!;
          log(totalPrice.toString(), name: 'totalPriceAftersub');
          // totalPrice += subProductPrice;//TODO: add sub product price
        } else {
          totalPrice += element.orderProduct!.price! * element.quantity!;
        }
      }
    }
    emit(CartProductsTotalPriceChangedState());
  }

  incrementProductQuantity() {
    productQuantity++;
    log(productQuantity.toString(), name: 'cartProductQuantity');
    log(totalPrice.toString(), name: 'cartTotalPrice');
    emit(CartProductQuantityChangedState());
  }

  decrementProductQuantity() {
    if (productQuantity == 1) return;
    productQuantity--;
    emit(CartProductQuantityChangedState());
  }

  getProductIsInCart(int productId) {

    return cartProducts.any((element) {
      log(element.orderProduct!.id.toString(), name: 'isInCart');
      return element.orderProduct!.id == productId;
    });
  }

  // getSubProductIsInCart(int productId) {
  //   return subProducts.any((element) {
  //     log(element.id.toString(), name: 'isInCart');
  //     return element.id == productId;
  //   });
  // }

  List<OrderProduct> getCartProductsByProductId(int productId) {
    return cartProducts
        .where((element) => element.orderProduct!.id == productId)
        .map((e) => e.orderProduct!)
        .toList();
  }

//===================== [sub products] ======================
// getSubProductFrom any product by id
  List<OrderProduct> getSubProductsFromProductById(
      {required BuildContext context, required int productId}) {
    // check if the sub product is have category name
    if (context.read<CartCubit>().categories.isNotEmpty) {
      if (context.read<CartCubit>().categories[0].name == 'Sub Products') {
        // get the sub products from the cart products
        for (var i = 0;
            i < context.read<CartCubit>().cartProducts.length;
            i++) {
          if (context
              .read<CartCubit>()
              .cartProducts[i]
              .orderProduct!
              .categories!
              .isNotEmpty) {
            if (context
                    .read<CartCubit>()
                    .cartProducts[i]
                    .orderProduct!
                    .categories![0]
                    .name ==
                'Sub Products') {
              context
                  .read<CartCubit>()
                  .subProducts
                  .add(context.read<CartCubit>().cartProducts[i].orderProduct!);
            }
          }
        }
      }
    }
    emit(GetSubProductsFromProductByIdState());
    return context.read<CartCubit>().subProducts;
  }

//   List<int> subProductsQuantities = List<int>.filled(500, 0, growable: false);
//   double subProductPrice = 0.0;
//   subProductQuantityByIndex(int index) {}
//   addSubProductPriceToTotal({
//     double price = 5,
//     required int index,
//   }) {
//     subProductPrice += price;
//     subProductsQuantities[index] += 1;

//     emit(AddSubProductPriceToTotalState());
//   }

//   removeSubProductPriceFromTotal({
//     double price = 5,
//     required int index,
//   }) {
//     if (subProductsQuantities[index] == 0) return;
//     subProductPrice -= price;
//     subProductsQuantities[index] -= 1;
//     emit(RemoveSubProductPriceFromTotalState());
//   }

//   List<ChildProduct> subProducts = [];

//   List<ChildProduct> getSubProducts(BuildContext context , int index) {
//     subProducts.clear();
//     if (context.read<CartCubit>().cartProducts.isNotEmpty) {
//       for (var element in context.read<CartCubit>().cartProducts[index].orderProduct.
//     }

//     return subProducts;
//   }

// // this sub product is will be not have sizes 😎
//   double getSubProductPrice(int index) {
//     if (subProducts.isNotEmpty) {
//       // subProductPrice = subProducts[index].price!.toDouble();
//       return subProducts[index].price!.toDouble();
//     }
//     return 0.0;
//   }

//   attachSubProductToCart({
//     required int index,
//   }) async {
//     emit(AttachSubProductToCartLoadingState());
//     final result = await attachProductCartUseCase(AttachProductCartParams(
//       productId: subProducts[index].id!,
//       quantity: subProductsQuantities[index],
//       type: 'product',
//     ));
//     result.fold(
//       (failure) => emit(AttachSubProductToCartErrorState(
//         message: failure.message!,
//       )),
//       (response) {
//         emit(AttachSubProductToCartLoadedState(index: index));
//       },
//     );
//   }

//===================== [End sub products] ======================

  resetCart() {
    cartProducts.clear();
    subProducts.clear();
    productQuantity = 0;
    totalPrice = 0.0;
    discountPrice = 0.0;
    emit(CartResetState());
  }
}
