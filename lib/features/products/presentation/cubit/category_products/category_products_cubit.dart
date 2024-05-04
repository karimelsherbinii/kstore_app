import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/api/responses/base_response.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_category_products.dart';
import '../../../domain/usecases/get_products.dart';

part 'category_products_state.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  final GetProducts getProductsUseCase;
  final GetCategoryProducts getCategoryProductsUseCase;

  CategoryProductsCubit(
      this.getProductsUseCase, this.getCategoryProductsUseCase)
      : super(CategoryProductsInitial());

  int pageNo = 1;
  int totalPages = 1;
  bool loadMore = false;

  List<Product> products = [];

  Future<void> getProductsByCategory({
    required int categoryId,
    String? searchQuery,
  }) async {
    if (state is CategoryProductsLoading) return;
    emit(CategoryProductsLoading(isFirstFetch: pageNo == 1));
    Either<Failure, BaseResponse> result =
        await getCategoryProductsUseCase.call(GetCategoryProductsParams(
      categoryId: categoryId,
      pageNo: pageNo,
      searchQuery: searchQuery,
    ));
    result.fold(
      (failure) => emit(CategoryProductsError(message: failure.message!)),
      (response) {
        products.addAll(response.data);
        pageNo++;
        totalPages = response.lastPage!;
        emit(CategoryProductsLoaded(products: response.data));
      },
    );
  }

  clearData() {
    if (products.isNotEmpty) {
      products.clear();
    }
    pageNo = 1;
    totalPages = 1;
  }
}
