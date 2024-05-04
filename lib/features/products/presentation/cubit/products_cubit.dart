import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kstore/core/api/responses/base_response.dart';
import 'package:kstore/core/error/failures.dart';
import 'package:kstore/features/products/domain/entities/child_product.dart';
import 'package:kstore/features/products/domain/usecases/get_products.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/get_category_products.dart';
import '../../domain/usecases/get_product.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProducts getProductsUseCase;
  final GetCategoryProducts getCategoryProductsUseCase;
  final GetProduct getProductUseCase;

  ProductsCubit({
    required this.getProductsUseCase,
    required this.getCategoryProductsUseCase,
    required this.getProductUseCase,
  }) : super(ProductsInitial());

  int pageNo = 1;
  int totalPages = 1;
  bool loadMore = false;
  Product? product;
  int productSizeIndex = 0;
  List<Product> products = [];
  double subProductPrice = 0.0;
  int productColorIndex = 0;

  Future<void> getProducts({
    String? searchQuery,
    String? perPage,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
  }) async {
    if (state is GetProductsLoadingState) return;
    emit(GetProductsLoadingState(isFirstFetch: pageNo == 1));
    Either<Failure, BaseResponse> result =
        await getProductsUseCase.call(ProductParams(
      pageNo: pageNo,
      searchQuery: searchQuery,
      perPage: perPage,
      categoryId: categoryId,
      sortBy: sortBy,
      sortOrder: sortOrder,
    ));
    result.fold(
      (failure) => emit(GetProductsErrorState(failure.message!)),
      (response) {
        products.addAll(response.data!);
        totalPages = response.lastPage!;
        pageNo++;
        emit(GetProductsLoadedState(response.data));
      },
    );
  }

  //
  Future<void> getProductById({
    required int productId,
  }) async {
    emit(GetProductLoadingState());
    Either<Failure, BaseResponse> result =
        await getProductUseCase.call(GetProductParams(productId: productId));
    result.fold(
      (failure) => emit(GetProductErrorState(failure.message!)),
      (response) {
        product = response.data;
        emit(GetProductLoadedState(response.data));
      },
    );
  }

  int productQuantity = 1;

  incrementProductQuantity() {
    productQuantity++;
    emit(ProductQuantityChangedState());
  }

  decrementProductQuantity() {
    if (productQuantity == 1) return;
    productQuantity--;
    emit(ProductQuantityChangedState());
  }

  //total price of the product
  double totalPrice = 0.0;

  //descount price of the product
  getDiscountPrice() {
    if (product != null) {
      if (product!.colors!.isEmpty) {
        return product!.discount;
      } else {
        for (var color in product!.colors!) {
          if (color.sizes!.isNotEmpty) {
            for (var size in color.sizes!) {
              return size.discount;
            }
          }
        }
      }
      return 0.0;
    }
  }

  getProductPrice({
    int? prdoductSizeIndex,
  }) {
    if (product != null) {
      if (product!.colors!.isEmpty) {
        return product!.price;
      } else {
        if (prdoductSizeIndex == null) {
          for (var color in product!.colors!) {
            if (color.sizes!.isNotEmpty) {
              for (var size in color.sizes!) {
                return size.price;
              }
            }
          }
        } else {
          return product!
              .colors![productColorIndex].sizes![prdoductSizeIndex].price;
        }
      }
      return 0.0;
    }
  }

//? discounted price of the product have size
  int? getDiscountedPrice() {
    if (getDiscountPrice() != null) {
      return getProductPrice(
            prdoductSizeIndex: productSizeIndex,
          )! -
          getDiscountPrice()!;
    } else {
      return 0;
    }
  }

//===================== [sub products] ======================
  List<int> subProductsQuantities = List<int>.filled(500, 0, growable: false);
  void resetQuantitiesToZero() {
      for (int i = 0;
          i < subProductsQuantities.length;
          i++) {
        subProductsQuantities[i] = 0;
      }
      emit(SubProductsQuantitiesChangedState());

  }
  addSubProductPriceToTotal({
    double price = 5,
    required int index,
  }) {
    subProductPrice += price;
    subProductsQuantities[index] += 1;

    emit(AddSubProductPriceToTotalState());
  }

  removeSubProductPriceFromTotal({
    double price = 5,
    required int index,
  }) {
    if (subProductsQuantities[index] == 0) return;
    subProductPrice -= price;
    subProductsQuantities[index] -= 1;
    emit(RemoveSubProductPriceFromTotalState());
  }

  List<ChildProduct> subProducts = [];

  List<ChildProduct> getSubProducts(BuildContext context) {
    // emit(ProductsInitial());
    subProducts.clear();
    if (context.read<ProductsCubit>().product!.childrens!.isNotEmpty) {
      for (var child in context.read<ProductsCubit>().product!.childrens!) {
        subProducts.add(child);
      }
    }
    // subProductsQuantities =
    //     List<int>.filled(subProducts.length, 0, growable: false);
    // emit(SubProductsChangedState());
    return subProducts;
  }

// this sub product is will be not have sizes 😎
  double getSubProductPrice(int index) {
    if (subProducts.isNotEmpty) {
      // subProductPrice = subProducts[index].price!.toDouble();
      return subProducts[index].price!.toDouble();
    }
    return 0.0;
  }

//===================== [End sub products] ======================

  attachSubProductToCart({
    required int index,
  }) {}

  getTotalPrice() {
    if (getDiscountedPrice() != null && subProductPrice == 0.0) {
      totalPrice = getDiscountedPrice()!.toDouble() * productQuantity;
    } else {
      totalPrice = getDiscountedPrice()!.toDouble() * productQuantity;
      totalPrice += subProductPrice;
    }
    emit(TotalPriceChangedState());
    return totalPrice.round();
  }

  resetProductData() {
    productQuantity = 1;
    subProductPrice = 0.0;
    subProductsQuantities.clear();
    getProductPrice();
    getDiscountPrice();
    getDiscountedPrice();
    getTotalPrice();
  }

  clearData() {
    if (products.isNotEmpty) products.clear();
    pageNo = 1;
    totalPages = 1;
  }
}
